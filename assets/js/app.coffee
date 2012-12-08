#= require vendor/jquery
#= require vendor/backbone

class SomeModel extends Backbone.Model


class SomeView extends Backbone.View
  el: '#aView'

  initialize: ->
    @model.on 'change:status', @showStatus

  events:
    'click button': 'onButtonClick'

  showStatus: =>
    ($ "<span style='color:green; font:bold italic 0.8em Georgia;'> #{@model.get 'status'}</span>").appendTo(@$el).delay(1000).fadeOut(200, -> ($ @).remove())
    @model.set 'status', '', {silent:yes}

  onButtonClick: ->
    @options.socket.emit 'update data', (@$ 'input').val()


class SomeCollection extends Backbone.Collection
  model: SomeModel


class SomeCollectionView extends Backbone.View
  el: '#aCollectionView'

  initialize: ->
    @collection.on 'add', @render

  render: =>
    items = (@collection.map (each) -> "<li>#{each.get 'aProperty'}</li>")
    (@$ 'ul').html items.join ''


class Controller extends Backbone.Router
  initialize: (socket) ->
    socket = io.connect 'http://localhost:3000'

    aModel = new SomeModel
    aCollection = new SomeCollection

    aView = new SomeView {model:aModel, socket:socket}
    aCollectionView = new SomeCollectionView {collection:aCollection}

    socket.on 'data updated', (incoming) ->
      aModel.set 'status', 'saved!'

    socket.on 'someone else updated', (incoming) ->
      aCollection.add {aProperty:incoming}


$ ->
  new Controller
