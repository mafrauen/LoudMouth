tweets = []

loadTweets = (data) ->
  tweets = data
  displayTweets()

getLimit = ->
  +$('#limit').val()

adjustLimit = ->
  displayTweets getLimit()

limitUp = ->
  limit = getLimit()
  return if limit > 19

  $('#limit').val limit + 1
  adjustLimit()

limitDown = ->
  limit = getLimit()
  return if limit < 2

  $('#limit').val limit - 1
  adjustLimit()

displayTweets = (limit) ->
  groups = _.groupBy tweets, (tweet) -> tweet.user.name
  data = []
  limit = limit or 1

  for own user, group of groups
    size = group.length
    continue if size < limit

    data.push
      packageName: user
      className: user
      value: size

  $('#graph').empty()
  graph '#graph', children: data

  lastTweet = tweets[tweets.length - 1]
  lastTime = new Date lastTweet.created_at

  $('#since').show()
  $('#sinceTime').html lastTime.toLocaleTimeString()

handleKeyPress = (e) ->
  j = 106; k = 107
  switch e.keyCode
    when k then limitUp()
    when j then limitDown()

jQuery ->
  socket = io.connect()
  socket.on 'tweets', loadTweets
  socket.emit 'getTweets', count: 200

  $('#since').hide()
  $('#changeLimit').click adjustLimit
  $('body').keypress handleKeyPress
