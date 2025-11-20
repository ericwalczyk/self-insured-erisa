#!/usr/bin/env bash
set -e

# -------------------------------------------------------
# MEPS bulk downloader – macOS-safe version using curl
# -------------------------------------------------------

YEARS=(2023 2022 2021 2020 2019 2018 2017 2016 2015 2014)

declare -A CONSOLIDATED=(
  [2023]="HC-251" [2022]="HC-243" [2021]="HC-233" [2020]="HC-224" [2019]="HC-216"
  [2018]="HC-206" [2017]="HC-195" [2016]="HC-183" [2015]="HC-171" [2014]="HC-163"
)

declare -A CONDITIONS=(
  [2023]="HC-249" [2022]="HC-241" [2021]="HC-231" [2020]="HC-222" [2019]="HC-214"
  [2018]="HC-204" [2017]="HC-193" [2016]="HC-181" [2015]="HC-169" [2014]="HC-161"
)

declare -A JOBS=(
  [2023]="HC-246" [2022]="HC-237" [2021]="HC-226" [2020]="HC-217" [2019]="HC-209"
  [2018]="HC-199" [2017]="HC-188" [2016]="HC-176" [2015]="HC-164" [2014]="HC-156"
)

declare -A OFFICE=(
  [2023]="HC-248G" [2022]="HC-239G" [2021]="HC-229G" [2020]="HC-220G" [2019]="HC-212G"
  [2018]="HC-202G" [2017]="HC-191G" [2016]="HC-179G" [2015]="HC-167G" [2014]="HC-159G"
)

declare -A OUTPATIENT=(
  [2023]="HC-248F" [2022]="HC-239F" [2021]="HC-229F" [2020]="HC-220F" [2019]="HC-212F"
  [2018]="HC-202F" [2017]="HC-191F" [2016]="HC-179F" [2015]="HC-167F" [2014]="HC-159F"
)

declare -A ER=(
  [2023]="HC-248E" [2022]="HC-239E" [2021]="HC-229E" [2020]="HC-220E" [2019]="HC-212E"
  [2018]="HC-202E" [2017]="HC-191E" [2016]="HC-179E" [2015]="HC-167E" [2014]="HC-159E"
)

declare -A INPATIENT=(
  [2023]="HC-248D" [2022]="HC-239D" [2021]="HC-229D" [2020]="HC-220D" [2019]="HC-212D"
  [2018]="HC-202D" [2017]="HC-191D" [2016]="HC-179D" [2015]="HC-167D" [2014]="HC-159D"
)

declare -A RX=(
  [2023]="HC-248A" [2022]="HC-239A" [2021]="HC-229A" [2020]="HC-220A" [2019]="HC-212A"
  [2018]="HC-202A" [2017]="HC-191A" [2016]="HC-179A" [2015]="HC-167A" [2014]="HC-159A"
)

mkdir -p data/raw/meps/{consolidated,conditions,jobs,events}

download_and_place () {
  local puf=$1
  local dest=$2
  local label=$3
  local year=$4

  local short=$(echo $puf | sed 's/-//g')
  local url="https://meps.ahrq.gov/mepsweb/data_files/pufs/$puf/${short}dta.zip"
  local out="data/raw/meps/$dest/${label}_${year}.zip"

  echo "Downloading $label $year ($puf)..."
  curl -s -o "$out" "$url"
}

for year in "${YEARS[@]}"; do
  download_and_place "${CONSOLIDATED[$year]}" "consolidated" "consolidated" "$year"
  download_and_place "${CONDITIONS[$year]}"   "conditions"   "conditions"   "$year"
  download_and_place "${JOBS[$year]}"         "jobs"         "jobs"         "$year"

  download_and_place "${OFFICE[$year]}"       "events"       "office"       "$year"
  download_and_place "${OUTPATIENT[$year]}"   "events"       "outpatient"   "$year"
  download_and_place "${ER[$year]}"           "events"       "er"           "$year"
  download_and_place "${INPATIENT[$year]}"    "events"       "inpatient"    "$year"
  download_and_place "${RX[$year]}"           "events"       "rx"           "$year"
done

echo "✅ Finished! Files saved as readable names under data/raw/meps/"
