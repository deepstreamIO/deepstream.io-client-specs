var config = require( '../config' );
var check = require( '../helper/helper' ).check;


module.exports = function() {
	this.When( /^the client requests RPC (\w*) with data (\w*)$/, function( rpcName, rpcData, callback ){
		global.dsClient.rpc.make( rpcName, rpcData, function( error, response ){
			console.log( 'GOT RPC', arguments );
		});
		setTimeout( callback, config.tcpMessageWaitTime );
	});


};