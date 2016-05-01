Pando Client
============

Non-browser clients for the Pando installation.
These have three modes:
1. Observer - you are not added to the room and cannot participate, but have access to all of the
              information about other users
2. Participant - you are added to the room and can send messages, but you only have access to a single sound
3. Relay - sets up a small intermediary server that can be communicated with via OSC from other clients written
           in any language that supports OSC but not websockets (many "creative coding" languages).
           