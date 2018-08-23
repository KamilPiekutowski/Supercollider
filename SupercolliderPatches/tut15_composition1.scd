s.reboot;
s.meter.alwaysOnTop_(true);
s.plotTree;

(
SynthDef(\bpfsaw, {
	arg atk=2,sus=0,rel=3,c1=1,c2=(-1),
	freq=500,detune=0.2, pan=0,
	cfmin=500,cfmax=2000,
	rqmin=0.1, rqmax=0.2,
	cfhzmin=0.1,cfhzmax=0.3,
	lsf=200,ldb=0,
	amp=1,out=0;
	var sig,env;
	env = EnvGen.kr(
		Env([0,1,1,0],
			[atk,sus,rel],
			[c1,0,c2]),
		doneAction:2
	);

	sig = Saw.ar(freq * {LFNoise1.kr(0.5,detune).midiratio}!2);
	sig = BPF.ar(
		sig,
		{LFNoise1.kr(
			LFNoise1.kr(4).exprange(cfhzmin,cfhzmax)
		).exprange(cfmin,cfmax)}!2,
		{LFNoise1.kr(0.1).exprange(rqmin,rqmax)}!2
	);
	sig = BLowShelf.ar(sig,lsf,0.5,ldb);
	sig = Balance2.ar(sig[0], sig[1], pan);
	sig = sig * env * amp;
	Out.ar(out,sig);
}).add;


SynthDef(\bpfbuf, {
	arg atk=0,sus=0,rel=3,c1=1,c2=(-1),
	buf=0,rate=1,spos=0,freq=440,rq=1,bpfmix=0,
	pan=0,amp=1,out=0;
	var sig,env;

	env = EnvGen.kr(
		Env([0,1,1,0],
			[atk,sus,rel],
			[c1,0,c2]),
		doneAction:2
	);
	sig = PlayBuf.ar(1,buf,rate*BufRateScale.ir(buf),startPos:spos);
	sig = XFade2.ar(sig,BPF.ar(sig,freq,rq,1/rq.sqrt), bpfmix*2-1);
	sig = sig * env;
	sig = Pan2.ar(sig,pan,amp);
	Out.ar(out,sig);
}).add;


)


(
b = Dictionary.new;
PathName("/home/kamilp/Documents/Supercollider/SupercolliderSamples/Perc/Comp1").entries.do{
	arg subFolder;
	b.add(
		subFolder.folderName.asSymbol ->
		Array.fill(
			subFolder.entries.size,
			{
				arg i;
				Buffer.read(s,subFolder.entries[i].fullPath);
			}
		)
	);
};
)


b.keys;

b[\shakers][11].play;


(
rrand(5,10).do{
Synth(\bpfbuf,
	[
		\buf,b[\shakers][[0,9,10,11].choose],
		\atk,exprand(2,3),
		\sus,3,
		\rel,exprand(5,8),
		\bpfmix,1,
		\freq,(Scale.lydian.degrees+69).choose.midicps * [1,2].choose,
		\rq, exprand(0.001,0.008),
		\rate,exprand(1.2,2.4),
		\pan, rrand(-0.5,0.5),
		\amp,exprand(4,6),
	]
);
}
)


(
~chords = Pbind(
	\instrument,\bpfsaw,
	\dur,Pwhite(4.5,7.0,inf),
	\midinote,Pxrand([
		[23,35,54,63,64],
		[45,52,54,59,61,64],
		[28,40,47,56,59,63],
		[42,52,57,61,63],
	],inf),
	\detune,Pexprand(0.05,0.2,inf),
	\cfmin,100,
	\cfmax,1500,
	\rqmin,Pexprand(0.01,0.15,inf),
	\atk,Pwhite(2.0,2.5,inf),
	\rel,Pwhite(6.5,10.0,inf),
	\ldb,6,
	\amp, 0.7,
	\out,0,
).play;
)

(
~marimba = Pbind(
	\instrument,\bpfsaw,
	\dur,Prand([1,0.5],inf),
	\freq,Prand([1/2,2/3,1,4/3,2,5/2,3,4,6,8],inf),
	\detune,0,
	\rqmin,0.005,
	\rqmax,0.008,
	\cfmin,Prand((Scale.major.degrees+64).midicps,inf) * Prand([0.5,1,2,4],inf),
	\cfmax,Pkey(\cfmin) * Pwhite(1.008,1.025, inf),
	\atk,3,
	\sus,1,
	\rel,5,
	\amp,2,
	\out,0,
).play;
)

~marimba.stop;
~chords.stop;

