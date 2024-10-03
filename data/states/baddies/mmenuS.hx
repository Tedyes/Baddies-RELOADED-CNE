import flixel.util.FlxAxes;
import flixel.effects.FlxFlicker;
import funkin.options.OptionsMenu;
import funkin.menus.credits.CreditsMain;
import funkin.menus.ModSwitchMenu;
import funkin.editors.EditorPicker;
import flixel.addons.display.FlxBackdrop;
import Sys;

static var curSelected:Int = 0;
var menuItems:FlxTypedGroup<FlxSprite>;
var optionsig:Array<String> = ["story_mode","freeplay","credits","art_gallery","merch","options","quit"];

function create() {
	bg = new FlxSprite(0,0).loadGraphic(Paths.image("menuReload/MAIN MENU/mainmenuBG"));
	bg.updateHitbox();
	bg.screenCenter(FlxAxes.XY);
	add(bg);

	step = new FlxSprite(0,0);
	step.frames = Paths.getSparrowAtlas('menuReload/MAIN MENU/stephanieMenu');
	step.animation.addByPrefix('idle', 'stephanieMenu', 24, true);
	step.animation.play("idle");
	step.updateHitbox();
	step.screenCenter(FlxAxes.XY);
	step.y += 25;
	step.x += 325;
	add(step);

	logo = new FlxSprite(0,0);
	logo.frames = Paths.getSparrowAtlas('menuReload/MAIN MENU/logoGlitch');
	logo.animation.addByPrefix('idle', 'logoGlitch', 24, true);
	logo.animation.play("idle");
	logo.updateHitbox();
	logo.screenCenter(FlxAxes.XY);
	logo.y -= 225;
	logo.x -= 450;
	add(logo);

	fog = new FlxBackdrop(Paths.image("menuReload/MAIN MENU/FOG"),FlxAxes.X,-200);
	fog.updateHitbox();
	fog.screenCenter(FlxAxes.XY);
	fog.y += 125;
	fog.velocity.set(-25,0);
	fog.alpha = 0.5;
	add(fog);

	overlay = new FlxSprite(0,0).loadGraphic(Paths.image("menuReload/SCREENS/SCREEN UI SHIT/screenOverlay"));
	overlay.updateHitbox();
	overlay.screenCenter(FlxAxes.XY);
	overlay.flipY = true;
	overlay.blend = 8;
	add(overlay);

	menuItems = new FlxTypedGroup();
	add(menuItems);

	for (i=>option in optionsig)
	{
		var menuItem:FlxSprite = new FlxSprite(200, 300 + (i * 40));
		menuItem.frames = Paths.getFrames('menuReload/MAIN MENU/menu_' + option);
		menuItem.animation.addByPrefix('idle', option + " basic", 24);
		menuItem.animation.addByPrefix('selected', option + " white", 24);
		menuItem.animation.play('idle');
		menuItem.scale.set(0.75,0.75);
		menuItem.updateHitbox();
		menuItem.ID = i;
		menuItem.alpha = 0.0001;
		menuItems.add(menuItem);
		menuItem.antialiasing = true;

		FlxTween.tween(menuItem, {alpha: 1}, 0.75,{startDelay: 0.5});
	}
	menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.scale.set(0.75,0.75);
			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				spr.scale.set(0.5,0.5);
			}
			spr.updateHitbox();
		});

	dust = new FlxBackdrop(Paths.image("menuReload/SCREENS/SCREEN UI SHIT/dust"));
	dust.updateHitbox();
	dust.screenCenter(FlxAxes.XY);
	dust.velocity.set(-20,20);
	dust.alpha = 0.25;
	add(dust);

	if (FlxG.sound.music == null || !FlxG.sound.music.playing){
		FlxG.sound.playMusic(Paths.music('reloadedTheme'), 0, true);
		FlxG.sound.music.persist = true;
		FlxG.sound.music.fadeIn(4, 0, 0.7);
	}
}

var selectedSomethin:Bool = false;
function update(){
	if (!selectedSomethin)
		{
			if (FlxG.keys.justPressed.SEVEN) {
				persistentUpdate = false;
				persistentDraw = true;
				openSubState(new EditorPicker());
			}

			if (controls.UP_P){
				changeItem(-1);
			}

			if (controls.DOWN_P){
				changeItem(1);
			}

			if (controls.BACK){
				FlxG.sound.play(Paths.sound('backspace'));
				new FlxTimer().start(0.25, function(tmr:FlxTimer){
					FlxG.switchState(new TitleState());
				});
			}

			if (controls.SWITCHMOD) {
				openSubState(new ModSwitchMenu());
				persistentUpdate = false;
				persistentDraw = true;
			}

			if (controls.ACCEPT)
			{
				selectItem();
			}
		}

}

function selectItem() {
	selectedSomethin = true;
	FlxG.sound.play(Paths.sound('confirm'));

	menuItems.forEach(function(spr:FlxSprite)
		{
			if (spr != menuItems.members[curSelected]){
				FlxTween.tween(spr, {alpha: 0.001}, 0.25);
			}
		});

	FlxFlicker.flicker(menuItems.members[curSelected], 0.85, Options.flashingMenu ? 0.06 : 0.15, false, false, function(flick:FlxFlicker)
	{
		var daChoice:String = optionsig[curSelected];
		switch (daChoice)
		{
			case 'story_mode': FlxG.switchState(new StoryMenuState());
			case 'freeplay': FlxG.switchState(new FreeplayState());
			case 'credits': FlxG.switchState(new CreditsMain());
			case 'merch': 
				CoolUtil.openURL('https://casanovasdoodles.myspreadshop.com/');
				selectedSomethin = false;
				menuItems.forEach(function(spr:FlxSprite)
					{
						menuItems.members[curSelected].visible = true;
						if (spr != menuItems.members[curSelected]){
							spr.alpha = 1;
						}
					});
			case 'options': FlxG.switchState(new OptionsMenu());
			case 'quit': Sys.exit(0);
		}
	});
}

function changeItem(huh:Int = 0){
	FlxG.sound.play(Paths.sound('arrows'));

	curSelected += huh;
	if (curSelected > 6){
		curSelected = 0;
	}
	if (curSelected < 0){
		curSelected = 6;
	}

	menuItems.forEach(function(spr:FlxSprite)
	{
		spr.animation.play('idle');
		spr.scale.set(0.75,0.75);
		if (spr.ID == curSelected)
		{
			spr.animation.play('selected');
			spr.scale.set(0.5,0.5);
		}
		spr.updateHitbox();
	});
}