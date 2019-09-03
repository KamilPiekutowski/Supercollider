
b = Buffer.read(s, "D:\\Documents\\\SC\\Supercollider\\Samples\\a11wlk01-44_1.aiff");
// Hear it raw:
b.play

Pathname;

D:\Documents\SC\Supercollider\Samples\a11wlk01-44_1.aiff


(
Ndef(\verb, {
	var input, output, delrd, sig, deltimes;

	// Choose which sort of input you want by (un)commenting these lines:
	input = Pan2.ar(PlayBuf.ar(1, b, loop: 0), 1.0); // buffer playback, panned halfway left
	//input = SoundIn.ar([0,1]); // TAKE CARE of feedback - use headphones
	//input = Dust2.ar([0.1, 0.01]); // Occasional clicks

	// Read our 4-channel delayed signals back from the feedback loop
	delrd = LocalIn.ar(4);

	// This will be our eventual output, which will also be recirculated
	output = input + delrd[[0,1]];

	// Cross-fertilise the four delay lines with each other:
	sig = [output[0]+output[1], output[0]-output[1], delrd[2]+delrd[3], delrd[2]-delrd[3]];
	sig = [sig[0]+sig[2], sig[1]+sig[3], sig[0]-sig[2], sig[1]-sig[3]];
	// Attenutate the delayed signals so they decay:
	sig = sig * [0.4, 0.37, 0.333, 0.3];

	// Here we give delay times in milliseconds, convert to seconds,
	// then compensate with ControlDur for the one-block delay
	// which is always introduced when using the LocalIn/Out fdbk loop
	deltimes = [101, 143, 165, 177] * 0.001 - ControlDur.ir;

	// Apply the delays and send the signals into the feedback loop
	LocalOut.ar(DelayC.ar(sig, deltimes, deltimes));

	// Now let's hear it:
	output

}).play
)