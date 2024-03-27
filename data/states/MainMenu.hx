import flixel.input.keyboard.FlxKey;

import funkin.editors.EditorPicker;
import funkin.menus.ModSwitchMenu;
import funkin.menus.credits.CreditsMain;
import funkin.options.OptionsMenu;

var optionsText:FunkinText;
var inputText:FunkinText;
var _realInput:String = "";
var _showLine:Bool = true;
var _onPlayScreen:Bool = false;

function create() {
	CoolUtil.playMenuSong();

	optionsText = new FunkinText(50, 100, FlxG.width-100, "//MENU//\n--------------------------------\n* PLAY\n* OPTIONS\n* CREDITS\n* MODS", 48, false);
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
}

function load(optTxt:String) { // for convenience
	optionsText.text = optTxt;
	inputText.y = optionsText.y + optionsText.height;
	_realInput = "";
}

function update(e) {
	if (![-1, 8, 32, 13, 55, 27, 18, 16, 17, 20, 189, 107, 187, 109].contains(FlxG.keys.firstJustPressed())) _realInput += FlxKey.toStringMap.get(FlxG.keys.firstJustPressed());
	else if (FlxG.keys.justPressed.BACKSPACE) _realInput = _realInput.substring(0, FlxG.keys.pressed.CONTROL ? _realInput.lastIndexOf(" ") == -1 ? 0 : _realInput.lastIndexOf(" ") : _realInput.length-1);
	else if (FlxG.keys.justPressed.SPACE) _realInput += " ";
	else if (FlxG.keys.justPressed.ENTER) {
		if (!_onPlayScreen) switch _realInput.substring(0, 3).toLowerCase() {
			default: trace(_realInput.substring(0,3) + "???");
			case "pla":
				_onPlayScreen = true;
				load("//PLAY// (ESCAPE TO GO BACK)\n--------------------------------\n* SOLO (S)\n* OPPONENT MODE (O)\n* CO-OP MODE (C)");
			case "opt": FlxG.switchState(new OptionsMenu());
			case "cre": FlxG.switchState(new CreditsMain());
			case "mod":
				persistentUpdate = false;
				openSubState(new ModSwitchMenu());
			case "ref": // refresh
				FlxG.switchState(new ModState("MainMenu"));
		} else switch _realInput.substring(0, 1).toLowerCase() {
			default: trace(_realInput.substring(0,1) + "???");
			case "s": play();
			case "o": play(true);
			case "c": play(false, true);
		}
	} else if (FlxG.keys.justPressed.SEVEN) {
		persistentUpdate = false;
		openSubState(new EditorPicker());
	} else if (FlxG.keys.justPressed.ESCAPE && _onPlayScreen) {
		load("//MENU//\n--------------------------------\n* PLAY\n* OPTIONS\n* CREDITS\n* MODS");
		_onPlayScreen = false;
	}

	inputText.text = _realInput + (_showLine ? "|" : "");
}

function play(oppnt:Bool = false, coop:Bool = false) {
	PlayState.loadSong("quota", "lethal", oppnt, coop);
	FlxG.switchState(new PlayState());
}