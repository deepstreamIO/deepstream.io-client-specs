@events
Feature: Record Listen

Scenario: The client is connected
	Given the test server is ready
		And the client is initialised
		And the client logs in with username XXX and password YYY
		And the server sends the message A|A+

Scenario: The client listens to recordPrefix
	When the client listens to a record matching "recordPrefix/.*"
	Then the server received the message R|L|recordPrefix/.*+

Scenario: The server responds with an ACK
	Given the server sends the message R|A|L|recordPrefix/.*+

Scenario: The client gets notified of new matching subscriptions
	Given the server sends the message R|SP|recordPrefix/.*|recordPrefix/foundAMatch+
	Then the client will be notified of new record match "recordPrefix/foundAMatch"

Scenario: The client gets notified for removed subscriptions
	Given the server sends the message R|SR|recordPrefix/.*|recordPrefix/foundAMatch+
	Then the client will be notified of record match removal "recordPrefix/foundAMatch"

Scenario: The client unlistens to recordPrefix
	When the client unlistens to a record matching "recordPrefix/.*"
	Then the server received the message R|UL|recordPrefix/.*+

Scenario: The server responds with an ACK
	Given the server sends the message R|A|UL|recordPrefix/.*+

Scenario: Following server updates will throw an error
	Given the server sends the message R|SP|recordPrefix/.*|recordPrefix/foundAMatch+
	#TODO: This error message isn't great
	And the client throws a UNSOLICITED_MESSAGE error with message recordPrefix/.* 