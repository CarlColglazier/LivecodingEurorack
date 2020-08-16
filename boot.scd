(
s.options.numOutputBusChannels = 6;
s.options.numInputBusChannels = 6;

// I probably want my DAW to handle this.
// This will probably go to custom inputs in BitWig.
"SC_JACK_DEFAULT_INPUTS".setenv("ES-9_in");

// env string constructor
e = "";
i = 9;
while( { i <= 16}, {
	e = (e++"ES-9_out:playback_"++i.asString);
	if ( i != 16, {
		e = e++",";
	});
	i = i + 1;
});


"SC_JACK_DEFAULT_OUTPUTS".setenv(e);


s.options.numBuffers = 1024 * 32; // increase this if you need to load more samples
s.options.memSize = 8192 * 32; // increase this if you get "alloc failed" messages
s.options.maxNodes = 1024 * 32; // increase this if you are getting drop outs and the message "too many nodes"
//~dirt = SuperDirt;
s.waitForBoot {
	~dirt = SuperDirt(2, s);
	~dirt.loadSoundFiles;
	~dirt.start(57120, [0, 2, 4]);
};

s.boot;
)


(
SynthDef(\dc_out, { | out, sustain, volts |
	var env = EnvGen.ar(Env.linen(0.001, 1.0, 0.001), timeScale: sustain, doneAction: 2);
	//var env = EnvGen.ar(Env.perc(0.001, 0.999, 1, -4), timeScale:sustain, doneAction:2);
	var ran = LinLin.kr(volts, -10, 10, -1, 1);
	var sig = Lag.kr(ran, 0.1);
	Out.ar(out, K2A.ar(sig) * env);
}).add;
)