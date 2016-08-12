data = Array.apply(0, Array(12)).map((item, i) ->
    i++
    {date: '2013-'+(if i < 12 then i else 12) + '-' + (if i < 10 then '0' + i else i), pv: parseInt(Math.random() * 100)}
)
dataTwo = Array.apply(0, Array(12)).map((item, i) ->
    i++
    return {date: '2012-'+(if i < 12 then i else 12) + '-' + (if i < 10 then '0' + i else i), pv: parseInt(Math.random() * 100)}
)
@CreateLines(data, dataTwo)
CreateLines: (data,dataTwo) ->
    dataset = []
    lines = []
    lineNames = []
    lineColor = ["#F00","#09F","#0F0"]
    currentLineNum = 0
    margin = {top: 20, right: 20, bottom: 30, left: 50}
    width = 800
    height = 250

    @getData()
    currentLineNum = dataset.length
    maxdata = getMaxData(dataset)

    svg = d3.select("body")
        .append("svg")
        .attr("width", width)              
        .attr("height", height + margin.top + margin.bottom)
        .append("g")

    xScale = d3.time.scale()
        .domain([d3.min(dataset[0], (d)-> 
            d.date),
            d3.max(dataset[0], (d)-> 
            d.date)]
        )
        .range([0, width - margin.left - margin.right])  

    yScale = d3.scale.linear()
        .domain([0, maxdata])
        .range([height  - margin.top - margin.bottom, 0])

    xAxis = d3.svg.axis()
        .scale(xScale)
        .orient("bottom")
        .tickFormat(d3.time.format('%b')) 

    yAxis = d3.svg.axis()
    .scale(yScale)
    .orient("left")

    svg.append("g")
      .attr("class","axis")
      .attr("transform","translate(#{margin.left}, #{height - margin.bottom})")
      .call(xAxis)
      .append('text')
      .text("Month")
      .attr('transform', "translate(#{width - margin.left - margin.right - 20}, 0)")

    svg.append("g")
      .attr("class","axis")
      .attr("transform","translate(#{margin.left}, #{margin.top})")
      .call(yAxis)
      .append('text')
      .text("Sales volume")

    @addlegend()

    for i in currentLineNum
      newLine = @CreateLineObject()
      newLine.init(i);
      lines.push(newLine)

    CreateLineObject: () ->
      this.init = (id)->
      var arr = dataset[id];
      xScale = d3.time.scale()
        .domain([d3.min(arr, function(d) { return d.date; }),d3.max(arr, function(d) { return d.date; })])
        .range([0, width - margin.left - margin.right])

      line = d3.svg.line()
        .x(function(d) { return xScale(d.date); })
        .y(function(d) { return yScale(d.pv); })
        .interpolate('monotone')

      svg.append("path")
        .datum(arr)
        .attr("transform","translate(" + margin.left + "," +  margin.top  + ")")
        .attr("class", "line")
        .transition()
        .ease("elastic")
        .duration(1000)
        .delay(function(d,j){
          return 200*j;
        )
        .style("stroke",lineColor[id])
        .attr("d", line)

      svg.append('g').selectAll('circle')
        .data(arr)
        .enter() 
        .append('circle')
        .on('mouseover', function(d) {
          d3.select(this).transition().duration(500).attr('r', 5)

      d3.select('.tips').style('display', 'block');
        tx = parseFloat(d3.select(this).attr("cx"));
        ty = parseFloat(d3.select(this).attr("cy"));  
        tipRectx = tx+60+180>width?tx+10-180:tx+60,
        tipRecty= ty+20+60>height?ty+10-60:ty+20;
        theDate = d3.time.format('%Y-%m-%d')(d.date);
        thePv= d.pv;
        tips = svg.append("g")
          .attr("id","tips")

        tipRect = tips.append("rect")
          .attr("x",tipRectx)
          .attr("y",tipRecty)
          .attr("width",180)
          .attr("height",60)
          .attr("fill","#FFF")
          .attr("stroke","#CCC")

        tipText = tips.append("text")
          .attr("class","tiptools")
          .text("Month:"+theDate)
          .attr("x",tipRectx+20)
          .attr("y",tipRecty+20)

        tipText = tips.append("text")
          .attr("class","tiptools")
          .text("Sales volume: "+thePv)
          .attr("x",tipRectx+20)
          .attr("y",tipRecty+50)
          .on('mouseout', function() {
            d3.select(this).transition().duration(500).attr('r', 3.5)
            d3.select('.tips').style('display', 'none')
            d3.select("#tips").remove())
              .on("click",function(d){
                alert("Month："+d3.time.format('%Y-%m-%d')(d.date)+"\r\n Sales volume："+d.pv)
              )
              .transition()
              .ease("elastic")
              .duration(1000)
              .delay(function(d,j){
                200*j
              )
              .attr("transform","translate(" + margin.left + "," +  margin.top  + ")")
              .attr('cx', line.x())
              .attr('cy', line.y())
              .attr('r', 5)
              .attr("fill",lineColor[id])

    getData: ()->
        dataset.push(data)
        dataset.push(dataTwo)

    getMaxData:(arr
        var  maxdata = 0;
        var parseDate = d3.time.format("%Y-%m-%d").parse;
        for(var i =0;i<arr.length;i++){
            arr[i].forEach(function(d) {
                d.date = parseDate(d.date);
                d.pv = + d.pv;
            });
            dataset[i]=arr[i];
            lineNames.push(dataset[i][1].date.getFullYear())
            maxdata = d3.max([maxdata,d3.max(arr[i], function(d) { return d.pv; })]);
        }
        return maxdata;
    }
    function addlegend(){

        var legend= svg.append('g');
        legend.selectAll("text")
            .data(lineNames)
            .enter()
            .append("text")
            .text(function(d){return d;})
            .attr("class","legend")
            .attr("x", function(d,i) {return i*100;}) 
            .attr("y",0)
            .attr("fill",function(d,i){ return lineColor[i];});

        legend.selectAll("rect")
            .data(lineNames)
            .enter()
            .append("rect")
            .attr("x", function(d,i) {return i*100-20;}) 
            .attr("y",-10)
            .attr("width",12)
            .attr("height",12)
            .attr("fill",function(d,i){ return lineColor[i];});
        legend.attr("transform","translate("+((width-lineNames.length*100)/2)+","+(height+10)+")"); 
    }
}