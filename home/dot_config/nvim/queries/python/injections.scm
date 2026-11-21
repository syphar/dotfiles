;; extends

((call
  function: (attribute) @_sf_query
  arguments: (argument_list (string) @injection.content))
  (#match? @_sf_query "^sf\.?.*\.query.*$")
  (#set! injection.language "soql")
)

(
    (string
	  (string_content) @injection.content
	)
    (#vim-match? @injection.content "\C^\w*SELECT|FROM|INNER JOIN|WHERE|CREATE|DROP|INSERT|UPDATE|ALTER.*$")
    (#set! injection.language "sql")
)
