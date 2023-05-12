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
# C++
#########################################################

OUTPUTPATH=gen/cpp-openfmb-ops-protobuf/openfmb/
clear_output_dir $OUTPUTPATH
if protoc --proto_path=$PROTOBUF_PATH --proto_path=$BASEPATH --cpp_out=$OUTPUTPATH $SRC_PATHS ;
then
  echo "Generated C++ protobuf files..."
else
  echo "C++ generation failed!!!"
  exit 2
fi

#########################################################
# Java + Kotlin
#########################################################

OUTPUTPATH_JAVA=gen/java-openfmb-ops-protobuf/openfmb/
clear_output_dir $OUTPUTPATH_JAVA
OUTPUTPATH_JAVA=gen/java-openfmb-ops-protobuf/
OUTPUTPATH_KOTLIN=gen/kotlin-openfmb-ops-protobuf/openfmb/
clear_output_dir $OUTPUTPATH_KOTLIN
OUTPUTPATH_KOTLIN=gen/kotlin-openfmb-ops-protobuf/
if protoc --proto_path=$PROTOBUF_PATH --proto_path=$BASEPATH --java_out=$OUTPUTPATH_JAVA --kotlin_out=$OUTPUTPATH_KOTLIN $SRC_PATHS ;

then
  echo "Generated Java + Kotlin protobuf files..."
else
  echo "Java + Kotlin generation failed!!!"
  exit 2
fi

#########################################################
# C#
#########################################################

OUTPUTPATH=gen/csharp-openfmb-ops-protobuf/openfmb/
clear_output_dir $OUTPUTPATH
if protoc --proto_path=$PROTOBUF_PATH --proto_path=$BASEPATH --csharp_out=$OUTPUTPATH $SRC_PATHS ;
then
  echo "Generated C# protobuf files..."
else
  echo "C# generation failed!!!"
  exit 2
fi

#########################################################
# Python
#########################################################

OUTPUTPATH=gen/python-openfmb-ops-protobuf/openfmb/
clear_output_dir $OUTPUTPATH
if protoc --proto_path=$PROTOBUF_PATH --proto_path=$BASEPATH --python_out=$OUTPUTPATH $SRC_PATHS ;
then
  echo "Generated Python protobuf files..."
else
  echo "Python generation failed!!!"
  exit 2
fi

#########################################################
# Ruby
#########################################################

OUTPUTPATH=gen/ruby-openfmb-ops-protobuf/openfmb/
clear_output_dir $OUTPUTPATH
if protoc --proto_path=$PROTOBUF_PATH --proto_path=$BASEPATH --ruby_out=$OUTPUTPATH $SRC_PATHS ;
then
  echo "Generated Ruby protobuf files..."
else
  echo "Ruby generation failed!!!"
  exit 2
fi

#########################################################
# TypeScript
#########################################################
OUTPUTPATH=gen/typescript-openfmb-ops-protobuf/openfmb/
clear_output_dir $OUTPUTPATH
if protoc --proto_path=$PROTOBUF_PATH --proto_path=$BASEPATH --plugin=protoc-gen-grpc-web=/protobufs/protoc-gen-grpc-web  --js_out=import_style=commonjs:$OUTPUTPATH --grpc-web_out=import_style=commonjs+dts,mode=grpcwebtext:$OUTPUTPATH $SRC_PATHS ;
then
  echo "Generated TypeScript protobuf files..."
else
  echo "TypeScript generation failed!!!"
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
if [ -n "$(find $GOPATH/pkg/mod/google.golang.org/ -name any.pb.go)" ];
then
  echo "Protobuf types for Go installed..."
else
  echo "Could not find protobuf types for Go!!! Go files not generated..."
  exit 3
fi

