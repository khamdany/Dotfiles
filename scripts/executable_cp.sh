DESTINATION="${@: -1}"  # get the last argument

for ((i=1; i<$#; i++)); do
    SOURCE="${!i}"  # get the i-th argument
    if [ -d "$SOURCE" ]; then 
        SOURCE="$SOURCE/"
        NAMEFOLDER=$(basename "$SOURCE")
        FINAL_DESTINATION="$DESTINATION$NAMEFOLDER"
    else
        FINAL_DESTINATION="$DESTINATION"
    fi
    rsync -avhu --progress "$SOURCE" "$FINAL_DESTINATION"
done
