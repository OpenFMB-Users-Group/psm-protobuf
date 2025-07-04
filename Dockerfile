FROM golang:1.20.3

ENV PROTOBUF_VER=22.3
ENV GRPCWEB_VER=1.4.2
ENV PROTOC_GEN_JS_VER=3.21.2

# Install protobuf types for Go
#RUN go get github.com/golang/protobuf/ptypes

# Install the protobuf compiler for Go
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@latest

RUN apt-get update && apt-get -y install unzip

WORKDIR /tmp

# Install protoc
RUN wget https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_VER}/protoc-${PROTOBUF_VER}-linux-x86_64.zip && \
    unzip protoc-${PROTOBUF_VER}-linux-x86_64.zip -d proto3 && \
    mv proto3/bin/* /usr/local/bin/ && \
    chmod +x /usr/local/bin/* && \
    mv proto3/include/* /usr/local/include/ && \
    chmod -R +r /usr/local/include

# Install protoc-gen-js
RUN wget https://github.com/protocolbuffers/protobuf-javascript/releases/download/v${PROTOC_GEN_JS_VER}/protobuf-javascript-${PROTOC_GEN_JS_VER}-linux-x86_64.zip && \
    unzip protobuf-javascript-${PROTOC_GEN_JS_VER}-linux-x86_64.zip -d protobuf-javascript && \
    chmod +x protobuf-javascript/bin/protoc-gen-js && \
    mv protobuf-javascript/bin/protoc-gen-js /usr/local/bin/

# Install protoc-gen-grpc-web
RUN wget -O protoc-gen-grpc-web https://github.com/grpc/grpc-web/releases/download/${GRPCWEB_VER}/protoc-gen-grpc-web-${GRPCWEB_VER}-linux-x86_64 && \
    chmod +x ./protoc-gen-grpc-web && \
    mkdir -p /protobufs && \
    mv protoc-gen-grpc-web /protobufs/

# Install protobuf source
RUN wget https://github.com/protocolbuffers/protobuf/archive/refs/tags/v${PROTOBUF_VER}.zip && \
    unzip v${PROTOBUF_VER}.zip -d proto3_src && \
    mkdir -p /protobufs/protobuf/ && \
    mv proto3_src/protobuf-${PROTOBUF_VER}/src /protobufs/protobuf/

WORKDIR /protobufs

#COPY protobuf/src protobuf/src/
COPY proto/openfmb proto/openfmb/
COPY generate-protos.sh .
RUN chmod 755 generate-protos.sh

CMD ["/protobufs/generate-protos.sh"]
