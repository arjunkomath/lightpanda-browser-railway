FROM debian:bookworm-slim

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ="Etc/UTC"

RUN apt-get update && apt-get install -y \
  ca-certificates \
  dumb-init \
  --no-install-recommends \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

# Latest stable release by default (https://github.com/lightpanda-io/browser/releases).
# Set LIGHTPANDA_VERSION to a release tag (e.g. 1.0.5) to pin it, or to "nightly".
# ADD re-checks the remote file on every build, so a new release isn't hidden by
# the layer cache.
ARG LIGHTPANDA_VERSION=
ADD --chmod=755 https://github.com/lightpanda-io/browser/releases/${LIGHTPANDA_VERSION:+download/}${LIGHTPANDA_VERSION:-latest/download}/lightpanda-x86_64-linux ./lightpanda
RUN ./lightpanda version

# The CDP endpoint has no authentication, so don't run it as root.
RUN useradd --create-home --uid 1000 lightpanda
USER lightpanda

EXPOSE 9222

# Lightpanda rejects (403) any request whose Host header is not an IP, localhost,
# or the --advertise-host value. Advertise Railway's private domain by default so
# clients can connect via <service>.railway.internal; set ADVERTISE_HOST to override
# (e.g. to your TCP proxy domain when connecting over the public network).
ENTRYPOINT ["dumb-init", "--"]
CMD ["sh", "-c", "exec ./lightpanda serve --host :: --port 9222 --advertise-host \"${ADVERTISE_HOST:-${RAILWAY_PRIVATE_DOMAIN:-127.0.0.1}}\""]
