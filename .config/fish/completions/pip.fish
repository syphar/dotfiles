# default from fish-shell source
pip completion --fish 2>/dev/null | source

# custom complete package names
function __list_pypi_packages
    set -l partial_name (commandline -t)
    rg "^$parital_name" --smart-case ~/.cache/pypi_packages.txt
end

complete -c pip -n "__fish_seen_subcommand_from install" -fa '(__list_pypi_packages)'
