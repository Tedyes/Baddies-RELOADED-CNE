function create() {
	if(!nextFrameSkip)
	{
		transitionTween.cancel();
		var out = newState != null;
	
		remove(blackSpr);
		remove(transitionSprite);
	
		holoSpr = new FlxSprite(-10,-10);
		holoSpr.frames = Paths.getSparrowAtlas('menuReload/TRANSITION/transitionBrush');
		holoSpr.animation.addByPrefix('in', 'brush00', 24, false);
		holoSpr.animation.addByPrefix('out', 'brush anim reverse', 24, false);
		holoSpr.cameras = [transitionCamera];
		holoSpr.scale.set(2,2);
		holoSpr.updateHitbox();
		add(holoSpr);
	
		if(out){holoSpr.animation.play('in');}
		else{holoSpr.animation.play('out');}
	
		transitionCamera.scroll.y = 0;
		holoSpr.animation.finishCallback = (f)->
		{
			switch(f){
				case "in":
					done();
				case "out":
					done();
			}
		}
	}
	else
	{
		done();
	}

}

function done()
{
	if (newState != null)
		FlxG.switchState(newState);

	new FlxTimer().start(1.2, ()-> {close();});
}