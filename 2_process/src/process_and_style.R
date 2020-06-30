process_data <- function(nwis_data_file){
  nwis_data = read_csv(nwis_data_file)
  nwis_data_clean <- rename(nwis_data, water_temperature = X_00010_00000) %>% 
    select(-agency_cd, -X_00010_00000_cd, tz_cd)
  
  return(nwis_data_clean)
}

annotate_data <- function(site_data_clean, site_info){
  annotated_data <- left_join(site_data_clean, site_info, by = "site_no") %>% 
    select(station_name = station_nm, site_no, dateTime, water_temperature, latitude = dec_lat_va, longitude = dec_long_va)
  
  return(annotated_data)
}


style_data <- function(site_data_annotated){
  mutate(site_data_annotated, station_name = as.factor(station_name))
}

process_annotate_style <- function(site_data_file, site_info, outfile){
  processed = process_data(site_data_file)
  annotated = annotate_data(processed, site_info)
  styled = style_data(annotated)
  write.csv(styled, outfile)
}