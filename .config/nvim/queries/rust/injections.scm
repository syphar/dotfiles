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
        ((string_literal) @sql (#offset! @sql 0 1 0 -1) )
    )

    (#any-of? @_macro_name "query")
)


; FIXME: doesnt work yet
; (macro_invocation
;     macro: (scoped_identifier
;         name: (identifier) @_macro_name
;     ) 
;     ((token_tree) @toml (#offset! @toml 1 0 -1 0) )

;     (#any-of? @_macro_name "toml")
; )
