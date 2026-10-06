FROM alpine:latest
LABEL description="Local web site preview tool"
WORKDIR /dott/
COPY . /dott
RUN apk add --no-cache bash curl php
CMD ["bash", "./dott.sh"]
