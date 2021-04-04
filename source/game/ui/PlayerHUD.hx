package game.ui;

class PlayerHUD extends FlxTypedGroup<FlxSprite> {
	public var scoreText:FlxText;
	public var fuelText:FlxText;

	public function new() {
		super();
		create();
	}

	public function create() {
		createScore();
		createFuel();
	}

	public function createScore() {
		scoreText = new FlxText(0, 0, -1, 'Score 0', Globals.FONT_L);
		add(scoreText);
	}

	public function createFuel() {
		fuelText = new FlxText(20, 20, -1, 'Fuel 1000', Globals.FONT_L);
		add(fuelText);
	}

	public function updateScore(val:Int) {
		scoreText.text = 'Score ${val}';
		scoreText.screenCenterHorz();
	}

	public function updateFuel(val:Int) {
		var valString = '${val}'.lpad('0', 3);
		fuelText.text = 'Fuel ${valString}';
	}
}