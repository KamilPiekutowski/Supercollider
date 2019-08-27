s.boot;
s.reboot;

s.plotTree;
s.meter;

(
SynthDef.new(\blip, {
	arg out, fund=300, decay=0.2, density=2, amp=1;
	var freq, trig, sig;
	freq = LFNoise0.kr(3).exprange(fund, fund * 4).round(fund);
	sig = SinOsc.ar(freq) * 0.25;
	trig = Dust.kr(density);
	sig = sig * EnvGen.kr(Env.perc(0.01, decay), trig);
	sig = Pan2.ar(sig, LFNoise0.kr(10));
	sig = sig * amp;
	Out.ar(out, sig);
}).add;

SynthDef.new(\reverb, {
	arg in, out=0;
	var sig;
	sig = In.ar(in,2);
	sig = FreeVerb.ar(sig, 0.5, 0.8, 0.2);
	Out.ar(out, sig);
}).add;
)


~sourceGrp = Group.new;
~fxGrp = Group.after(~sourceGrp);
~reverbBus = Bus.audio(s, 1);

Synth.new(\reverb, [\in, ~reverbBus], ~fxGrp);

(
8.do{
	Synth.new(
		\blip,
		[
			\out, ~reverbBus,
			\fund, exprand(60,300).round(30);
		],
		~sourceGrp
	);
}
)

~sourceGrp.set(\decay, 0.5, \density, 8, \amp, 0.5);

~sourceGrp.free;
~fxGrp.free;
y.free;




