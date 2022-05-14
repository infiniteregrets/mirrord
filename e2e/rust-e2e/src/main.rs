#![feature(decl_macro)]
#[macro_use] extern crate rocket;

use rocket::data::{Data, ToByteUnit};
use std::env::current_dir;
use std::fs;
use std::process;

#[post("/", data = "<data>")]
async fn validate(data: Data<'_>) -> std::io::Result<()> {
    let received_data = data.open(2.mebibytes()).into_string().await?;
    let validate_data = get_file_data();    
    if received_data.value == validate_data {
        process::exit(0);
    } else {
        process::exit(1);
    }
}

fn get_file_data() -> String {
    let path = format!("{}/e2e/data.txt", current_dir().unwrap().display());
    let data = fs::read_to_string(&path).unwrap();
    data  
}

#[launch]
fn rocket() -> _ {
    let figment = rocket::Config::figment().merge(("port", 80));
    rocket::custom(figment).mount("/", routes![validate])
}