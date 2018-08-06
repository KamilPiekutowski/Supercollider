s.meter;

(
SynthDef.new(\multi,{
	var sig, amp, env;
	env = EnvGen.kr(
		Env.new([0,1,0],[10,10],[1,-1]),
		doneAction:2
	);
	amp = SinOsc.kr({ExpRand(0.2,12)}!8).range(0,1);
	sig = SinOsc.ar({ExpRand(50,1200)}!8);
	sig = sig * amp * env;
	sig = Splay.ar(sig) * 0.28;
	Out.ar(0, sig);
}).add;
)

x = Synth.new(\multi);

x.free;