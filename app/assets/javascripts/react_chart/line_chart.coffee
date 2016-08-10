@ReactChart ||= {}
@ReactChart.LineChart = React.createClass
  render: ->
    <div className="line-chart">
    </div>

  componentDidMount: ->
    width = jQuery(".line-chart").width()
    height = jQuery(".line-chart").height()

    padding = {left:40, right: 40, top:30, bottom:30}

    svg = d3.select(".line-chart")
      .append("svg")
      .attr("width", width)
      .attr("height", height)

    data_item = @props.data.items
    data_temperature = []
    data_time = []
    for d in data_item
      data_temperature.push(d.height_value)
      data_time.push(d.bottom_value)

    x = d3.scale.ordinal()
      .domain(data_time)
      .rangeRoundBands([0, width - padding.left - padding.right])

    y = d3.scale.linear()
      .domain([0, d3.max(data_temperature)])
      .range([height - padding.top - padding.bottom, 0])

    tips = d3.tip()
      .attr('class', 'd3-tip')
      .offset([70, 70])
      .html (d, i) ->
        "<span>时间：#{d.bottom_value}</span><br/><span>温度：#{d.height_value}°</span>"
    svg.call(tips)

    line = d3.svg.line()
      .x (d)->
        x(d.bottom_value)
      .y (d)->
        y(d.height_value)
      .interpolate('monotone')

    path = svg.append('path')
      .attr('class', 'line')
      .attr('d', line(data_item))
      .attr('transform', "translate(#{padding.left}, #{padding.top})")
      .attr('fill', 'none')
      .attr("stroke", "steelblue")
      .attr("stroke-width", 1)

    g = svg.selectAll('circle')
      .data(data_item)
      .enter()
      .append('g')
      .append('circle')
      .attr('class', 'linecircle')
      .attr('cx', line.x())
      .attr('cy', line.y())
      .attr('r', 3.5)
      .attr('transform', "translate(#{padding.left}, #{padding.top})")
      .on 'mouseover', (d) ->
        d3.select(this).transition().duration(500).attr('r', 10)
        tips.show(d)
        jQuery(".d3-tip").css("pointer-events", "none")
      .on 'mouseout', (d) ->
        d3.select(this).transition().duration(500).attr('r', 3.5)
        tips.hide(d)


    x_axis = d3.svg.axis()
      .scale(x)
      .orient('bottom')

    y_axis = d3.svg.axis()
      .scale(y)
      .orient('left')

    svg.append('g')
      .attr("class", "axis")
      .attr("transform", "translate(#{padding.left}, #{height - padding.bottom})")
      .call(x_axis)
      .append('text')
      .text('时间')
      .attr('transform', "translate(#{width - padding.right - padding.left}, 0)")

    svg.append('g')
      .attr('class', 'axis')
      .attr("transform", "translate(#{padding.left - 1}, #{padding.top})")
      .call(y_axis)
      .append('text')
      .text('温度（单位：摄氏度）')





