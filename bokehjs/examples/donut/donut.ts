namespace WebBrowserMarketShare {
    import plt = Bokeh.Plotting;
    import _ = Bokeh._;

    Bokeh.set_log_level("info");
    Bokeh.logger.info(`Bokeh ${Bokeh.version}`);

    const text = document.getElementById("data").innerHTML
    const raw = text.split("\n").map((line) => line.split(",").map((val) => val.trim()))

    type Shares = Array<[string, number]>
    interface DataItem {
        year: number
        month: string
        shares: Shares
    }

    const data: Array<DataItem> = []

    let browsers: Array<string> = null
    let year: number = null

    for (let [head, ...tail] of raw) {
        const _year = parseInt(head)
        if (!isNaN(_year)) {
            [year, browsers] = [_year, tail]
        } else {
            const [month, shares] = [head, tail.map((val) => parseFloat(val))]
            data.push({year: year, month: month, _.zip(browsers, shares) as Shares])
        }
    }

    function to_radians(x) {
        return 2*Math.PI*(x/100)
    }

    const xdr = Range1d(-2, 2)
    const ydr = Range1d(-2, 2)

    const fig = plt.figure({title: "", x_range: xdr, y_range: ydr, width: 800, height: 800})

    _.reduce(_.values(shares), (a, b) => a + b, 0)

    const source = new ColumnDataSource()

    const end_angles = shares.map(to_radians).cumsum()
    const start_angles = [0].concat(end_angles.slice(0, -1))

    fig.wedge({x: 0, y: 0, radius: 1, source: source,
              start_angle: start_angles, end_angle: end_angles,
              line_color: "white", line_width: 2, fill_color: colors})

    plt.show()
}
