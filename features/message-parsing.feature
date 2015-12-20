Feature: Parsing Messages
	Every message from that's received from the server is validated for some basic
	syntactic and semantic criteria

Background:
	Given the test server is ready
		And the client is initialised
	When the client logs in with username XXX and password YYY
		And the server sends the message A|A+

Scenario: The client receives a message with too few parts
	When the server sends the message I only have one part+
	Then the client throws a MESSAGE_PARSE_ERROR error with message Insufficiant message parts

Scenario: The client receives an empty message
	When the server sends the message +
	Then the client throws a MESSAGE_PARSE_ERROR error with message Insufficiant message parts

Scenario: The client receives a message for an unknown topic
	When the server sends the message B|R+
	#TODO This should be a MESSAGE_PARSE_ERROR
	Then the client throws a R error with message received message for unknown topic B

Scenario: The client receives a message with an unknown action
	When the server sends the message R|XXX+
	Then the client throws a MESSAGE_PARSE_ERROR error with message Unknown action XXX

#TODO Eventhandler needs to pass the client to convert typed
#Scenario: The client receives a message with typed data, but an unknown type
	#When the server sends the message E|EVT|someEvent|QXX+
	#Then the client throws a MESSAGE_PARSE_ERROR error with message Unknown type XXX