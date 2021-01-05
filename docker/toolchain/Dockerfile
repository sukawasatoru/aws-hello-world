FROM ubuntu:18.04 AS prepare-ubuntu
SHELL ["/bin/bash", "-c"]
ARG DEBIAN_FRONTEND=noninteractive
RUN rm /etc/apt/apt.conf.d/docker-clean && \
  echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,dst=/var/cache/apt \
  --mount=type=cache,dst=/var/lib/apt \
  apt-get update && apt-get install -y --no-install-recommends \
  ca-certificates \
  curl
RUN --mount=type=cache,dst=/var/cache/apt \
  --mount=type=cache,dst=/var/lib/apt \
  apt-get update && apt-get install -y \
  build-essential \
  musl-tools \
  pkg-config \
  vim \
  zip
ARG RUST_VERSION
ENV CARGO_HOME=/opt/cargo
ENV PATH=$CARGO_HOME/bin:$PATH
ENV RUSTUP_HOME=/opt/rustup
RUN curl -sSf https://sh.rustup.rs | bash -s -- -v -y --no-modify-path --default-toolchain $RUST_VERSION && \
  rustup target add x86_64-unknown-linux-musl && \
  rustup install ${RUST_VERSION}-x86_64-unknown-linux-musl

FROM prepare-ubuntu AS exa
ARG DEBIAN_FRONTEND=noninteractive
RUN cargo install exa

FROM prepare-ubuntu AS sccache
ARG DEBIAN_FRONTEND=noninteractive
RUN cargo install --no-default-features sccache

FROM prepare-ubuntu
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=JST-9
RUN --mount=type=cache,dst=/var/cache/apt \
  --mount=type=cache,dst=/var/lib/apt \
  apt-get update && apt-get install tzdata
COPY --from=exa $CARGO_HOME/bin/exa $CARGO_HOME/bin/
COPY --from=sccache $CARGO_HOME/bin/sccache $CARGO_HOME/bin/
