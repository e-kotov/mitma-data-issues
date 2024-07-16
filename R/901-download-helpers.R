require(data.table)
require(tidyverse)
require(xml2)
require(curl)

get_latest_v2_xml <- function(){
    
    if( fs::dir_exists("data/cache") == FALSE ) { fs::dir_create("data/cache") }
    
    xml_url <- "https://movilidad-opendata.mitma.es/RSS.xml"
    current_timestamp <- format(Sys.time(), format = "%Y-%m-%dT%H-%M-%SZ", usetz = F, tz = "UTC")
    current_filename <- glue("data/cache/{current_timestamp}_data_links.xml")
    xml_requested <- curl::curl_download(url = xml_url, destfile = current_filename, quiet = FALSE)
    
}


load_latest_v2_xml <- function(data_dir = "data/raw_data/v2//"){
    
    xml_files_list <- fs::dir_ls(here("data/cache/"), type = "file", regexp = "data_links.xml") |> sort()
    latest_data_links_xml_path <- tail(xml_files_list, 1)
    
    x_xml <- xml2::read_xml(latest_data_links_xml_path)
    
    download_dt <- data.table( target_url = xml_find_all(x = x_xml, xpath = "//link") %>% xml2::xml_text(),
                               pub_date = xml_find_all(x = x_xml, xpath = "//pubDate") %>% xml2::xml_text())
    
    download_dt[ , pub_ts := dmy_hms(pub_date)]
    download_dt[ , file_extension := tools::file_ext(target_url), ]
    download_dt <- download_dt[ file_extension != "" ]
    download_dt[ , pub_date := NULL, ]
    
    download_dt[ , data_ym := ym( str_extract(target_url, "[0-9]{4}-[0-9]{2}") ), ]
    download_dt[ , data_ymd := ymd( str_extract(target_url, "[0-9]{8}" )), ]
    # glimpse(download_dt)
    
    download_dt <- download_dt[ file_extension != "" ]
    
    setorder(download_dt, pub_ts)
    
    
    download_dt[ , local_path := paste0(data_dir, str_replace(target_url, "https://movilidad-opendata.mitma.es/", "")), ]
    download_dt[ , local_path := gsub("\\/\\/\\/|\\/\\/", "\\/", local_path), ]
    
    return(download_dt)
}


download_with_log <- function(files_to_download, return_log = FALSE){
    
    fs::dir_create(unique(dirname(files_to_download$local_path)), recurse = T)
    tmp_download_log <- curl::multi_download(url = files_to_download$target_url,
                                             destfile = files_to_download$local_path,
                                             progress = T, resume = FALSE)
    log_timestamp <- format(Sys.time(), format = "%Y-%m-%dT%H-%M-%SZ", usetz = F, tz = "UTC")
    log_filename <- glue("data/logs/{log_timestamp}_download_log.csv")
    fwrite(tmp_download_log, log_filename, sep = ",")
    if(return_log){
        return(tmp_download_log)
    }
}
