year=$(date +%Y)
month=$(date +%m)
day=$(date +%d)
mkdir -p "blog/$year/$month"
nvim blog/$year/$month/$day.html
