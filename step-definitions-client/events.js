var config = require( '../config' );
var check = require( '../helper/helper' ).check;
var lastEventName;
var lastEventData;

module.exports = function() {
	this.When( /^the client subscribes to an event named (\w*)$/, function( eventName, callback ){
		global.dsClient.event.subscribe( eventName, function( data ){
			lastEventName = eventName;
			lastEventData = data;
		});
		setTimeout( callback, config.tcpMessageWaitTime );
	});

	this.When( /^the client unsubscribes from an event named (\w*)$/, function( eventName, callback ){
		global.dsClient.event.unsubscribe( eventName );
		setTimeout( callback, config.tcpMessageWaitTime );
	});

	this.Then( /^the client received the event (\w*) with data (\w*)$/, function(eventName, eventData, callback ){
		check( 'last event name', eventName, lastEventName, callback, true );
		check( 'last event data', eventData, lastEventData, callback );
	});
};