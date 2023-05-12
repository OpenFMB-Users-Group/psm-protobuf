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
# Elixir
#########################################################

# Generate the new Elixir files
OUTPUTPATH=gen/elixir-openfmb-ops-protobuf/openfmb/
clear_output_dir $OUTPUTPATH
if protoc --proto_path=$PROTOBUF_PATH --proto_path=$BASEPATH --elixir_out=$OUTPUTPATH $SRC_PATHS ;
then
  # Fix module references to include Openfmb.
  sed -i "s/Commonmodule./Openfmb.Commonmodule./g" $OUTPUTPATH/**/*.pb.ex
  sed -i "s/Breakermodule./Openfmb.Breakermodule./g" $OUTPUTPATH/**/*.pb.ex
  sed -i "s/Capbankmodule./Openfmb.Capbankmodule./g" $OUTPUTPATH/**/*.pb.ex
  sed -i "s/Circuitsegmentservicemodule./Openfmb.Circuitsegmentservicemodule./g" $OUTPUTPATH/**/*.pb.ex
  sed -i "s/Essmodule./Openfmb.Essmodule./g" $OUTPUTPATH/**/*.pb.ex
  sed -i "s/Generationmodule./Openfmb.Generationmodule./g" $OUTPUTPATH/**/*.pb.ex
  sed -i "s/Interconnectionmodule./Openfmb.Interconnectionmodule./g" $OUTPUTPATH/**/*.pb.ex
  sed -i "s/Loadmodule./Openfmb.Loadmodule./g" $OUTPUTPATH/**/*.pb.ex
  sed -i "s/Metermodule./Openfmb.Metermodule./g" $OUTPUTPATH/**/*.pb.ex
  sed -i "s/Reclosermodule./Openfmb.Reclosermodule./g" $OUTPUTPATH/**/*.pb.ex
  sed -i "s/Regulatormodule./Openfmb.Regulatormodule./g" $OUTPUTPATH/**/*.pb.ex
  sed -i "s/Reservemodule./Openfmb.Reservemodule./g" $OUTPUTPATH/**/*.pb.ex
  sed -i "s/Resourcemodule./Openfmb.Resourcemodule./g" $OUTPUTPATH/**/*.pb.ex
  sed -i "s/Solarmodule./Openfmb.Solarmodule./g" $OUTPUTPATH/**/*.pb.ex
  sed -i "s/Switchmodule./Openfmb.Switchmodule./g" $OUTPUTPATH/**/*.pb.ex

  echo "Generated Elixir protobuf files..."
else
  echo "Elixir generation failed!!!"
  exit 2
fi
