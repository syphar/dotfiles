# custom pip completion because default is too slow

for cmd in install uninstall
    complete -c pip -n __fish_use_subcommand -xa $cmd
end

function __list_pypi_packages
    set -l partial_name (commandline -t)

    if string match -q "*==*" $partial_name
        set -l package (string match -g --regex "([^=]+)==.*" $partial_name)
        curl -Lfs https://pypi.org/pypi/$package/json | \
            jq -r '.releases|keys[]' | \
            # prefix with package name again so complete matches
            sed -e "s/^/$package==/" | \
            # semver sort: https://stackoverflow.com/a/63027058/1194456
            sort -r -t "." -k1,1n -k2,2n -k3,3n 
    else
        rg "^$partial_name" --smart-case ~/.cache/pypi_packages.txt
    end
end

complete -c pip -n "__fish_seen_subcommand_from install" -fka '(__list_pypi_packages)'
