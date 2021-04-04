package game.states;

import flixel.math.FlxMath;
import game.item.FuelCell;
import game.item.Item;
import game.ui.PlayerHUD;
import flixel.text.FlxText;
import flixel.FlxState;

/**
 * Endless Game so we don't need the tile states.
 */
class PlayState extends FlxState {
	public var player:Player;
	public var enemyGrp:FlxTypedGroup<Enemy>;
	public var itemGrp:FlxTypedGroup<Item>;
	public var spawnTimer:Float = 0;
	public var itemSpawnTimer:Float = 0;
	public var hud:PlayerHUD;
	public var score:Int = 0;
	public var fuel:Float = 1000;
	public var stars:Stars;

	public static inline var SPAWN_TIME:Float = 1.75;
	public static inline var ITEM_SPAWN_TIME:Float = 10;
	public static inline var FUEL_DMG:Int = 500;

	override public function create() {
		super.create();
		createStarField();
		createPlayer();
		createEnemies();
		createItems();
		createUI();
	}

	public function createStarField() {
		stars = new Stars(FlxG.width / 2, -200, 5000);
		stars.start(false, .015, 0);
		add(stars);
	}

	public function createPlayer() {
		var start = FlxG.width / 2;
		player = new Player(start, 450);
		add(player);
	}

	public function createEnemies() {
		enemyGrp = new FlxTypedGroup<Enemy>();
		add(enemyGrp);
	}

	public function createItems() {
		itemGrp = new FlxTypedGroup<Item>();
		add(itemGrp);
	}

	public function createUI() {
		hud = new PlayerHUD();
		add(hud);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		processFuel(elapsed);
		processScore(elapsed);
		updateHUD(elapsed);
		spawnEnemies(elapsed);
		spawnItems(elapsed);
		processLevel(elapsed);
	}

	public function processFuel(elapsed:Float) {
		fuel -= elapsed * 20;
	}

	public function processScore(elapsed:Float) {
		score += 1;
	}

	public function updateHUD(elapsed:Float) {
		hud.updateScore(score);
		hud.updateFuel(Math.ceil(fuel));
	}

	public function spawnEnemies(elapsed:Float) {
		if (spawnTimer > SPAWN_TIME) {
			// Spawn new enemies at the top of the screen;

			var speedVariance = FlxG.random.int(0, 175);
			var spawnX = FlxG.random.int(0, FlxG.width);
			var spawnY = -30;
			var asteroid = new Asteroid(spawnX, spawnY);
			asteroid.acceleration.y = 400;
			asteroid.maxVelocity.set(0, 75 + speedVariance);
			enemyGrp.add(asteroid);
			spawnTimer = 0;
		} else {
			spawnTimer += elapsed;
		}
	}

	public function spawnItems(elapsed:Float) {
		if (itemSpawnTimer > ITEM_SPAWN_TIME) {
			var spawnX = FlxG.random.int(0, FlxG.width);
			var spawnY = -30;
			var fuelCell = new FuelCell(spawnX, spawnY);
			fuelCell.acceleration.y = 400;
			fuelCell.maxVelocity.set(0, 100);
			itemGrp.add(fuelCell);
			itemSpawnTimer = 0;
		} else {
			itemSpawnTimer += elapsed;
		}
	}

	public function processLevel(elapsed:Float) {
		processCollisions();
		// Game Over State
		if (fuel <= 0) {
			openSubState(new GameOverSubState());
		}

		// No Win State
	}

	public function processCollisions() {
		FlxG.overlap(player, enemyGrp, playerTouchEnemy);
		FlxG.overlap(player, itemGrp, playerTouchItem);
		FlxG.overlap(enemyGrp, enemyGrp, enemyTouchEnemy);
	}

	public function playerTouchEnemy(player:Player, enemy:Enemy) {
		enemy.kill();
		// Fuel Damage & Potential Slow Down
		fuel -= FUEL_DMG;
		fuel = fuel.clampf(0, FlxMath.MAX_VALUE_INT);
		hud.updateFuel(Math.ceil(fuel));
	}

	public function playerTouchItem(player:Player, item:Item) {
		switch (Type.getClass(item)) {
			case FuelCell:
				// var fuelCell = cast item;
				fuel += FuelCell.FUEL_AMOUNT;
			case _:
				// Do nothing otherwise
		}
		item.kill();
	}

	public function enemyTouchEnemy(enemyOne:Enemy, enemyTwo:Enemy) {
		FlxG.collide(enemyOne, enemyTwo);
	}
}