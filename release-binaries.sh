#!/usr/bin/env bash
echo "Using username: ${GITHUB_USER}"

VERSION=$(cat VERSION)

if [ "$(uname)" == "Darwin" ]; then
    os="darwin"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    os="linux"
else
    echo "unsupported OS"
    exit 1
fi

echo "Building on Arch: ${os}"

repo=yunxing/reason-bin

RELEASE_RESULT=

RELEASE_ID=$(\
  curl --silent -H 'Accept: application/vnd.github.v3+json' \
       --user "${GITHUB_USER}:${GITHUB_TOKEN}" \
       -X POST --data "{\"tag_name\": \"${VERSION}-${os}\"}" \
       https://api.github.com/repos/$repo/releases \
      | python -c 'import sys, json; print json.load(sys.stdin)["id"]' \
)

if [ $? -ne 0 ]
then
    echo "Can't create a release: ${VERSION}-${os}"
    exit 1
fi

echo "new release id: $RELEASE_ID"

BIN_DIR=$(opam config var bin)

cleanup () {
  curl --silent -H 'Accept: application/vnd.github.v3+json' \
       --user "${GITHUB_USER}:${GITHUB_TOKEN}" \
       -X DELETE
       https://api.github.com/repos/$repo/releases
}

if [ $? -ne 0 ]
then
    cleanup
fi
rm -rf bin
mkdir -p bin
cp ${BIN_DIR}/refmt bin
cp ${BIN_DIR}/ocamlmerlin bin
cp ${BIN_DIR}/ocamlmerlin-reason bin

TARNAME="reason-bin.tar.gz"
rm -f ${TARNAME}
tar -cvzf ${TARNAME} "bin"
if [ $? -ne 0 ]
then
    cleanup
fi

ASSET_DOWNLOAD_URL=$(\
  curl -H 'Accept: application/vnd.github.v3+json' \
       -H 'Content-Type: application/gzip' \
       --user "${GITHUB_USER}:${GITHUB_TOKEN}" \
       -X POST \
       --data-binary "@${TARNAME}" \
       "https://uploads.github.com/repos/$repo/releases/${RELEASE_ID}/assets?name=${TARNAME}"
)

if [ $? -ne 0 ]
then
    cleanup
fi
