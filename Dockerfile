FROM debian:bookworm-slim

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ="Etc/UTC"

RUN apt-get update && apt-get install -y \
  ca-certificates \
  curl \
  dumb-init \
  --no-install-recommends \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

RUN curl -L -o lightpanda https://github.com/lightpanda-io/browser/releases/download/nightly/lightpanda-x86_64-linux && \
  chmod a+x ./lightpanda

EXPOSE 9222

ENTRYPOINT ["dumb-init", "--"]
CMD ["./lightpanda", "serve", "--host", "::", "--port", "9222"]
