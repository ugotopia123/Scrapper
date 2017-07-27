package shipParts {
	import ship.Ship;
	
	/**
	 * ...
	 * @author Alec Spillman
	 */
	public class MainThruster extends ShipPart {
		public static const speedToThrust:Number = -(2 / 3);
		public static const speedToWeight:Number = 2;
		public static const thrustToSpeed:Number = 1 / speedToThrust;
		public static const thrustToWeight:Number = 2;
		public static const weightToSpeed:Number = 1 / speedToWeight;
		public static const weightToThrust:Number = 1 / thrustToWeight;
		
		private static var _standard:MainThruster;
		private static var _hammer:MainThruster;
		private static var _tortoise:MainThruster;
		private static var _lightweight:MainThruster;
		private static var _thumper:MainThruster;
		private static var _cascade:MainThruster;
		private static var _warp:MainThruster;
		
		public var speed:Number;
		public var thrust:Number;
		private var _currentSpeed:Number;
		private var _currentThrust:Number;
		
		public function MainThruster(name:String, weight:Number, speed:Number, thrust:Number) {
			super(name, weight);
			this.speed = speed;
			this.thrust = thrust;
			levelVector = new <Function>[speedLevel, thrustLevel, weightLevel];
		}
		
		public static function initialize():void {
			_standard = new MainThruster("Standard", 10, 5, 2);
			_hammer = new MainThruster("Hammer", 5, 4, 4);
			_tortoise = new MainThruster("Tortoise", 12.5, 6.5, 1.25);
			_lightweight = new MainThruster("Lightweight", 2.5, 5, 1);
			_thumper = new MainThruster("Thumper", 25, 6, 6);
			_cascade = new MainThruster("Cascade", 15, 5, 7.5);
			_warp = new MainThruster("Warp", 20, 10, 2);
		}
		
		public static function get standard():MainThruster { return _standard.copyPart() as MainThruster; }
		public static function get hammer():MainThruster { return _hammer.copyPart() as MainThruster; }
		public static function get tortoise():MainThruster { return _tortoise.copyPart() as MainThruster; }
		public static function get lightweight():MainThruster { return _lightweight.copyPart() as MainThruster; }
		public static function get thumper():MainThruster { return _thumper.copyPart() as MainThruster; }
		public static function get cascade():MainThruster { return _cascade.copyPart() as MainThruster; }
		public static function get warp():MainThruster { return _warp.copyPart() as MainThruster; }
		
		public function get currentSpeed():Number { return _currentSpeed; }
		public function get currentThrust():Number { return _currentThrust; }
		
		override public function copyPart():ShipPart {
			return new MainThruster(name, weight, speed, thrust);
		}
		
		override public function equip(ship:ship.Ship):void {
			super.equip(ship);
			
			if (ship.mainThruster != null) ship.mainThruster.unequip(ship);
			
			ship.mainThruster = this;
		}
		
		override public function unequip(ship:ship.Ship):void {
			super.unequip(ship);
			ship.mainThruster = null;
		}
		
		private function speedLevel():void {
			var rand:Number = Main.randNumber(1, 3);
			speed++;
			
			if (rand == 1 && thrust >= Math.abs(speedToThrust * 2)) thrust += speedToThrust;
			else if (rand == 2 && thrust >= Math.abs(speedToThrust)) {
				thrust += speedToThrust / 2;
				weight += speedToWeight / 2;
			}
			else weight += speedToWeight;
		}
		
		private function thrustLevel():void {
			var rand:Number = Main.randNumber(1, 3);
			thrust++;
			
			if (rand == 1 && speed >= Math.abs(thrustToSpeed * 2)) speed += thrustToSpeed;
			else if (rand == 2 && speed >= Math.abs(thrustToSpeed)) {
				speed += thrustToSpeed / 2;
				weight += thrustToWeight / 2;
			}
			else weight += thrustToWeight;
		}
		
		private function weightLevel():void {
			var rand:Number = Main.randNumber(1, 3);
			weight++;
			
			if (rand == 1) speed += weightToSpeed;
			else if (rand == 2) thrust += weightToThrust;
			else {
				speed += weightToSpeed / 2;
				thrust += weightToThrust / 2;
			}
		}
	}
}