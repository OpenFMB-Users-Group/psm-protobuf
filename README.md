# Protobuf definitions for OpenFMB operational use cases

This repository contains the Protocol Buffer (protobuf) definitions based on the OpenFMB operational use case data model located [here](https://gitlab.com/openfmb/data-models/ops).

## Using

There really is no need to build these yourself (unless you just really want to). Individual repositories exist for each language which contain the output of the build steps below. If you just want to use the OpenFMB protobuf definitions in your own project, please choose one of these repositories to get native support for your particular language:

* C++ - https://gitlab.com/openfmb/psm/ops/protobuf/cpp-openfmb-ops-protobuf
* C# - https://gitlab.com/openfmb/psm/ops/protobuf/csharp-openfmb-ops-protobuf
* Go - https://gitlab.com/openfmb/psm/ops/protobuf/go-openfmb-ops-protobuf
* Java - https://gitlab.com/openfmb/psm/ops/protobuf/java-openfmb-ops-protobuf
* Python - https://gitlab.com/openfmb/psm/ops/protobuf/python-openfmb-ops-protobuf
* Rust - https://gitlab.com/openfmb/psm/ops/protobuf/rust-openfmb-ops-protobuf

## Building

Clone this repository locally:

```
git clone https://gitlab.com/openfmb/psm/ops/protobuf/openfmb-ops-protobuf.git
cd openfmb-ops-protobuf
```

In order to build the language-specific protobuf wrappers, two Dockerfiles have been provided:

* Dockerfile (for most languages)
* Dockerfile.rust (which is specific to Rust)

Before proceeding, install Docker according to your platform of choice.

### Dockerfile - most languages

Dockerfile will generate protobuf wrappers for the following programming languages:

* C++
* C#
* Go
* Java
* Python

Now, run the following commands:

```
docker build -t openfmb-generate-protos -f Dockerfile .
docker run --rm -v $PWD/gen:/protobufs/gen openfmb-generate-protos
```

After running these commands, you should have new subfolder for each of the above languages located in the "gen" folder of the current directory.

### Dockerfile.rust

Dockerfile.rust will only generate protobuf wrappers for the Rust programming language.

Run the following commands:

```
docker build -t openfmb-generate-protos -f Dockerfile .
docker run --rm -v $PWD/gen:/protobufs/gen openfmb-generate-protos
```

After running these commands, you will have a new "rust" subfolder in the "gen" folder of the current directory.

## Copyright

See the COPYRIGHT file for copyright information of information contained in this repository.

## License

Unless otherwise noted, all files in this repository are distributed under the Apache Version 2.0 license found in the LICENSE file.
