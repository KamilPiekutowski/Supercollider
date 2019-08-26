s.boot;

play{a=HPF.ar(ar(PinkNoise,5e-3),10)*Line.kr(0,1,9);ar(GVerb,({|i|ar(Ringz,a*LFNoise1.kr(0.01+0.1.rand),99*i+40,0.2)}!99).sum,10,12).tanh};