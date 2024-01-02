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
                timestamp="$(echo $day | sed 's/.html//')-$month-$year"
                notes="$(cat blog/$year/$month/$day)"
                echo "<div class=\"day\"><h2 class="timestamp">$timestamp</h2><div class=blog>$notes</div></div>" >> indexUnformatted.html
            done
        done
    done
    cat index-footer.html >> indexUnformatted.html
    tidy -indent --indent-spaces 4 --tidy-mark no -quiet indexUnformatted.html > indexNew.html
    rm indexUnformatted.html
}

blog

git checkout gh-pages || { echo -e "\033[31mCould'nt checkout gh-pages\033[0m.\n\033[33mCommit any changes to current Branch and rerun the script" && rm indexNew.html && exit 1; }
if [[ -e index.html ]]; then
    mkdir -p .backup
    timestamp=$(date +"%H-%M-%S=%d-%m-%Y")
    mv "index.html" ".backup/index_$timestamp.html"
    git add .backup
fi
mv -f indexNew.html index.html
git add index.html
git commit -a || echo "Could'nt Commmit"  && git checkout main
