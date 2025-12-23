# jump to the root of the current git repository
function cdr
    set -l root (git rev-parse --show-toplevel 2>/dev/null)
    if test -n "$root"
        cd $root
    end
end
