s.boot;


(
SynthDef.new(\iter,{
	arg freq=40;
	var temp, sum, env;
	sum = 0;
	env = EnvGen.kr(
		Env.perc(0.01, 10, 1, -1),
		doneAction: 2
	);
	10.do{
		temp = VarSaw.ar(
			freq * {Rand(0.99,1.02)}!2,
			{Rand(0.0,1.0)},
			{Rand(0.005,0.05)}
		);
		sum = sum + temp;
	};
	sum = sum * 0.2 * env;
	Out.ar(0,sum);
}).add;
)

x = Synth.new(\iter,[\freq,55]);

x.free;