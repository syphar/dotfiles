function new-rust-playground --description "Create a temporary Rust playground project"
    set tmp_dir (mktemp -d ~/tmp/rust-playground.XXXXXX)
    
    set project_name "playground-"(random)
    
    cargo init --bin "$tmp_dir/$project_name"
    
    cd "$tmp_dir/$project_name"
    
    cargo add url
end
