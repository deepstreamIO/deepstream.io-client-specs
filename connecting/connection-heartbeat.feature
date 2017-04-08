@events
Feature: Heartbeats
	Heartbeats are deepstreams way of knowing a server
    hasn't gone down unexpectedly.

Scenario: Heartbeats

	# The client is connected
	Given the test server is ready
		And the client is initialised with a small heartbeat interval
		And the server sends the message C|A+
		And the client logs in with username "XXX" and password "YYY"
		And the server sends the message A|A+

	# Happy Path
	# The server sends a ping
	Given the server sends the message C|PI+
    Then the server received the message C|PO+

	# The client receives an event
	When two seconds later
	Then the client throws a "connectionError" error with message "heartbeat not received in the last 1000 milliseconds"
