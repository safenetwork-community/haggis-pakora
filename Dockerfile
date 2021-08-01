# Build SafeNetwork Docker container
FROM alpine:latest
LABEL version="0.2"
LABEL maintainer="southside"
LABEL release-date="2021-08-01"

# Update and install dependencies
RUN apk update
RUN apk add bash #unix shell to run install script
RUN apk add curl #cUrl to transfer data
RUN apk add tree

#Make profile file with exported PATH and refresh the shell (while building)
SHELL ["/bin/bash", "--login", "-c"]
RUN echo 'export PATH=$PATH:/root/.safe/cli' > ~/.profile && source ~/.profile

#Set ENV PATH (after build will be used to find 'safe')
ENV PATH=$PATH:/root/.safe/cli


#Create app structure
#Installation Script - MaidSafe installation script
RUN curl -so- https://sn-api.s3.amazonaws.com/install.sh | bash

#Install Safe - During Build
RUN safe node install
#Ensure we use the correct versions of the safe binaries
COPY src/safe-0.33.4 /root/.safe/cli
COPY src/sn_node-0.9.1 /root/.safe/node/sn_node

ENV APPDIR=/root/.safe

#Expose PORT of the node 
EXPOSE 12000

#Run command on Docker launch
CMD ["bash"]
