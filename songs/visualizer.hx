//shoutouts to frakits
import funkin.backend.utils.AudioAnalyzer;
import flixel.util.FlxSpriteUtil;

var analyzer:AudioAnalyzer;
var canvas:FlxSprite;
public var color = 0xFFFFFFFF;

var w = FlxG.width + 200;
var h = FlxG.height + 100;
var yOfs = 200;

function postCreate() {
	camHUD.visible = false;
	player.cpu = true;

	initWaveform();

}

function initWaveform() {
	canvas = new FunkinSprite().makeGraphic(w, h, 0x00000000);
	canvas.screenCenter(FlxAxes.X);
	canvas.antialiasing = false;
	canvas.scrollFactor.set();
	canvas.zoomFactor = 0;
	insert(5, canvas);
}

function getValue(index) {
	return 720 * analyzer.analyze(FlxG.sound.music.time - (Conductor.stepCrochet/25 * index) - Conductor.stepCrochet/25, FlxG.sound.music.time - (Conductor.stepCrochet/25 * index));
}

var wavelength = 50;

var lastValues = [for (i in 0...20) 0];
function draw() {
	FlxSpriteUtil.fill(canvas, 0);
	if (FlxG.sound.music != null) {
		if (analyzer == null) analyzer = new AudioAnalyzer(FlxG.sound.music);
		FlxSpriteUtil.beginDraw(0, {
			thickness: 4,
			color: color,
		});
		lastValues[0] = -getValue(0);
		FlxSpriteUtil.flashGfx.moveTo(0, lastValues[0] + yOfs);
		for (i in 1...wavelength)
		{
			lastValues[i] = -getValue(i);
			// lastValues[i] = i % 2 == 0 ? -getValue(i) : getValue(i);
			FlxSpriteUtil.flashGfx.lineTo((w / wavelength) * i, (lastValues[i]/4) + yOfs);
		}
		FlxSpriteUtil.endDraw(canvas, null);
	}
}