# Generate the new Go files to a temporary folder
OUTPUTPATH=gen/go/
clear_output_dir $OUTPUTPATH
# For Go, uml and commonmodule MUST be generated first at the present time.
# Otherwise, breakermodule will not generate since it comes alphabetically
# before commonmodule. Will need to see if there is a way around this
# at some point.
#protoc --proto_path=$BASEPATH --go_out=$OUTPUTPATH $BASEPATH/**/*.proto
if protoc --proto_path=$PROTOBUF_PATH --proto_path=$BASEPATH --go_out=$OUTPUTPATH $BASEPATH/uml.proto ;
then
  echo "Generating Go protobuf files..."
else
  echo "Go generation failed!!!"
  exit 2
fi
protoc --proto_path=$PROTOBUF_PATH --proto_path=$BASEPATH --go_out=$OUTPUTPATH $BASEPATH/commonmodule/commonmodule.proto
protoc --proto_path=$PROTOBUF_PATH --proto_path=$BASEPATH --go_out=$OUTPUTPATH $BASEPATH/breakermodule/breakermodule.proto
protoc --proto_path=$PROTOBUF_PATH --proto_path=$BASEPATH --go_out=$OUTPUTPATH $BASEPATH/capbankmodule/capbankmodule.proto
protoc --proto_path=$PROTOBUF_PATH --proto_path=$BASEPATH --go_out=$OUTPUTPATH $BASEPATH/circuitsegmentservicemodule/circuitsegmentservicemodule.proto
protoc --proto_path=$PROTOBUF_PATH --proto_path=$BASEPATH --go_out=$OUTPUTPATH $BASEPATH/essmodule/essmodule.proto
protoc --proto_path=$PROTOBUF_PATH --proto_path=$BASEPATH --go_out=$OUTPUTPATH $BASEPATH/generationmodule/generationmodule.proto
protoc --proto_path=$PROTOBUF_PATH --proto_path=$BASEPATH --go_out=$OUTPUTPATH $BASEPATH/interconnectionmodule/interconnectionmodule.proto
protoc --proto_path=$PROTOBUF_PATH --proto_path=$BASEPATH --go_out=$OUTPUTPATH $BASEPATH/loadmodule/loadmodule.proto
protoc --proto_path=$PROTOBUF_PATH --proto_path=$BASEPATH --go_out=$OUTPUTPATH $BASEPATH/metermodule/metermodule.proto
protoc --proto_path=$PROTOBUF_PATH --proto_path=$BASEPATH --go_out=$OUTPUTPATH $BASEPATH/reclosermodule/reclosermodule.proto
protoc --proto_path=$PROTOBUF_PATH --proto_path=$BASEPATH --go_out=$OUTPUTPATH $BASEPATH/regulatormodule/regulatormodule.proto
protoc --proto_path=$PROTOBUF_PATH --proto_path=$BASEPATH --go_out=$OUTPUTPATH $BASEPATH/reservemodule/reservemodule.proto
protoc --proto_path=$PROTOBUF_PATH --proto_path=$BASEPATH --go_out=$OUTPUTPATH $BASEPATH/resourcemodule/resourcemodule.proto
protoc --proto_path=$PROTOBUF_PATH --proto_path=$BASEPATH --go_out=$OUTPUTPATH $BASEPATH/solarmodule/solarmodule.proto
protoc --proto_path=$PROTOBUF_PATH --proto_path=$BASEPATH --go_out=$OUTPUTPATH $BASEPATH/switchmodule/switchmodule.proto

# Delete the old generated Go files
OUTPUTPATH=gen/go-openfmb-ops-protobuf/v2/openfmb/
clear_output_dir $OUTPUTPATH

# Copy the generated Go files into the local folder
cp -R gen/go/gitlab.com/openfmb/psm/ops/protobuf/go-openfmb-ops-protobuf/v2/openfmb/** gen/go-openfmb-ops-protobuf/v2/openfmb/

# Remove the generated gen/go/ folder
rm -R gen/go/

echo "Generating Go protobuf files...DONE"
