FROM ubuntu:16.04

COPY . /opt/rpcserver
RUN apt update
RUN apt install -y build-essential checkinstall
RUN apt install -y wget locales \
    libreadline-gplv2-dev libncursesw5-dev \ 
    libssl-dev libsqlite3-dev tk-dev libgdbm-dev \
    libc6-dev libbz2-dev libffi-dev  zlib1g-dev \
    locales-all libglib2.0-0 libsm6 libxext6 \
    libxrender-dev python3-pip python3-venv
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en 
ENV LC_ALL en_US.UTF-8 
RUN pip3 install --upgrade pip
RUN cd /opt &&\
    wget https://www.python.org/ftp/python/3.8.2/Python-3.8.2.tgz &&\
    tar xzf Python-3.8.2.tgz &&\
    cd Python-3.8.2 &&\
    ./configure --enable-optimizations &&\
    make altinstall &&\
    cd ../ &&\
    rm -f Python-3.8.2.tgz &&\
    cd rpcserver/retail-product-classifier-server &&\
    python3.8 -m venv env &&\
    /bin/bash -c "source env/bin/activate" &&\
    pip3.8 install -r requirements.txt &&\
    cd ../ &&\
    cd sku110k &&\
    python3 -m venv env &&\
    /bin/bash -c "source env/bin/activate" &&\
    pip3 install numpy==1.16.3 &&\
    pip3 install -r requirements.txt

