import funkin.backend.utils.ShaderResizeFix;
import Sys;
import openfl.system.Capabilities;
import funkin.game.GameOverSubstate;
import funkin.menus.PauseSubState;
import funkin.menus.BetaWarningState;
import funkin.menus.MainMenuState;
import funkin.menus.StoryMenuState;
import funkin.backend.utils.WindowUtils;
import openfl.Lib;
import lime.graphics.Image;

static var redirectStates:Map<FlxState, String> = [
    TitleState => "baddies/titleS",
    MainMenuState => "baddies/mmenuS",
    FreeplayState => "baddies/freeplayS",
];

function new() {
    windowShit(1920, 720, 0.75);
    FlxG.stage.window.resizable = false;
}

function destroy()
    windowShit(1280, 720);

function postStateSwitch()
    windowShit(1920, 720, 0.75);

var winWidth = Math.floor(Capabilities.screenResolutionX * (3 / 4)) > Capabilities.screenResolutionY ? Math.floor(Capabilities.screenResolutionY * (4 / 3)) : Capabilitities.screenResolutionX;
var winHeight = Math.floor(Capabilities.screenResolutionX * (3 / 4)) > Capabilities.screenResolutionY ? Capabilities.screenResolutionY : Math.floor(Capabilities.screenResolutionX * (3 / 4));

public static function windowShit(newWidth:Int, newHeight:Int, scale:Float = 0.9){
    if(newWidth == 1024 && newHeight == 768)
        FlxG.resizeWindow(winWidth * scale, winHeight * scale);
    else
        FlxG.resizeWindow(newWidth, newHeight);
    FlxG.resizeGame(newWidth, newHeight);
    FlxG.scaleMode.width = FlxG.width = FlxG.initialWidth = newWidth;
    FlxG.scaleMode.height = FlxG.height = FlxG.initialHeight = newHeight;
    ShaderResizeFix.doResizeFix = true;
    ShaderResizeFix.fixSpritesShadersSizes();
    window.x = Capabilities.screenResolutionX/2 - window.width/2;
    window.y = Capabilities.screenResolutionY/2 - window.height/2;
}

function preStateSwitch() {
    for (redirectState in redirectStates.keys())
        if (FlxG.game._requestedState is redirectState)
            FlxG.game._requestedState = new ModState(redirectStates.get(redirectState));
}