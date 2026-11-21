function __list_poe_tasks
    # Check if `-C target_path` have been provided
    set target_path ''
    set prev_args (commandline -pco)
    for i in (seq (math (count $prev_args) - 1))
        set j (math $i + 1)
        set k (math $i + 2)
        if test "$prev_args[$j]" = "-C" && test "$prev_args[$k]" != ""
            set target_path "$prev_args[$k]"
            break
        end
    end
    set tasks (poe _list_tasks $target_path | string split ' ')
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
