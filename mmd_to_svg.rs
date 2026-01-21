#!/usr/bin/env cargo
---
[dependencies]
walkdir = "2"
---

use std::process::{Command, Stdio};
use walkdir::WalkDir;

fn main() {
    for entry in WalkDir::new(".").into_iter().filter_map(|e| e.ok()) {
        let path = entry.path();

        // Skip if not mmd
        if path.extension().map(|e| e != "mmd").unwrap_or(true) {
            continue;
        }

        let svg_path = path.with_extension("svg");
        let pdf_path = path.with_extension("pdf");

        // Skip if svg is newer than mmd
        if svg_path.exists() {
            let mmd_time = path.metadata().unwrap().modified().unwrap();
            let svg_time = svg_path.metadata().unwrap().modified().unwrap();
            if svg_time >= mmd_time {
                continue;
            }
        }

        let path_str = path.to_string_lossy();
        let pdf_str = pdf_path.to_string_lossy();
        let svg_str = svg_path.to_string_lossy();

        println!("Converting: {}", path.display());

        // mmd -> pdf
        let mut mmdc_args = vec!["-i", &*path_str, "-o", &*pdf_str];
        let puppeteer_config = std::env::var("PUPPETEER_CONFIG");
        if let Ok(ref config) = puppeteer_config {
            mmdc_args.extend(["-p", config]);
        }
        execute("mmdc", &mmdc_args);
        assert!(pdf_path.exists());

        // pdf -> svg
        execute(
            "inkscape",
            &[
                "--export-area-drawing",
                "--export-type=svg",
                "--pdf-poppler",
                "-l",
                &pdf_str,
                "-o",
                &svg_str,
            ],
        );
        assert!(svg_path.exists());

        // Clean up pdf
        std::fs::remove_file(&pdf_path).unwrap();
        assert!(!pdf_path.exists());
    }
    println!("Done");
}

fn execute(cmd: &str, args: &[&str]) {
    if cfg!(windows) {
        Command::new("cmd")
            .arg("/C")
            .arg(cmd)
            .args(args)
            .stderr(Stdio::null())
            .stdout(Stdio::null())
            .status()
            .unwrap();
    } else {
        Command::new(cmd)
            .args(args)
            .stderr(Stdio::null())
            .stdout(Stdio::null())
            .status()
            .unwrap();
    }
}
