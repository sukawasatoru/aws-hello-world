FROM ubuntu:18.04 AS prepare-ubuntu
SHELL ["/bin/bash", "-c"]
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
  ca-certificates \
  curl && \
  rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y \
  build-essential \
  git \
  musl-tools \
  pkg-config \
  vim \
  zip && \
  rm -rf /var/lib/apt/lists/*
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
RUN cargo install --git https://github.com/mozilla/sccache.git --rev e6326bc --no-default-features sccache

FROM prepare-ubuntu
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=JST-9
RUN apt-get update && apt-get install tzdata && \
  rm -rf /var/lib/apt/lists/*
COPY --from=exa $CARGO_HOME/bin/exa $CARGO_HOME/bin/
COPY --from=sccache $CARGO_HOME/bin/sccache $CARGO_HOME/bin/
