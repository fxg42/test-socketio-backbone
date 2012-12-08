#= require vendor/jquery
#= require vendor/backbone

class SomeModel extends Backbone.Model


class SomeView extends Backbone.View
  initialize: ->
    @model.on 'change:status', @showStatus

  events:
    'click button': 'onButtonClick'
    'change input': 'onInputChange'

  showStatus: =>
    ($ "<span class='status'>#{@model.get 'status'}</span>").appendTo(@$el).delay(1000).fadeOut(200, -> ($ @).remove())
    @model.set 'status', '', {silent:yes}

  onInputChange: ->
    @model.set 'aProperty', (@$ 'input').val()

  onButtonClick: ->
    @options.socket.emit 'update data', @model.toJSON()


class SomeCollection extends Backbone.Collection
  model: SomeModel


class SomeCollectionView extends Backbone.View
  initialize: ->
    @collection.on 'add', @render

  render: =>
    items = (@collection.map (each) -> "<li>#{each.get 'aProperty'}</li>")
    (@$ 'ul').html items.join ''


class SomeController
  constructor: ->
    socket = io.connect()

    aModel = new SomeModel
    aCollection = new SomeCollection

    aView = new SomeView {el:'#aView', model:aModel, socket:socket}
    aCollectionView = new SomeCollectionView {el:'#aCollectionView', collection:aCollection}

    socket.on 'data updated', (incoming) ->
      aModel.set 'status', 'saved!'

    socket.on 'someone else updated', (incoming) ->
      aCollection.add new SomeModel incoming


$ -> new SomeController
