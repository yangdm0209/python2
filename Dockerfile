FROM centos:6

MAINTAINER kevin0209

RUN yum -y update
RUN yum groupinstall -y development
RUN yum install -y zlib-dev openssl openssl-devel sqlite-devel bzip2-devel tar wget vim

# Install python 2.7.11
WORKDIR /tmp
ADD https://www.python.org/ftp/python/2.7.11/Python-2.7.11.tgz /tmp/
RUN tar -xvzf Python-2.7.11.tgz
WORKDIR /tmp/Python-2.7.11
RUN ./configure --prefix=/usr/local && \
    make && \
    make altinstall

# create a symlink python -> python2.7
RUN sed -i 's/python$/python2.6/g' /usr/bin/yum
RUN ln -s /usr/local/bin/python2.7 /usr/local/bin/python

# Install setuptools
WORKDIR /tmp
ADD https://pypi.python.org/packages/source/s/setuptools/setuptools-1.4.2.tar.gz /tmp/
RUN tar -xvzf setuptools-1.4.2.tar.gz
WORKDIR /tmp/setuptools-1.4.2
RUN python2.7 setup.py install && \
    # Install pip and virtualenv
    curl https://bootstrap.pypa.io/get-pip.py | python2.7 - && \
    pip install virtualenv

WORKDIR /
RUN rm -rf /tmp/*

