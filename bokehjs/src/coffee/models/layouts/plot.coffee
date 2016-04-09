_ = require "underscore"
Box = require "./box"
PlotCanvas = require "../plots/plot_canvas"
p = require "../../core/properties"

class PlotView extends Box.View
  className: "bk-plot-layout"

class Plot extends Box.Model
  type: 'Plot'
  default_view: PlotView

  constructor: (attrs, options) ->
    super(attrs, options)
    # This makes us a column by default
    @_horizontal = false

  initialize: (options) ->
    super(options)
    @plot_canvas = new PlotCanvas.Model(options)

  _doc_attached: () ->
    @plot_canvas.attach_document(@document)

  get_layoutable_children: () ->
    toolbar_location = @get('toolbar_location')
    if toolbar_location in ['left', 'right']
      @_horizontal = true

    # Define the layout children based on the toolbar_location

    # Default if toolbar_location is None
    children = [@plot_canvas]

    if toolbar_location in ['above', 'left']
      # Toolbar is first
      children = [@get('toolbar'), @plot_canvas]
    if toolbar_location in ['below', 'right']
      # Toolbar is second
      children = [@plot_canvas, @get('toolbar')]

    return children

  props: ->
    return _.extend {}, super(), {
      toolbar_location:  [ p.Location, 'above'                ]
    }

module.exports =
  View: PlotView
  Model: Plot
