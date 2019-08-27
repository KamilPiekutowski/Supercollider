s.boot;


(
SynthDef(\sine, {
	arg freq=440, atk=0.005, rel=0.3, amp=1, pan=0;
	var sig, env;
	sig = SinOsc.ar(freq);
	env = EnvGen.kr(Env.new([0,1,0],[atk,rel],[1,-1]), doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * env;
	Out.ar(0,sig);
}).add;
)

(
Pdef(
	\sinepat,
    Pbind(
		\instrument, \sine,
		\dur, Pwhite(0.05, 0.5, inf),
		\midinote, Pseq([35], inf).trace,
		\harmonic, Pexprand(1, 10, inf).round,
		\atk, Pwhite(0.01, 0.1, inf),
		\rel, Pwhite(5.0, 10.0, inf),
		\amp, Pkey(\harmonic).reciprocal * 0.3,
		\pan, Pwhite(-0.8, 0.8, inf),
	);
).stop;
)

p.stop;

Env.new([0,1,0],[0.004,0.3],[1,-1]).plot;

