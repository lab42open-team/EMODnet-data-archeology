FROM ubuntu:18.04 
MAINTAINER Savvas Paragkamian s.paragkamian@hcmr.gr

# Basic ubuntu tools
RUN apt-get update && apt-get install -y wget \
    && apt-get install -qq -y curl

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN apt-get update
RUN apt-get install -y git-all

# R dependencies
RUN apt-get remove -y r-base-core

RUN apt-get install -y gfortran
RUN apt-get install -y build-essential
RUN apt-get install -y fort77
RUN apt-get install -y xorg-dev
RUN apt-get install -y liblzma-dev libblas-dev gfortran
RUN apt-get install -y gcc-multilib
RUN apt-get install -y gobjc++
RUN apt-get install -y aptitude
RUN aptitude install -y libreadline-dev
RUN apt-get update
RUN apt-get install -y libbz2-dev

RUN export CC=/usr/bin/gcc
RUN export CXX=/usr/bin/g++
RUN export FC=/usr/bin/gfortran
RUN export PERL=/usr/bin/perl

# System libraries for tidyverse
RUN apt-get update
RUN apt-get install -y libpcre3-dev libpcre2-dev libpcre-ocaml-dev libghc-regex-pcre-dev
RUN apt-get update
RUN apt-get install -y libxml2-dev libcurl4-openssl-dev libssl-dev
RUN apt-get update

# tesseract dependencies
## leptonica

WORKDIR /home
RUN wget http://www.leptonica.org/source/leptonica-1.80.0.tar.gz
RUN tar -zxf leptonica-1.80.0.tar.gz
WORKDIR /home/leptonica-1.80.0
RUN ./configure
RUN make
RUN make install
# Note that if building Leptonica from source, you may need to ensure that /usr/local/lib is in your library path. This is a standard Linux bug, and the information at Stackoverflow is very helpful.

## other libraries for images
RUN apt-get update
RUN apt-get install -y automake
RUN apt-get install -y libtool
RUN apt-get install -y libpng-dev
RUN apt-get install -y libjpeg8-dev
RUN apt-get install -y libtiff5-dev
RUN apt-get install -y zlib1g-dev
RUN apt-get update

# Main tools installation

# Ghostscript
WORKDIR /home
RUN wget https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs9533/ghostscript-9.53.3.tar.gz
RUN tar -xvf ghostscript-9.53.3.tar.gz
WORKDIR ghostscript-9.53.3
RUN ./configure
RUN make
RUN make install

# ImageMagick
WORKDIR /home
RUN wget https://download.imagemagick.org/ImageMagick/download/ImageMagick.tar.gz
RUN tar -zxf ImageMagick.tar.gz
WORKDIR ImageMagick-7.0.10-61
RUN ./configure
RUN make
RUN make install

# jq

RUN apt-get update
RUN apt-get install -y jq
RUN apt-get update

# tesseract OCR

WORKDIR /home
RUN wget https://github.com/tesseract-ocr/tesseract/archive/4.1.1.tar.gz
RUN tar -zxf 4.1.1.tar.gz
WORKDIR /home/4.1.1
RUN ./automake.sh
RUN ./configure
RUN make
RUN make install

# gnfinder
WORKDIR /home
RUN wget https://github.com/gnames/gnfinder/releases/download/v0.11.1/gnfinder-v0.11.1-linux.tar.gz
RUN tar -zxf gnfinder-v0.11.1-linux.tar.gz
RUN mv gnfinder /usr/local/bin

# Install R
WORKDIR /home
RUN wget https://ftp.cc.uoc.gr/mirrors/CRAN/src/base/R-4/R-4.0.3.tar.gz
RUN tar -xf R-4.0.3.tar.gz
WORKDIR /home/R-4.0.3
RUN ./configure 
RUN make
RUN make install
RUN Rscript -e 'install.packages("tidyverse", repos="https://cran.rstudio.com")'


# EMODnet workflow
RUN git clone https://github.com/lab42open-team/EMODnet-data-archaeology.git

# Clean the container

# Set "EMODnet-data-archaeology" as my working directory when a container starts

WORKDIR /home/EMODnet-data-archaeology