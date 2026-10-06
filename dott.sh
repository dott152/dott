#!/usr/bin/env bash
set -Eeuo pipefail

# ==========================================
# PALETA DE COLORES Y ESTILOS (ANSI)
# ==========================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m' 

# ==========================================
# CONFIGURACIÓN Y VARIABLES
# ==========================================
BASE_DIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")")
SITES_DIR="$BASE_DIR/sites"
SERVER_DIR="$BASE_DIR/server"
HOST="127.0.0.1"
PORT="8080"
SERVER_PID=""
TUNNEL_PID=""

# ==========================================
# BANNER Y COMPONENTES VISUALES
# ==========================================
show_banner() {
    clear 2>/dev/null || true
    echo -e "${PURPLE}${BOLD}"
    cat << 'EOF'
  ██████╗  ██████╗ ████████╗████████╗
  ██╔══██╗██╔═══██╗╚══██╔══╝╚══██╔══╝
  ██║  ██║██║   ██║   ██║      ██║   
  ██║  ██║██║   ██║   ██║      ██║   
  ██████╔╝╚██████╔╝   ██║      ██║   
  ╚═════╝  ╚═════╝    ╚═╝      ╚═╝   
EOF
    echo -e "${NC}${CYAN}  Local Site Server & Cloudflare Tunnel${NC}"
    echo -e "${DIM}  ──────────────────────────────────────────────────${NC}\n"
}

spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while kill -0 "$pid" 2>/dev/null; do
        local temp=${spinstr#?}
        printf " [%c] " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# ==========================================
# MANEJO DE ERRORES Y LIMPIEZA
# ==========================================
cleanup() {
    [[ -n "$TUNNEL_PID" ]] && kill "$TUNNEL_PID" 2>/dev/null || true
    [[ -n "$SERVER_PID" ]] && kill "$SERVER_PID" 2>/dev/null || true
}
trap cleanup EXIT INT TERM

fail() {
    echo -e "\n${RED}${BOLD}[✘] Error:${NC} ${RED}$1${NC}" >&2
    exit 1
}

usage() {
    show_banner
    cat <<EOF
${BOLD}Uso:${NC} bash dott.sh

Sirve sitios propios guardados en .sites/<nombre>/, con index.html o index.php.
El servidor local escucha solo en 127.0.0.1. Cloudflare Tunnel es opcional; si
falta cloudflared, se descarga al elegir ese modo. El enlace será público.
EOF
}

# ==========================================
# DESCARGA DE CLOUDFLARED
# ==========================================
install_cloudflared() {
    local architecture asset download_path
    case "$(uname -m)" in
        x86_64) asset="amd64" ;;
        aarch64) asset="arm64" ;;
        arm*|armv7l) asset="arm" ;;
        i?86) asset="386" ;;
        *) fail "Arquitectura no compatible con la descarga automática de cloudflared" ;;
    esac

    download_path="$SERVER_DIR/cloudflared.download"
    echo -e "${YELLOW}[↓] Descargando cloudflared oficial para ${BOLD}$asset${NC}${YELLOW}...${NC}"
    if ! curl --silent --show-error --fail --location --retry 3 \
        --output "$download_path" \
        "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-$asset"; then
        rm -f "$download_path"
        fail "No se pudo descargar cloudflared desde GitHub"
    fi
    if ! chmod +x "$download_path" || ! "$download_path" --version >/dev/null 2>&1; then
        rm -f "$download_path"
        fail "El binario descargado de cloudflared no pasó la verificación básica"
    fi
    mv "$download_path" "$SERVER_DIR/cloudflared"
    echo -e "${GREEN}[✔] Binario de cloudflared verificado e instalado correctamente.${NC}\n"
}

