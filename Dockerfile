FROM golang:1.12.4

# Install protobuf types for Go
RUN go get github.com/golang/protobuf/ptypes

# Install the protobuf compiler for Go
RUN go get -u github.com/golang/protobuf/protoc-gen-go

RUN apt-get update && apt-get -y install unzip

# Install protoc
RUN wget https://github.com/protocolbuffers/protobuf/releases/download/v3.7.1/protoc-3.7.1-linux-x86_64.zip && \
    unzip protoc-3.7.1-linux-x86_64.zip -d proto3 && \
    mv proto3/bin/* /usr/local/bin/ && \
    mv proto3/include/* /usr/local/include/

WORKDIR /protobufs

COPY protobuf/src protobuf/src/
COPY proto/openfmb proto/openfmb/
COPY generate-protos.sh .
RUN chmod 755 generate-protos.sh

CMD ["/protobufs/generate-protos.sh"]
