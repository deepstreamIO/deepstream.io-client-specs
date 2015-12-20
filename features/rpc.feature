Feature: Receiving RPCS
	Remote Procedure Calls are deepstream's concept of request-response communication. This requires
	a client that makes the RPC (requestor or receiver) and another client that answers it (provider)

Scenario: The client is connected
	Given the test server is ready
		And the client is initialised
		And the client logs in with username XXX and password YYY
		And the server sends the message A|A+

# Requestor
Scenario: The client makes an RPC
	When the client requests RPC toUppercase with data abc
	Then the server received the message P|REQ|toUppercase|<UID>|Sabc+

Scenario: The client receives a Response
	