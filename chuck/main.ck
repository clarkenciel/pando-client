OscIn fromPando;
OscOut toPando;
OscMsg msg;

// set up pando
5731 => fromPando.port;
fromPando.listenAll();
("localhost", 5730) => toPando.dest;

"ChucK" => string username;

// MAIN
///////
spork ~ pandoListen();

int i;
while (second => now) {
    "hello it has been " + Std.itoa(i) + " seconds in ChucK" => string message;
    toPando.start("/pando/send_message");
    toPando.add(message).add(username);
    toPando.send();
    i++;
};

// FUNCTIONS
////////////

// fun void addSound (Shred procs[], string id, float freq) {
//     Machine.add("sound.ck:"+id+":"+Std.ftoa(freq)) @=> procs[id];
// };

fun void pandoListen () {
    while (true) {
        fromPando => now;
        while (fromPando.recv(msg) != 0) {
            <<< "message received from pando ", msg, "" >>>;
        }
    }
}