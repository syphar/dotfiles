# custom pip completion because default is too slow

for cmd in 'install' 'uninstall' 
    complete -c pip -n __fish_use_subcommand -xa $cmd
end

function __list_pypi_packages
    set -l partial_name (commandline -t)
    rg "^$partial_name" --smart-case ~/.cache/pypi_packages.txt
end

complete -c pip -n "__fish_seen_subcommand_from install" -fa '(__list_pypi_packages)'
