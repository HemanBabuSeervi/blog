TERM=ansi
blog(){
    cd blog
    cat ../index-header.html > indexUnformatted.html
    for year in $(ls [0-9][0-9][0-9][0-9] -dr); do
        year=$(basename $year)
        for month in $(ls $year/[0-9][0-9] -dr); do
            month=$(basename $month)
            for day in $(ls $year/$month/[0-9][0-9].html -r); do
                day=$(basename $day)
                title="$(echo $day | sed 's/.html//')-$month-$year"
                notes="$(cat $year/$month/$day)"
                echo "<div class=\"day\"><h3>$title</h3><div class=notes>$notes</div></div>" >> indexUnformatted.html
            done
        done
    done
    cat ../index-footer.html >> indexUnformatted.html
    cd -
}
backup(){
    if [[ -e $1 ]]; then
        backupExt=$(date +"%H-%M-%S=%d-%m-%Y")
        mkdir -p $(dirname "blog/backup/$1")
        mv "$1" "blog/backup/$1.$backupExt"
    fi
}

backup "index.html"
blog

tidy -indent --indent-spaces 4 --tidy-mark no -quiet blog/indexUnformatted.html > blog/index.html
rm blog/indexUnformatted.html
