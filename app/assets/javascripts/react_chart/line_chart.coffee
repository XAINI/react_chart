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

    line = d3.svg.line()
      .x (d)->
        x(d.bottom_value)
      .y (d)->
        y(d.height_value)
      .interpolate('monotone')

    path = svg.append('path')
      .attr('class', 'line')
      .attr('d', line(data_item))
      .attr('fill', 'blue')


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





