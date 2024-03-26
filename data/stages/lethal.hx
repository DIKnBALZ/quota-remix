// shut up vsc
function postCreate() {
	horndude = new FunkinSprite(bg.getGraphicMidpoint().x-50,bg.getGraphicMidpoint().y);
	horndude.frames = Paths.getFrames("stages/lethal/lookathimgo");
	horndude.animation.addByPrefix('left','bgdance',24);
	horndude.animation.addByPrefix('idle','bgloop',24); 
	horndude.animation.play('idle');
	horndude.antialiasing = true;
	insert(4, horndude);

	bell = new FunkinSprite();
	bell.frames = Paths.getFrames("stages/lethal/bell");
	bell.animation.addByPrefix('idle','bell0');
	bell.animation.addByPrefix('click','bell_ring',24,false);
	bell.playAnim('idle', true);
	bell.antialiasing = true;
	add(bell);
	bell.x = table.x + (table.width - bell.width)/2;
	bell.y = table.y -20;
	bell.animation.finishCallback = (anim:String) -> {
		if (anim == 'click') {
			dad.stunned = false;
			bell.animation.play('idle');
		}
	}

	blend = new FunkinSprite().loadGraphic(Paths.image('stages/lethal/gradient'));
	blend.blend = 0;
	add(blend);
}

function update(e) blend.alpha = (FlxG.camera._fxFadeAlpha == 0 && FlxG.camera._fxFadeAlpha == 0);

function onEvent(e) {
	if (e.event.name == "jeb_please_listen_to_our_heeds") { // the name might be inconvenient but its an inside joke so maybe screw You..?????
		if (!PlayState.opponentMode && !PlayState.coopMode)
			ding(e.event.params[0], e.event.params[1]);
	} else if (e.event.name == "look_at_him_go") horndude.playAnim(e.event.params[0] ? "left" : "idle", false);
	else if (e.event.name == "cam_snap") {
		if (!e.event.params[1]) {
			camera.lock(
				!e.event.params[0] ? stage.getSprite("sky").getGraphicMidpoint().x + 50 - 100 : stage.getSprite("sky").getGraphicMidpoint().x + 50 + 100,
				stage.getSprite("sky").getGraphicMidpoint().y + 200 - 50, true
			);
			camGame.zoom = defaultCamZoom = 2.5;
		} else {
			camera.unlock();
			camGame.zoom = defaultCamZoom = 1.425;
			camera.snap();
		}
	}
}

function onPostNoteCreation(e) {
	if (e.note.noteType == "Ding" && strumLines.members[e.strumLineID].cpu) {
		e.note.visible = false;
	}
}

function onNoteHit(event) {
	if (event.note.strumLine.characters[0].getAnimName() == "ding" && event.note.strumLine.characters[0].animation.curAnim.finished == false) {
		event.cancelAnim();
	}

	if (event.note.noteType == "Ding") {
		event.cancelAnim();
		event.cancelStrumGlow();
		if (!event.note.strumLine.cpu)
			ding(strumLines.members.indexOf(event.note.strumLine), event.note.strumLine.characters.indexOf(event.character));
	}
}

function ding(sLIndex:Int, charIndex:Int) {
	bell.playAnim("click", true);
	vocals.volume = 1;
	if (charIndex != -1)
		strumLines.members[sLIndex].characters[charIndex].playAnim("ding", true);
	else for (char in strumLines.members[sLIndex].characters)
		char.playAnim("ding", true);
}