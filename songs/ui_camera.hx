// this shit is grinding my gears....
public var camera = {
	pos: [
		0 => {x: -20, y: 0},
		1 => {x: 20, y: 0},
		2 => {x: 0, y: 0}
	],

	offset: {x: 0, y: 0},

	lock: (x:Float, y:Float, snap:Bool) -> {
		_locked = true;
		_lockPos = {x: x, y: y};
		if (snap) camera.snap();
	},

	// hi guys
	unlock: () -> {_locked = false;},

	snap: () -> {
		if (_locked)
			camGame.scroll.set(_lockPos.x - camGame.width * 0.5, _lockPos.y - camGame.height * 0.5);
		else
			camGame.scroll.set(camera.pos[curCameraTarget].x - camGame.width * 0.5, camera.pos[curCameraTarget].y - camGame.height * 0.5);
	}
};
public var _locked:Bool = false;
public var _lockPos:{x:Float, y:Float} = {x: 0, y: 0};

function postCreate() {
	for (fuckOff => screwYou in camera.pos) {
		screwYou.x += stage.getSprite("sky").getGraphicMidpoint().x + 50;
		screwYou.y += stage.getSprite("sky").getGraphicMidpoint().y + 200;
	}
}

function onCameraMove(event) {
	if (startingSong) camGame.snapToTarget();

	// is this really necessary No but i dont care
	if (StringTools.startsWith(strumLines.members[curCameraTarget].characters[0].getAnimName(), 'sing')) {
		var direction:String = StringTools.replace(strumLines.members[curCameraTarget].characters[0].getAnimName(), 'sing', '').toLowerCase();

		if (StringTools.contains(direction, 'left')) camera.offset = {x: -5, y: 0};
		if (StringTools.contains(direction, 'right')) camera.offset = {x: 5, y: 0};

		if (StringTools.contains(direction, 'down')) camera.offset = {x: 0, y: 5};
		if (StringTools.contains(direction, 'up')) camera.offset = {x: 0, y: -5};
	} else camera.offset = {x:0, y: 0};

	if (!_locked)
		event.position.set(camera.pos[curCameraTarget].x + camera.offset.x, camera.pos[curCameraTarget].y + camera.offset.y);
	else
		event.position.set(_lockPos.x, _lockPos.y);
}