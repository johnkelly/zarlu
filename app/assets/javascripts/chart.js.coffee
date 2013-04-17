time_off_used_by_category = ->
  data = pie_chart_json()
  width = 640
  height = 480
  radius = Math.min(width, height) / 2
  colors = d3.scale.ordinal().range(["#0668C0", "green", "#FF5E00", "purple", "red", "black"])
  pie = d3.layout.pie().sort(null).value((d) -> d.hours)
  arc = d3.svg.arc().innerRadius(radius * .6).outerRadius(radius)
  svg = d3.select("#pie_chart").append("svg").attr("width", width).attr("height", height).append("g").attr("transform", "translate(" + width / 2 + "," + height / 2 + ")")

  data.forEach((d) ->
    d.hours = +d.hours
  )

  g = svg.selectAll(".arc").data(pie(data)).enter().append("g").attr("class", "arc")
  g.append("path").attr("d", arc).style("fill", (d) -> colors(d.data.kind))

jQuery ->
  if $('#pie_chart').length
    time_off_used_by_category()

pie_chart_json = ->
  durations = $('#pie_chart').data('durations')
  [
    {"kind": "Vacation", "hours": durations[0]},
    {"kind": "Sick", "hours": durations[1]},
    {"kind": "Holiday", "hours": durations[2]},
    {"kind": "Personal", "hours": durations[3]},
    {"kind": "Unpaid", "hours": durations[4]},
    {"kind": "Other", "hours": durations[5]},
  ]

