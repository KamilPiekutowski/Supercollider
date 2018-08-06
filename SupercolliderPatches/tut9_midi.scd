s.boot;

MIDIClient.init;
MIDIClient.sources;
MIDIIn.connectAll;

~notes = Array.newClear(128);
~bend = 8192;

(
MIDIdef.noteOn(\noteOnTest, {
	arg vel, nn, chan, src;
	[vel, nn].postln;
	~notes[nn] = Synth.new(
		\tone,
		[
			\freq, nn.midicps,
			\amp, vel.linexp(0,127, 0.01, 0.3),
			\gate, 1,
			\bend, ~bend.linlin(0,16383,-2,2),
		]
	);
});

MIDIdef.noteOff(\noteOffTest, {
	arg vel, nn;
	[vel, nn].postln;
	~notes[nn].set(\gate, 0);
	~notes[nn] = nil;
});

MIDIdef.bend(\bendTest, {
	arg val, chan, src;
	[val, chan, src].postln;
	~bend = val;
	~notes.do{arg synth; synth.set(\bend, val.linlin(0,16383, -2,2))};
}, chan: 0);

)




s.meter;
s.plotTree;

MIDIdef(\noteOnTest).free;
MIDIdef.freeAll;

(
SynthDef.new(\tone, {
	arg freq=440, amp=0.3, gate=0 ,bend = 0;
	var sig, env;
	sig = SinOsc.ar(freq * bend.midiratio)!2;
	env = EnvGen.kr(Env.adsr, gate, doneAction:2);
	sig = sig * env * amp;
	Out.ar(0,sig);
}).add;
)








