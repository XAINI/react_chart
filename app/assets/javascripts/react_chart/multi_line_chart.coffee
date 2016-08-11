@ReactChart ||= {}
@ReactChart.MultiLineChart = React.createClass
  render: ->
    <div className='multi-line-chart'>
    </div>

  componentDidMount: ->
    width = jQuery('.multi-line-chart').width()
    height = jQuery('.multi-line-chart').height()
    padding = {top: 30, bottom: 30, left: 40, right: 40}

    svg = d3.select('.multi-line-chart')
      .append('svg')
      .attr('width', width)
      .attr('height', height)

    data_x = [1,2,3,4,5,6,7,8,9,10]
    data_y = [5,6,7,8,9,10,11,12,17]

    x = d3.scale.ordinal()
      .domain(data_x)
      .rangeRoundBands([0, width - padding.left - padding.right])

    y = d3.scale.linear()
      .domain([0, d3.max(data_y)])
      .range([height - padding.top - padding.bottom, 0])

    x_axis = d3.svg.axis()
      .scale(x)
      .orient('bottom')

    y_axis = d3.svg.axis()
      .scale(y)
      .orient('left')

    svg.append('g')
      .attr('class', 'axis')
      .attr('transform', "translate(#{padding.left - 2}, #{height - padding.bottom})")
      .call(x_axis)
      .append('text')
      .text('时间')
      .attr('transform', "translate(#{width - padding.right - padding.left + 4}, 0)")

    svg.append('g')
      .attr('class', 'axis')
      .attr('transform', "translate(#{padding.left - 2}, #{padding.top})")
      .call(y_axis)
      .append('text')
      .text('温度（单位：摄氏度）')

