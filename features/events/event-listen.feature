@events
Feature: Event Listen

Scenario: The client is connected
	Given the test server is ready
		And the client is initialised
		And the client logs in with username XXX and password YYY
		And the server sends the message A|A+

Scenario: The client listens to eventPrefix
	When the client listens to events matching "eventPrefix/.*"
	Then the server received the message E|L|eventPrefix/.*+

@timeout
Scenario: The server does not respond in time with an ACK
	When some time passes
	Then the client throws a ACK_TIMEOUT error with message Listening to pattern eventPrefix/.*

Scenario: The server responds with an ACK
	Given the server sends the message E|A|L|eventPrefix/.*+

Scenario: The client gets notified of new matching subscriptions
	Given the server sends the message E|SP|eventPrefix/.*|eventPrefix/foundAMatch+
	Then the client will be notified of new event match "eventPrefix/foundAMatch"

Scenario: The client gets notified for removed subscriptions
	Given the server sends the message E|SR|eventPrefix/.*|eventPrefix/foundAMatch+
	Then the client will be notified of event match removal "eventPrefix/foundAMatch"

Scenario: The client unlistens to eventPrefix
	When the client unlistens to events matching "eventPrefix/.*"
	Then the server received the message E|UL|eventPrefix/.*+

@timeout
Scenario: The server does not respond in time with an ACK
	When some time passes
	#TODO: Rename message
	Then the client throws a ACK_TIMEOUT error with message Listening to pattern eventPrefix/.*

Scenario: The server responds with an ACK
	Given the server sends the message E|A|UL|eventPrefix/.*+

@timeout
Scenario: Following server updates will throw an error
	Given the server sends the message E|SP|eventPrefix/.*|eventPrefix/foundAMatch+
	#TODO: This error message isn't great
	And the client throws a UNSOLICITED_MESSAGE error with message eventPrefix/.* 