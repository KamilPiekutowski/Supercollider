s.boot;

(
SynthDef.new(\playbuf_test, {
	arg amp=1, out=0, buf,  da=2;
	var sig;
	sig = PlayBuf.ar(2, buf,

		doneAction:da);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

~b0 = Buffer.read(s,"C:/Users/kamilp/Documents/SupercolliderSamples/sample5.wav");
~b0.duration;

x = Synth.new(\playbuf_test,[\buf, ~b0.bufnum, \rate, -1, \start, ~b0.numFrames - 2, \loop, 1]);
x.set(\rate, 1);
x.set(\loop, 0);

Synth.new(\playbuf_test,[\buf, ~b0.bufnum, \rate, -15.midiratio, \loop, 1]);


g = Group.new;

(
x = Synth.new(\playbuf_test,[\buf, ~b0.bufnum, \rate, 1.5, \loop, 1, \amp, 0.5], g);
y = Synth.new(\playbuf_test,[\buf, ~b0.bufnum, \rate, 1.2, \loop, 1, \amp, 0.5], g);
z = Synth.new(\playbuf_test,[\buf, ~b0.bufnum, \rate, 2.1, \loop, 1, \amp, 0.5], g);
)

x.set(\rate, exprand(0.2,2.0));
y.set(\rate, exprand(0.2,2.0));
z.set(\rate, exprand(0.2,2.0));

///ends loop in all synths
g.set(\loop, 0);

s.freeAll;
s.plotTree;

//BUFER Section

~fx1 = Buffer.read(s, "C:/Users/kamilp/Documents/SupercolliderSamples/FX_Loops/RK_BO_2016_Fx_Loop_07_125bpm.wav");

~fx1.play;

(
SynthDef.new(\bufrd_test, {
	arg amp=0.5, out=0, buf, start, end;
	var sig, ptr;
	ptr = Line.ar(start, end, BufDur.kr(buf), doneAction:2);
	sig = BufRd.ar(2, buf, ptr);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

Synth.new(\bufrd_test, [\buf, ~fx1.bufnum, \start, 0, \end, ~fx1.numFrames-1]);
Synth.new(\bufrd_test, [\buf, ~fx1.bufnum, \start, ~fx1.numFrames-1, \end, 0]);

//PHAZOR LOOP Section

~fx1 = Buffer.read(s, "C:/Users/kamilp/Documents/SupercolliderSamples/FX_Loops/RK_BO_2016_Fx_Loop_07_125bpm.wav");

~fx1.play;

(
SynthDef.new(\bufrd_loop, {
	arg amp=0.5, out=0, buf, start, end, rate=1;
	var sig, ptr;
	ptr = Phasor.ar(0, BufRateScale.kr(buf) * rate, start, end);
	sig = BufRd.ar(2, buf, ptr);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

x = Synth.new(\bufrd_loop, [\buf, ~fx1.bufnum, \start, 0, \end, ~fx1.numFrames-1]);

x.set(\start, 2000, \end, 10000 * 2);
x.set(\rate, 9.midiratio);

//SINE RATIO EXAMPLE
(
SynthDef.new(\bufrd_sine, {
	arg amp=0.5, out=0, buf, start, end, freq=1;
	var sig, ptr;
	ptr = SinOsc.ar(freq, 3pi/2).range(start,end);
	sig = BufRd.ar(2, buf, ptr);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

x = Synth.new(\bufrd_sine, [\buf, ~fx1.bufnum, \start, 0, \end, ~fx1.numFrames-1]);

x.set(\start, 16000, \end, 100000);
x.set(\freq, 18);

//LFDNOISE1 EXAMPLE
(
SynthDef.new(\bufrd_sine, {
	arg amp=0.5, out=0, buf, start, end, freq=1;
	var sig, ptr;
	ptr = LFDNoise1.ar(freq).range(start,end);
	sig = BufRd.ar(2, buf, ptr);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

w = Synth.new(\bufrd_sine, [\buf, ~fx1.bufnum, \start, 0, \end, ~fx1.numFrames-1, \freq, 0.6, \amp, 0.5]);
x = Synth.new(\bufrd_sine, [\buf, ~fx1.bufnum, \start, 0, \end, ~fx1.numFrames-1, \freq, 0.8, \amp, 0.4]);
y = Synth.new(\bufrd_sine, [\buf, ~fx1.bufnum, \start, 0, \end, ~fx1.numFrames-1, \freq, 1.0, \amp, 0.6]);
z = Synth.new(\bufrd_sine, [\buf, ~fx1.bufnum, \start, 0, \end, ~fx1.numFrames-1, \freq, 0.3, \amp, 0.4]);



x.set(\start, 16000, \end, 100000);
x.set(\freq, 64, \amp, 0.2);


