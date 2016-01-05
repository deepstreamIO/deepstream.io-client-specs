@rpc
Feature: Providing RPCS
	Remote Procedure Calls are deepstream's concept of request-response communication. This requires
	a client that makes the RPC (requestor or receiver) and another client that answers it (provider)

Scenario: The client is connected
	Given the test server is ready
		And the client is initialised
		And the client logs in with username XXX and password YYY
		And the server sends the message A|A+

# Providing

Scenario: The client provides a RPC
	When the client provides a RPC called toUppercase
	Then the last message the server recieved is P|S|toUppercase+

Scenario: The client gets an ACK
 	When the server sends the message P|A|S|toUppercase+

# Success

Scenario: The client gets a supported request
 	When the server sends the message P|REQ|toUppercase|<UID>|Sabc+

Scenario: The client responds with an ack and processes message
	Then the last message the server recieved is P|A|toUppercase|<UID>+
 		And the client recieves a request for a RPC called toUppercase with data abc

Scenario: The client responds with a success
	When the client responds to the RPC toUppercase with data ABC
 	Then the last message the server recieved is P|RES|toUppercase|<UID>|SABC+

# Error

Scenario: The client gets a supported request
 	When the server sends the message P|REQ|toUppercase|<UID>|Sabc+

Scenario: The client responds with an ack and processes message
	Then the last message the server recieved is P|A|toUppercase|<UID>+
 		And the client recieves a request for a RPC called toUppercase with data abc

Scenario: The client responds with an error
	When the client responds to the RPC toUppercase with the error "An Error Occured"
 	Then the last message the server recieved is P|E|An Error Occured|toUppercase|<UID>+

# Rejection when supported

Scenario: The client gets a supported request
 	When the server sends the message P|REQ|toUppercase|<UID>|Sabc+

Scenario: The client responds with an ack and processes message
	Then the last message the server recieved is P|A|toUppercase|<UID>+
 		And the client recieves a request for a RPC called toUppercase with data abc

Scenario: The client responds with an error
	When the client rejects the RPC toUppercase
 	Then the last message the server recieved is P|REJ|toUppercase|<UID>+

# Rejection when not supported

Scenario: The client gets an unsupported request
	When the server sends the message P|REQ|unSupported|<UID>|Sabc+

Scenario: The client responds a reject
	Then the last message the server recieved is P|REJ|unSupported|<UID>+

# Unproviding

Scenario: The client stops providing a RPC
	When the client stops providing a RPC called toUppercase
	Then the last message the server recieved is P|US|toUppercase+

Scenario: The client gets an ACK
 	When the server sends the message P|A|US|toUppercase+
	