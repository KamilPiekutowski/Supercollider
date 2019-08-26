s.boot;

(
SynthDef.new(\iter2, {
	arg freq=200;
	var temp, sum;
	sum=0;
	10.do{
		arg count;
		temp = SinOsc.ar(freq * (count +1));
		sum = sum + temp;
	};
	sum = sum * 0.05;
	Out.ar(0,sum);
}).add;
)

x = Synth.new(\iter2)


x.free;