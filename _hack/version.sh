#!/bin/bash -x

scriptDir="$(dirname "$0")"

if [ $# -ne 2 ]; then
	echo "Usage: $0 <Version> <Operator Version>"
	exit 1
fi

VERSION="$1"
OP_VER="$2"

IMAGE=cicd-util

INCLUDED=("was" "was-db" "db" "gitlab" "jenkins" "mysql-ha" "package-server" "vscode")

for DIR in "${INCLUDED[@]}"; do
    find "$scriptDir/../$DIR" -type f -name "*.yaml" | while read line; do
        sed -i -E "s/template-version[ ]*:[ ]*.*/template-version: $VERSION/" "$line"
        sed -i -E "s/tested-operator-version[ ]*:[ ]*.*/tested-operator-version: $OP_VER/" "$line"
        sed -i -E "s/$IMAGE:.*/$IMAGE:$VERSION/" "$line"
    done
done
