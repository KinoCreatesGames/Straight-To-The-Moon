package game.char;

import flixel.math.FlxMath;

class Asteroid extends Enemy {
	public function new(x:Float, y:Float) {
		super(x, y, null, null);
		create();
	}

	public function create() {
		var asteroidAssets = [AssetPaths.asteroid_1__png, AssetPaths.asteroid_2__png];
		var asteroidAsset = asteroidAssets[FlxG.random.int(0,
			asteroidAssets.length - 1)];
		loadGraphic(asteroidAsset, false, 16, 16);
	}

	override function assignStats() {}
}