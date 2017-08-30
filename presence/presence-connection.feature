@presence
Feature: Presence Connectivity
	Presence subscription must be sent to the server.
    after connection issues to guarantee
	it continues recieving them correctly.

Scenario: Client loses connection

	# The client is connected
	Given the test server is ready
		And the client is initialised
		And the server sends the message C|A+
		And the client logs in with username "XXX" and password "YYY"
		And the server sends the message A|A+

	Given the client subscribes to presence events for "userA,userB"
    Then the server received the message U|S|1|["userA","userB"]+

    # The server sends an ACK message for subscription
    Given the server sends the message U|A|S|1+

	Given the client subscribes to all presence events
    Then the server received the message U|S|S+

    # The server sends an ACK message for subscription
    Given the server sends the message U|A|S|S+

	# The client loses its connection to the server
	When the connection to the server is lost
	Given two seconds later
	Then the client throws a "connectionError" error with message "Can't connect! Deepstream server unreachable on ws://localhost:7777/deepstream"
		And the clients connection state is "RECONNECTING"

	# The client tries to query for connected clients
	Given the client queries for connected clients
	Then the server did not recieve any messages

	Given the client queries if "userA,userB" are online
	Then the server did not recieve any messages

	# The client reconnects to the server
	When the connection to the server is reestablished
	And the server sends the message C|A+
	Then the clients connection state is "AUTHENTICATING"

	# The client successfully reconnects
	Given the client logs in with username "XXX" and password "YYY"
		And the server sends the message A|A+
	Then the clients connection state is "OPEN"

	# The client resends the presence subscription
	Then the server received the message U|S|3|["userA","userB"]+
		And the server received the message U|S|S+

	# The client resends the query
	Then the server received the message U|Q|Q+
		And the server received the message U|Q|2|["userA","userB"]+
