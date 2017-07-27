package shipParts {
	import ship.Ship;
	
	/**
	 * ...
	 * @author Alec Spillman
	 */
	public class Hull extends ShipPart {
		public static const healthToShield:Number = -(2 / 3);
		public static const healthToRecharge:Number = 0.5;
		public static const healthToWeight:Number = 2;
		public static const shieldToHealth:Number = 1 / healthToShield;
		public static const shieldToRecharge:Number = 0.75;
		public static const shieldToWeight:Number = 3;
		public static const rechargeToHealth:Number = 1 / healthToRecharge;
		public static const rechargeToShield:Number = 1 / shieldToRecharge;
		public static const rechargeToWeight:Number = -2;
		public static const weightToHealth:Number = 1 / healthToWeight;
		public static const weightToShield:Number = 1 / shieldToWeight;
		public static const weightToRecharge:Number = 1 / rechargeToWeight;
		
		private static var _standard:Hull;
		private static var _guardian:Hull;
		private static var _mini:Hull;
		private static var _bulwark:Hull;
		private static var _electric:Hull;
		private static var _organic:Hull;
		private static var _ghost:Hull;
		
		public var health:Number;
		public var shield:Number;
		public var recharge:Number;
		private var _currentHealth:Number;
		private var _currentShield:Number;
		private var _currentRecharge:Number;
		
		public function Hull(name:String, weight:Number, health:Number, shield:Number, recharge:Number) {
			super(name, weight);
			this.health = health;
			this.shield = shield;
			this.recharge = recharge;
			levelVector = new <Function>[healthLevel, shieldLevel, rechargeLevel, weightLevel];
		}
		
		public static function initialize():void {
			_standard = new Hull("Standard", 15, 10, 10, 5);
			_guardian = new Hull("Guardian", 25, 15, 15, 7);
			_mini = new Hull("Mini", 5, 5, 5, 3);
			_bulwark = new Hull("Bulwark", 20, 25, 5, 2.5);
			_electric = new Hull("Electric", 22.5, 5, 25, 10);
			_organic = new Hull("Organic", 20, 30, 0, 5);
			_ghost = new Hull("Ghost", 25, 0, 30, 12.5);
		}
		
		public static function get standard():Hull { return _standard.copyPart() as Hull; }
		public static function get guardian():Hull { return _guardian.copyPart() as Hull; }
		public static function get mini():Hull { return _mini.copyPart() as Hull; }
		public static function get bulwark():Hull { return _bulwark.copyPart() as Hull; }
		public static function get electric():Hull { return _electric.copyPart() as Hull; }
		public static function get organic():Hull { return _organic.copyPart() as Hull; }
		public static function get ghost():Hull { return _ghost.copyPart() as Hull; }
		
		public function get currentHealth():Number { return _currentHealth; }
		public function get currentShield():Number { return _currentShield; }
		public function get currentRecharge():Number { return _currentRecharge; }
		
		override public function copyPart():ShipPart {
			return new Hull(name, weight, health, shield, recharge);
		}
		
		override public function equip(ship:ship.Ship):void {
			super.equip(ship);
			
			if (ship.hull != null) ship.hull.unequip(ship);
			
			ship.hull = this;
		}
		
		override public function unequip(ship:ship.Ship):void {
			super.unequip(ship);
			ship.hull = null;
		}
		
		override public function bonusLevel(level:uint):void {
			super.bonusLevel(level);
		}
		
		private function healthLevel():void {
			var rand:Number = Main.randNumber(1, 4);
			health++;
			
			if (rand == 1 && shield >= Math.abs(healthToShield * 2)) shield += healthToShield;
			else if (rand == 2) recharge += healthToRecharge;
			else if (rand == 3) weight += healthToWeight;
			else {
				recharge += healthToRecharge / 2;
				weight += healthToWeight / 2;
			}
		}
		
		private function shieldLevel():void {
			var rand:Number = Main.randNumber(1, 4);
			shield++;
			
			if (rand == 1 && health >= Math.abs(shieldToHealth * 2)) health += shieldToHealth;
			else if (rand == 2) recharge += shieldToRecharge;
			else if (rand == 3) weight += shieldToWeight;
			else {
				recharge += shieldToRecharge / 2;
				weight += shieldToWeight / 2;
			}
		}
		
		private function rechargeLevel():void {
			var rand:Number = Main.randNumber(1, 4);
			recharge++;
			
			if (rand == 1) health += rechargeToHealth;
			else if (rand == 2) shield += rechargeToShield;
			else if (rand == 3 && weight >= Math.abs(rechargeToWeight * 2)) weight += rechargeToWeight;
			else {
				health += rechargeToHealth / 2;
				shield += rechargeToShield / 2;
			}
		}
		
		private function weightLevel():void {
			var rand:Number = Main.randNumber(1, 4);
			weight++;
			
			if (rand == 1) health += weightToHealth;
			else if (rand == 2) shield += weightToShield;
			else if (rand == 3 && recharge >= Math.abs(weightToRecharge * 2)) recharge += weightToRecharge;
			else {
				health += weightToHealth / 2;
				shield += weightToShield / 2;
			}
		}
	}
}