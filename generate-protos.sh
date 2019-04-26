#!/bin/bash

function clear_output_dir {
    if [ ! -d $1 ]
    then
    	mkdir -p $1
    else
    	rm -R $1/*
    fi
}

# Make sure that protoc is installed
if ! [ -x "$(command -v protoc)" ]; then
  echo 'Error: protoc is not installed.' >&2
  exit 1
fi

# Environment variables used during protoc calls
PROTOBUF_PATH=protobuf/src
BASEPATH=proto/openfmb

#########################################################
# C++
#########################################################

OUTPUTPATH=gen/cpp/openfmb/
clear_output_dir $OUTPUTPATH
if protoc --proto_path=$PROTOBUF_PATH --proto_path=$BASEPATH --cpp_out=$OUTPUTPATH $BASEPATH/**/*.proto ;
then
  echo "Generated C++ protobuf files..."
else
  echo "C++ generation failed!!!"
  exit 2
fi

#########################################################
# Java
#########################################################

OUTPUTPATH=gen/java/
clear_output_dir $OUTPUTPATH
if protoc --proto_path=$PROTOBUF_PATH --proto_path=$BASEPATH --java_out=$OUTPUTPATH $BASEPATH/**/*.proto ;
then
  echo "Generated Java protobuf files..."
else
  echo "Java generation failed!!!"
  exit 2
fi

#########################################################
# C#
#########################################################

OUTPUTPATH=gen/csharp/openfmb/
clear_output_dir $OUTPUTPATH
if protoc --proto_path=$PROTOBUF_PATH --proto_path=$BASEPATH --csharp_out=$OUTPUTPATH $BASEPATH/**/*.proto ;
then
  echo "Generated C# protobuf files..."
else
  echo "C# generation failed!!!"
  exit 2
fi

#########################################################
# Python
#########################################################

OUTPUTPATH=gen/python/openfmb/
clear_output_dir $OUTPUTPATH
if protoc --proto_path=$PROTOBUF_PATH --proto_path=$BASEPATH --python_out=$OUTPUTPATH $BASEPATH/**/*.proto ;
then
  echo "Generated Python protobuf files..."
else
  echo "Python generation failed!!!"
  exit 2
fi

#########################################################
# Go
#########################################################

# Make sure that go is installed
if ! [ -x "$(command -v go)" ]; then
  echo 'Error: Go language is not installed.' >&2
  exit 1
fi

# Make sure that we have the protobuf types for Go
if go get github.com/golang/protobuf/ptypes ;
then
  echo "Protobuf types for Go installed..."
else
  echo "Could not install protobuf types for Go!!!"
  exit 
fi

OUTPUTPATH=gen/go/
clear_output_dir $OUTPUTPATH
# For Go, uml and commonmodule MUST be generated first at the present time.
# Otherwise, breakermodule will not generate since it comes alphabetically
# before commonmodule. Will need to see if there is a way around this
# at some point.
#protoc --proto_path=$BASEPATH --go_out=$OUTPUTPATH $BASEPATH/**/*.proto
if protoc --proto_path=$PROTOBUF_PATH --proto_path=$BASEPATH --go_out=$OUTPUTPATH $BASEPATH/uml.proto ;
then
  echo "Generated Go protobuf files..."
else
  echo "Go generation failed!!!"
  exit 2
fi
protoc --proto_path=$PROTOBUF_PATH --proto_path=$BASEPATH --go_out=$OUTPUTPATH $BASEPATH/commonmodule/commonmodule.proto
protoc --proto_path=$PROTOBUF_PATH --proto_path=$BASEPATH --go_out=$OUTPUTPATH $BASEPATH/breakermodule/breakermodule.proto
protoc --proto_path=$PROTOBUF_PATH --proto_path=$BASEPATH --go_out=$OUTPUTPATH $BASEPATH/essmodule/essmodule.proto
protoc --proto_path=$PROTOBUF_PATH --proto_path=$BASEPATH --go_out=$OUTPUTPATH $BASEPATH/generationmodule/generationmodule.proto
protoc --proto_path=$PROTOBUF_PATH --proto_path=$BASEPATH --go_out=$OUTPUTPATH $BASEPATH/loadmodule/loadmodule.proto
protoc --proto_path=$PROTOBUF_PATH --proto_path=$BASEPATH --go_out=$OUTPUTPATH $BASEPATH/metermodule/metermodule.proto
protoc --proto_path=$PROTOBUF_PATH --proto_path=$BASEPATH --go_out=$OUTPUTPATH $BASEPATH/reclosermodule/reclosermodule.proto
protoc --proto_path=$PROTOBUF_PATH --proto_path=$BASEPATH --go_out=$OUTPUTPATH $BASEPATH/regulatormodule/regulatormodule.proto
protoc --proto_path=$PROTOBUF_PATH --proto_path=$BASEPATH --go_out=$OUTPUTPATH $BASEPATH/resourcemodule/resourcemodule.proto
protoc --proto_path=$PROTOBUF_PATH --proto_path=$BASEPATH --go_out=$OUTPUTPATH $BASEPATH/solarmodule/solarmodule.proto
protoc --proto_path=$PROTOBUF_PATH --proto_path=$BASEPATH --go_out=$OUTPUTPATH $BASEPATH/switchmodule/switchmodule.proto

# #########################################################
# # Rust
# #########################################################

# # Make sure that rust is installed
# if ! [ -x "$(command -v cargo)" ]; then
#   echo 'Error: Rust language is not installed.' >&2
#   exit 1
# fi

# cd rust-prost-gen
# cargo -q run
# cd ..
