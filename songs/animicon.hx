import funkin.game.HealthIcon;

static var animiconP1:FlxSprite;
static var animiconP2:FlxSprite;

function postCreate() {
    iconP1.visible = iconP2.visible = false;

    for (newIcon in 0...2) {
        var icon = createIcon(newIcon == 1 ? boyfriend : dad);
        insert(members.indexOf(newIcon == 1 ? iconP2 : iconP1),switch (newIcon) {
            case 1: animiconP1 = icon;
            case 0: animiconP2 = icon;
        });
    }

    updateIcons();
}

function postUpdate(elapsed:Float){
    updateIcons();
}

var P1caniconanim:Bool = true;
var P2caniconanim:Bool = true;
static function updateIcons() {
	animiconP1.y = iconP1.y+40;
	animiconP1.x = iconP1.x+15;
	animiconP1.scale.set(iconP1.scale.x,iconP1.scale.y);
	animiconP1.updateHitbox();

	animiconP2.y = iconP2.y+40;
	animiconP2.x = iconP2.x-15;
	animiconP2.scale.set(iconP2.scale.x,iconP2.scale.y);
	animiconP2.updateHitbox();

    if (P1caniconanim && healthBar.percent < 20){
        animiconP1.animation.play('lose');
        P1caniconanim = false;
    }else if (healthBar.percent > 20 && !P1caniconanim){
        animiconP1.animation.play('win');
        P1caniconanim = true;
    }
    if (P2caniconanim && healthBar.percent > 80){
        animiconP2.animation.play('lose');
        P2caniconanim = false;
    }else if (healthBar.percent < 80 && !P2caniconanim){
        animiconP2.animation.play('win');
        P2caniconanim = true;
    }
}

static function createIcon(character:Character):FlxSprite {
    var icon = new FlxSprite();

    var path = 'healthShit/' + ((character != null) ? character.getIcon() : "face");
    if ((character != null && character.xml != null && Assets.exists(Paths.image(path)))) {
        icon.frames = Paths.getSparrowAtlas(path);
        
        icon.animation.addByPrefix("lose", "lose", 24, false);
        icon.animation.addByPrefix("win", "win", 24, false);
        icon.animation.addByPrefix("idle", "idle", 24, false);
        icon.animation.play("idle");
    } else {
        icon.frames = Paths.getSparrowAtlas("healthShit/bf-new-york-animated");
        
        icon.animation.addByPrefix("lose", "lose", 24, false);
        icon.animation.addByPrefix("win", "win", 24, false);
        icon.animation.addByPrefix("idle", "idle", 24, false);
        icon.animation.play("idle");
    }

    icon.flipX = character.isPlayer; icon.updateHitbox();
    icon.cameras = [camHUD]; icon.scrollFactor.set();
    icon.antialiasing = character.antialiasing;

    return icon;
}