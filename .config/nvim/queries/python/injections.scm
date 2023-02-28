;; extends

((call
  function: (attribute) @_sf_query
  arguments: (argument_list (string) @soql ))
  (#match? @_sf_query "^sf\.?.*\.query.*$")
)

(
    (string) @sql
    (#match? @sql "^.*SELECT|FROM|INNER JOIN|WHERE|CREATE|DROP|ALTER.*$")
    (#offset! @sql 0 1 0 -1)
)
