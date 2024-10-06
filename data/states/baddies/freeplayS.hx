import flixel.util.FlxAxes;
import flixel.addons.display.FlxBackdrop;
import haxe.Json;
import flixel.FlxObject;
import funkin.savedata.FunkinSave;

var camFollow:FlxObject;
static var FPcurSelected:Int = 0;
public var intendedScore:Int = 0;
public var lerpScore:Int = 0;

function create() {
	bg = new FlxBackdrop(Paths.image("menuReload/ART GALLERY/artgallery"));
	bg.updateHitbox();
	bg.velocity.set(20,20);
	add(bg);

	fade = new FlxSprite(0,0).loadGraphic(Paths.image("menuReload/FREEPLAY/fade"));
	fade.updateHitbox();
	add(fade);

	name = new FlxSprite(0,25).loadGraphic(Paths.image("menuReload/FREEPLAY/freeplayName"));
	name.updateHitbox();
	name.angle = -5;
	add(name);

	tear = new FlxSprite(0,0).loadGraphic(Paths.image("menuReload/FREEPLAY/tear"));
	tear.x = FlxG.width - tear.width;
	tear.updateHitbox();
	add(tear);

	esc = new FlxSprite(10,0).loadGraphic(Paths.image("menuReload/FREEPLAY/esc")); //those code sucks i swear to god
	backtext = new FlxText(esc.x+125, esc.y+10, 800, "BACK");
	resettext = new FlxText(backtext.x+1100, 0, 800, "RESET SCORE");
	r = new FlxSprite(resettext.x+110,0).loadGraphic(Paths.image("menuReload/FREEPLAY/r"));
	listentext = new FlxText(r.x+75, 0, 800, "LISTEN TO SONG");
	space = new FlxSprite(listentext.x+130,0).loadGraphic(Paths.image("menuReload/FREEPLAY/space"));
	selecttext = new FlxText(space.x+160, 0, 800, "SELECT");
	enter = new FlxSprite(selecttext.x+60,0).loadGraphic(Paths.image("menuReload/FREEPLAY/enter"));
	songnametext = new FlxText(315,FlxG.height/2-150, 800, "");
	songnametext.setFormat(Paths.font('GothicJoker.ttf'), 60, 0xFFFFFF);
	songnametext.updateHitbox();
	add(songnametext);
	
	for (whatgsdtg in [esc,r,space,enter]){
		whatgsdtg.y = FlxG.height - whatgsdtg.height - 10;
		whatgsdtg.updateHitbox();
		add(whatgsdtg);
	}

	for (whats in [backtext,resettext,listentext,selecttext]){
		whats.y = FlxG.height - esc.height;
		whats.setFormat(Paths.font('GothicJoker.ttf'), 30, 0xFFFFFF);
		whats.updateHitbox();
		add(whats);
	}

	camFollow = new FlxObject(0, 0, 1, 1);
	add(camFollow);

	cardBG = new FlxCamera();
    cardBG.bgColor = 0;
    FlxG.cameras.add(cardBG,false);
	cardBG.follow(camFollow, null, 0.12);

	cardGroup = new FlxTypedGroup();
    cardGroup.cameras = [cardBG];
    add(cardGroup);

	var songJSON:Array = Json.parse(Assets.getText(Paths.json('../data/FPSongs')));
	for (whats in 0 ... songJSON.songs.length){
		var card = new FlxSprite(225+300*whats,FlxG.height/2-100).loadGraphic(Paths.image("cards/card-" + songJSON.songs[whats].card));
		card.scale.set(0.5,0.5);
		card.updateHitbox();
		card.ID = whats;
		cardGroup.add(card);
	}
	var saveData = FunkinSave.getSongHighscore(songJSON.songs[FPcurSelected].name, "hard");
	intendedScore = saveData.score;
	cardGroup.forEach(function(spr:FlxSprite)
		{
			spr.alpha = 0.75;
			if (spr.ID == FPcurSelected)
			{
				songnametext.text = songJSON.songs[FPcurSelected].name;
				spr.alpha = 1;
				var mid = spr.getGraphicMidpoint();
				camFollow.setPosition(mid.x+450, 350);
			}
			spr.updateHitbox();
		});
	
	upCard = new FlxCamera();
    upCard.bgColor = 0;
    FlxG.cameras.add(upCard,false);

	leftarrow = new FlxSprite(50, FlxG.height/2);
	leftarrow.angle = -90;
	rightarrow = new FlxSprite(FlxG.width - 125, FlxG.height/2);
	rightarrow.angle = 90;

	for (ilovegays in [leftarrow,rightarrow]){
		ilovegays.frames = Paths.getFrames('menuReload/STORY MENU/arrowslol');
		ilovegays.animation.addByPrefix('idle', "arrow00", 24,true);
		ilovegays.animation.addByPrefix('pressed', "arrowPressed", 24,false);
		ilovegays.animation.play('idle');
		ilovegays.animation.finishCallback = (f)->
		{
			switch(f){
				case "pressed":
					ilovegays.animation.play('idle');
			}
		}
		ilovegays.updateHitbox();
		ilovegays.cameras = [upCard];
		add(ilovegays);
	}

	scoreText = new FlxText(FlxG.width * 0.7, 5, 550, "", 64);
	scoreText.setFormat(Paths.font("GothicJoker.ttf"), 64, FlxColor.BLACK, "right");
	add(scoreText);

	if (FlxG.sound.music == null || !FlxG.sound.music.playing){
		FlxG.sound.playMusic(Paths.music('reloadedTheme'), 0, true);
		FlxG.sound.music.persist = true;
		FlxG.sound.music.fadeIn(4, 0, 0.7);
	}
}

