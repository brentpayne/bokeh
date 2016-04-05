PlotLayout = require "../layouts/plot_layout"
PlotCanvas = require "../plots/plot_canvas"

class PlotView extends PlotLayout.View

class Plot extends PlotLayout.Model
  type: 'Plot'
  default_view: PlotView

  initialize: (options) ->
    @plot_canvas = new PlotCanvas.Model({
      plot_width: options.plot_width,
      plot_height: options.plot_height,
      h_symmetry: options.h_symmetry,
      v_symmetry: options.v_symmetry,

      above: options.above,
      below: options.below,
      left: options.left,
      right: options.right,

      renderers: options.renderers,

      x_range: options.x_range,
      extra_x_ranges: options.extra_x_ranges,
      y_range: options.y_range,
      extra_y_ranges: options.extra_y_ranges,

      x_mapper_type: options.x_mapper_type,
      y_mapper_type: options.y_mapper_type,

      tools: options.tools,
      tool_events: options.tool_events,
      toolbar_location: options.toolbar_location,
      logo: options.logo,

      lod_factor: options.lod_factor,
      lod_interval: options.lod_interval,
      lod_threshold: options.lod_threshold,
      lod_timeout: options.lod_timeout,

      webgl: options.webgl,
      hidpi: options.hidpi,
      responsive: options.responsive,

      min_border: options.min_border,
      min_border_top: options.min_border_top,
      min_border_left: options.min_border_left,
      min_border_bottom: options.min_border_bottom,
      min_border_right: options.min_border_right,
    })

  _doc_attached: () ->
    @plot_canvas.attach_document(@document)

  get_layoutable_children: () ->
    return [
      @plot_canvas
    ]

#  props: ->
#    return _.extend {}, super(), {
#      plot_width:        [ p.Number,   600                    ]
#      plot_height:       [ p.Number,   600                    ]
#      h_symmetry:        [ p.Bool,     true                   ]
#      v_symmetry:        [ p.Bool,     false                  ]
#
#      above:             [ p.Array,    []                     ]
#      below:             [ p.Array,    []                     ]
#      left:              [ p.Array,    []                     ]
#      right:             [ p.Array,    []                     ]
#
#      renderers:         [ p.Array,    []                     ]
#
#      x_range:           [ p.Instance                         ]
#      extra_x_ranges:    [ p.Any,      {}                     ] # TODO (bev)
#      y_range:           [ p.Instance                         ]
#      extra_y_ranges:    [ p.Any,      {}                     ] # TODO (bev)
#
#      x_mapper_type:     [ p.String,   'auto'                 ] # TODO (bev)
#      y_mapper_type:     [ p.String,   'auto'                 ] # TODO (bev)
#
#      tools:             [ p.Array,    []                     ]
#      tool_events:       [ p.Instance, new ToolEvents.Model() ]
#      toolbar_location:  [ p.Location, 'above'                ]
#      logo:              [ p.String,   'normal'               ] # TODO (bev)
#
#      lod_factor:        [ p.Number,   10                     ]
#      lod_interval:      [ p.Number,   300                    ]
#      lod_threshold:     [ p.Number,   2000                   ]
#      lod_timeout:       [ p.Number,   500                    ]
#
#      webgl:             [ p.Bool,     false                  ]
#      hidpi:             [ p.Bool,     true                   ]
#      responsive:        [ p.Bool,     false                  ]
#
#      min_border:        [ p.Number,   50                     ]
#      min_border_top:    [ p.Number,   null                     ]
#      min_border_left:   [ p.Number,   null                     ]
#      min_border_bottom: [ p.Number,   null                     ]
#      min_border_right:  [ p.Number,   null                     ]
#    }
#
#  defaults: ->
#    return _.extend {}, super(), {
#      # overrides
#      outline_line_color: '#aaaaaa'
#      border_fill_color: "#ffffff",
#      background_fill_color: "#ffffff",
#
#      # internal
#      min_size: 120
#    }

module.exports =
  View: PlotView
  Model: Plot
