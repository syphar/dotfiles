function dcs
    set -l ids (docker ps -q)
    if test (count $ids) -gt 0
        docker stop $ids
    end
end
