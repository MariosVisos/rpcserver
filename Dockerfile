FROM ubuntu:16.04

COPY . /opt/rpcserver

RUN apt-get -qq update
RUN apt-get install -qq -y -o=Dpkg::Use-Pty=0 build-essential checkinstall
RUN apt-get install -qq -y -o=Dpkg::Use-Pty=0 wget locales liblzma-dev \
    libreadline-gplv2-dev libncursesw5-dev  libssl-dev libsqlite3-dev \
    tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev  zlib1g-dev \
    locales-all libglib2.0-0 libsm6 libxext6 libxrender-dev \
    python3-pip python3-venv && apt-get remove -qq -y libcudnn7 &&\
    apt-get install -qq -y -o=Dpkg::Use-Pty=0 libcudnn7=7.6.2.24-1+cuda10.0

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
    python3 -q -m venv env &&\
    env/bin/pip install -q numpy==1.16.3 &&\
    env/bin/pip install -q -r requirements.txt &&\
    cd ../ &&\
    cd retail-product-classifier-server &&\
    python3.8 -q -m venv env &&\
    env/bin/pip install -q --upgrade pip &&\
    env/bin/pip install -q -r requirements.txt &&\
    cd ../ &&\
    cd encoder &&\
    python3 -q -m venv env &&\
    env/bin/pip install -q --upgrade pip &&\
    env/bin/pip install -q -r requirements.txt

