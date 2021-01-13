AWS Hello Lambda
================

```bash
# prepare
make build-docker

# build
docker run --rm --mount type=bind,src=$PWD,dst=/aws-hello-lambda --mount type=volume,dst=/aws-hello-lambda/target -e RUSTC_WRAPPER=sccache -e SCCACHE_DIR=/sccache --mount type=bind,src=$PWD/.cache/docker-sccache,dst=/sccache --mount type=bind,src=$PWD/.cache/docker-rustup-git,dst=/opt/cargo/git --mount type=bind,src=$PWD/.cache/docker-rustup-registry,dst=/opt/cargo/registry -w /aws-hello-lambda ghcr.io/sukawasatoru/toolchain-aws-hello-lambda:1.0 make dist

MY_ROLE=arn:aws:iam::123456789012:role/RoleName
MY_REGION=us-east-1

# create
docker run --rm --mount type=bind,src=$HOME/.aws,dst=/root/.aws --mount type=bind,src=$PWD,dst=/aws amazon/aws-cli lambda create-function --function-name rustTest --handler main --zip-file fileb://./lambda.zip --runtime provided --role $MY_ROLE --environment Variables={RUST_BACKTRACE=1,RUST_LOG=bootstrap=debug} --tracing-config Mode=Active --region $MY_REGION

# update
docker run --rm --mount type=bind,src=$HOME/.aws,dst=/root/.aws --mount type=bind,src=$PWD,dst=/aws amazon/aws-cli lambda update-function-code --region $MY_REGION --function-name rustTest --zip-file fileb://./lambda.zip

# execute
docker run --rm --mount type=bind,src=$HOME/.aws,dst=/root/.aws --mount type=bind,src=$PWD,dst=/aws amazon/aws-cli lambda invoke --region $MY_REGION --function-name rustTest --cli-binary-format raw-in-base64-out --payload '{"firstName": "world"}' out.json
```
