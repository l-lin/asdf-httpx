#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/servicex-sh/httpx"
TOOL_NAME="httpx"
TOOL_TEST="httpx --version"

fail() {
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if httpx is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' | cut -d/ -f3- |
    sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
  list_github_tags
}

download_release() {
  local version filename url
  version="$1"
  filename="$2"

  local arch="$(get_arch)"
  local platform="$(get_platform)"

  case $platform in
  darwin)
    url="$GH_REPO/releases/download/v${version}/httpx-${version}-${arch}-apple-${platform}.tar"
    ;;
  linux)
    url="$GH_REPO/releases/download/v${version}/httpx-${platform}-${arch}.zip"
    ;;
  windows)
    url="$GH_REPO/releases/download/v${version}/httpx-${platform}-${arch}.exe.zip"
    ;;
  *)
    echo "Unknown platform: ${platform}"
    exit 1
    ;;
  esac

  echo "* Downloading $TOOL_NAME release $version..."
  curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="$3"

  if [ "$install_type" != "version" ]; then
    fail "asdf-$TOOL_NAME supports release installs only"
  fi

  (
    mkdir -p "$install_path/bin"

    local tool_cmd
    tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"

    local first_extracted_file=$(ls -1 $ASDF_DOWNLOAD_PATH | head -n 1)
    echo "Copying $first_extracted_file to $install_path/bin/$tool_cmd"
    cp -r "$ASDF_DOWNLOAD_PATH/$first_extracted_file" "$install_path/bin/$tool_cmd"

    echo "Setting $install_path/bin/$tool_cmd as executable"
    chmod +x "$install_path/bin/$tool_cmd"

    test -x "$install_path/bin/$tool_cmd" || fail "Expected $install_path/bin/$tool_cmd to be executable."

    echo "$TOOL_NAME $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error ocurred while installing $TOOL_NAME $version."
  )
}

get_platform() {
  echo "$(uname | tr '[:upper:]' '[:lower:]')"
}

get_arch() {
  local arch=$(uname -m)
  if [[ "$arch" != "x86_64" ]]; then
    echo "Unsupported: ${arch}"
    exit 1
  fi
  echo "$arch"
}

get_archive_extension() {
  local platform=$(get_platform)
  case $platform in
  linux)
    echo "zip"
    ;;
  *)
    echo "tar.gz"
    ;;
  esac
}

extract_archive() {
  local release_file=$1
  local target_folder=$2

  if [[ $release_file =~ .*\.zip$ ]]; then
    unzip $release_file -d $target_folder
  else
    tar xzvf "$release_file" -C $target_folder
  fi
}
