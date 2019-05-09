# Protobuf definitions for OpenFMB operational use cases

This repository contains the Protocol Buffer (protobuf) definitions based on the OpenFMB operational use case data model located [here](https://gitlab.com/openfmb/data-models/ops).

## Using

There really is no need to generate programming language specific bindings yourself (unless you just really want to). Individual repositories exist for several programming languages which contain the output of the generation steps below. If you just want to use the OpenFMB protobuf definitions in your own project, please choose one of these repositories to get native support for your particular programming language:

* C++ - https://gitlab.com/openfmb/psm/ops/protobuf/cpp-openfmb-ops-protobuf
* C# - https://gitlab.com/openfmb/psm/ops/protobuf/csharp-openfmb-ops-protobuf
* Go - https://gitlab.com/openfmb/psm/ops/protobuf/go-openfmb-ops-protobuf
* Java - https://gitlab.com/openfmb/psm/ops/protobuf/java-openfmb-ops-protobuf
* Python - https://gitlab.com/openfmb/psm/ops/protobuf/python-openfmb-ops-protobuf
* Rust - https://gitlab.com/openfmb/psm/ops/protobuf/rust-openfmb-ops-protobuf

## Generating language-specific bindings

In order to generate language specific bindings, first clone this repository locally:

```
git clone --recursive https://gitlab.com/openfmb/psm/ops/protobuf/openfmb-ops-protobuf.git
cd openfmb-ops-protobuf
```

Make sure to include the `--recursive` flag above as the actual protocol buffers source needs to be fetched as well for the code generation to work properly.

In order to generate the language-specific bindings for OpenFMB protocol buffer definitions, two Dockerfiles have been provided:

* `Dockerfile` (for most languages)
* `Dockerfile.rust` (which is specific to Rust)

Before continuing, install [Docker](https://docs.docker.com/install/) (or Docker alternative such as [Podman](https://podman.io)) according to your development platform of choice.

### Dockerfile - most languages

Using `Dockerfile` will generate protobuf language bindings for the following programming languages:

* C++
* C#
* Go
* Java
* Python

Run the following commands:

```
docker build -t openfmb-generate-protos -f Dockerfile .
docker run --rm -v $PWD/gen:/protobufs/gen openfmb-generate-protos
```

After running these commands, you should have new subfolder for each of the above languages located in the `gen` folder of the current directory.

### Dockerfile.rust

Using `Dockerfile.rust` will only generate protobuf language bindings for the [Rust](https://www.rust-lang.org/) programming language.

Run the following commands:

```
docker build -t openfmb-generate-protos-rust -f Dockerfile.rust .
docker run --rm -v $PWD/gen:/protobufs/gen openfmb-generate-protos-rust
```

After running these commands, you will have a new `/rust` subfolder in the `gen` folder of the current directory.

### Note about the above Dockerfiles

Depending on how you install Docker (or a Docker alternative such as [Podman](https://podman.io)), you may need to add the `--privileged` flag to the `docker run` commands above so it can have the necessary permission to write the output files into the `$PWD/gen` volume mount. For example:

```
docker run --rm --privileged -v $PWD/gen:/protobufs/gen openfmb-generate-protos-rust
```

## Copyright

See the COPYRIGHT file for copyright information of information contained in this repository.

## License

Unless otherwise noted, all files in this repository are distributed under the Apache Version 2.0 license found in the LICENSE file.
