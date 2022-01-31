FROM node:16

LABEL maintainer "kevin.oehme@accenture.com"

# # Update aptitude with new repo
# RUN apt-get update

# # Install software 
# RUN apt-get install -y git

# # Make ssh dir
# RUN mkdir /root/.ssh/

# # Copy over private key, and set permissions
# # Warning! Anyone who gets their hands on this image will be able
# # to retrieve this private key file from the corresponding image layer
# ADD id_rsa /root/.ssh/id_rsa

# # Create known_hosts
# RUN touch /root/.ssh/known_hosts

# # Add bitbuckets key
# RUN ssh-keyscan bitbucket.org >> /root/.ssh/known_hosts

# # Clone the conf files into the docker container
# RUN git clone git@bitbucket.org:User/repo.git



#ENV NODE_PATH='/node_modules'
ENV BUILD_LIBRDKAFKA=0

# Create app directory
WORKDIR /usr/src/app

#COPY --from=${YOUR_REGISTRY}/node-rdkafka-builds:node-10 /node_modules /usr/src/app/node_modules

# RUN docker container create --name dummy -v node-rdkafka:/root node-rdkafka
# RUN docker cp dummy:/root/* /usr/src/app/node_modules  
# RUN docker rm dummy

VOLUME ["/node-rdkafka"]
COPY ./node-rdkafka/ /usr/src/app/node_modules

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

RUN npm install
# If you are building your code for production
# RUN npm ci --only=production

# Bundle app source
COPY . .

EXPOSE 8080
CMD [ "node", "src/index.js" ]