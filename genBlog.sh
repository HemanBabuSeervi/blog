TERM=ansi
blog(){
    if [[ ! -d blog ]]; then
        echo "No blog Written"
        exit
    fi

    cat index-header.html > indexUnformatted.html
    for year in $(ls blog/[0-9][0-9][0-9][0-9] -dr); do
        year=$(basename $year)
        for month in $(ls blog/$year/[0-9][0-9] -dr); do
            month=$(basename $month)
            for day in $(ls blog/$year/$month/[0-9][0-9].html -r); do
                day=$(basename $day)
                title="$(echo $day | sed 's/.html//')-$month-$year"
                notes="$(cat $year/$month/$day)"
                echo "<div class=\"day\"><h3>$title</h3><div class=blog>$notes</div></div>" >> indexUnformatted.html
            done
        done
    done
    cat index-footer.html >> indexUnformatted.html
    tidy -indent --indent-spaces 4 --tidy-mark no -quiet indexUnformatted.html > indexNew.html
    rm indexUnformatted.html
}
backupIndex(){
    if [[ -e index.html ]]; then
        mkdir -p .backup
        timestamp=$(date +"%H-%M-%S=%d-%m-%Y")
        mv "index.html" ".backup/index_$timestamp.html"
    fi
}

blog

git checkout gh-pages
backupIndex
mv -f indexNew.html index.html
rm indexNew.html
git commmit -a || echo "Could'nt Commmit"  && git checkout main
