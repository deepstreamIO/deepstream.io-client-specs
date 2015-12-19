exports.check = function( type, expected, actual, callback ) {
	if( expected === actual ) {
		callback();
	} else {
		callback( new Error( 'Expected ' + type + ' to be ' + expected + ', but it was ' + actual ) );
	}
};