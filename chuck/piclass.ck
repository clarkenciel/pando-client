// maybe set up pi class
if (me.args()) {
    // get listen and send data
    // piclass.ck:hostname:targetPort:listenPort
    me.args(0) => string hostname;
    me.args(1) => Std.atoi => int targetPort;
    if (me.args() > 2) me.args(2) => Std.atoi => int listenPort;
    else targetPort => int listenPort;
    
    // set up osc
    OscIn fromPiClass;
    OscOut toPiClass;
    OscMsg msg;
    (hostname, targetPort) => toPiClass.dest;
    listenPort => fromPiClass.port;
    fromPiClass.listenAll();
}
else {
    <<< "ERROR: Please provide a hostname and a port to listen to the pi class on", "" >>>;
};

fun void classListen () {
    while (true) {
        fromPiClass => now;
        while (fromPiClass.recv(msg) != 0) {
            <<< "message received from pi class", "" >>>;
        }
    }
}

fun void pandoListen () {
    while (true) {
        fromPiClass => now;
        while (fromPiClass.recv(msg) != 0) {
            <<< "message received from pi class", "" >>>;
        }
    }
}