var selectedSomethin:Bool = false;
function update(elasped){
	lerpScore = Math.floor(lerp(lerpScore, intendedScore, 0.4));

	if (Math.abs(lerpScore - intendedScore) <= 10){
		lerpScore = intendedScore;
	}

	scoreText.text = "PERSONAL BEST: " + lerpScore;

	if (!selectedSomethin){
	if (controls.LEFT_P){
		changeItem(-1);
		leftarrow.animation.play('pressed',true);
	}

	if (controls.RIGHT_P){
		changeItem(1);
		rightarrow.animation.play('pressed',true);
	}

	if (controls.BACK){
		FlxG.sound.play(Paths.sound('backspace'));
		new FlxTimer().start(0.25, function(tmr:FlxTimer){
			FlxG.switchState(new MainMenuState());
		});
	}

	if (controls.ACCEPT)
	{
		selectItem();
	}
	}
}

function selectItem() {
	selectedSomethin = true;
	var songJSON:Array = Json.parse(Assets.getText(Paths.json('../data/FPSongs')));
	FlxG.sound.play(Paths.sound('confirm'));

	PlayState.loadSong(songJSON.songs[FPcurSelected].name, "hard", false, false);
	FlxG.switchState(new PlayState());
}

function changeItem(huh:Int = 0){
	FlxG.sound.play(Paths.sound('arrows'));
	var songJSON:Array = Json.parse(Assets.getText(Paths.json('../data/FPSongs')));

	FPcurSelected += huh;
	if (FPcurSelected > 5){
		FPcurSelected = 0;
	}
	if (FPcurSelected < 0){
		FPcurSelected = 5;
	}
	var saveData = FunkinSave.getSongHighscore(songJSON.songs[FPcurSelected].name, "hard");
	intendedScore = saveData.score;

	cardGroup.forEach(function(spr:FlxSprite)
	{
		spr.alpha = 0.75;
		if (spr.ID == FPcurSelected)
		{
			songnametext.text = songJSON.songs[FPcurSelected].name;
			spr.alpha = 1;
			var mid = spr.getGraphicMidpoint();
			camFollow.setPosition(mid.x+450, 350);
		}
		spr.updateHitbox();
	});
}