var net = require('net');
var config = require( '../config' );
var server = net.createServer();
var isReady = false;
var lastSocket;

server.on( 'connection', bindSocket );
server.on( 'listening', onListening );
server.listen( config.testServerPort, config.testServerHost );

exports.lastMessage = null;
exports.isReady = false;
exports.connectionCount = 0;

exports.send = function( message ) {
	lastSocket.write( message );
};

exports.whenReady = function( callback ) {
	if( isReady ) {
		callback();
	} else {
		server.on( 'listening', callback );
	}
};

function bindSocket( socket ) {
	exports.connectionCount++;
	lastSocket = socket;
	socket.setEncoding( 'utf8' );
	socket.on( 'data', onIncomingMessage );
	socket.on( 'end', onDisconnect );
}

function onDisconnect() {
	exports.connectionCount--;
}

function onIncomingMessage( message ) {
	exports.lastMessage = message;
}

function onListening() {
	isReady = true;
}
