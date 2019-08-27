s.boot;
s.meter;
s.plotTree;


(
SynthDef(\analog, {
	arg out=0, freq=80, amp=0.3, atk=0.01, sust=0.1;
	var sig, env;
	sig =
	[
		Pulse.ar(freq, SinOsc.kr(0.0625).range(0.01,0.49)),
		Pulse.ar(freq, SinOsc.kr(0.05).range(0.2,0.40))
	];

	env = EnvGen.ar(Env.perc(atk, sust), doneAction:2);
	sig = sig * env * amp;


	Out.ar(out, sig);
}).add;
)

(
SynthDef(\delay, {
	arg in, out=0, buff=0, mix=1.0, maxDelayTime=1.0, delayTime=0.1, amp=1.8;
	var sig = In.ar(in, 2);
	sig = DelayN.ar(sig,maxDelayTime, delayTime, mix);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

(
Synth.new(\analog, [\freq, 48.midicps]);
Synth.new(\analog, [\freq, 51.midicps]);
Synth.new(\analog, [\freq, 55.midicps]);
Synth.new(\analog, [\freq, 58.midicps]);
)

(
	~seq = [0.2,0.5,0.4,0.3];
	~pitch = [48, 51, 55, 58].midicps;
	~sust = [0.05, 0.1, 0.5, 0.05, 0.01];
	~atk = [0.05, 0.05, 0.02];

	~delayBus = Bus.audio(s, 0);
	r = Synth.new(\delay, [\in, ~delayBus]);
)


//start play
r = Synh.new(\delay, [\in, ~delayBus]);
r.set(\mix, 0.5, \maxDelayTime, 0.6, \delayTime, 1.0);
(
Pdef(\pulse,
	Pbind(
		\instrument, \analog,
		\dur, Pseq([1/4], inf),
		\stretch, 2.0 /4,
		\amp, Pseq(~seq, inf),
		\atk, Pseq(~atk, inf),
		\sust, Pseq(~sust, inf),
		\freq, Pseq([48,58].midicps, inf),
		//\out, Pseq([1], inf),
	);
).play(quant: 2.0 / 4);
)

//change
(
Pdef(\pulse,
	Pbind(
		\instrument, \analog,
		\dur, Pseq([1/4],inf),
		\stretch, 2.0 / 4,
		\amp, Pseq(~seq, inf),
		\atk, Pseq(~atk, inf),
		\sust, Pseq(~sust, inf),
		\freq, Pseq(~pitch,inf),
		\out, ~delayBus,
	);
).quant_(2.0 / 4);
)


60/120 * 4;