// OSC
OscIn listener;
OscMsg msg;

// drones
Shred loops[0];
SinOsc sines[0];
ADSR adsrs [0];
Gain master => PRCRev rev => dac;
master.gain(0.5);
rev.mix(0.2);

if (!me.args()) {
    chout <= "Please provide a port number" <= IO.nl();
    chout.flush();
}
else {
    me.arg(0) => Std.atoi => int port => listener.port;
    listener.listenAll();
    <<< "listening on: ", port, "" >>>;
    
    // main loop
    while (true) {
        listener => now;
        while (listener.recv(msg) != 0) {
            if (msg.address == "/add_user") {
                <<< "adding user", msg.getString(0), msg.getFloat(1), "" >>>;
                addUser(msg.getString(0), msg.getFloat(1));
            }
            else if (msg.address == "/update") {
                <<< "updating user", msg.getString(0), msg.getFloat(1), "" >>>;
                updateUser(msg.getString(0), msg.getFloat(1));
            }
            else if (msg.address == "/delete") {
                <<< "deleting user", msg.getString(0), "" >>>;
                removeUser(msg.getString(0));
            };
        };
    };
};

fun void addUser (string userName, float frequency) {
    new SinOsc @=> sines[userName];
    new ADSR @=> adsrs[userName];
    sines[userName].freq(frequency);
    sines[userName].gain(0.3);
    adsrs[userName].set(second, 0.01::second, 0.0, second);
    sines[userName] => adsrs[userName] => master;
    spork ~ loop(userName, Math.random2f(5,15)) @=> loops[userName];
};

fun void removeUser (string userName) {
    Machine.remove(loops[userName].id());
    sines[userName].gain(0.0);
    adsrs[userName] =< master;
    sines[userName] =< adsrs[userName];
    NULL @=> sines[userName];
    NULL @=> adsrs[userName];
};

fun void updateUser (string userName, float frequency) {
    frequency => sines[userName].freq;
    adsrs[userName].keyOn(1);
};

fun void loop (string userName, float period) {
    while (true) {
        adsrs[userName].keyOn(1);
        period::second => now;
    }
};
