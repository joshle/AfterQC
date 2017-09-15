FROM ubuntu:14.04

RUN cp /etc/apt/sources.list /etc/apt/sources.list.bak
RUN echo " \n\
deb http://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse \n\
deb http://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse \n\
deb http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse \n\
deb http://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse \n\
deb http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse \n\
deb-src http://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse \n\
deb-src http://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse \n\
deb-src http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse \n\
deb-src http://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse \n\
deb-src http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse \n\
" >/etc/apt/sources.list

RUN bash -c 'echo -e "Asia/Shanghai" > /etc/timezone'&& \
    apt-get update

RUN apt-get install -y apt-utils \
    build-essential \
    zlib1g.dev

# install python
RUN apt-get install -y python-pip python2.7 python2.7-dev

# install pypy
RUN add-apt-repository ppa:pypy/ppa
RUN apt-get update
RUN apt-get install -y pypy pypy-dev

# ADD after.py
RUN mkdir -p /bioapp/after
COPY . /bioapp/after/
#RUN chmod +x /bioapp/after/after.py
WORKDIR /bioapp/after
RUN make

##configuration the env
ENV PATH /bioapp/after:$PATH

##clean
RUN apt-get clean

##switch the directory
WORKDIR /var/data
