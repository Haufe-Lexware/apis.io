## --------------------------------------------------------
## Building the demeteorized version of apis.io
## --------------------------------------------------------

FROM node:8-stretch as builder

ENV METEOR_VER=1.6.1

RUN npm install -g demeteorizer@4.3.0

RUN su -c "curl https://install.meteor.com/?release=$METEOR_VER | sh" node

RUN cp "/home/node/.meteor/packages/meteor-tool/${METEOR_VER}/mt-os.linux.x86_64/scripts/admin/launch-meteor" /usr/bin/meteor

COPY . /src

RUN chown -R node:node /src

WORKDIR /src

RUN su -c "demeteorizer" node

WORKDIR /src/.demeteorized/bundle/programs/server

RUN su -c "npm install" node

## --------------------------------------------------------
## Creating a node - only image with the 
## demeteorized version of apis.io from above
## --------------------------------------------------------

FROM node:8-stretch

ARG MONGO_URL
ARG PORT
ARG ROOT_URL

COPY --from=builder /src/.demeteorized/bundle /app

ENV MONGO_URL=${MONGO_URL:-mongodb://mongo:27017/test} \
    PORT=${PORT:-8080} \
    ROOT_URL=${ROOT_URL:-http://localhost:8080}

WORKDIR /app/programs/server

CMD [ "/bin/su", "-c", "npm start", "node" ]
