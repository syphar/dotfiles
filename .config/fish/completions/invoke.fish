# Invoke tab-completion script for the fish shell
# Copy it to the ~/.config/fish/completions directory

function __complete_invoke
    invoke --complete -- (commandline --tokenize)
end

# --no-files: Don't complete files unless invoke gives an empty result
# TODO: find a way to honor all binary_names
complete --command invoke --no-files --arguments '(__complete_invoke)'
