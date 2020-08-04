FROM ubuntu:16.04

COPY . /opt/rpcserver

RUN apt-get -qq update
RUN apt-get install -qq -o=Dpkg::Use-Pty=0 build-essential checkinstall
RUN apt-get install -qq -o=Dpkg::Use-Pty=0 wget locales liblzma-dev \
    libreadline-gplv2-dev libncursesw5-dev \ 
    libssl-dev libsqlite3-dev tk-dev libgdbm-dev \
    libc6-dev libbz2-dev libffi-dev  zlib1g-dev \
    locales-all libglib2.0-0 libsm6 libxext6 \
    libxrender-dev python3-pip python3-venv

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
RUN pip3 install -q --upgrade pip &&\
    cd /opt &&\
    wget -q https://www.python.org/ftp/python/3.8.2/Python-3.8.2.tgz &&\
    tar xzf Python-3.8.2.tgz &&\
    cd Python-3.8.2 &&\
    ./configure -q --enable-optimizations &&\
    make --quiet altinstall &&\
    cd ../ &&\
    rm -f Python-3.8.2.tgz &&\
    cd rpcserver/sku110k &&\
    python3 -m venv env &&\
    /opt/rpcserver/sku110k/env/bin/pip install -q numpy==1.16.3 &&\
    /opt/rpcserver/sku110k/env/bin/pip install -q -r requirements.txt &&\
    cd ../ &&\
    cd retail-product-classifier-server &&\
    python3.8 -m venv env &&\
    /opt/rpcserver/retail-product-classifier-server/env/bin/pip install -q --upgrade pip &&\
    /opt/rpcserver/retail-product-classifier-server/env/bin/pip install -q -r requirements.txt &&\
    cd ../ &&\
    cd encoder &&\
    python3 -m venv env &&\
    /opt/rpcserver/encoder/env/bin/pip install -q --upgrade pip &&\
    /opt/rpcserver/encoder/env/bin/pip install -q -r requirements.txt

