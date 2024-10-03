import flixel.util.FlxAxes;
var enterd:Bool = false;

function create() {
	flie = new FlxSprite(0,0).loadGraphic(Paths.image("criminalRecords/stephanieFile"));
	flie.updateHitbox();
	flie.screenCenter(FlxAxes.XY);
	flie.alpha = 0.001;
	add(flie);

	logo = new FlxSprite(0,0).loadGraphic(Paths.image("criminalRecords/BADDIES LOGO"));
	logo.scale.set(0.15,0.15);
	logo.updateHitbox();
	logo.screenCenter(FlxAxes.XY);
	logo.x -= 650;
	logo.alpha = 0.001;
	add(logo);

	logowhite = new FlxSprite(0,0);
	logowhite.frames = Paths.getSparrowAtlas('criminalRecords/logoShine');
	logowhite.animation.addByPrefix('show', 'logoShakelol0000', 0, true);
	logowhite.animation.play("show");
	logowhite.scale.set(0.5,0.5);
	logowhite.updateHitbox();
	logowhite.screenCenter(FlxAxes.XY);
	logowhite.alpha = 0.001;
	add(logowhite);

	entertext = new FlxSprite(0,0);
	entertext.frames = Paths.getSparrowAtlas('baddieTitleEnter');
	entertext.animation.addByPrefix('idle', 'ENTER IDLE', 0, true);
	entertext.animation.play("idle");
	entertext.updateHitbox();
	entertext.screenCenter(FlxAxes.XY);
	entertext.y += 100;
	entertext.x -= 1250;
	add(entertext);
	FlxTween.tween(entertext, {alpha: 0.25}, 1,{type: 4,startDelay: 0.5,loopDelay: 0.5});

	FlxTween.tween(logowhite, {alpha: 1}, 0.25,{startDelay: 0.5});
	FlxG.sound.play(Paths.sound('titleCars'));

	new FlxTimer().start(5, function(tmr:FlxTimer){
		FlxTween.tween(logowhite, {alpha: 0.001}, 0.75, {
			onComplete: function(tween:FlxTween)
			{
				for (sigmas in [flie,logo]){
					FlxTween.tween(sigmas, {alpha: 1}, 0.75);
				}
				FlxTween.tween(entertext, {x: entertext.x + 600}, 0.75, {ease: FlxEase.expoOut});
				if (FlxG.sound.music == null || !FlxG.sound.music.playing){
					FlxG.sound.playMusic(Paths.music('reloadedTheme'), 0, true);
					FlxG.sound.music.persist = true;
					FlxG.sound.music.fadeIn(4, 0, 0.7);
				}
			}});
    });
}

function update(){
	if (FlxG.keys.justPressed.ENTER && !enterd){
		FlxG.sound.play(Paths.sound('confirm'));
		enterd = true;
		entertext.visible = false;
		FlxTween.tween(logo, {alpha: 0}, 0.5,{startDelay: 0.5});
		FlxTween.tween(flie, {alpha: 0}, 0.5,{startDelay: 1,
			onComplete: function(tween:FlxTween)
			{
				FlxG.switchState(new MainMenuState());
			}});
	}
}
