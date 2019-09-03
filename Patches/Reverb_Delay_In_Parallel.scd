s.reboot;
s.meter;
s.plotTree;

(
SynthDef.new(\tone, {
	arg freq=1000, out=0;
	var sig, env;
	sig = SinOsc.ar(freq);
	env = EnvGen.kr(
		Env.new([0,1,0],[0.001, 0.1],[1,-1]),
		LFSaw.kr(0.5)
	);
	sig = sig * env * 0.3;
	Out.ar(out,sig);
}).add;

SynthDef.new(\reverb, {
	arg in=0, out=0;
	var sig;
	sig = In.ar(in, 1);
	sig = sig + (GVerb.ar(sig, 5, 1) * 0.2);
	Out.ar(out, sig);
}).add;

SynthDef.new(\delay, {
	arg in=0, out=0;
	var sig;
	sig = In.ar(in, 1);
	sig = sig + DelayL.ar(sig, 0.2, 0.2, 1, sig)!2;
	Out.ar(out, sig);
}).add;


SynthDef.new(\mix, {
	var sig1, sig2, main;
	sig1 = In.ar(50, 2);
	sig2 = In.ar(52, 2);
	main = sig1 + sig2;
	Out.ar(0, main);
}).add;

)

(
~mix  = Synth.new(\mix);
~rev1 = Synth.new(\reverb, [\in, 40, \out, 50]);
~rev2 = Synth.new(\delay, [\in, 40, \out, 52]);
)


~tone = Synth.new(\tone, [\out, 40]);

s.scope;