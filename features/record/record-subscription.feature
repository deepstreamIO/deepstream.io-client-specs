@records
Feature: Record Subscription

Scenario: The client is connected
	Given the test server is ready
		And the client is initialised
		And the client logs in with username XXX and password YYY
		And the server sends the message A|A+

Scenario: The client creates a record
	When the client creates a record named "test1"
	Then the last message the server recieved is R|CR|test1+

Scenario: The server responds with an ack and the initial read
	When the server sends the message R|A|CR|test1+
		And the server sends the message R|R|test1|124|{"name":"Smith","pets":[{"name":"Ruffus","type":"dog","age":0}]}+

# Full Subscribe

Scenario: The client subscribes to test1
	When the client subscribes to the entire record "test1" changes
	Then the client will not be notified of the record change

Scenario: The client record test1 receives updated data it will notify subscribers
	When the server sends the message R|U|test1|125|{"name":"Smith","pets":[{"name":"Ruffus","type":"dog","age":1}]}+
	Then the client will be notified of the record change

Scenario: The client record test1 receives partial data it will notify subscribers
	When the server sends the message R|P|test1|126|pets.0.name|SRuffusTheSecond+
	Then the client will be notified of the partial record change

Scenario: The client will no longer get notified after it unsubscribes
	Given the client unsubscribes to the entire record "test1" changes
	When the server sends the message R|U|test1|127|{"name":"Smith","pets":[{"name":"Ruffus","type":"dog","age":1}]}+
	Then the client will not be notified of the record change

# Path Susbcribe

Scenario: The client subscribes test1 to the path pets.0
	When the client subscribes to "pets.0.age" for the record "test1"
	Then the client will not be notified of the record change

Scenario: The client receives an partial update unrelated to the path subscribed to
	When the server sends the message R|P|test1|128|name|SJohn Smith+
	Then the client will not be notified of the record change

Scenario: The client receives an full update where the pets age hasn't changed
	When the server sends the message R|U|test1|129|{"name":"John Smith", "age": 21, "pets": [{"name":"Ruffus", "type":"dog","age":1}]}+
	Then the client will not be notified of the record change

Scenario: The client receives an partial update related to the path subscribed to
	When the server sends the message R|P|test1|130|pets.0.age|N4+
	Then the client will be notified of the record change

Scenario: The client receives an full update where the pets has changed
	When the server sends the message R|U|test1|131|{"name":"John Smith", "age": 21, "pets": [{"name":"Ruffus", "type":"dog","age":5}]}+
	Then the client will be notified of the second record change

Scenario: The client will no longer get notified after it unsubscribes to the path
	Given the client unsubscribes to "pets.0.age" for the record "test1"
	When the server sends the message R|P|test1|132|pets.0.age|N6+
	Then the client will not be notified of the record change