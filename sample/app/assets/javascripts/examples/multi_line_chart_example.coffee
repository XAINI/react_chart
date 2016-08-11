@MultiLineChartExample = React.createClass
  render: ->
    <div className='multi-line-chart-example'>
      <ReactChart.MultiLineChart data={@props.data}/>
    </div>