# SYNTAX TEST "Packages/User/syntaxes/Coffeescript.sublime-syntax"
#
# These are by no stretch extensive tests
# Layout:
# - 5 blank separating different contexts
# - comment with the name of the context before the test
# - if there are multple tests for a context:
#  - separate tests with 1 blank line
#  - add a comment before each test to describe the case it's testing





# block-string-single
''' #{@something} \x12 '''
# <- source.coffee string.quoted.single.heredoc.coffee punctuation.definition.string.begin.coffee
#   ^ source.coffee string.quoted.single.heredoc.coffee
#                 ^ source.coffee string.quoted.single.heredoc.coffee constant.character.escape.coffee
#                      ^ source.coffee string.quoted.single.heredoc.coffee punctuation.definition.string.end.coffee





# block-string-double
""" something #{@something} \x12 """
# <- string.quoted.double.heredoc.coffee punctuation.definition.string.begin.coffee
#   ^ source.coffee string.quoted.double.heredoc.coffee
#             ^ source.coffee string.quoted.double.heredoc.coffee source.coffee.embedded.source punctuation.section.embedded.coffee
#                           ^ source.coffee string.quoted.double.heredoc.coffee constant.character.escape.coffee
#                                ^ source.coffee string.quoted.double.heredoc.coffee punctuation.definition.string.end.coffee





# embedded-javascript
hi = `function() { return [document.title, "Hello JavaScript\?"].join(": "); }`
#    ^ source.coffee string.quoted.script.coffee punctuation.definition.string.begin.coffee
#        ^ source.coffee string.quoted.script.coffee
#                                                           ^ source.coffee string.quoted.script.coffee constant.character.escape.coffee
#                                                                             ^ source.coffee string.quoted.script.coffee punctuation.definition.string.end.coffee





# block-comment
### @something something ###
# <- source.coffee comment.block.coffee punctuation.definition.comment.coffee
#   ^ source.coffee comment.block.coffee storage.type.annotation.coffeescript
#              ^ source.coffee comment.block.coffee
#                        ^ source.coffee comment.block.coffee punctuation.definition.comment.coffee





# line-comment
# something
# <- source.coffee comment.line.number-sign.coffee punctuation.definition.comment.coffee
# ^ source.coffee comment.line.number-sign.coffee





# inline-comment
something = something_else # a comment
#                          ^ source.coffee comment.line.number-sign.coffee punctuation.definition.comment.coffee
#                            ^ source.coffee comment.line.number-sign.coffee





# assignment
singers = {Jagger: "Rock", Elvis: "Roll"}
# <- source.coffee variable.assignment.coffee
#       ^ source.coffee variable.assignment.coffee keyword.operator.coffee
#                ^ source.coffee variable.assignment.coffee punctuation.separator.key-value





# destructuring-assignment
# Nesting works
{poet: {name, address: [street, city]}} = futurists
# <- source.coffee meta.variable.assignment.destructured.coffee keyword.operator.coffee
#^ source.coffee meta.variable.assignment.destructured.coffee variable.assignment.coffee
#      ^ source.coffee meta.variable.assignment.destructured.coffee keyword.operator.coffee
#                      ^ source.coffee meta.variable.assignment.destructured.coffee keyword.operator.coffee
#                                   ^ source.coffee meta.variable.assignment.destructured.coffee keyword.operator.coffee
#                                    ^ source.coffee meta.variable.assignment.destructured.coffee keyword.operator.coffee
#                                     ^ source.coffee meta.variable.assignment.destructured.coffee keyword.operator.coffee
#                                       ^ source.coffee meta.variable.assignment.destructured.coffee keyword.operator.coffee

# instance variables work
class Person
  constructor: (options) ->
    {@name, @age, @height} = options
#   ^ source.coffee meta.variable.assignment.destructured.coffee keyword.operator.coffee
#    ^ source.coffee meta.variable.assignment.destructured.coffee variable.other.readwrite.instance.coffee
#                        ^ source.coffee meta.variable.assignment.destructured.coffee keyword.operator.coffee
#                          ^ source.coffee meta.variable.assignment.destructured.coffee keyword.operator.coffee





# single-quoted-string
'something \x12 \"wee\"'
# <- source.coffee string.quoted.single.coffee punctuation.definition.string.begin.coffee
# ^ source.coffee string.quoted.single.coffee
#          ^ source.coffee string.quoted.single.coffee constant.character.escape.coffee
#                      ^ source.coffee string.quoted.single.coffee punctuation.definition.string.end.coffee





# double-quoted-string
"something \x12 \"wee\" #{something}"
# <- source.coffee string.quoted.double.coffee punctuation.definition.string.begin.coffee
# ^ source.coffee string.quoted.double.coffee
#          ^ source.coffee string.quoted.double.coffee constant.character.escape.coffee
#                       ^ source.coffee string.quoted.double.coffee source.coffee.embedded.source punctuation.section.embedded.coffee
#                        ^ source.coffee string.quoted.double.coffee source.coffee.embedded.source punctuation.section.embedded.coffee
#                          ^ source.coffee string.quoted.double.coffee source.coffee.embedded.source
#                                  ^ source.coffee string.quoted.double.coffee source.coffee.embedded.source punctuation.section.embedded.coffee
#                                   ^ source.coffee string.quoted.double.coffee punctuation.definition.string.end.coffee





# numeric - there's a hell of a lot more cases to this regex
a = 1
#   ^ source.coffee constant.numeric.coffee
