package gameplay;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import hscript.HScript;
import states.PlayState;
import systems.Conductor;

using StringTools;

class GameplayUI extends FlxGroup
{
    public var scoreTxt:FlxText;

    public var songTxt:FlxText;
    public var engineTxt:FlxText;
    #if debug
    public var debugTxt:FlxText;
    #end

    public var opponentStrums:StrumLine;
    public var playerStrums:StrumLine;

    public var engineVersion:String = 'Genesis Engine v${Main.engineVersion}';

    // Scripts
    public var healthBarScript:HScript;

    public function new()
    {
        super();
    
        // Arrows
        var arrowOffset:Float = 90.0;
        var strumY:Float = Init.trueSettings.get("Downscroll") ? FlxG.height - 165 : 50.0;

        opponentStrums = new StrumLine(arrowOffset, strumY, PlayState.SONG.keyCount);
        opponentStrums.hasInput = false;
        add(opponentStrums);
        add(opponentStrums.notes);

        playerStrums = new StrumLine((FlxG.width/2)+arrowOffset, strumY, PlayState.SONG.keyCount);
        playerStrums.hasInput = true;
        add(playerStrums);
        add(playerStrums.notes);

        // Text
        songTxt = new FlxText(5, FlxG.height - 25, 0, '${PlayState.SONG.song} - ${PlayState.currentDifficulty.toUpperCase()}', 16);
        songTxt.setFormat(AssetPaths.font("vcr"), 16, FlxColor.WHITE, LEFT);
        songTxt.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
        add(songTxt);

        engineTxt = new FlxText(0, FlxG.height - 25, 0, engineVersion, 16);
        engineTxt.setFormat(AssetPaths.font("vcr"), 16, FlxColor.WHITE, RIGHT);
        engineTxt.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
        engineTxt.x = FlxG.width - (engineTxt.width + 5);
        add(engineTxt);

        healthBarScript = new HScript("scripts/HealthBar");
        healthBarScript.setVariable("add", this.add);
        healthBarScript.setVariable("remove", this.remove);
        healthBarScript.start();
        PlayState.current.scripts.push(healthBarScript);

        #if debug
        debugTxt = new FlxText(0, 5, 0, "", 16);
        debugTxt.setFormat(AssetPaths.font("vcr"), 16, FlxColor.WHITE, RIGHT);
        debugTxt.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
        add(debugTxt);
        #end
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        #if debug
        updateDebugTxt();
        #end
    }

    #if debug
    function updateDebugTxt()
    {
        debugTxt.text = (
            "Song Position: " + Conductor.position + "\n" +
            "Current Beat: " + Conductor.currentBeat + " ("+Conductor.currentBeatFloat+")" + "\n" +
            "Current Step: " + Conductor.currentStep + " ("+Conductor.currentStepFloat+")"
        );
        debugTxt.x = FlxG.width - (debugTxt.width + 5);
    }
    #end
}