var net = require('net');
var config = require( '../config' );
var server;
var isReady = false;
var lastSocket;
var connections = [];

exports.allMessages = [];
exports.lastMessage = null;
exports.connectionCount = 0;

exports.start = function() {
	if( server ) {
		stop( start );
	} else { 
		start();
	}
};

exports.stop = function( callback ) {
	server.on( 'close', callback );
	stop();
};

exports.send = function( message ) {
	lastSocket.write( message );
};

exports.whenReady = function( callback ) {
	if( !server ) {
		start();
	}

	if( isReady ) {
		callback();
	} else {
		server.on( 'listening', callback );
	}
};

function start() {
	server = net.createServer();
	server.on( 'connection', bindSocket );
	server.on( 'listening', onListening );
	server.listen( config.testServerPort, config.testServerHost );
}

function stop() {
	isReady = false;

	exports.allMessages = [];
	exports.lastMessage = null;
	exports.connectionCount = 0;

	server.close();
	connections.forEach( function( connection ) {
		connection.destroy();
	} );

	server = null;
}

function bindSocket( socket ) {
	exports.connectionCount++;
	lastSocket = socket;
	socket.setEncoding( 'utf8' );
	socket.on( 'data', onIncomingMessage );
	socket.on( 'end', onDisconnect );
	connections.push( socket );
}

function onDisconnect() {
	exports.connectionCount--;
}

function onIncomingMessage( message ) {
	var messages = message.split( String.fromCharCode( 30 ) );
	if( !messages[ messages.length - 1 ] ) {
		messages.splice( messages.length - 1, 1 );
	}
	for( var i=0; i<messages.length; i++) {
		exports.allMessages.push( messages[ i ] + String.fromCharCode( 30 ) );
	}
	exports.lastMessage = messages[ messages.length - 1 ] + String.fromCharCode( 30 );
}

function onListening() {
	isReady = true;
}
