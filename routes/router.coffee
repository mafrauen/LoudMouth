request = require('request')
qs = require('querystring')

pages = (twitter, io) =>

  io.set 'log level', 2
  io.sockets.on 'connection', (socket) ->
    socket.on 'getTweets', (data) ->
      getTweets data, (tweets) ->
        socket.emit 'tweets', tweets

  getTweets = (params, cb) ->
    url = 'https://api.twitter.com/1/statuses/home_timeline.json?'
    url += qs.stringify params
    request.get
      url: url
      oauth: twitter.auth
      json: true
      (e, r, body) ->
        cb body


module.exports = pages

