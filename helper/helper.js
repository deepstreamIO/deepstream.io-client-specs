var sinon = require( 'sinon' );

exports.check = function( type, expected, actual, callback, dontCallbackOnSuccess ) {
	if( sinon.deepEqual( expected, actual ) ) {
		if( dontCallbackOnSuccess !== true ) {
			callback();
		}
	} else {
		callback( new Error( 'Expected ' + type + ' to be ' + JSON.stringify( expected ) + ', but it was ' + JSON.stringify( actual ) ) );
	}
};