@events
Feature: Events Timeouts

Scenario: The client is connected
	Given the test server is ready
		And the client is initialised
		And the client logs in with username XXX and password YYY
		And the server sends the message A|A+

Scenario: The client subscribes to an event
	Given the client subscribes to an event named test1
	#data: string eventName, 
	Then the server received the message E|S|test1+ 

@timeout
Scenario: The server does not respond in time with an ACK
	Given some time passes
	Then the client throws a ACK_TIMEOUT error with message No ACK message received in time for test1

Scenario: The client unsubscribes from an event
	When the client unsubscribes from an event named test1
	Then the server received the message E|US|test1+

@timeout
Scenario: The server does not respond in time with an ACK
	Given some time passes
	Then the client throws a ACK_TIMEOUT error with message No ACK message received in time for test1
