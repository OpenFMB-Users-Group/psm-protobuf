# Protobuf definitions for OpenFMB operational use cases

This repository contains the Protocol Buffer (protobuf) definitions based on the OpenFMB operational use case data model located [here](https://github.com/OpenFMB-Users-Group/pim.git).

## Using

There really is no need to generate programming language specific bindings yourself (unless you just really want to). Individual repositories exist for several programming languages which contain the output of the generation steps below. If you just want to use the OpenFMB protobuf definitions in your own project, please choose one of these repositories to get native support for your particular programming language:

* C++ - https://github.com/OpenFMB-Users-Group/psm-protobuf-cpp.git
* Crystal - https://github.com/OpenFMB-Users-Group/psm-protobuf-crystal.git
* C# - https://github.com/OpenFMB-Users-Group/psm-protobuf-csharp.git
* Elixir - https://github.com/OpenFMB-Users-Group/psm-protobuf-elixir.git
* Go - https://github.com/OpenFMB-Users-Group/psm-protobuf-go.git
* Java - https://github.com/OpenFMB-Users-Group/psm-protobuf-java.git
* Kotlin - https://github.com/OpenFMB-Users-Group/psm-protobuf-kotlin.git
* Python - https://github.com/OpenFMB-Users-Group/psm-protobuf-python.git
* Ruby - https://github.com/OpenFMB-Users-Group/psm-protobuf-ruby.git
* Rust - https://github.com/OpenFMB-Users-Group/psm-protobuf-rust.git
* TypeScript - https://github.com/OpenFMB-Users-Group/psm-protobuf-typescript.git

## Generating language-specific bindings

In order to generate language specific bindings, first clone this repository locally:

```
git clone https://github.com/OpenFMB-Users-Group/psm-protobuf.git
cd psm-protobuf
```

In order to generate the language-specific bindings for OpenFMB protocol buffer definitions, four Dockerfiles have been provided:

* `Dockerfile` (for most languages)
* `Dockerfile.rust` (which is specific to Rust)
* `Dockerfile.crystal` (which is specific to Crystal)
* `Dockerfile.elixir` (which is specific to Elixir)

Before continuing, install [Docker](https://docs.docker.com/install/) (or Docker alternative such as [Podman](https://podman.io)) according to your development platform of choice.

### Dockerfile - most languages

Using `Dockerfile` will generate protobuf language bindings for the following programming languages:

* C++
* C#
* Go
* Java
* Kotlin
* Python
* Ruby
* TypeScript

Run the following commands:

```
docker build -t openfmb-generate-protos:$(git branch --show-current) -f Dockerfile .
docker run --user=$(id -u):$(id -g) --rm -v $PWD/gen:/protobufs/gen openfmb-generate-protos:$(git branch --show-current)
```

After running these commands, you should have new subfolder for each of the above languages located in the `gen` folder of the current directory.

### Dockerfile.rust

Using `Dockerfile.rust` will only generate protobuf language bindings for the [Rust](https://www.rust-lang.org/) programming language.

Run the following commands:

```
docker build -t openfmb-generate-protos-rust:$(git branch --show-current) -f Dockerfile.rust .
docker run --user=$(id -u):$(id -g) --rm -v $PWD/gen:/protobufs/gen openfmb-generate-protos-rust:$(git branch --show-current)
```

After running these commands, you will have a new `/rust-openfmb-ops-protobuf` subfolder in the `gen` folder of the current directory.

### Dockerfile.crystal

Using `Dockerfile.crystal` will only generate protobuf language bindings for the [Crystal](https://crystal-lang.org/) programming language.

Run the following commands:

```
docker build -t openfmb-generate-protos-crystal:$(git branch --show-current) -f Dockerfile.crystal .
docker run --user=$(id -u):$(id -g) --rm -v $PWD/gen:/protobufs/gen openfmb-generate-protos-crystal:$(git branch --show-current)
```

After running these commands, you will have a new `/crystal-openfmb-ops-protobuf` subfolder in the `gen` folder of the current directory.


### Dockerfile.elixir

Using `Dockerfile.elixir` will only generate protobuf language bindings for the [Elixir](https://elixir-lang.org/) programming language.

Run the following commands:

```
docker build -t openfmb-generate-protos-elixir:$(git branch --show-current) -f Dockerfile.elixir .
docker run --user=$(id -u):$(id -g) --rm -v $PWD/gen:/protobufs/gen openfmb-generate-protos-elixir:$(git branch --show-current)
```

After running these commands, you will have a new `/elixir-openfmb-ops-protobuf` subfolder in the `gen` folder of the current directory.


### Note about the above Dockerfiles

Depending on how you install Docker (or a Docker alternative such as [Podman](https://podman.io)), you may need to add the `--privileged` flag to the `docker run` commands above so it can have the necessary permission to write the output files into the `$PWD/gen` volume mount. For example:

```
docker run --user=$(id -u):$(id -g) --rm --privileged -v $PWD/gen:/protobufs/gen openfmb-generate-protos-rust:$(git branch --show-current)
```

## Copyright

See the COPYRIGHT file for copyright information of information contained in this repository.

## License

Unless otherwise noted, all files in this repository are distributed under the Apache Version 2.0 license found in the LICENSE file.
