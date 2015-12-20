Feature: Events
	Events are deepstream's publish-subscribe pattern. Everytime a client subscribes to
	or unsubscribes from an event the server replies with an acknowledgment message

Scenario: The client is connected
	Given the test server is ready
		And the client is initialised
	When the client logs in with username XXX and password YYY
		And the server sends the message A|A+

# Happy Path
Scenario: The client subscribes to an event
	Given the client subscribes to an event named test1
	Then the server received the message E|S|test1+

Scenario: The server sends an ACK message for test1
	Given the server sends the message E|A|S|test1+

Scenario: The client receives an event
	When the server sends the message E|EVT|test1|SsomeValue+
	Then the client received the event test1 with data someValue

Scenario: The client receives another event
	When the server sends the message E|EVT|test1|SanotherValue+
	Then the client received the event test1 with data anotherValue

Scenario: The client unsubscribes from an event
	When the client unsubscribes from an event named test1
	Then the server received the message E|US|test1+

Scenario: The server sends an ACK message for test1 unsubscribe
	Given the server sends the message E|A|US|test1+

# Other
Scenario: The client attempts to subscribe to the same event multiple times. This should still
			only trigger a single subscribe message to the server and the incoming events should
			be multiplexed on the client
	Given the server resets its message count
	When the client subscribes to an event named test2
		And the client subscribes to an event named test2
	Then the server received the message E|S|test2+
		And the server has received 1 messages

Scenario: The client tries to unsubscribe from an event it wasn't previously subscribed to
	Given the server resets its message count
	When the client unsubscribes from an event named test3
		And the server sends the message E|E|NOT_SUBSCRIBED|test3+
	Then the client throws a E error with message NOT_SUBSCRIBED

#TODO
#Scenario: The client doesn't receive an ACK message in time for its subscription
	#Given the client subscribes to an event named test4
	#When some time passes
	#Then the client throws a ACK_TIMEOUT error with message test4
