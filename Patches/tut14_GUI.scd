s.boot;
// PALETTE:
// #012738
// #06527B
// #036CBA
// #00DCE9
// #BD6DBC

(
SynthDef.new(\simplebpf, {
	arg freq = 440, res=0.2;
	var sig;
	sig = PinkNoise.ar(1!2);
	sig = BPF.ar(
		sig,
		freq.lag(0.35),
		res.lag(0.35),
		1/res.sqrt.lag(0.25)
	);
	Out.ar(0,sig);

}).add;
)

(

Window.closeAll;

//window dimentions

~width = 400;
~height = 240;

w = Window.new("gui", Rect.new(
	(Window.screenBounds.width/2) - (~width/2),
	Window.screenBounds.height/2 - (~height/2),
	~width,
	~height
))
.onClose_({
	"CLOSING".postln;
	s.freeAll;
})
.front
.alwaysOnTop_(true)
.background_(Color.new255(1,39,56));

~freqNumBox = NumberBox(w, Rect.new(62,150,55,20))
.value_(100).align_(\center)
.clipLo_(100)
.clipHi_(4000)
.background_(Color.new255(1,39,56))
.normalColor_(Color.new255(189,109,188))
.decimals_(2)
.action_({
	arg obj;
	~freqKnob.valueAction_(obj.value.explin(100,4000,0,1));
});

~freqLabel = StaticText(w, Rect.new(74,175,50,20))
.string_("Freq")
.background_(Color.new255(1,39,56))
.stringColor_(Color.new255(189,109,188));

~hertzLabel = StaticText(w, Rect.new(120,150,50,20))
.string_("Hz")
.background_(Color.new255(1,39,56))
.stringColor_(Color.new255(189,109,188));

~resLabel = StaticText(w, Rect.new(196,175,50,20))
.string_("Res")
.background_(Color.new255(1,39,56))
.stringColor_(Color.new255(189,109,188));

~qualLabel = StaticText(w, Rect.new(240,150,50,20))
.string_("Q")
.background_(Color.new255(1,39,56))
.stringColor_(Color.new255(189,109,188));

~resNumBox = NumberBox(w, Rect.new(185,150,50,20))
.value_(0.2)
.clipLo_(0.01)
.clipHi_(100)
.align_(\center)
.background_(Color.new255(1,39,56))
.normalColor_(Color.new255(189,109,188))
.decimals_(2)
.action_({
	arg obj;
	~resKnob.valueAction_(obj.value.explin(1,100,0.1,1));
});

~freqKnob = Knob.new(w, Rect.new(40,40,100,100))
.color_([
	Color.new255(1,39,56),
	Color.new255(189,109,188),
	Color.new255(6,82,123),
	Color.new255(189,109,188)]
)
.action_({
	arg obj;
	var freq;
	freq = obj.value.linexp(0,1,100,4000).postln;
	if(
		x.isPlaying,
		{x.set(\freq,freq);}
	);
	~freqNumBox.value_(obj.value.linexp(0,1,100,4000));
});


~resKnob = Knob.new(w, Rect.new(160,40,100,100))
.color_([
	Color.new255(1,39,56),
	Color.new255(189,109,188),
	Color.new255(6,82,123),
	Color.new255(189,109,188)]
)
.action_({
	arg obj;
	var res;
	res = obj.value.linexp(0.1,1,1,100).reciprocal;
	if(
		x.isPlaying,
		{x.set(\res,res);}
	);
	~resNumBox.value_(obj.value.explin(0.1,100,0,1).reciprocal.postln);
});


~button = Button(w, Rect(300,80,50,30))
.states_(
	[
		["OFF", Color.new255(0,220,233), Color.new255(6,82,123)],
		["ON" , Color.new255(0,220,233), Color.new255(189,109,188)]
	]
)
.action_({
	arg obj;
	if(
		obj.value == 1,
		{
			x = Synth.new(
				\simplebpf,
				[
					\freq, ~freqKnob.value.linexp(0,1,100,4000)
				]
			).register;
		},
		{x.free}
	)
})
)


x.free;

w.close;


~freqKnob.valueAction_(rrand(0.0,1.0));
~resKnob.valueAction_(rrand(0.7,1.0));




w.close;
w.view.children;

GUI.current;

