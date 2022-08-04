[
    (keyword_select)
    (keyword_typeof)
    (keyword_when)
    (keyword_then)
    (keyword_else)
    (keyword_end)
    (keyword_from)
    (keyword_where)
    (keyword_having)
    (keyword_group_by)
    (keyword_orderby)
    (keyword_limit)
    (orderDirection)
    (nullHandling)
] @keyword

[
    (aggregateFunction)
    (toLabel)
] @function

(string_literal) @string
(string_escape_character) @string.escape
(special_character) @string.special
(number_literal) @number
(fieldName) @variable; this was @variable.builtin
[
    (null_literal)
    (date_literal)
    (datetime_literal)
] @constant

;; Punctuation
[
  ","
  "."
] @punctuation.delimiter

;; Brackets
[
    "("
    ")"
] @punctuation.bracket

(sObject) @type

(comparisonOperator) @operator

(logical_operator) @keyword.operator
