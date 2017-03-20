@records
Feature: Record Conflicts
	Record conflicts occur most often when the
	client disconnects, does offline work and then
	reconnects resulting in a merge issue with
	other potential edits, but can also occur in
	rare conditions as part of a race condition.

	If a conflict does occur, the client should
	recieve a VERSION_EXISTS error.

	These tests do not send anything back to the
	server because by default record conflicts
	are REMOTE_WINS, meaning they accepts the
	server data

	Background:
	  Given the test server is ready
	  And the client is initialised
	  And the server sends the message C|A+
	  And the client logs in with username "XXX" and password "YYY"
	  And the server sends the message A|A+
	  And the client creates a record named "mergeRecord"
	  When the server sends the message R|A|S|mergeRecord+
	  And the server sends the message R|R|mergeRecord|100|{"key":"value1"}+

	Scenario: Record conflict on set

	  # The client tries to set an out of date value
	  Given the client sets the record "mergeRecord" "key" to "value3"
	  When the server sends the message R|E|VERSION_EXISTS|mergeRecord|101|{"key":"value2"}+
	  Then the last message the server recieved is R|P|mergeRecord|101|key|Svalue3+

	Scenario: Record conflict from update

	  # The client recieves an out of sync update
	  When the server sends the message R|U|mergeRecord|100|{"key":"value3"}+
	  Then the last message the server recieved is R|CR|mergeRecord+
