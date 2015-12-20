var deepstream = require( 'deepstream.io-client-js' );
var config = require( '../config' );
var check = require( '../helper/helper' ).check;
var lastAuthArgs;
var lastErrorArgs;

module.exports = function() {
	this.Given( /^the client is initialised$/, function( callback ){
		if( global.dsClient ) {
			global.dsClient.close();
		}
		global.dsClient = deepstream( config.testServerHost + ':' + config.testServerPort, {
			subscriptionTimeout: 60
		});
		global.dsClient.on( 'error', function(){
			lastErrorArgs = arguments;
		});
		setTimeout( callback, config.tcpMessageWaitTime );
	});

	this.When( /^some time passes$/, function( callback ){
		setTimeout( callback, 200 );
	});
	
	this.When( /^the client logs in with username (\w*) and password (\w*)$/, function( username, password, callback ){
		global.dsClient.login({ username: username, password: password }, function(){
			lastAuthArgs = arguments;
		});
		setTimeout( callback, config.tcpMessageWaitTime );
	});

	this.Then( /^the last login was successful$/, function( callback ){
		check( 'last login result', true, lastAuthArgs[ 0 ], callback );
	});

	this.Then( /^the clients connection state is (\w*)$/, function( connectionState, callback ){
		check( 'connectionState', connectionState, global.dsClient.getConnectionState(), callback );
	});

	this.Then( /^the client throws a (\w*) error with message (.*)$/, function( error, errorMessage, callback ){
		if( error !== lastErrorArgs[ 1 ] ) {
			callback( new Error( 'Expected last error to be ' + error + ', but it was ' + lastErrorArgs[ 1 ] ) );
		} else if( errorMessage !== lastErrorArgs[ 0 ] ) {
			callback( new Error( 'Expected last error message to be ' + errorMessage + ', but it was ' + lastErrorArgs[ 0 ] ) );
		} else {
			callback();
		}
	});

	this.Then( /^the last login failed with error (\w*) and message (.*)$/, function( error, errorMessage, callback ){
		if( error !== lastAuthArgs[ 1 ] ) {
			callback( new Error( 'Expected last auth error to be ' + error + ', but it was ' + lastAuthArgs[ 1 ] ) );
		} else if( errorMessage !== lastAuthArgs[ 2 ] ) {
			callback( new Error( 'Expected last auth error message to be ' + errorMessage + ', but it was ' + lastAuthArgs[ 2 ] ) );
		} else {
			callback();
		}
	});
};