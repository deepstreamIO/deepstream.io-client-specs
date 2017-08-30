@presence
Feature: Presence
    Presence is deepstreams way of querying for clients
    and knowing about client login/logout events

Scenario: Presence Global Listener

    # The client is connected
    Given the test server is ready
        And the client is initialised
        And the server sends the message C|A+
        And the client logs in with username "XXX" and password "YYY"
        And the server sends the message A|A+

    # Happy Path
    # The client subscribes to all presence events
    Given the client subscribes to all presence events
    Then the server received the message U|S|S+

    # The server sends an ACK message for subscription
    Given the server sends the message U|A|S|S+

    # The the client is alerted when a client logs in
    When the server sends the message U|PNJ|userA+
    Then the client is notified that client "userA" logged in

    # The the client is alerted when a client logs out
    When the server sends the message U|PNL|userA+
    Then the client is notified that client "userA" logged out

    # Client is no longer alerted to presence events after unsubscribing
    Given the client unsubscribes to all presence events
    Then the server received the message U|US|US+

    # The server sends an ACK message for unsubscription
    Given the server sends the message U|A|US|US+

    When the server sends the message U|PNJ|userA+
    Then the client is not notified that client "userA" logged in
