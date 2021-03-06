
# https://facebook.github.io/react/docs/jsx-gotchas.html
# These all display: First · Second
<div>First &middot; Second</div>
<div>{'First · Second'}</div>
<div>{'First \u00b7 Second'}</div>
<div>{'First ' + String.fromCharCode(183) + ' Second'}</div>
<div>{['First ', <span>&middot;</span>, ' Second']}</div>
<div dangerouslySetInnerHTML={{__html: 'First &middot; Second'}} />

# This, however, displays: First &middot; Second
# This is because React escapes all the strings you are displaying
# in order to prevent a wide range of XSS attacks by default.
<div>{'First &middot; Second'}</div>



@setState color: '128EDB'
<div>@state.color</div> # displays: @state.color
<div>{@state.color}</div> # displays: 128EDB
<div>#{@state.color}</div> # displays: #128EDB
<div>"#{@state.color}"</div> # displays: "#128EDB"
<div>{"#{@state.color}"}</div> # displays: 128EDB





<div className="#{React.findDOMNode(@).a}"></div>


@props.collection.map (item, index) =>
  <div key={index}>{item.name}</div>

# Good
<div>
  {@props.collection.map (item, index) =>
      <div key={index}>{item.name}</div>}
</div>

# Bad
<div>
  @props.collection.map (item, index) =>
      <div key={index}>{item.name}</div>
</div>














# Below is the old file











#= require ./paranoid_warning_modal

Modal = Chalk.Shared.Modal
ParanoidWarningModal = Chalk.Shared.ParanoidWarningModal
ColorPicker = Chalk.Shared.ColorPicker

@Chalk.Shared.EditUnitModal = React.createClass
  mixins: [ Reflux.connect Chalk.Shared.SingleUnitStore, 'unit' ]

  getInitialState: ->
    unit         : Chalk.Shared.SingleUnitStore.unit()
    saving       : false
    isDeleteOpen : false

  componentWillReceiveProps: (nextProps) ->
    if !@props.isOpen and nextProps.isOpen
      @setState color: if nextProps.isCreating then '00AEEF' else @state.unit.color

  openDeleteConfirm: -> @setState isDeleteOpen: true
  closeDeleteConfirm: -> @setState isDeleteOpen: false
  selectColor: (color) -> @setState color: color

  save: ->
    if React.findDOMNode(@refs.number).value is ''
      Gritter.warning 'Please enter a unit # for the unit.'
      React.findDOMNode(@refs.number).focus()
    else if React.findDOMNode(@refs.title).value is ''
      Gritter.warning "asdfas #{<span attr='asdf'> element not work here</span>}wdfasdf 'asdfasdf''
                       asdf #{'Please enter a title for the unit.'}"
      React.findDOMNode(@refs.title).focus()
    else # Should be all good!
      @setState saving: true

      options =
        subject_id : @props.subject_id
        number     : React.findDOMNode(@refs.number).value
        title      : React.findDOMNode(@refs.title).value
        color      : @state.color

      if @props.isCreating
        Chalk.Api.Units.create options
        .done (unit) =>
          Chalk.Shared.SingleUnitActions.create unit
          @props.onSelectUnit?(unit.id)
          @props.onClickOut()
        .fail (unit) => Gritter.error unit.responseJSON.errors
        .always => @setState saving: false
      else
        Chalk.Api.Units.update _.merge options, id: @state.unit.id
        .done (unit) =>
          Chalk.Shared.SingleUnitActions.update unit
          @props.onSelectUnit?(unit.id)
          @props.onClickOut()
        .fail (unit) => Gritter.error unit.responseJSON.errors
        .always => @setState saving: false

  deleteUnit: ->
    @setState saving: true
    @props.deleteUnit()

  renderDelete: ->
    unless @props.isCreating
      <button className='flat-grey-danger right' onClick={@openDeleteConfirm} disabled={@state.saving}>
        Delete
        <ParanoidWarningModal isOpen={@state.isDeleteOpen} saving={@state.saving}
          onClickOut={@closeDeleteConfirm} onConfirm={@deleteUnit} itemName={@state.unit.title}
          warnings={['I understand that this will delete this unit map and all the data it contains.',
                     'I understand that once this unit map is deleted it cannot be recovered.']}/>
      </button>

  render: ->
    editCreate = if @props.isCreating then 'Create' else 'Edit'

    if @state.saving
      saveText = <span><i className='fa fa-spin fa-refresh'/>Saving</span>
    else
      saveText = if @props.isCreating then 'Create' else 'Save'

    <Modal className='edit-unit-modal' aria-hidden='' isOpen2={@props.isOpen} onClickOut={@props.onClickOut unless @state.saving}>
      <div className='modal-topbar'>
        "asdfas #{<span> element not work here</span>}wdfasdf 'asdfasdf''
                       asdf #{'Please enter a title for the unit.'}"
        {@props.manyBlahs.map (aBlah) ->
          <blah attra='wewe' astt={@state.wee}>blah!</blah>}
        <div>,asdf &amp; &asdf&;</div>
        {@props.manyBlahs.map (aBlah) ->
          <blah attra='wewe' astt={@state.wee}>blah!</blah>}
        Unit
      </div>
      <div className={@props.name} onClick={wee: -> i_think_this_has_to_be_a_funtion_name}
        dangerouslySetInnerHTML={{__html: @props.contents or @props.placeholder}}/>
      <div className='modal-section'>
        <ColorPicker color={@state.color} selectColor={@selectColor}/>
        <div className='color-picker-offset row'>
          <div className='small-2 columns number-col'>
            <label className='sub-shout'>
              Number< > </  >
              <input ref='number' type='number' min='1' defaultValue={@state.unit.number unless @props.isCreating}/>
            </label>
          </div>
          <div></div>
          <div className='small-10 columns'>
            <label className='sub-shout'>
              Title
              <input ref='title' type='text' defaultValue={@state.unit.title unless @props.isCreating}/>
            </label>
          </div>
        </div>
      </div>
      <div className='modal-bottombar'>
        <button className='flat-blue' onClick={@save} disabled={@state.saving}>{saveText}</button>
        <button className='flat-grey' onClick={@props.onClickOut} disabled={@state.saving}>Cancel</button>
        {@renderDelete()}
      </div>
    </Modal>
