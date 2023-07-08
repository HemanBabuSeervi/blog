TERM=ansi   #bug-fix for tidy to work
blog(){
    cat index-header.html > indexUnformatted.html
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
    cat index-footer.html >> indexUnformatted.html
}
backup(){
    if [[ -e $1 ]]; then
        backupExt=$(date +"%H-%M-%S=%d-%m-%Y")
        mkdir -p $(dirname "backup/$1")
        mv "$1" "backup/$1.$backupExt"
    fi
}

backup "index.html"
blog

tidy -indent --indent-spaces 4 --tidy-mark no -quiet indexUnformatted.html > index.html
rm indexUnformatted.html
