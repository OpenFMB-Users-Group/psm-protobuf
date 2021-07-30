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
SRC_PATHS="$BASEPATH/*.proto $BASEPATH/**/*.proto"

#########################################################
# Crystal
#########################################################

# Delete the previously generated Crystal files
rm -R gen/crystal-openfmb-ops-protobuf/openfmb/*

# Generate the new Crystal files
OUTPUTPATH=gen/crystal-openfmb-ops-protobuf/src/openfmb/
clear_output_dir $OUTPUTPATH
if protoc --proto_path=$PROTOBUF_PATH --proto_path=$BASEPATH --crystal_out=$OUTPUTPATH $SRC_PATHS ;
then
  echo "Generated Crystal protobuf files..."
else
  echo "Crystal generation failed!!!"
  exit 2
fi
