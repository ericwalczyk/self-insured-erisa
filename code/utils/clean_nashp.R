## upload and normalize NASHP data
library(readxl)
library(janitor)
library(dplyr)
library(purrr)

nashp_raw <- "data/raw/state_mandates/NASHP_leg_tracking.xlsx"

sheets <- excel_sheets(nashp_raw)

combined_df <- sheets %>%
  map_df(~ read_excel(nashp_raw, sheet = .x) %>%
           clean_names() %>%
           mutate(source_sheet = .x)
  )

## do it work tho
glimpse(combined_df)

#@ write it
write.csv(combined_df, "nashp_combined_clean.csv", row.names = FALSE)
