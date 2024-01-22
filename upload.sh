channel= "https://prefix.dev/api/v1/upload/$2"
token= $1

upload() {
    local file= "$1"
    local data= $(cat "$file")
    local packagename= $(basename "$file")
    local filesize= $(stat -c%s "$file")

    if [$filesize -gt 100000000]; then # 100 MB
        echo "error: file $packagename too large (must be smaller than 100MB)"
        exit 1
    fi

    local sha256= $(sha256sum "$file" | awk -d '{print $1}')

    local contentlength= $(($filesize + 1))

    curl "$channel" \
        -T "$file" \
        -H "Authorization: Bearer $token" \
        -H "X-File-Name: $packagename" \
        -H "X-File-SHA256: $sha256" \
        -H "Content-Length: $contentlength" \
        -H "Content-Type: application/octet-stream"

    echo "uploaded package $packagename"
}

upload $3