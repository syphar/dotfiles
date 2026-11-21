function fkill
    set -l signal 'TERM'
    test -z $argv[1]
    or set signal $argv[1]

    set -l uid (id -u)
    set -l pid
    if test $uid -ne 0
        set pid (/bin/ps -f -u $uid | sed 1d | fzf -m | awk '{ print $2; }')
    else
        set pid (/bin/ps -ef | sed 1d | fzf -m | awk '{ print $2; }')
    end

    echo $pid

    test -z $pid
    or kill -$signal $pid
end
