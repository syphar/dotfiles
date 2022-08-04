((call
  function: (attribute) @_sf_query
  arguments: (argument_list (string) @soql ))
  (#match? @_sf_query "^sf\.?.*\.query$")
)
