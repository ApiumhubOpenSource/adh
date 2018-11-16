FROM node:6.14

# Docker installation
RUN apt-get update && \
	apt-get -y install apt-transport-https \
		 ca-certificates \
		 curl \
		 gnupg2 \
		 software-properties-common && \
	curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
	add-apt-repository \
	   "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
	   $(lsb_release -cs) \
	   stable" && \
	apt-get update && \
	apt-get -y install docker-ce

# BASH Automated Testing  System
RUN git clone https://github.com/sstephenson/bats.git && \
    cd bats && ./install.sh /usr/local

RUN mkdir -p /adh
WORKDIR /adh

COPY package.json .
COPY package-lock.json .
RUN npm install

COPY src ./src
COPY tsconfig.json .
RUN npm run tsc

COPY runTest.sh .
COPY tests.bats .
