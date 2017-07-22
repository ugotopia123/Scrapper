package shipParts {
	
	/**
	 * ...
	 * @author Alec Spillman
	 */
	public class SideThruster extends ShipPart {
		public var speed:Number;
		public var thrust:Number;
		
		public static var standard:SideThruster;
		public static var hammer:SideThruster;
		public static var tortoise:SideThruster;
		
		public function SideThruster(name:String, weight:Number, speed:Number, thrust:Number) {
			super(name, weight);
			this.speed = speed;
			this.thrust = thrust;
		}
		
		public static function initialize():void {
			standard = new SideThruster("Standard", 2, 2, 2.5);
			hammer = new SideThruster("Hammer", 1, 1.5, 2.5);
			tortoise = new SideThruster("Tortoise", 4, 3.5, 1);
		}
		
		override public function equip(ship:Ship):void {
			super.equip(ship);
			
			if (ship.sideThruster != null) ship.sideThruster.unequip(ship);
			
			ship.sideThruster = this;
		}
		
		override public function unequip(ship:Ship):void {
			super.unequip(ship);
			ship.sideThruster = null;
		}
	}
}