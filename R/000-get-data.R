library(tidyverse)
library(glue)
library(curl)
library(data.table)
library(xml2)
library(fs)
# renv::install("spanishoddata=Robinlovelace/spanishoddata")
library(spanishoddata)

fs::dir_create("data", recurse = TRUE)

# v2 data

source("R/901-download-helpers.R")

download_selected_data <- function(){
    
    get_latest_v2_xml()
    
    all_files <- load_latest_v2_xml()
    
    fs::dir_create("data/logs", recurse = T)
    fs::dir_create("data/raw_data", recurse = T)
   
# 1. Download all spatial data 

    all_files[ grepl("zonificacion", target_url) ] |> 
        download_with_log(return_log = TRUE)
    
    
    
# 2. download sample of municipalities overnight stays --------------------

    all_files[ grepl("20220101_Pernoctaciones_municipios.csv.gz", target_url) ] |> 
        download_with_log(return_log = TRUE)
    
    
}

# v1 data

download_v1_data <- function(){

  Sys.setenv("SPANISH_OD_DATA_DIR" = here::here("data"))
  # Sys.getenv("SPANISH_OD_DATA_DIR")

  v1 <- spanishoddata:::spod_available_data(1, check_local_files = FALSE)

  spanishoddata::spod_download_data(
    "tpp",
    zones = "municip",
    dates = c("2020-03-14", "2020-10-01")
  )

  spanishoddata::spod_download_data(
    "tpp",
    zones = "distr",
    dates = c("2020-03-14", "2020-10-01")
  )
  
  spanishoddata::spod_download_data(
    "od",
    zones = "municip",
    dates = c("2020-03-14", "2020-10-01")
  )

  spanishoddata::spod_download_data(
    "od",
    zones = "distr",
    dates = c("2020-03-14", "2020-10-01")
  )
  
  zones_municip <- spanishoddata::spod_get_zones("municip", ver = 1)
  zones_distr <- spanishoddata::spod_get_zones("distr", ver = 1)

}
