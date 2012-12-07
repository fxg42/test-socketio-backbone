
/**
 * Module dependencies.
 */

var express = require('express'),
    routes = require('./routes'),
    user = require('./routes/user'),
    http = require('http'),
    path = require('path'),
    assets = require('connect-assets')();

var app = express();

var cookieParser = express.cookieParser('secret'),
    sessionStore = new express.session.MemoryStore();

app.configure(function(){
  app.set('port', process.env.PORT || 3000);
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(express.favicon());
  app.use(express.logger('dev'));
  app.use(express.bodyParser());
  app.use(express.cookieParser());
  app.use(express.session({ store: sessionStore, secret:'secret' }));
  app.use(express.methodOverride());
  app.use(app.router);
  app.use(assets);
  app.use(express['static'](path.join(__dirname, 'public')));
});

app.configure('development', function(){
  app.use(express.errorHandler());
});

var server = http.createServer(app).listen(app.get('port'), function(){
  console.log("Express server listening on port " + app.get('port'));
});

var io = require('socket.io').listen(server);

var SessionSockets = require('session.socket.io'),
    sessionSockets = new SessionSockets(io, sessionStore, cookieParser);

sessionSockets.on('connection', function (err, socket, session) {
  socket.on('update data', function (data) {
    session.data = data;
    socket.emit('data updated', data);
    socket.broadcast.emit('someone else updated', data);
  });
});

app.get('/', routes.index);
app.get('/users', user.list);

