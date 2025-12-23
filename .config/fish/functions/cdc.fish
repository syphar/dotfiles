# select a subcrate to jump to. searches from the repo root
function cdc
    set -l root (git rev-parse --show-toplevel 2>/dev/null)
    test -n "$root"; or return

    set -l target (
        fd \
            --glob Cargo.toml \
            --type f \
            --relative-path \
            --base-directory $root \
            --format '{//}' \
        | fzf
    )

    test -n "$target"; and cd $root/$target
end
