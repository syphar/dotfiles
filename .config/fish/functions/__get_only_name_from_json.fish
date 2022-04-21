function __get_only_name_from_json
    jq -r '. | map("\(.name)") | .[]'
end
