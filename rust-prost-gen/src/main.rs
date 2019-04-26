extern crate prost;
extern crate prost_build;

use std::fs;
use std::fs::File;
use std::io::prelude::*;
use std::io::Result;
use std::path::Path;

fn main() {
    // Make sure the output directory is actually present or the run statement
    // below will panic with a "No such file or directory" error.
    let output_directory = "../gen/rust/openfmb/";
    if Path::new(output_directory).exists() {
        let paths = fs::read_dir(output_directory).unwrap();

        for path in paths {
            let path = path.unwrap().path();
            // println!("path: {:?}", path);
            let _result = fs::remove_file(path).unwrap();
        }
    } else {
        let _result: Result<()> = fs::create_dir_all(output_directory);
    }

    // "Base" directory where the OpenFMB .proto files are located
    let base_dir = "../proto/openfmb";

    // Google protobuf definitions
    let google_proto_dir = "../protobuf/src";

    // Loop through the OpenFMB protobuf folders and add all of the .proto files
    // to the input files array. Also save the "module" folder names so they can
    // be added to the "mod.rs" file.
    let mut input_files: Vec<String> = Vec::new();
    let mut openfmb_modules: Vec<String> = Vec::new();
    let paths = fs::read_dir(Path::new(base_dir)).unwrap();
    // Sort the directory listing
    let mut paths: Vec<_> = paths.map(|r| r.unwrap()).collect();
    paths.sort_by_key(|dir| dir.path());

    for path in paths {
        let path = path.path();
        // print!("Path name: {}\n", path.display());
        let comp = path.components();
        if path.is_dir() {
            let folder_comp = comp.last().unwrap();
            let folder_str = folder_comp.as_os_str().to_str().unwrap();
            // print!("Folder name: {}\n", folder_str);
            openfmb_modules.push(String::from(folder_str));
            let protos = fs::read_dir(Path::new(path.to_str().unwrap())).unwrap();
            for proto in protos {
                let proto = proto.unwrap().path();
                // print!("File name: {}\n", proto.display());
                input_files.push(String::from(proto.to_str().unwrap()));
            }
        } else {
            // Remove the ".proto" from the end of the file name
            let file_comp = comp.last().unwrap();
            let file_str = file_comp.as_os_str().to_str().unwrap();
            openfmb_modules.push(String::from(file_str.trim_end_matches(".proto")));

            input_files.push(String::from(path.to_str().unwrap()));
        }
    }
    let mut input_protos: Vec<&str> = Vec::new();
    for filepath in &input_files {
        // println!("filepath: {}", &filepath);
        input_protos.push(&filepath);
    }

    // Generate the actual .rs files for the input .proto files
    let mut pb = prost_build::Config::default();
 
    pb.out_dir(output_directory);
    let r = pb.compile_protos(&input_protos, &[&base_dir, &google_proto_dir]);
    match r {
        Ok(_is_ok) => {
            println!("Generated Rust protobuf files...");
        }
        Err(e) => {
            println!("{}", e);
            std::process::exit(1);
        }
    };

    // Finally build the "mod.rs" files to reference all of the modules
    let mut buffer = File::create(String::from(output_directory) + "/mod.rs").unwrap();
    for module in openfmb_modules {
        let line = String::from("pub mod ") + &module + ";\n";
        buffer.write(line.as_bytes()).unwrap();
    }
}
