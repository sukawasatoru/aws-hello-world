SHELL = /bin/sh
.SUFFIXES:
RM = rm -f

.PHONY: dist
dist: release
	zip -j lambda.zip target/x86_64-unknown-linux-musl/release/bootstrap

.PHONE: release
release:
	cargo build --release --target x86_64-unknown-linux-musl

.PHONY: clean
clean:
	-cargo clean

.PHONY: distclean
distclean: clean
	-$(RM) lambda.zip

.PHONY: build-docker
build-docker:
	cd docker/toolchain && docker build --build-arg RUST_VERSION=1.49.0 -t ghcr.io/sukawasatoru/toolchain-aws-hello-lambda:1.0 .
