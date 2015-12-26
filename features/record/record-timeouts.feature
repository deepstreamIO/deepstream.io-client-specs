@records
Feature: Record Timeouts

Scenario: The client is connected
	Given the test server is ready
		And the client is initialised
		And the client logs in with username XXX and password YYY
		And the server sends the message A|A+

@timeout
Scenario: The server does not respond in time with an ACK
	Given the server resets its message count
	When the client creates a record named "unhappyRecord"
		And some time passes
	Then the client throws a ACK_TIMEOUT error with message unhappyRecord

@timeout
Scenario: The server does not recieve initial record data in time
	Given the server resets its message count
	When the server sends the message R|A|CR|unhappyRecord+
		And some time passes
	#TODO: readtimeout?
	Then the client throws a RESPONSE_TIMEOUT error with message unhappyRecord

Scenario: The server then recieves the initial record data
	When the server sends the message R|R|unhappyRecord|100|{"reasons":["Because."]}+

Scenario: The client sends an partial update
	When the client sets the record "unhappyRecord" to {"reasons":["Just Because."]}
	Then the server received the message R|U|unhappyRecord|101|{"reasons":["Just Because."]}+

@timeout
Scenario: The server does not respond in time with an ACK
	Given the server resets its message count
	#And some time passes
	#TODO: Do write acks actually exists?
	#Then the client throws a ACK_TIMEOUT error with message unhappyRecord

@timeout
Scenario: The server send a cache retrieval timeout
	Given the server resets its message count
	When the server sends the message R|E|CACHE_RETRIEVAL_TIMEOUT|unhappyRecord+
	Then the client throws a CACHE_RETRIEVAL_TIMEOUT error with message unhappyRecord

@timeout
Scenario: The server send a storage retrieval timeout
	Given the server resets its message count
	When the server sends the message R|E|STORAGE_RETRIEVAL_TIMEOUT|unhappyRecord+
	Then the client throws a STORAGE_RETRIEVAL_TIMEOUT error with message unhappyRecord

Scenario: The client discards record
	When the client discards the record named "unhappyRecord"
	Then the server received the message R|US|unhappyRecord+

@timeout
Scenario: The server does not respond in time with an ACK
	Given the server resets its message count
	When some time passes
	Then the client throws a ACK_TIMEOUT error with message unhappyRecord

Scenario: The client deletes the record
	Given the client creates a record named "unhappyRecord"
		And the server sends the message R|A|CR|unhappyRecord+
		And the server sends the message R|R|unhappyRecord|100|{"reasons":["Because."]}+
	When the client deletes the record named "unhappyRecord"
	Then the server received the message R|D|unhappyRecord+

@timeout
Scenario: The server does not recieve an ack
	Given the server resets its message count
	When some time passes
	Then the client throws a ACK_TIMEOUT error with message unhappyRecord