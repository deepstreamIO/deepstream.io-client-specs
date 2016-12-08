@records
Feature: Record Conflicts
	Record conflicts occur most often when the
	client disconnects, does offline work and then
	reconnects resulting in a merge issue with
	other potential edits, but can also occur in
	rare conditions as part of a race condition.

	If a conflict does occur, the client should
	recieve a VERSION_EXISTS error.

Scenario: Record Conflicts

	# The client is connected
	Given the test server is ready
		And the client is initialised
		And the server sends the message C|A+
		And the client logs in with username "XXX" and password "YYY"
		And the server sends the message A|A+

	# The server requests a record
	Given the client creates a record named "mergeRecord"

	# The server responds with ack and read
	When the server sends the message R|A|S|mergeRecord+
	And the server sends the message R|R|mergeRecord|100|{"key":"value1"}+

	# The client tries to set an out of date value
	Given the client sets the record "mergeRecord" "key" to "value3"
	When the server sends the message R|E|VERSION_EXISTS|mergeRecord|101|{"key":"value2"}+
	Then the last message the server recieved is R|U|mergeRecord|102|{"key":"value2"}+

	# The client recieves an out of sync update
	When the server sends the message R|U|mergeRecord|102|{"key":"value3"}+
	Then the last message the server recieved is R|U|mergeRecord|103|{"key":"value3"}+

	# The client checks record data
	Then the client record "mergeRecord" data is {"key":"value3"}

	# The client receives a correct update
	When the server sends the message R|U|mergeRecord|104|{"key":"value4"}+
	Then the client record "mergeRecord" data is {"key":"value4"} 