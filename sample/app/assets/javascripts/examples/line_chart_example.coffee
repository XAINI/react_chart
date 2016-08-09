@LineChartExample = React.createClass
  render: ->
    <div className="line-chart-example">
      <ReactChart.LineChart data={@props.data}/>
    </div>
    