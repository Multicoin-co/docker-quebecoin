FROM ubuntu:xenial
MAINTAINER Ahmed Bodiwala <ahmedbodi@crypto-expert.com>

ARG USER_ID
ARG GROUP_ID

ENV HOME /quebecoin

# add user with specified (or default) user/group ids
ENV USER_ID ${USER_ID:-1000}
ENV GROUP_ID ${GROUP_ID:-1000}

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -g ${GROUP_ID} quebecoin && useradd -u ${USER_ID} -g quebecoin -s /bin/bash -m -d /quebecoin quebecoin

RUN set -ex \
	&& apt-get update \
        && apt-get install software-properties-common build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils python3 git libboost-all-dev gosu -y \
        && add-apt-repository ppa:bitcoin/bitcoin \
        && apt-get update \
        && apt-get install libdb4.8-dev libdb4.8++-dev -y \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /quebecoin
RUN mkdir bin src
RUN echo PATH=\"\$HOME/bin:\$PATH\" >> .bash_profile

WORKDIR /quebecoin/src
RUN git clone https://github.com/ahmedbodi/quebecoin

WORKDIR /quebecoin/src/quebecoin/
RUN ./autogen.sh && ./configure --with-incompatible-bdb
RUN make -j $(nproc) install

ADD ./bin /usr/local/bin

VOLUME ["/quebecoin"]

EXPOSE 10890 20890 10889 20889

WORKDIR /quebecoin

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["oneshot"]
