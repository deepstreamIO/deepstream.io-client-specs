@presence
Feature: Presence
    Presence is deepstreams way of querying for clients
    and knowing about client login/logout events

Scenario: Presence Individual Listeners

    # The client is connected
    Given the test server is ready
        And the client is initialised
        And the server sends the message C|A+
        And the client logs in with username "XXX" and password "YYY"
        And the server sends the message A|A+

    # Happy Path
    # The client subscribes to presence events
    Given the client subscribes to presence events for "userA,userB"
    Then the server received the message U|S|1|["userA","userB"]+

    # The server sends an ACK message for subscription
    Given the server sends the message U|A|S|1+

    # The the client is alerted when a client logs in
    When the server sends the message U|PNJ|userA+
    Then the client is notified that client "userA" logged in

    # The the client is alerted when a client logs out
    When the server sends the message U|PNL|userB+
    Then the client is notified that client "userB" logged out

    # Client is no longer alerted to presence events after unsubscribing
    Given the client unsubscribes to presence events for "userA"
    Then the server received the message U|US|2|["userA"]+

    # The server sends an ACK message for unsubscription
    Given the server sends the message U|A|US|2+

    # The the client is alerted when a client logs out
    When the server sends the message U|PNJ|userB+
    Then the client is notified that client "userB" logged in
    
    When the server sends the message U|PNJ|userA+
    Then the client is not notified that client "userA" logged in
