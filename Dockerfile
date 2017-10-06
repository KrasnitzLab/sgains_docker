FROM ubuntu:16.04

MAINTAINER Lubomir Chorbadjiev <lubomir.chorbadjiev@gmail.com>

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion
RUN apt-get install -y gfortran
RUN apt-get install -y build-essential


RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/archive/Anaconda3-5.0.0-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh

RUN apt-get install -y curl grep sed dpkg && \
    TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb && \
    apt-get clean

ENV PATH /opt/conda/bin:$PATH

RUN conda config --add channels bioconda
RUN conda install -y samtools bcftools biopython pysam

RUN conda config --add channels r
RUN conda install -y r-essentials

RUN conda install pandas numpy

RUN conda install -y -c conda-forge perl=5.22.0
RUN conda install -y bowtie=1.2.1.1

RUN pip install python-box termcolor PyYAML pytest pytest-asyncio setproctitle

RUN wget --quiet https://github.com/KrasnitzLab/sgains/archive/1.0_beta2.tar.gz -O ~/sgains.tar.gz && \
    mkdir /opt/sgains && \
    tar zxf ~/sgains.tar.gz -C /opt/sgains --strip-components 1

ENV PATH /opt/sgains/tools:$PATH
ENV PYTHONPATH /opt/sgains/scpipe:$PYTHONPATH

RUN cd /opt/sgains/scripts && Rscript setup.R

VOLUME /data
WORKDIR /data
