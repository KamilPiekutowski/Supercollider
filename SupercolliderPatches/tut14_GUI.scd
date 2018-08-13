s.boot;
// PALETTE:
// #012738
// #06527B
// #036CBA
// #00DCE9
// #BD6DBC

(
SynthDef.new(\simplebpf, {
	arg freq = 440;
	var sig;
	sig = PinkNoise.ar(1!2);
	sig = BPF.ar(sig, freq.lag(0.35), 0.2);
	Out.ar(0,sig);

}).add;
)

(

Window.closeAll;

//window dimentions

~width = 400;
~height = 200;

w = Window.new("gui", Rect.new(
	(Window.screenBounds.width/2) - (~width/2),
	Window.screenBounds.height/2 - (~height/2),
	~width,
	~height


))
.front
.alwaysOnTop_(true)
.background_(Color.new255(1,39,56));

~knob = Knob.new(w, Rect.new(40,40,100,100))
.color_([
	Color.new255(1,39,56),
	Color.new255(189,109,188),
	Color.new255(6,82,123),
	Color.new255(189,109,188)]);

~knob.action_({
	arg obj;
	var cf;
	cf = obj.value.linexp(0,1,100,4000).postln;
	if(
		x.isPlaying,
		{x.set(\freq,cf);}
	);
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
					\freq, ~knob.value.linexp(0,1,100,4000)
				]
			).register;
		},
		{x.free}
	)
})
)


x.free;

w.close;

~knob.valueAction_(rrand(0.0,1.0));




w.close;
w.view.children;

GUI.current;

