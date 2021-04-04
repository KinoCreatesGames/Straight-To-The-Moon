package game.item;

import flixel.math.FlxMath;

class FuelCell extends Item {
	public static inline var FUEL_AMOUNT:Int = 200;

	public function new(x:Float, y:Float) {
		super(x, y);
		makeGraphic(8, 8, KColor.BEAU_BLUE);
	}
}