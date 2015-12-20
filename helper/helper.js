exports.check = function( type, expected, actual, callback, dontCallbackOnSuccess ) {
	if( expected === actual ) {
		if( dontCallbackOnSuccess !== true ) {
			callback();
		}
	} else {
		callback( new Error( 'Expected ' + type + ' to be ' + expected + ', but it was ' + actual ) );
	}
};