# Overall Strategy
# 
# /opt/node_app: Will be the root folder and contain a subfolder node_modules
#   - /opt/node_app/app: Volume mount that host should mount to.
#     - If node_modules is not found here it'll use the containers version in /opt/node_app/node_modules
#     - This is because of slow performance of reading the node_modules in docker for Mac
#     - Logic taken from : https://www.docker.com/blog/keep-nodejs-rockin-in-docker/
#       - Source: https://github.com/BretFisher/node-docker-good-defaults/blob/69c923bc646bc96003e9ada55d1ec5ca943a1b19/Dockerfile#L19-L30
# 
# Images
#   - hex-base: hexo-cli

# Global args
ARG dir_node_app_root="/opt/node_app"
ARG dir_node_app="${dir_node_app_root}/app"
ARG proj_dummy_dir="/tmp/dummy"


# *** HEXO-BASE ***
# - Hexo CLI
FROM node:current-alpine as hexo-base
LABEL maintainer="Martin DSouza <martin@talkapex.com>"
ENV TZ="GMT"

# Not setting values will use the default global args
ARG dir_node_app_root
ARG dir_node_app

RUN echo "RUN root" && \  
  npm i npm@latest -g && \
  # Create app directories
  mkdir ${dir_node_app_root} ${dir_node_app} && \
  chown node:node ${dir_node_app_root} ${dir_node_app} && \
  # For hexo
  apk update && \
  apk upgrade && \
  apk add --no-cache git && \
  # apex add --no-cache openssh && \
  npm install -g hexo-cli && \
  echo "END root"

USER node


# *** HEXO-PROJ-INIT ***
# Get the node_modules to store in /opt/node_app
FROM hexo-base as hexo-proj-init

ARG proj_dummy_dir
ARG dir_node_app_root

RUN mkdir ${proj_dummy_dir}

WORKDIR ${proj_dummy_dir}

# Init a dummy project so that we can get the package.json and mode_modules files
RUN echo "START hexo-node-modules" && \
  hexo init . && \
  # npm install hexo-deployer-git --save && \
  npm install hexo-browsersync --save && \
  echo "END hexo-node-modules" 


# *** HEXO-FINAL ***
FROM hexo-base as hexo-final

ARG dir_node_app_root
ARG dir_node_app
ARG proj_dummy_dir

# Get the node_modules in into /opt/node_app
COPY --from=hexo-proj-init ${proj_dummy_dir}/node_modules ${dir_node_app_root}/node_modules

WORKDIR ${dir_node_app}

# 4000: Hexo Draft Server
# 3000: Browser Synce
EXPOSE 4000 3000

# VOLUME [ "${dir_node_app}", "/home/node"]

ENTRYPOINT [ "hexo" ]

# debug
# ENTRYPOINT [ "/bin/ash" ]
# or run --entrypoint /bin/ash
