@records
Feature: Record Has
	Record Has allows you to query whether or not a record 
    exists.

Scenario: Record Has

	# The client is connected
	Given the test server is ready
		And the client is initialised
		And the server sends the message C|A+
		And the client logs in with username "XXX" and password "YYY"
		And the server sends the message A|A+

    # The client creates a record
	#

	# The client queries for an existing record
	Given the client checks if the server has the record "existingRecord"
    When the server sends the message R|H|existingRecord|T|+
	Then the client is told the record "existingRecord" exists

	# The client queries for a non existing record
	Given the client checks if the server has the record "nonExistentRecord"
    When the server sends the message R|H|nonExistentRecord|F|+
	Then the client is told the record "nonExistentRecord" doesn't exist

	# The client creates a record then queries for it
	Given the client creates a record named "hasRecord"
	When the server sends the message R|A|S|hasRecord+
	Given the client checks if the server has the record "hasRecord"
	Then the server didn't receive the message R|H|hasRecord+
	Then the client is told the record "existingRecord" exists
