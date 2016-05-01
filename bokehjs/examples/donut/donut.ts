namespace WebBrowserMarketShare {
    import plt = Bokeh.Plotting;
    import _ = Bokeh._;

    Bokeh.set_log_level("info");
    Bokeh.logger.info(`Bokeh ${Bokeh.version}`);

    function to_radians(x: number) {
        return 2*Math.PI*(x/100)
    }

    function sum(array: Array<number>) {
        return array.reduce((a, b) => a + b, 0)
    }

    function cumsum(array: Array<number>) {
        const result: Array<number> = []
        array.reduce((a, b, i) => result[i] = a + b, 0)
        return result
    }

    const text = document.getElementById("data").innerHTML
    const raw = text.split("\n")
                    .map((line) => line.trim())
                    .filter((line) => line.length > 0)
                    .map((line) => line.split(",").map((val) => val.trim()))

    interface MonthlyShares {
        year: number
        month: string
        browsers: Array<string>
        shares: Array<number>
    }

    const data: Array<MonthlyShares> = []

    let _browsers: Array<string> = null
    let year: number = null

    for (let [head, ...tail] of raw) {
        const _year = parseInt(head)
        if (!isNaN(_year)) {
            [year, _browsers] = [_year, tail]
        } else {
            const month = head

            const shares = tail.map((val) => parseFloat(val))
            const browsers = _browsers.slice()

            for (let i = 0; i < shares.length;) {
                if (isNaN(shares[i])) {
                    shares.splice(i, 1)
                    browsers.splice(i, 1)
                } else
                    i++
            }

            const other = 100 - sum(shares)
            if (other > 0) {
                browsers.push("Other")
                shares.push(other)
            }

            data.push({year: year, month: month, browsers: browsers, shares: shares})
        }
    }

    const fig = plt.figure({title: "", x_range: [-2, 2], y_range: [-2, 2], width: 600, height: 600})

    const source = new Bokeh.ColumnDataSource()

    const shares = data[0].shares

    const end_angles = cumsum(shares.map(to_radians))
    const start_angles = [0].concat(end_angles.slice(0, -1))
    const colors = "red"

    fig.wedge({x: 0, y: 0, radius: 1, source: source,
              start_angle: start_angles, end_angle: end_angles,
              line_color: "white", line_width: 1, fill_color: colors})

    //const tap = new Bokeh.TapTool()
    //fig.add_tools(tap)

    plt.show(fig)
}
