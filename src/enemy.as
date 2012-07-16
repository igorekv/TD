package
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author igorek
	 */
	public class enemy extends Sprite
	{
		private var state:int;
		private const STAY:int = 0;
		private const WALK:int = 1;
		private const FIRE:int = 2;
		public var sprite:Sprite = new Sprite();
		public var select:Boolean = false;
		public var life:int = 350;
		public var toDelete:Boolean = false;
		private var targetX:int;
		private var targetY:int;
		private var checkpoint:int = 0;
		private var curX:Number;
		private var curY:Number;
		private var statBar:statusBar;
		private var path:Array = new Array();
		private var speed:int = 1;
		
		public function enemy(x:int, y:int)
		{
			
			path = global.findPath(global.nodes[0][4], global.nodes[10][9]);
			this.x = curX = targetX = path[0].mapX;
			this.y = curY = targetY = path[0].mapY;
			sprite.graphics.beginFill(0xCC3333);
			sprite.graphics.drawRect(0, 0, 10, 10);
			sprite.graphics.endFill();
			addChild(sprite);
			addEventListener(Event.ENTER_FRAME, draw);
			
			statBar = new statusBar(life, 100, this.width);
			addChild(statBar);
		
		}
		
		public function hit(dmg:int):void
		{
			life -= dmg;
			statBar.draw(life);
			global.stat_bullHitCount++;
			global.stat_dmgCount += dmg;
			if (life < 0 && !this.toDelete)
			{
				dead();
			}
		}
		
		private function dead():void
		{
			this.removeEventListener(Event.ENTER_FRAME, draw);
			parent.removeChild(this);
			this.toDelete = true;
		}
		
		private function destCalc(x:int, y:int):Number
		{
			return Math.sqrt((x * x) + (y * y));
		}
		
		private function draw(e:Event):void
		{
			
			if (Math.abs(int(curX) - path[checkpoint].mapX) >= 1 || Math.abs(int(curY) - path[checkpoint].mapY) >= 1)
			{
				
				var len:Number = destCalc(Math.abs(curX - path[checkpoint].mapX), Math.abs(curY - path[checkpoint].mapY));
				curX += (path[checkpoint].mapX - curX) / (len / speed);
				curY += (path[checkpoint].mapY - curY) / (len / speed);
				
			}
			this.x = curX;
			this.y = curY;
			
			if (Math.abs(int(curX) - path[checkpoint].mapX) < 2 && Math.abs(int(curY) - path[checkpoint].mapY) < 2)
			{
				checkpoint++;
			}
			;
			
			if (checkpoint == path.length)
			{
				checkpoint = 0;
				this.x = curX = targetX = path[0].mapX;
				this.y = curY = targetY = path[0].mapY;
			}
			;
		
		}
	
	}

}