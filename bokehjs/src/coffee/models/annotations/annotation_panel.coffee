_ = require "underscore"
{EQ, GE} = require "../../core/layout/solver"
BokehView = require "../../core/bokeh_view"
LayoutCanvas = require "../../core/layout/layout_canvas"
p = require "../../core/properties"

build_views = require "../../common/build_views"

Renderer = require "../renderers/renderer"


class AnnotationPanelView extends Renderer.View

  view_options: () ->
    _.extend({plot_model: @plot_model, plot_view: @plot_view}, @options)

  render: () ->
    ctx = @plot_view.canvas_view.ctx

    console.log(@visuals)

    if @visuals.background_fill.doit
      @visuals.background_fill.set_value(ctx)
      ctx.fill()

    if @visuals.border_fill.doit
      @visuals.border_fill.set_value(ctx)
      ctx.stroke()

    annotation_models = @mget("annotations")
    @annotation_views = {}
    build_views(@annotation_views, annotation_models, @view_options())
    for model_id, view of @annotation_views
      console.log(view)
      view.render()

  update_constraints: () ->
    if not @mget('visible')
      # if not visible, avoid applying constraints until visible again
      return
    size = @mget('size')
    if not @_last_size?
      @_last_size = -1
    if size == @_last_size
      return
    @_last_size = size
    s = @model.document.solver()
    if @_size_constraint?
      s.remove_constraint(@_size_constraint)
    @_size_constraint = GE(@model._size, -size)
    s.add_constraint(@_size_constraint)


class AnnotationPanel extends LayoutCanvas.Model
  type: 'AnnotationPanel'
  default_view: AnnotationPanelView

  @define {
    annotations: [ p.Array, [] ]
    level: [ p.RenderLevel, 'overlay' ]
    visible: [ p.Bool, true ]
  }

  @internal {
    location: [ p.String, 'auto' ]
    size: [ p.Number, 50 ]
  }

  @mixins [
    'fill:border_',
    'fill:background_',
  ]

  initialize: (attrs, options) ->
    super(attrs, options)
    @panel = @

  initialize_layout: () ->
    side = @get('layout_location')
    if side == "above" or side == "below"
      @_size = @panel._height
    else if side == "left" or side == "right"
      @_size = @panel._width
    else
      logger.error("unrecognized side: '#{ side }'")

  get_constraints: () ->
    constraints = []
    constraints.push(GE(@_top))
    constraints.push(GE(@_bottom))
    constraints.push(GE(@_left))
    constraints.push(GE(@_right))
    constraints.push(GE(@_width))
    constraints.push(GE(@_height))
    constraints.push(EQ(@_left, @_width, [-1, @_right]))
    constraints.push(EQ(@_bottom, @_height, [-1, @_top]))
    return constraints

module.exports =
  Model: AnnotationPanel
  View: AnnotationPanelView
