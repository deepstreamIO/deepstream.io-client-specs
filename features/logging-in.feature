Feature: Logging In
	The client authenticates the connection

	Scenario: The client sends login credentials
		Given the test server is ready
			And the client is initialised
		When the client logs in with username XXX and password YYY
		Then the server received the message A|REQ|{"username":"XXX","password":"YYY"}+
			And the clients connection state is AUTHENTICATING

	Scenario: The client receives a login confirmation
		When the server sends the message A|A+
		Then the clients connection state is OPEN
			And the last login was successful

	Scenario: The client logs in with an invalid authentication message
		Given the client is initialised
		When the client logs in with username XXX and password YYY
			And the server sends the message A|E|INVALID_AUTH_MSG|invalid authentication message+
		Then the last login failed with error INVALID_AUTH_MSG and message invalid authentication message