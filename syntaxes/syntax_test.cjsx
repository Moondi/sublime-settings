# SYNTAX TEST "Packages/User/syntaxes/CJSX.sublime-syntax"
#
# Layout:
# - 5 blank separating different contexts
# - comment with the name of the context before the test
# - if there are multple tests for a context:
#  - separate tests with 1 blank line
#  - add a comment before each test to describe the case it's testing




# illegal-tag
<> <  > </> </  > <  />
# <- source.cjsx invalid.illegal.tag.incomplete.cjsx
#   ^ source.cjsx invalid.illegal.tag.incomplete.cjsx
#        ^ source.cjsx invalid.illegal.tag.incomplete.cjsx
#             ^ source.cjsx invalid.illegal.tag.incomplete.cjsx
#                   ^ source.cjsx invalid.illegal.tag.incomplete.cjsx





# opening-tag
<div/>
# <- source.cjsx meta.tag.open.cjsx punctuation.definition.tag.begin.cjsx
# ^ source.cjsx meta.tag.open.cjsx entity.name.tag.open.cjsx
#   ^ source.cjsx meta.tag.open.cjsx punctuation.definition.tag.end.cjsx

<div    />
# <- source.cjsx meta.tag.open.cjsx punctuation.definition.tag.begin.cjsx
# ^ source.cjsx meta.tag.open.cjsx entity.name.tag.open.cjsx
#    ^ source.cjsx
#       ^ source.cjsx meta.tag.open.cjsx punctuation.definition.tag.end.cjsx

# Test that a self-closing tag can span multiple lines
<div
# <- source.cjsx meta.tag.open.cjsx punctuation.definition.tag.begin.cjsx
# ^ source.cjsx meta.tag.open.cjsx entity.name.tag.open.cjsx

# ^ source.cjsx meta.tag.attribute.cjsx

/>
# <- source.cjsx meta.tag.open.cjsx punctuation.definition.tag.end.cjsx

<div></div>
# <- source.cjsx meta.tag.open.cjsx punctuation.definition.tag.begin.cjsx
# ^ source.cjsx meta.tag.open.cjsx entity.name.tag.open.cjsx
#   ^ source.cjsx meta.tag.open.cjsx punctuation.definition.tag.end.cjsx
#    ^ source.cjsx meta.tag.close.cjsx punctuation.definition.tag.begin.cjsx
#       ^ source.cjsx meta.tag.close.cjsx entity.name.tag.close.cjsx
#         ^ source.cjsx meta.tag.close.cjsx punctuation.definition.tag.end.cjsx

# Test that nesting stacks scopes appropriately
<div><span><i/><span></span></span></div>
# ^ source.cjsx meta.tag.open.cjsx entity.name.tag.open.cjsx
#       ^ source.cjsx meta.tag.contents.cjsx meta.tag.open.cjsx entity.name.tag.open.cjsx
#           ^ source.cjsx meta.tag.contents.cjsx meta.tag.contents.cjsx meta.tag.open.cjsx entity.name.tag.open.cjsx
#                 ^ source.cjsx meta.tag.contents.cjsx meta.tag.contents.cjsx meta.tag.open.cjsx entity.name.tag.open.cjsx
#                        ^ source.cjsx meta.tag.contents.cjsx meta.tag.contents.cjsx meta.tag.close.cjsx entity.name.tag.close.cjsx
#                              ^ source.cjsx meta.tag.contents.cjsx meta.tag.close.cjsx entity.name.tag.close.cjsx
#                                     ^ source.cjsx meta.tag.close.cjsx entity.name.tag.close.cjsx

# Specifically test that quotes within a set of tags are not scoped at all
<div>hi "quotes should be normal text" 'so should these quotes'</div>
#    ^ source.cjsx meta.tag.contents.cjsx
#       ^ source.cjsx meta.tag.contents.cjsx
#                  ^ source.cjsx meta.tag.contents.cjsx
#                                      ^ source.cjsx meta.tag.contents.cjsx
#                                             ^ source.cjsx meta.tag.contents.cjsx





# cjsx-attributes
<div attr1='wee' attr2="wee" attr3={wee}/>
#    ^ source.cjsx meta.tag.attribute entity.other.attribute-name.cjsx
#         ^ source.cjsx meta.tag.attribute keyword.operator.assignment
#            ^ source.cjsx meta.tag.attribute string.quoted.single
#                        ^ source.cjsx meta.tag.attribute string.quoted.double
#                                    ^ source.cjsx meta.tag.attribute source.cjsx.embedded.source




