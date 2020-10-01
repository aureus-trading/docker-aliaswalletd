FROM ubuntu:20.04
MAINTAINER HLXEasy <hlxeasy@gmail.com>

ARG USER_ID
ARG GROUP_ID

ENV HOME /alias

# add user with specified (or default) user/group ids
ENV USER_ID ${USER_ID:-1000}
ENV GROUP_ID ${GROUP_ID:-1000}

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -g ${GROUP_ID} aliaswallet \
	&& useradd -u ${USER_ID} -g aliaswallet -s /bin/bash -m -d /alias aliaswallet

# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.7
RUN set -x \
	&& apt-get update && apt-get install -y --no-install-recommends \
		ca-certificates \
		dirmngr \
		gpg \
		libboost-chrono1.67.0 \
		libboost-filesystem1.67.0 \
		libboost-program-options1.67.0 \
		libboost-thread1.67.0 \
		libcap2 \
		libevent-2.1-7 \
		libtool \
		libseccomp2 \
		mc \
		obfs4proxy \
		tor \
		wget \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& for server in $(shuf -e ha.pool.sks-keyservers.net \
			hkp://p80.pool.sks-keyservers.net:80 \
			keyserver.ubuntu.com \
			hkp://keyserver.ubuntu.com:80 \
			pgp.mit.edu) ; do \
		gpg --keyserver "$server" --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 && break || : ; \
	done \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true \
	&& apt-get purge -y \
		ca-certificates \
		wget \
	&& apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD ./bin /usr/local/bin

VOLUME ["/alias"]

EXPOSE 36657 37347 36757 37111

# Download and install daemon binary
ARG DOWNLOAD_URL=https://github.com/aliascash/alias-wallet/releases/download/latest/Alias-latest-Ubuntu-20-04.tgz
ADD ${DOWNLOAD_URL} /tmp/alias.tgz
RUN cd / \
 && tar xzf /tmp/alias.tgz \
 && rm -f /usr/local/bin/aliaswallet /tmp/alias.tgz

WORKDIR /alias

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["alias_oneshot"]
