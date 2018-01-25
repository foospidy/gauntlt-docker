FROM ubuntu:16.04
MAINTAINER james@gauntlt.org

ARG ARACHNI_VERSION=arachni-1.5.1-0.5.12

# Install Ruby and other OS stuff
RUN \
  apt-get update && \
  apt-get install -y build-essential \
    bzip2 \
    ca-certificates \
    curl \
    git \
    libcurl3 \
    libcurl4-openssl-dev \
    wget \
    zlib1g-dev \
    libfontconfig \
    libxml2-dev \
    libxslt1-dev \
    ruby \
    ruby-dev \
    ruby-bundler && \
    rm -rf /var/lib/apt/lists/*

# Install Gauntlt
RUN gem install gauntlt --no-rdoc --no-ri

# Install Attack tools

# arachni
RUN wget https://github.com/Arachni/arachni/releases/download/v1.5.1/${ARACHNI_VERSION}-linux-x86_64.tar.gz && \
    tar xzvf ${ARACHNI_VERSION}-linux-x86_64.tar.gz && \
    mv ${ARACHNI_VERSION} /usr/local && \
    ln -s /usr/local/${ARACHNI_VERSION}/bin/* /usr/local/bin/

# Nikto
WORKDIR /opt

RUN apt-get update \
        && apt-get install -y libtimedate-perl libnet-ssleay-perl \
        && rm -rf /var/lib/apt/lists/*

RUN git clone --depth=1 https://github.com/sullo/nikto.git && \
    cd nikto/program && \
    echo "EXECDIR=/opt/nikto/program" >> nikto.conf && \
    ln -s /opt/nikto/program/nikto.conf /etc/nikto.conf && \
    chmod +x nikto.pl && \
    ln -s /opt/nikto/program/nikto.pl /usr/local/bin/nikto


ENTRYPOINT [ "/usr/local/bin/gauntlt" ]
