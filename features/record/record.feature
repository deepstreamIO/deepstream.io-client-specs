@records
Feature: Record

Scenario: The client is connected
	Given the test server is ready
		And the client is initialised
		And the client logs in with username XXX and password YYY
		And the server sends the message A|A+

Scenario: The client creates a record
	Given the client creates a record named "test1"
	Then the last message the server recieved is R|CR|test1+

Scenario: The server sends a read ACK message for test1
	Given the server sends the message R|A|CR|test1+

Scenario: The client receives the initial record data
	When the server sends the message R|R|test1|100|{"name":"John", "pets": [{"name":"Ruffles", "type":"dog","age":2}]}+
	Then the client record "test1" data is {"name":"John", "pets": [{"name":"Ruffles", "type":"dog","age":2}]}

Scenario: The client receives an partial update
	When the server sends the message R|P|test1|101|pets.0.age|N3+
	Then the client record "test1" data is {"name":"John", "pets": [{"name":"Ruffles", "type":"dog","age":3}]}

Scenario: The client receives a full update
	When the server sends the message R|U|test1|102|{"name":"Smith", "pets": [{"name":"Ruffus", "type":"dog","age":4}]}+
	Then the client record "test1" data is {"name":"Smith", "pets": [{"name":"Ruffus", "type":"dog","age":4}]}

Scenario: The client sends an partial update
	When the client sets the record "test1" "pets.0.name" to "Max"
	Then the last message the server recieved is R|P|test1|103|pets.0.name|SMax+

Scenario: The server sends a write ACK message for test1
	#TODO:  this doesn't exist
	#Given the server sends the message R|A|P|test1+

Scenario: The client receives a full update
	When the client sets the record "test1" to {"name":"Smith","pets":[{"name":"Ruffus","type":"dog","age":5}]}
	Then the last message the server recieved is R|U|test1|104|{"name":"Smith","pets":[{"name":"Ruffus","type":"dog","age":5}]}+

Scenario: The server sends a write ACK message for test1
	#TODO:  this doesn't exist
	#Given the server sends the message R|A|U|test1+

Scenario: The client discards the record
	When the client discards the record named "test1"
	Then the last message the server recieved is R|US|test1+

Scenario: The server responds with a discard ACK
	When the server sends the message R|A|US|test1+

Scenario: The client deletes the record
	Given the client creates a record named "test1"
		And the client deletes the record named "test1"
	Then the last message the server recieved is R|D|test1+

Scenario: The server responds with a delete ACK
	When the server sends the message R|A|D|test1+

Scenario: The client attempts to request the same record multiple times. This should still
		only trigger a single subscribe message to the server and the incoming events should
		be multiplexed on the client

	Given the server resets its message count
	When the client creates a record named "test2"
		And the client creates a record named "test2"
	Then the last message the server recieved is R|CR|test2+
		And the server has received 1 messages