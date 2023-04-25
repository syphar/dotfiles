;; extends

((call
  function: (attribute) @_sf_query
  arguments: (argument_list (string) @soql ))
  (#match? @_sf_query "^sf\.?.*\.query.*$")
)

(
    (string) @sql
    (#vim-match? @sql "\C^\w*SELECT|FROM|INNER JOIN|WHERE|CREATE|DROP|INSERT|UPDATE|ALTER.*$")
    (#offset! @sql 0 1 0 -1)
)
