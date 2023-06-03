# syntax=docker/dockerfile:1.4
FROM --platform=$BUILDPLATFORM node:19-alpine3.17 AS development

RUN mkdir /project
WORKDIR /project

COPY .. .

RUN yarn global add @vue/cli
RUN yarn install
RUN apk update
RUN apk add git
ENV HOST=0.0.0.0
CMD ["yarn", "run", "serve"]

RUN addgroup -S docker
RUN adduser -S --shell /bin/bash --ingroup docker vscode

# install Docker tools (cli, buildx, compose)
COPY --from=gloursdocker/docker / /
CMD ["yarn", "run", "serve"]
