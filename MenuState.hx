package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;

class MenuState extends FlxState
{
	//create variables to modify
	var start:FlxText;
	var play:FlxText;

	override public function create():Void
	{
		//text 1 for Main Menu
		start = new FlxText(180,40, "   Game Start\n RED = Player 1\nBLUE = Player 2", 30);
        add(start);
        //text 2 for Direction to start game
        play = new FlxText(220, 300, "Press Space to Start!", 15);
        add(play);
        super.create();

	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		//function to start game after key is pressed
		if(FlxG.keys.anyPressed(["Space"]))
		{
        	FlxG.switchState(new PlayState());
        }
	}
}