_ = require "underscore"

build_views = require "../../common/build_views"
LayoutBox = require "../canvas/layout_box"
{logger} = require "../../core/logging"
Renderer = require "../renderers/renderer"
ToolEvents = require "../../common/tool_events"
ToolManager = require "../../common/tool_manager"
UIEvents = require "../../common/ui_events"

p = require "../../core/properties"


class ToolBarView extends Renderer.View
  className: "bk-toolbar"

  initialize: (options) ->
    super(options)

    @ui_event_bus = new UIEvents({
      tool_manager: @mget('tool_manager')
      hit_area: @plot_view.canvas_view.$el
    })
    for id, tool_view of @tools
      @ui_event_bus.register_tool(tool_view)

    @tools = {}
    @build_levels()

    toolbar_location = @mget('toolbar_location')
    if toolbar_location?
      toolbar_selector = '.bk-plot-' + toolbar_location
      logger.debug("attaching toolbar to #{toolbar_selector} for plot #{@plot_model.id}")
      @tm_view = new ToolManager.View({
        model: @mget('tool_manager')
        el: @plot_view.$(toolbar_selector)
        location: toolbar_location
      })
      console.log(@tm_view.$el.html())
      @plot_view.$(toolbar_selector).html(@tm_view.$el)



  render: () ->
    super()
    if @tm_view?
      @tm_view.render()
    toolbar_location = @mget('toolbar_location')
    if toolbar_location?
      width = @plot_model._width._value
      height = 50 # @model._height._value
      toolbar_selector = '.bk-plot-' + toolbar_location
      @plot_view.$(toolbar_selector).css({
        position: 'absolute'
        left: @mget('dom_left')
        top: @mget('dom_top')
        width: width
        height: height
      })

  view_options: () ->
    _.extend({plot_model: @plot_model, plot_view: @plot_view}, @options)

  build_levels: () ->
    tools = build_views(@tools, @mget('tools'), @view_options())
    for t in tools
      level = t.mget('level')
      @plot_view.levels[level][t.model.id] = t
      t.bind_bokeh_events()

  remove: () =>
    super()
    # When this view is removed, also remove all of the tools.
    for id, tool_view of @tools
      tool_view.remove()

  bind_bokeh_events: () ->
    @listenTo(@plot_model, 'change:tool', @build_levels)
    @listenTo(@plot_model, 'destroy', () => @remove())


class ToolBar extends LayoutBox.Model
  default_view: ToolBarView
  type: 'ToolBar'

  constructor: (attrs, options) ->
    super(attrs, options)
    @set('dom_left', 0)
    @set('dom_top', 0)

  initialize: (attrs, options) ->
    super(attrs, options)
    @set('dom_left', 0)
    @set('dom_top', 0)
    @set('tool_manager', new ToolManager.Model({
      tools: @get('tools')
      toolbar_location: @get('toolbar_location')
      logo: @get('logo')
    }))

  _doc_attached: () ->
    super()
    @panel = @

  nonserializable_attribute_names: () ->
    super().concat(['tool_manager'])
      
  props: ->
    return _.extend {}, super(), {
      tools:             [ p.Array,    []                     ]
      tool_events:       [ p.Instance, new ToolEvents.Model() ]
      toolbar_location:  [ p.Location, 'above'                ]
      logo:              [ p.String,   'normal'               ] # TODO (bev)
      level:             [ p.RenderLevel, 'tool' ]
    }

  set_dom_origin: (left, top) ->
    @set({ dom_left: left, dom_top: top })

module.exports =
  Model: ToolBar
  View: ToolBarView
