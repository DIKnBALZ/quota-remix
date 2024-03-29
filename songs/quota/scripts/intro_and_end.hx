/// shut up vsc

import funkin.backend.MusicBeatState;

/// FUCK YOU BLEND
var _hate:FunkinSprite;
function postCreate() {
	boyfriend.alpha = 0;
	dad.alpha = 0;
	camGame.zoom = 1.425 * 1.5;
	camera.lock(stage.getSprite("sky").getGraphicMidpoint().x + 50, stage.getSprite("sky").getGraphicMidpoint().y + 200, true);
	camHUD.alpha = 0;

	_hate = new FunkinSprite().makeSolid(FlxG.width, FlxG.height, 0xFF000000);
	_hate.scrollFactor.set(); _hate.zoomFactor = 0;
	add(_hate);

	MusicBeatState.skipTransOut = true;

	camZooming = true;
}

function onPostCountdown(event) {
	if (event.sprite != null) {
		event.sprite.destroy();
		remove(event.sprite, true);
	}
}

function onSongStart() {
	var time = 4;
	FlxTween.tween(_hate, {alpha: 0},time, {ease: FlxEase.quadInOut});
	FlxTween.tween(FlxG.camera, {zoom: 1.425},time, {ease: FlxEase.quadInOut});

	_lockPos.y -= 100;
	camera.snap();
	FlxTween.num(_lockPos.y, stage.getSprite("sky").getGraphicMidpoint().y + 200,time, null, (f:Float)->{_lockPos.y = f;});
	
	new FlxTimer().start(time/2,Void->{
		for (i in [dad,boyfriend]) {
			FlxTween.tween(i, {alpha: 1},time/2, {ease: FlxEase.quadInOut});
		}

	});
}

// show the hud earlier for opponent and coop support
function beatHit(b) {
	if (b == 28) FlxTween.tween(camHUD,{alpha: 1},0.7,{ease: FlxEase.sineInOut});
	if (b == 332) {
		// _endVideo.play();
		// accuracyTxt.visible = missesTxt.visible = scoreTxt.visible = false;
	}
}