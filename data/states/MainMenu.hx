import flixel.input.keyboard.FlxKey;

import funkin.editors.EditorPicker;
import funkin.menus.ModSwitchMenu;
import funkin.menus.credits.CreditsMain;
import funkin.options.OptionsMenu;

import lethal.menus.MenuData;

var optionsText:FunkinText;
var inputText:FunkinText;
var _realInput:String = "";
var _showLine:Bool = true;
var _onPlayScreen:Bool = false;
var _data:MenuData = null;

function create() {
	CoolUtil.playMenuSong();

	optionsText = new FunkinText(50, 100, FlxG.width-100, "", 48, false);
	optionsText.font = Paths.font("3270.ttf");
	optionsText.antialiasing = true;
	optionsText.color = 0xFF4DC656;
	add(optionsText);

	inputText = new FunkinText(50, optionsText.y + optionsText.height, FlxG.width-100, "|", 48, false);
	inputText.font = Paths.font("3270.ttf");
	inputText.antialiasing = true;
	inputText.color = 0xFF4DC656;
	add(inputText);

	new FlxTimer().start(0.5, (t:FlxTimer) -> {
		_showLine = !_showLine;
	}, 0);

	var main:MenuData = new MenuData();
	main.data = {
		title: "MENU",
		letterMin: 3,
		options: [
			{
				text: "PLAY",
				callback: () -> {
					var menu:MenuData = new MenuData();
					menu.data = {
						title: "PLAY",
						letterMin: 3,
						options: [
							{
								text: "SOLO",
								callback: () -> {play();}
							}, {
								text: "OPPONENT MODE",
								callback: () -> {play(true);}
							}, {
								text: "COOP MODE",
								callback: () -> {play(false, true);}
							}
						]
					};
					load(menu, true);
				}
			}, {
				text: "OPTIONS",
				callback: () -> {FlxG.switchState(new OptionsMenu());}
			}, {
				text: "CREDITS",
				callback: () -> {FlxG.switchState(new CreditsMain());}
			}, {
				text: "MODS",
				callback: () -> {
					persistentUpdate = false;
					openSubState(new ModSwitchMenu());
				}
			}
		]
	};
	load(main);
}

function load(d:MenuData, setParent:Bool = true) { // for convenience
	if (setParent) d.parent = _data;
	_data = d;
	optionsText.text = "//" + d.data.title + "//\n--------------------------------";
	for (i in d.data.options) optionsText.text += "\n* " + i.text;
	inputText.y = optionsText.y + optionsText.height;
	_realInput = "";
	_count = 0;
}

var _count:Int = 0;
function what() { // unrecognized input
	_count ++;
	if (_count != 6) { // dont let the input text go offscreen
		var _unrecognizedCommand:String = "\nUNRECOGNIZED COMMAND";
		optionsText.text += _unrecognizedCommand;
	} else {
		optionsText.text = optionsText.text.substring(0, optionsText.text.indexOf("\nUNRECOGNIZED COMMAND")) + "\nUNRECOGNIZED COMMAND";
		_count = 1;
	}
	inputText.y = optionsText.y + optionsText.height;
	_realInput = "";
}

function update(e) {
	if (FlxG.keys.justPressed.EIGHT) FlxG.switchState(new ModState());
	if (![-1, 8, 32, 13, 55, 27, 18, 16, 17, 20, 189, 107, 187, 109, 96, 48].contains(FlxG.keys.firstJustPressed())) _realInput += FlxKey.toStringMap.get(FlxG.keys.firstJustPressed());
	else if (FlxG.keys.justPressed.BACKSPACE) _realInput = _realInput.substring(0, FlxG.keys.pressed.CONTROL ? _realInput.lastIndexOf(" ") == -1 ? 0 : _realInput.lastIndexOf(" ") : _realInput.length-1);
	else if (FlxG.keys.justPressed.SPACE) _realInput += " ";
	else if (FlxG.keys.justPressed.ENTER && !FlxG.keys.pressed.ALT) {
		var _finalinp:String = _realInput.substring(0, _data.data.letterMin).toLowerCase();
		var _nonos:Array<String> = ["clear", "refresh", "back"];
		for (index => i in _nonos) {_nonos.remove(i); _nonos.insert(index, i.substring(0, _data.data.letterMin));};
		if (!_nonos.contains(_finalinp)) {
			var _failed:Array<Bool> = [];
			var _worked:Bool = false;
			for (i in _data.data.options) {
				if (i.text.substring(0, _data.data.letterMin).toLowerCase() == _finalinp) {
					i.callback();
					_worked = true;
				}
				else {_failed.push(true); continue;}
			}
			if (_failed.length == _data.data.options.length && !_worked) what();
		} else {
			switch _finalinp {
				case _nonos[0]:
					optionsText.text = optionsText.text.substring(0, optionsText.text.indexOf("\nUNRECOGNIZED COMMAND") == -1 ? optionsText.text.length : optionsText.text.indexOf("\nUNRECOGNIZED COMMAND"));
					inputText.y = optionsText.y + optionsText.height;
				case _nonos[1]: FlxG.switchState(new ModState("MainMenu"));
				case _nonos[2]: back();
			}
		}
		_realInput = "";
	} else if (FlxG.keys.justPressed.SEVEN) {
		persistentUpdate = false;
		openSubState(new EditorPicker());
	} else if (FlxG.keys.justPressed.ESCAPE) back();

	inputText.text = _realInput + (_showLine ? "|" : "");
}

function back() if (_data.parent != null) load(_data.parent, false); // convenience

function play(oppnt:Bool = false, coop:Bool = false) {
	PlayState.loadSong("quota", "lethal", oppnt, coop);
	FlxG.switchState(new PlayState());
}