var sinon = require( 'sinon' );
var config = require( '../config' );
var check = require( '../helper/helper' ).check;

var rpcCallback;

module.exports = function() {

	this.When( /^the client requests RPC (\w*) with data (\w*)$/, function( rpcName, rpcData, callback ){
		rpcCallback = sinon.spy();
		global.dsClient.rpc.make( rpcName, rpcData, rpcCallback );
		setTimeout( callback, config.tcpMessageWaitTime );
	});

	this.Then(/^the client recieves a successful RPC callback for (\w*) with data (\w*)$/, function ( rpcName, rpcData ) {
  		sinon.assert.calledOnce( rpcCallback );
  		sinon.assert.calledWith( rpcCallback, null, rpcData );
	});

	this.Then(/^the client recieves an error RPC callback for (\w*) with the message "([^"]*)"$/, function ( rpcName, errorMessage ) {
  		sinon.assert.calledOnce( rpcCallback );
  		sinon.assert.calledWith( rpcCallback, errorMessage );
	});

};