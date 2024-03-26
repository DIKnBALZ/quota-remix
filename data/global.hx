import openfl.system.Capabilities;

function new() {
    FlxG.width = FlxG.initialWidth = 960;
	window.resize(FlxG.width, FlxG.height);
	window.resizable = false;
	for (camera in FlxG.cameras.list) camera.setSize(FlxG.width, FlxG.height);

	window.x = (Capabilities.screenResolutionX / 2) - (window.width / 2);
	window.y = (Capabilities.screenResolutionY / 2) - (window.height / 2);
}

function postStateSwitch() window.title = "LETHAL LOGS";

function destroy() {
    FlxG.width = FlxG.initialWidth = 1280;
	window.resize(FlxG.width, FlxG.height);
	window.resizable = false;
	for (camera in FlxG.cameras.list) camera.setSize(FlxG.width, FlxG.height);

	window.x = (Capabilities.screenResolutionX / 2) - (window.width / 2);
	window.y = (Capabilities.screenResolutionY / 2) - (window.height / 2);
}