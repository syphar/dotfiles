(call_expression 
    function: (field_expression
        field: (field_identifier) @_field_ident
    ) 
    arguments: (arguments
        (string_literal) @sql
    )

    (#any-of? @_field_ident "query" "query_one" "query_opt")
)

(macro_invocation
    macro: (scoped_identifier
        name: (identifier) @_macro_name
    ) 
    (token_tree
        (string_literal) @sql
    )

    (#any-of? @_macro_name "query")
)

(macro_invocation
    macro: (scoped_identifier
        name: (identifier) @_macro_name
    ) 
    (token_tree) @toml

    (#any-of? @_macro_name "toml")
)
