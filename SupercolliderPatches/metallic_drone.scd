s.boot;

(
SynthDef.new(\iter2, {
	arg freq=200, dev=1.02;
	var temp, sum;
	sum=0;
	10.do{
		arg count;
		temp = SinOsc.ar(
			freq *
			(count +1) *
			LFNoise1.kr({Rand(0.05,0.2)}!2).range(dev.reciprocal, dev)
		);
		temp = temp * LFNoise1.kr({Rand(0.5,8)}!2).exprange(0.01,1);
		sum = sum + temp;
	};
	sum = sum * 0.05;
	Out.ar(0,sum);
}).add;
)

x = Synth.new(\iter2);


x.set(\freq, 53);
x.set(\dev, 0.98);

x.free;