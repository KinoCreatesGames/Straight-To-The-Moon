package game.item;

import flixel.math.FlxMath;

class FuelCell extends Item {
	public static inline var FUEL_AMOUNT:Int = 200;

	public function new(x:Float, y:Float) {
		super(x, y);
		loadGraphic(AssetPaths.fuel_cell__png);
	}
}