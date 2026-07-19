function download-crate-source
    if test (count $argv) -ne 2
        echo "Usage: download-crate-source <crate> <version>" >&2
        return 2
    end

    set -l crate $argv[1]
    set -l ver $argv[2]

    set -l destination (mktemp -d "$HOME/tmp/$crate-$ver.XXXXXX")
    or return 1

    set -l url "https://static.crates.io/crates/$crate/$crate-$ver.crate"
    echo "Downloading $url" >&2
    curl -fsSL "$url" | tar -xz --strip-components=1 -C "$destination"
    set -l pipeline_status $pipestatus

    if test $pipeline_status[1] -ne 0; or test $pipeline_status[2] -ne 0
        echo "Error: failed to download or extract $crate $ver" >&2
        return 1
    end

    cd "$destination"
    or return 1
end
