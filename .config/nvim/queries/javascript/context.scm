;; extends

(if_statement
  consequence: (_) @context.end
) @context

([
  (class_declaration)
  (function_declaration)
  (method_definition)
  (arrow_function)
  (else_clause)
  (while_statement)
  (jsx_element)
  (jsx_self_closing_element)
  (call_expression)
] @context)
