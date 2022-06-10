function __list_poe_tasks
    set prev_args (commandline -pco)
    set tasks (poe _list_tasks | string split " ")
    set arg (commandline -ct)
    for task in $tasks
        if test "$task" != poe && contains $task $prev_args
            complete -C "ls $arg"
            return 0
        end
    end
    for task in $tasks
        echo $task
    end
end
complete -c poe --no-files -a '(__list_poe_tasks)'
