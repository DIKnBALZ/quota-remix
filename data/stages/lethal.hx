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
			bell.animation.play('idle');
			for (char in _stunned) char.stunned = false;
		}
	}

	blend = new FunkinSprite().loadGraphic(Paths.image('stages/lethal/gradient'));
	blend.blend = 0;
	add(blend);

	canDie = canDadDie = false;
}

function update(e) blend.alpha = (FlxG.camera._fxFadeAlpha == 0 && FlxG.camera._fxFadeAlpha == 0);

function onEvent(e) {
	if (e.event.name == "look_at_her_go") horndude.playAnim(e.event.params[0] ? "left" : "idle", false);
	else if (e.event.name == "cam_snap") {
		if (!e.event.params[1]) {
			camera.lock(!e.event.params[0] ? stage.getSprite("sky").getGraphicMidpoint().x + 50 - 100 : stage.getSprite("sky").getGraphicMidpoint().x + 50 + 100, stage.getSprite("sky").getGraphicMidpoint().y + 200 - 50, true);
			camGame.zoom = defaultCamZoom = 2.5;
		} else {
			camera.unlock();
			camGame.zoom = defaultCamZoom = 1.425;
			camera.snap();
		}
	}
}

function onPostNoteCreation(e) if (e.note.noteType == "Ding" && strumLines.members[e.strumLineID].cpu) e.note.visible = false; // craziest one liner

function onNoteHit(event) {
	if (event.noteType == "Ding" || event.noteType == "Visible Ding") {
		event.cancelAnim();
		if (event.note.strumLine.cpu && event.noteType != "Visible Ding") event.cancelStrumGlow();
		ding(strumLines.members.indexOf(event.note.strumLine), event.note.strumLine.characters.indexOf(event.character));
	}
}

function onPlayerMiss(e) {
	if (e.noteType == "Ding" || e.noteType == "Visible Ding") {
		e.cancelAnim();
		e.character.playAnim("dingmiss", true, "MISS");
	}
}

var _stunned:Array<Character> = [];
function ding(sLIndex:Int, charIndex:Int) {
	bell.playAnim("click", true);
	if (charIndex != -1) {
		strumLines.members[sLIndex].characters[charIndex].playAnim("ding", true);
		strumLines.members[sLIndex].characters[charIndex].stunned = true;
		_stunned = [strumLines.members[sLIndex].characters[charIndex]];
	} else for (char in strumLines.members[sLIndex].characters) {
		char.playAnim("ding", true);
		char.stunned = true; _stunned.push(char);
	};
}