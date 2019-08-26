s.boot;

(
{
	var	sig, sig1, sig2, lpf, popHz, lagtime, noise, popHzMul,
		pan1, pan2, panmod1, panmod2;
	popHzMul = Decay.kr(Dust.kr(0.15), 3, 10, 0.8);
	popHz = 	LFNoise1.kr(20).exprange(0.1,10) * popHzMul;
	sig = Dust2.ar(popHz);
	lpf = LFNoise1.kr(10).exprange(1000,20000);
	lagtime = LFNoise1.kr(20).range(0.008,0.0001);
	sig = LPF.ar(sig, lpf);
	sig = Lag.ar(sig, lagtime);
	sig = sig + FreeVerb.ar(sig, 0.8, 1, mul:0.11);
	panmod1 = LFNoise1.kr(5).range(0.2,0.7);
	panmod2 = LFNoise1.kr(5).range(0.2,0.7);
	pan1 = SinOsc.kr(panmod1).range(-0.2,0.2);
	pan2 = SinOsc.kr(panmod2).range(-0.2,0.2);
	sig1 = Pan2.ar(sig, pan1, 0.5);
	sig2 = Pan2.ar(sig, pan2, 0.5);
	sig = sig1 + sig2;
	sig = sig + BPF.ar(BrownNoise.ar([0.0025,0.0025]), 7200, 0.4);
	sig = sig + HPF.ar(Crackle.ar([1.999,1.999], 0.0025),2000);
	Out.ar(0, sig*6);
}.play
)


(
fork{
	// notes sequence
	var seq = Pxrand([0,3,5,7,8],inf).asStream;
	loop{
		var dur = 8;
		var num = 8;
		var root = 36;
		var freq = (seq.next+root).midicps;
		var spread = rrand(0.4,0.8);
		var attack = rrand(0.05, 0.3);

		// play the cluster
		play{
			var harm = Array.geom(num, 1, 1.5);
			var harma = Array.geom(num, 0.5, 0.8);
			var detune = Array.fill(num, { LFNoise2.kr(1,0.01,1) });
			var source = PinkNoise.ar;
			var bandwidth = Rand(0.001,0.01);
			var generator = [
				SinOsc.ar(freq*harm*detune, mul:harma*0.3).scramble,
				Resonz.ar(source, freq*harm*detune, bandwidth, mul:harma).scramble * 50
			].wchoose([0.2,0.8]);
			var snd = Splay.ar(generator,spread);
			snd * LFGauss.ar(dur, attack, loop:0, doneAction:2);
		};
		dur.wait;
	};

};

)

// this is what I write when I didn't sleep last night.. zzzzzz
// easy subsynth with dynklank and simple scale

(

fork{
	loop{
		var time;
		time = 5.rand;
		{
			var sound, freqs, envs, rings, numvoices, env;
			numvoices = 40;
			freqs = {(Scale.major(\just).degrees+26+
				(0,12..110).choose).choose}.dup(numvoices).midicps;
			rings = {1.0.rand}.dup(numvoices);
			envs = { EnvGen.kr(Env.linen( time/3.0.rand,
				time/3.0.rand, time/3.0.rand, 1.0.rand ) ) }.dup(numvoices);

			sound = PinkNoise.ar(numvoices.reciprocal!2);
			sound = DynKlank.ar(`[freqs,envs,rings], sound );
			sound = sound * EnvGen.kr(Env.linen(time.rand,time/3,time.rand),doneAction:2);

			sound = HPF.ar(sound, 120);

			4.do{sound = DelayC.ar(sound, 0.4, [0.4.rand,0.4.rand], 1/8, sound) };

			//good call - lets turn this down
			sound*0.04;
		}.play;
	time.wait;
	}
}
)