FROM node:8

# Install dockerize
RUN apt-get update && apt-get install -y wget
ENV DOCKERIZE_VERSION v0.5.0
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# Copy source
ARG NPM_TOKEN
COPY .npmrc /tmp/.npmrc
COPY package.json /tmp/package.json
RUN cd /tmp && npm install --production
RUN rm -f /tmp/.npmrc

RUN mkdir -p /src && cp -a /tmp/node_modules /src/

# Bootstrap data
WORKDIR /src
ADD . /src
RUN rm -f /src/.npmrc
EXPOSE 80
CMD npm run start

