# Message Structure Overview

deepstream messages are transmitted using a proprietary, minimal, string-based protocol. Every message follows the same structure:

<div class="message-structure">
&lt;topic&gt;|&lt;action&gt;|&lt;data[0]&gt;|...|&lt;data[n]&gt;+
</div>

| and + are used in these examples as placeholders, messages are actually separated by invisible Ascii control characters ("unit separator" (31) and "record separator" (30))

Every message has a topic (e.g. RECORD, EVENT, AUTH etc.) and an action ( CREATE, DELETE, SUBSCRIBE etc.). For a full list of available topics and actions please see the list of constants [here](/docs/common/constants/).

### Example
Here's an example: creating or reading a record `user/Lisa`

```javascript
userLisa = ds.record.getRecord( 'user/Lisa' );
```

would prompt the client to send this message to the server

Messages always start with `topic` and `action`, but can contain an arbitrary amount of data fields afterwards.

Setting the value of a path within the record for example

```javascript
userLisa.set( 'lastname', 'Owen' );
```

would result in this outgoing message

Please note the additional S before `Owen`. This indicates that the remaining part of the message should be treated as a string. Please find a list of available types [here](/docs/common/constants/#data-types).

Both client and server use a message-parser to validate these messages and to convert them into objects looking like this:

```javascript
{
	raw: 'R\u001fP\u001fuser/Lisa\u001f1\u001flastname\u001fSOwen',
	topic: 'R',
	action: 'P',
	data: [ 'user/Lisa', '1', 'lastname', 'SOwen' ]
}
```

The actual conversion of `SOwen` into `Owen` happens further down the line by the part of the application that handles this specific message and knows which fields contain typed data.
