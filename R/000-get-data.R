library(tidyverse)
library(glue)
library(curl)
library(data.table)
library(xml2)
library(fs)

fs::dir_create("data", recurse = TRUE)

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

