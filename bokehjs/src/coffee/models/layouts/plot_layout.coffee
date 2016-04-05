Box = require "./box"

class PlotLayoutView extends Box.View
  className: "bk-grid-row"

class PlotLayout extends Box.Model
  type: 'PlotLayout'
  default_view: PlotLayoutView

  constructor: (attrs, options) ->
    super(attrs, options)
    @_horizontal = true

module.exports =
  View: PlotLayoutView
  Model: PlotLayout
