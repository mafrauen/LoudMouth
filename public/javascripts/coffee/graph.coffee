graph = (id, data) ->
  r = 720
  format = d3.format ",d"
  fill = d3.scale.category20c()

  bubble = d3.layout.pack()
          .sort(null)
          .size([r, r])

  vis = d3.select(id).append("svg")
        .attr("width", r)
        .attr("height", r)
        .attr("class", "bubble")

  node = vis.selectAll("g.node")
        .data(bubble.nodes(data)
              .filter((d) -> !d.children ))
        .enter().append("g")
        .attr("class", "node")
        .attr("transform", (d) -> "translate(" + d.x + "," + d.y + ")")

  node.append("title")
      .text((d) -> d.className + ": " + format(d.value))

  node.append("circle")
      .attr("r", (d) -> d.r)
      .style("fill", (d) -> fill(d.packageName))

  node.append("text")
      .attr("text-anchor", "middle")
      .attr("dy", ".3em")
      .text((d) -> d.className.substring(0, d.r / 3))
