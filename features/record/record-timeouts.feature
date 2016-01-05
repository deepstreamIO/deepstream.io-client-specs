@records
Feature: Record Timeouts

Scenario: The client is connected
	Given the test server is ready
		And the client is initialised
		And the client logs in with username XXX and password YYY
		And the server sends the message A|A+

@timeout
Scenario: The server does not respond in time with an ACK
	When the client creates a record named "unhappyRecord"
		And some time passes
	Then the client throws a ACK_TIMEOUT error with message unhappyRecord

@timeout
Scenario: The server does not recieve initial record data in time
 	When the server sends the message R|A|S|unhappyRecord+
 		And some time passes
 	#TODO: readtimeout?
 	# ACK_TIMEOUT is not too bad here, as it is the subscription that's beeing acknowledget
 	# Response timeout is for RPC responses. Let's discuss
 	Then the client throws a RESPONSE_TIMEOUT error with message unhappyRecord

Scenario: The server then recieves the initial record data
	When the server sends the message R|R|unhappyRecord|100|{"reasons":["Because."]}+

Scenario: The client sends an partial update
	When the client sets the record "unhappyRecord" to {"reasons":["Just Because."]}
	Then the last message the server recieved is R|U|unhappyRecord|101|{"reasons":["Just Because."]}+

#@timeout
#Scenario: The server does not respond in time with an ACK
	#Given some time passes
	#TODO: Do write acks actually exists?
	#Then the client throws a ACK_TIMEOUT error with message unhappyRecord

@timeout
Scenario: The server send a cache retrieval timeout
 	When the server sends the message R|E|CACHE_RETRIEVAL_TIMEOUT|unhappyRecord+
 	Then the client throws a CACHE_RETRIEVAL_TIMEOUT error with message unhappyRecord
 
 @timeout
Scenario: The server send a storage retrieval timeout
 	When the server sends the message R|E|STORAGE_RETRIEVAL_TIMEOUT|unhappyRecord+
 	Then the client throws a STORAGE_RETRIEVAL_TIMEOUT error with message unhappyRecord

Scenario: The client discards record
	When the client discards the record named "unhappyRecord"
	Then the last message the server recieved is R|US|unhappyRecord+

@timeout
Scenario: The server does not respond in time with an ACK
	When some time passes
	Then the client throws a ACK_TIMEOUT error with message unhappyRecord

Scenario: The client deletes the record
	Given the client creates a record named "unhappyRecord"
		And the server sends the message R|A|S|unhappyRecord+
		And the server sends the message R|R|unhappyRecord|100|{"reasons":["Because."]}+
	When the client deletes the record named "unhappyRecord"
	Then the last message the server recieved is R|D|unhappyRecord+

@timeout
Scenario: The server does not recieve an ack
	When some time passes
	Then the client throws a DELETE_TIMEOUT error with message unhappyRecord