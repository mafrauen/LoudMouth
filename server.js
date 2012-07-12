
/**
 * Module dependencies.
 */

var express = require('express')
  , http = require('http');

require('coffee-script');

var app = express();

app.configure(function(){
  app.set('port', process.env.PORT || 3000);
  app.set('views', __dirname + '/views');
  app.set('view engine', 'hjs');
  app.use(express.favicon());
  app.use(express.logger('dev'));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.cookieParser('TheSecr3tOfC00kies'));
  app.use(express.session());
  app.use(app.router);
  app.use(require('less-middleware')({ src: __dirname + '/public' }));
  app.use(express.static(__dirname + '/public'));
});

app.configure('development', function(){
  app.use(express.errorHandler());
  app.set('root', 'http://localhost:3000');
});


var server = http.createServer(app);
io = require('socket.io').listen(server);

var twitter = require('./routes/twitter')(app);
require('./routes/router')(twitter, io);

server.listen(app.get('port'), function(){
  console.log("Express server listening on port " + app.get('port'));
});
