FROM alpine
RUN apk add libarcus --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing
RUN apk add --update \
  libtool \
  autoconf \
  automake \
  g++ \
  git \
  make \
  cmake \
  py3-sip-dev \
  python3-dev \
  && mkdir -p /usr/src/
WORKDIR /usr/src/

RUN git clone https://github.com/protocolbuffers/protobuf.git
WORKDIR /usr/src/protobuf
RUN /usr/src/protobuf/autogen.sh \
  && ./configure \
  && make \
  && make install
WORKDIR /usr/src/

RUN git clone https://github.com/Ultimaker/libArcus.git
WORKDIR /usr/src/libArcus
RUN mkdir build && cd build \
  && cmake /usr/src/libArcus \
  && make \
  && make install
WORKDIR /usr/src/

RUN git clone https://github.com/Ultimaker/CuraEngine.git
WORKDIR /usr/src/CuraEngine
RUN ls /usr/lib/libArcus.so.3
RUN git checkout -b origin/master \
  && mkdir build \
  && cd build \
  && cmake .. \
  && make
COPY . .
ENTRYPOINT [ "/usr/src/CuraEngine/build/CuraEngine"] 
CMD ["help"]