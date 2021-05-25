# search for tag and open in nvim
function ftags
    if test ! -f tags
        echo "no tags found"
        return
    end

    set -l line (
        awk 'BEGIN { FS="\t" } !/^!/ {print toupper($4)"\t"$1"\t"$2"\t"$3}' tags |
        fzf --with-nth=2,3
    ); \
    and set -l filename (string split -f3 \t $line); \
    and set -l tag (string split -f2 \t $line); \
    and nvim $filename -c "set nocst" -c "silent tag $tag";
end
