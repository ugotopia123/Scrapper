package shipParts {
	
	/**
	 * ...
	 * @author Alec Spillman
	 */
	public class ShipPart {
		public var name:String;
		public var weight:Number;
		protected var owner:Ship;
		protected var levelVector:Vector.<Function>;
		private var leveled:Boolean = false;
		
		public function ShipPart(name:String, weight:Number) {
			this.name = name;
			this.weight = weight;
		}
		
		public static function initialize():void {
			Hull.initialize();
			MainThruster.initialize();
			SideThruster.initialize();
		}
		
		public function copyPart():ShipPart {
			return new ShipPart(name, weight);
		}
		
		public function equip(ship:Ship):void {
			ship.weight += weight;
			owner = ship;
		}
		
		public function unequip(ship:Ship):void {
			ship.weight -= weight;
			owner = null;
		}
		
		public function bonusLevel(level:uint):void {
			if (level == 0 || leveled) return;
			
			var beforeWeight:Number = weight;
			
			for (var i:uint = 0; i < level * 5; i++) levelVector[Main.randNumber(0, levelVector.length - 1)].call();
			
			if (weight > beforeWeight) weight = Math.round(weight * Math.pow(0.99775, weight) * 1000) / 1000;
			
			leveled = true;
			name += " +" + level;
			owner.weight += (weight - beforeWeight);
		}
	}
}