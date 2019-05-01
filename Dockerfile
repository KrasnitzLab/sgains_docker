FROM continuumio/anaconda3:latest

LABEL Author="Lubomir Chorbadjiev <lubomir.chorbadjiev@gmail.com>"

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update --fix-missing 
RUN apt-get install -y build-essential gfortran


RUN conda install -c bioconda -c krasnitzlab sgains==1.0.3
RUN pip install setproctitle termcolor

CMD ["/bin/bash"]