# escaped-entity
<div>\x12</div>
#     ^ source.cjsx meta.tag.contents.cjsx constant.character.escape.cjsx





# html-entity
<div>& &middot;</div>
#    ^ source.cjsx meta.tag.contents.cjsx invalid.illegal.bad-ampersand.cjsx
#      ^ source.cjsx meta.tag.contents.cjsx constant.character.entity.cjsx punctuation.definition.entity.begin.cjsx
#         ^ source.cjsx meta.tag.contents.cjsx constant.character.entity.cjsx
#             ^ source.cjsx meta.tag.contents.cjsx constant.character.entity.cjsx punctuation.definition.entity.end.cjsx





# embedded-cjsx
<div>{@renderSomethingElse()}</div>

<div>
  {
# ^ source.cjsx meta.tag.contents.cjsx source.cjsx.embedded.source meta.brace.curly.cjsx punctuation.section.embedded.begin.cjsx
    # renders the collection
#       ^ source.cjsx meta.tag.contents.cjsx source.cjsx.embedded.source comment.line.number-sign.coffee
    @props.collection.map (item, index) =>
#     ^ source.cjsx meta.tag.contents.cjsx source.cjsx.embedded.source variable.other.readwrite.instance.coffee
      <div key={index}>{@item.name}</div>
#       ^ source.cjsx meta.tag.contents.cjsx source.cjsx.embedded.source meta.tag.open.cjsx entity.name.tag.open
#                         ^ source.cjsx meta.tag.contents.cjsx source.cjsx.embedded.source meta.tag.contents source.cjsx.embedded.source variable.other.readwrite.instance.coffee
  }
# ^ source.cjsx meta.tag.contents.cjsx source.cjsx.embedded.source meta.brace.curly.cjsx punctuation.section.embedded.end.cjsx
</div>




# embedded-coffee
<div attr="something #{something + @interpolated}"/>
#                    ^ source.cjsx meta.tag.attribute.cjsx string.quoted.double.cjsx source.coffee.embedded.source punctuation.section.embedded.begin.cjsx
#                        ^ source.cjsx meta.tag.attribute.cjsx string.quoted.double.cjsx source.coffee.embedded.source
#                                      ^ source.cjsx meta.tag.attribute.cjsx string.quoted.double.cjsx source.coffee.embedded.source variable.other.readwrite.instance.coffee
#                                               ^ source.cjsx meta.tag.attribute.cjsx string.quoted.double.cjsx source.coffee.embedded.source punctuation.section.embedded.end.cjsx





# single-quoted-string
<div attr='something \'with &middot; quotes\''/>
#         ^ source.cjsx meta.tag.attribute.cjsx string.quoted.single.cjsx punctuation.definition.string.begin.cjsx
#             ^ source.cjsx meta.tag.attribute.cjsx string.quoted.single.cjsx
#                    ^ source.cjsx meta.tag.attribute.cjsx string.quoted.single.cjsx constant.character.escape.cjsx
#                              ^ source.cjsx meta.tag.attribute.cjsx string.quoted.single.cjsx constant.character.entity.cjsx
#                                            ^ source.cjsx meta.tag.attribute.cjsx string.quoted.single.cjsx punctuation.definition.string.end.cjsx





# double-quoted-string
<div attr="something \"with &middot; quotes\" #{interpolated}"/>
#         ^ source.cjsx meta.tag.attribute.cjsx string.quoted.double.cjsx punctuation.definition.string.begin.cjsx
#             ^ source.cjsx meta.tag.attribute.cjsx string.quoted.double.cjsx
#                    ^ source.cjsx meta.tag.attribute.cjsx string.quoted.double.cjsx constant.character.escape.cjsx
#                              ^ source.cjsx meta.tag.attribute.cjsx string.quoted.double.cjsx constant.character.entity.cjsx
#                                                   ^ source.cjsx meta.tag.attribute.cjsx string.quoted.double.cjsx source.coffee.embedded.source
#                                                            ^ source.cjsx meta.tag.attribute.cjsx string.quoted.double.cjsx punctuation.definition.string.end.cjsx
