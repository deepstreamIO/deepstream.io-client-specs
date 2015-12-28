@events
Feature: Events Connectivity

Scenario: The client is connected
	Given the test server is ready
		And the client is initialised
		And the client logs in with username XXX and password YYY
		And the server sends the message A|A+

Scenario: The client subscribes to an event
	Given the client subscribes to an event named test1
	Then the last message the server recieved is E|S|test1+

Scenario: The server sends an ACK message for test1
	Given the server sends the message E|A|S|test1+

Scenario: The client loses it connection to the server
	When the connection to the server is lost
	Given some time passes
	Then the clients connection state is RECONNECTING

Scenario: The client publishes an event
	When the client publishes an event named test1 with data yetAnotherValue
	Then the server did not recieve any messages
	
Scenario: The client reconnects to the server
	When the connection to the server is reestablished
	Then the clients connection state is AUTHENTICATING

Scenario: The client is connected
	Given the client logs in with username XXX and password YYY
		And the server sends the message A|A+
	Then the clients connection state is OPEN

Scenario: The client resends the event subscription
	Then the server received the message E|S|test1+

Scenario: The client sends offline events
	#TODO: Is this actually expected?
	Then the server received the message E|EVT|test1|SyetAnotherValue+
