Feature: Record Timeouts

Scenario: The client is connected
	Given the test server is ready
		And the client is initialised
		And the client logs in with username XXX and password YYY
		And the server sends the message A|A+

@unhappy
Scenario: The server does not respond in time with an ACK
	Given the server resets its message count
	When the client creates a record named "createAckMissing"
		And some time passes
	Then the client throws a ACK_TIMEOUT error with message createAckMissing

#@unhappy
#Scenario: The server does not recieve initial record data in time
	#Given the server resets its message count
	#When the client creates a record named "readTimeout"
	#	And the server sends the message R|A|CR|readTimeout+
	#	And some time passes
	#Then the client throws a READ_TIMEOUT error with message readTimeout