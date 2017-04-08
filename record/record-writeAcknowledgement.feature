@records @write-ack
Feature: Record write acknowledgement
	Write acknowledgement when setting a record
	allows users to pass a callback to the set method
	of a record.

	It will be called with any errors while setting
	the record

Scenario: Record write acknowledgement

	# The client is connected
	Given the test server is ready
		And the client is initialised
		And the server sends the message C|A+
		And the client logs in with username "XXX" and password "YYY"
		And the server sends the message A|A+

	# The client creates a record and requires write acknowledgement
	Given the client creates a record named "happyRecord"
	And the client requires write acknowledgement on record "happyRecord"
	Then the last message the server recieved is R|CR|happyRecord+
	Then the server sends the message R|A|S|happyRecord+

	# The client receives the initial record data
	When the server sends the message R|R|happyRecord|100|{"name":"John", "pets": [{"name":"Ruffles", "type":"dog","age":2}]}+
	Then the client record "happyRecord" data is {"name":"John", "pets": [{"name":"Ruffles", "type":"dog","age":2}]}

	# The client sends patch and gets acknowledgement
	When the client sets the record "happyRecord" "pets.0.name" to "Max"
	Then the last message the server recieved is R|P|happyRecord|101|pets.0.name|SMax|{"writeSuccess":true}+

	Then the server sends the message R|WA|happyRecord|[101]|L+
	Then the client is notified that the record "happyRecord" was written without error

	# The client sends same patch again and gets acknowledgement
	When the client sets the record "happyRecord" "pets.0.name" to "Max"
	Then the client is notified that the record "happyRecord" was written without error

	# The client sends update and gets acknowledgement
	When the client sets the record "happyRecord" to {"newData":"someValue"}
	Then the last message the server recieved is R|U|happyRecord|102|{"newData":"someValue"}|{"writeSuccess":true}+
	Then the server sends the message R|WA|happyRecord|[102]|L+
	Then the client is notified that the record "happyRecord" was written without error

	Then the client record "happyRecord" data is {"newData":"someValue"}

	# Sends update but gets an error
	When the client sets the record "happyRecord" to {"validData":"newErrorData"}
	Then the last message the server recieved is R|U|happyRecord|103|{"validData":"newErrorData"}|{"writeSuccess":true}+
	Then the server sends the message R|WA|happyRecord|[103]|SError writing record to storage+
	Then the client is notified that the record "happyRecord" was written with error "Error writing record to storage"

	# Sends patch but gets an error
	When the client sets the record "happyRecord" "validData" to "differentData"
	Then the last message the server recieved is R|P|happyRecord|104|validData|SdifferentData|{"writeSuccess":true}+
	Then the server sends the message R|WA|happyRecord|[104]|SError writing record to cache+
	Then the client is notified that the record "happyRecord" was written with error "Error writing record to cache"

	# Gets version conflict but reconciles and receives write acknowledgement
	When the client sets the record "happyRecord" "validData" to "someData"
	Then the last message the server recieved is R|P|happyRecord|105|validData|SsomeData|{"writeSuccess":true}+
	Then the server sends the message R|E|VERSION_EXISTS|happyRecord|105|{"validData":"newErrorData"}|{"writeSuccess":true}+
	Then the last message the server recieved is R|P|happyRecord|105|validData|SsomeData|{"writeSuccess":true}+
	Then the server sends the message R|WA|happyRecord|[106]|L+
	Then the client is notified that the record "happyRecord" was written without error

#Scenario: Record write acknowledgement edge cases

	# The client loses it connection to the server
	When the connection to the server is lost
	Given two seconds later
	Then the client throws a "connectionError" error with message "Can't connect! Deepstream server unreachable on ws://localhost:7777/deepstream"
		And the clients connection state is "RECONNECTING"

	# The client sends patch during offline
	When the client sets the record "happyRecord" "pets.0.name" to "Max"
	Then the client is notified that the record "happyRecord" was written with error "Connection error: error updating record as connection was closed"

	# The client reconnects to the server
	When the connection to the server is reestablished
	And the server sends the message C|A+
	Then the clients connection state is "AUTHENTICATING"

	# The client successfully reconnects
	Given the client logs in with username "XXX" and password "YYY"
		And the server sends the message A|A+
	Then the clients connection state is "OPEN"

	# The client loses it connection to the server
	When the connection to the server is lost
	Given two seconds later
	Then the client throws a "connectionError" error with message "Can't connect! Deepstream server unreachable on ws://localhost:7777/deepstream"
		And the clients connection state is "RECONNECTING"

	# The client sends same patch again
	When the client sets the record "happyRecord" "pets.0.name" to "Max"
	Then the client is notified that the record "happyRecord" was written with error "Connection error: error updating record as connection was closed"

	# The client reconnects to the server
	When the connection to the server is reestablished
	And the server sends the message C|A+
	Then the clients connection state is "AUTHENTICATING"

	# The client successfully reconnects
	Given the client logs in with username "XXX" and password "YYY"
		And the server sends the message A|A+
	Then the clients connection state is "OPEN"