# ==========================================
# VALIDACIONES INICIALES
# ==========================================
[[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && { usage; exit 0; }
[[ $# -eq 0 ]] || fail "Opción desconocida: $1 (usa --help)"

show_banner

command -v php >/dev/null 2>&1 || fail "PHP no está instalado. Instala PHP CLI para servir el sitio."
command -v curl >/dev/null 2>&1 || fail "curl no está instalado. Instálalo para comprobar que el sitio inició."
[[ -d "$SITES_DIR" ]] || fail "No existe $SITES_DIR. Crea una carpeta para tu sitio ahí."
mkdir -p "$SERVER_DIR"

sites=()
for candidate in "$SITES_DIR"/*; do
    [[ -d "$candidate" && ! -L "$candidate" ]] || continue
    [[ -f "$candidate/index.html" || -f "$candidate/index.php" ]] || continue
    sites+=("$candidate")
done

if [[ ${#sites[@]} -eq 0 ]]; then
    fail "No hay sitios. Crea .sites/mi-sitio/index.html o index.php."
fi

# ==========================================
# MENÚ INTERACTIVO DE SELECCIÓN
# ==========================================
echo -e "${CYAN}${BOLD}[?] Selecciona un sitio disponible:${NC}"
for index in "${!sites[@]}"; do
    echo -e "  ${GREEN}${BOLD}$((index + 1)))${NC} $(basename "${sites[$index]}")"
done
echo
echo -ne "${CYAN}${BOLD}❯ Elige una opción [1-${#sites[@]}]: ${NC}"
read -r site_choice
[[ "$site_choice" =~ ^[0-9]+$ ]] || fail "Selección inválida"
site_index=$((site_choice - 1))
(( site_index >= 0 && site_index < ${#sites[@]} )) || fail "Selección fuera de rango"
site_dir=$(realpath "${sites[$site_index]}")

echo -ne "\n${CYAN}${BOLD}❯ Puerto local [Predeterminado 8080]: ${NC}"
read -r requested_port
PORT=${requested_port:-8080}
[[ "$PORT" =~ ^[0-9]{1,5}$ ]] && (( PORT >= 1024 && PORT <= 65535 )) || fail "Puerto inválido (usa 1024-65535)"

echo -e "\n${CYAN}${BOLD}[?] Elige el modo de ejecución:${NC}"
echo -e "  ${GREEN}${BOLD}1)${NC} Solo local (${HOST})"
echo -e "  ${GREEN}${BOLD}2)${NC} Cloudflare Tunnel (Público)"
echo -ne "\n${CYAN}${BOLD}❯ Modo [Predeterminado 2]: ${NC}"
read -r mode
mode=${mode:-2}
[[ "$mode" == "1" || "$mode" == "2" ]] || fail "Modo inválido"

if [[ "$mode" == "2" ]]; then
    echo -ne "\n${YELLOW}${BOLD}[!] Esto hará tu sitio accesible públicamente. ¿Tienes autorización? [y/N]: ${NC}"
    read -r confirmation
    [[ "$confirmation" =~ ^[yY]$ ]] || fail "Túnel cancelado por el usuario"
    if command -v cloudflared >/dev/null 2>&1; then
        CLOUDFLARED=$(command -v cloudflared)
    elif [[ -x "$SERVER_DIR/cloudflared" ]]; then
        CLOUDFLARED="$SERVER_DIR/cloudflared"
    else
        install_cloudflared
        CLOUDFLARED="$SERVER_DIR/cloudflared"
    fi
fi

# ==========================================
# INICIO Y COMPROBACIÓN DEL SERVIDOR PHP
# ==========================================
echo -e "\n${BLUE}[i] Iniciando servidor web interno PHP...${NC}"
php -S "$HOST:$PORT" -t "$site_dir" >"$SERVER_DIR/php.log" 2>&1 &
SERVER_PID=$!

ready=false
for _ in {1..20}; do
    if curl --silent --fail --max-time 1 "http://$HOST:$PORT/" >/dev/null; then
        ready=true
        break
    fi
    kill -0 "$SERVER_PID" 2>/dev/null || break
    sleep 0.25
done
[[ "$ready" == true ]] || fail "PHP no pudo iniciar en $HOST:$PORT; revisa $SERVER_DIR/php.log"

tunnel_url=""

# ==========================================
# INICIO DE CLOUDFLARE TUNNEL
# ==========================================
if [[ "$mode" == "2" ]]; then
    echo -e "${BLUE}[i] Creando túnel seguro con Cloudflare...${NC}"
    "$CLOUDFLARED" tunnel --url "http://$HOST:$PORT" --no-autoupdate >"$SERVER_DIR/cloudflared.log" 2>&1 &
    TUNNEL_PID=$!
    
    # Espera visual con animación
    for _ in {1..60}; do
        tunnel_url=$(grep -Eo 'https://[[:alnum:]-]+\.trycloudflare\.com' "$SERVER_DIR/cloudflared.log" | head -n 1 || true)
        [[ -n "$tunnel_url" ]] && break
        kill -0 "$TUNNEL_PID" 2>/dev/null || break
        sleep 0.5
    done
    [[ -n "$tunnel_url" ]] || {
        echo -e "\n${RED}[✘] Cloudflare no creó un enlace. Últimas líneas del registro:${NC}\n" >&2
        tail -n 20 "$SERVER_DIR/cloudflared.log" >&2
        fail "Revisa la instalación o la conexión de cloudflared"
    }
fi

# ==========================================
# PANEL DE CONTROL / RESUMEN
# ==========================================
echo -e "\n${GREEN}${BOLD}┌─────────────────────────────────────────────────────────────┐${NC}"
echo -e "${GREEN}${BOLD}│                   SERVIDORES EN EJECUCIÓN                   │${NC}"
echo -e "${GREEN}${BOLD}├─────────────────────────────────────────────────────────────┤${NC}"
printf "${GREEN}${BOLD}│${NC}  ${BOLD}Sitio cargado :${NC} %-41s ${GREEN}${BOLD}│${NC}\n" "$(basename "$site_dir")"
printf "${GREEN}${BOLD}│${NC}  ${BOLD}Servidor Local:${NC} %-41s ${GREEN}${BOLD}│${NC}\n" "http://$HOST:$PORT/"

if [[ "$mode" == "2" ]]; then
    printf "${GREEN}${BOLD}│${NC}  ${BOLD}Enlace Público:${NC} %-41s ${GREEN}${BOLD}│${NC}\n" "$tunnel_url"
fi
echo -e "${GREEN}${BOLD}└─────────────────────────────────────────────────────────────┘${NC}"

echo -e "\n${YELLOW}${BOLD}[!] Presiona Ctrl+C para detener el servidor y cerrar el túnel.${NC}\n"

while kill -0 "$SERVER_PID" 2>/dev/null; do
    sleep 1
done
