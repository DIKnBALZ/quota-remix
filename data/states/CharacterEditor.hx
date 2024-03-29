import openfl.system.Capabilities;

function create() {
	FlxG.width = FlxG.initialWidth = 1280;
	window.resize(FlxG.width, FlxG.height);
	for (camera in FlxG.cameras.list) camera.setSize(FlxG.width, FlxG.height);

	window.x = (Capabilities.screenResolutionX / 2) - (window.width / 2);
}

function destroy() {
	FlxG.width = FlxG.initialWidth = 960;
	window.resize(FlxG.width, FlxG.height);
	for (camera in FlxG.cameras.list) camera.setSize(FlxG.width, FlxG.height);

	window.x = (Capabilities.screenResolutionX / 2) - (window.width / 2);
}