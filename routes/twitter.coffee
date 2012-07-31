request = require 'request'
qs = require 'querystring'
auth = require '../twitter_opts'

twitter = (app) =>

  urlPostAuth = '/twitter_auth'

  index = (req, res) ->
    auth.callback = "http://#{req.headers.host}#{urlPostAuth}"
    unless req.session.auth
      return doAuth req, res

    auth.token = req.session.auth.token
    auth.token_secret = req.session.auth.token_secret

    res.render 'index',
      title: 'LoudMouth'

  doAuth = (req, res) ->
    url = 'https://api.twitter.com/oauth/request_token'
    delete auth.token
    delete auth.token_secret
    request.post
      url: url
      oauth: auth
      (e, r, body) ->
        access_token = qs.parse body

        auth.token = access_token.oauth_token
        auth.token_secret = access_token.oauth_token_secret
        auth_token = qs.stringify oauth_token: auth.token

        url = 'https://api.twitter.com/oauth/authenticate?'
        url += qs.stringify
          oauth_token: auth.token
        res.redirect url

  postAuth = (req, res) ->
    auth.verifier = req.query.oauth_verifier
    url = 'https://api.twitter.com/oauth/access_token'
    request.post
      url: url
      oauth: auth
      (e, r, body) ->
        perm_token = qs.parse(body)

        console.log 'authorized user', perm_token.screen_name

        auth.token = perm_token.oauth_token
        auth.token_secret = perm_token.oauth_token_secret

        req.session.auth = auth

        res.redirect '/'

  app.get '/', index
  app.get urlPostAuth, postAuth

  return auth: auth


module.exports = twitter

