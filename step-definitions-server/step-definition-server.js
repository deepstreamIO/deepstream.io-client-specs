var server = require( './tcp-server' );
var config = require( '../config' );
var check = require( '../helper/helper' ).check;

var convertChars = function( input ) {
	return input
		.replace( new RegExp( String.fromCharCode( 31 ), 'g' ), '|' )
		.replace( new RegExp( String.fromCharCode( 30 ), 'g' ), '+' );
};

module.exports = function() {
	this.Given( /the test server is ready/, function (callback) {
		server.whenReady( callback );
	});

	this.Given( /^the server resets its message count$/, function (callback) {
		server.lastMessage = null;
		server.allMessages = [];
		callback();
	});

	this.When( /^the server sends the message (.*)$/, function( message, callback ){
		message = message.replace( /\|/g, String.fromCharCode( 31 ) );
		message = message.replace( /\+/g, String.fromCharCode( 30 ) );
		server.send( message );
		setTimeout( callback, config.tcpMessageWaitTime );
	});

	this.Then( /^no message was send to the server$/, function( callback ){
		check( 'last received message', null, convertChars( server.lastMessage ), callback );
	});

	this.Then( /^the server has (\d*) active connections$/, function( connectionCount, callback ){
		check( 'active connections', Number( connectionCount ), server.connectionCount, callback );
	});

	this.Then( /^the server received the message (.*)$/, function( message, callback ){
		check( 'last received message', message, convertChars( server.lastMessage ), callback );
	});

	this.Then( /^the server has received (\d*) messages$/, function( numberOfMessages, callback ) {
		check( 'number of received messages', Number( numberOfMessages ), server.allMessages.length, callback );
	});
};