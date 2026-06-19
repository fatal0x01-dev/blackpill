FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Base tooling for kernel builds
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    bc \
    bison \
    flex \
    libssl-dev \
    libelf-dev \
    dwarves \
    curl \
    wget \
    ca-certificates \
    pkg-config \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# LLVM toolchain (kernel Rust + LLVM mode)
RUN apt-get update && apt-get install -y \
    clang \
    lld \
    llvm \
    && rm -rf /var/lib/apt/lists/*

# Rust (official installer for reproducibility)
ENV RUSTUP_HOME=/usr/local/rustup
ENV CARGO_HOME=/usr/local/cargo
ENV PATH=/usr/local/cargo/bin:$PATH

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# Rust components needed for kernel work
RUN rustup component add rust-src clippy rustfmt

# bindgen CLI (equivalent to your Arch setup)
RUN cargo install --locked bindgen-cli

WORKDIR /workspace
