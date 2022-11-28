;; extends 

(call_expression 
    function: (field_expression
        field: (field_identifier) @_field_ident
    ) 
    arguments: (arguments
        (string_literal) @sql
    )

    (#any-of? @_field_ident "query" "query_one" "query_opt" "execute")
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

; try this: any string literal which contain upper-case SQL keywords is SQL
(
    (string_literal) @sql
    (#match? @sql "^.*SELECT|FROM|INNER JOIN|WHERE|CREATE|DROP|ALTER.*$")
)

(
    (raw_string_literal) @sql
    (#match? @sql "^.*SELECT|FROM|INNER JOIN|WHERE|CREATE|DROP|ALTER.*$")
)
(
    (string_literal) @graphql
    (#match? @graphql ".*query\(.*\).*$")
    (#offset! @graphql 0 1 0 -1)
)
