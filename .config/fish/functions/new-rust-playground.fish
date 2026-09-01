function new-rust-playground --description "Create a temporary Rust playground project"
    set tmp_dir (mktemp -d ~/tmp/rust-playground.XXXXXX)

    set project_name "playground-"(random)
    set project_dir "$tmp_dir/$project_name"

    cargo init --bin "$project_dir"

    printf '%s\n' \
        'fn main() -> anyhow::Result<()> {' \
        '    Ok(())' \
        '}' >"$project_dir/src/main.rs"

    cd "$project_dir"

    cargo add url anyhow
    cargo check
    cargo fmt
end
