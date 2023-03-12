FROM debian:buster as base

RUN apt-get update
RUN apt-get install -y cmake pkg-config build-essential git devscripts fakeroot wget unzip tar

RUN dpkg --add-architecture armhf
RUN dpkg --add-architecture arm64
RUN apt-get update
RUN apt-get install -y crossbuild-essential-armhf crossbuild-essential-arm64

FROM base AS yaml-cpp

RUN pwd
RUN pwd

WORKDIR /app

RUN wget https://github.com/emrahayanoglu/yaml-cpp/archive/refs/heads/debian-support.zip

RUN unzip debian-support.zip
RUN mv yaml-cpp-debian-support/ yaml-cpp_0.7.0/
RUN tar -czvf yaml-cpp_0.7.0.orig.tar.gz yaml-cpp_0.7.0

WORKDIR /app/yaml-cpp_0.7.0/

RUN apt-get -o Debug::pkgProblemResolver=yes -y --force-yes build-dep .
RUN debuild -us -uc

WORKDIR /app
RUN rm -rf yaml-cpp_0.7.0/
RUN unzip debian-support.zip
RUN mv yaml-cpp-debian-support/ yaml-cpp_0.7.0/
WORKDIR /app/yaml-cpp_0.7.0/

RUN apt-get -o Debug::pkgProblemResolver=yes -y --force-yes build-dep -aarmhf .
RUN debuild -us -uc -aarmhf

WORKDIR /app
RUN rm -rf yaml-cpp_0.7.0/
RUN unzip debian-support.zip
RUN mv yaml-cpp-debian-support/ yaml-cpp_0.7.0/
WORKDIR /app/yaml-cpp_0.7.0/

RUN apt-get -o Debug::pkgProblemResolver=yes -y --force-yes build-dep -aarm64 .
RUN debuild -us -uc -aarm64

WORKDIR /app
RUN mkdir -p build
RUN cp *.deb build/