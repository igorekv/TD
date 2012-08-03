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
		public var life:int = 100;
		public var toDelete:Boolean = false;
		public var toRemove:Boolean = false;
		private var targetX:int;
		private var targetY:int;
		private var checkpoint:int = 0;
		private var curX:Number;
		private var curY:Number;
		private var statBar:statusBar;
		private var path:Array = new Array();
		private var speed:int = 1;
		private var deadCount:int = 5;
		
		public function enemy(_x:int, _y:int,_health:int)
		{
			this.x = _x;
			this.y = _y;
			life = _health;
			findNewPath();
			//trace(tx,ty);
			//path = global.findPath(global.nodes[0][4], global.nodes[3][6]);
			this.x = curX = targetX = path[0].mapX;
			this.y = curY = targetY = path[0].mapY;
			sprite.graphics.beginFill(0xCC3333,0.1);	
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
			//
			//parent.removeChild(this);
			global.score += 10;
			global.money += 5;
			statBar.show("$"+5);
			this.toDelete = true;
		}
		
		
		
		private function destCalc(x:int, y:int):Number
		{
			return Math.sqrt((x * x) + (y * y));
		}
		
		public function findNewPath() {
			var tx:int = global.LEVEL_TARGET_X; var ty:int = global.LEVEL_TARGET_Y;
			if (global.ownBase && global.ownBase.builded) { global.ownBase.getPosition(); tx = global.ownBase.target_x; ty = global.ownBase.target_y; }
			
			path = global.findPath(global.nodes[int(x/global.TILE_WIDTH)][int(y/global.TILE_HEIGHT)], global.nodes[tx][ty]);
			
		}
		
		
		private function draw(e:Event):void
		{
			if (toDelete) {//действия при смерти
				if (deadCount < 0) { 
					//удаление обьекта
					this.toRemove = true; 
					this.removeEventListener(Event.ENTER_FRAME, draw);
					}
				deadCount--;
				
			}else{
			
				if (Math.abs(int(curX) - path[checkpoint].mapX) > 1 || Math.abs(int(curY) - path[checkpoint].mapY) > 1)
			{//если растояние до чекпойнта  больше 1 то двигаться
				
				var len:Number = destCalc(Math.abs(curX - path[checkpoint].mapX), Math.abs(curY - path[checkpoint].mapY));
				curX += (path[checkpoint].mapX - curX) / (len / speed);
				curY += (path[checkpoint].mapY - curY) / (len / speed);
				
			}
			this.x = curX;
			this.y = curY;
			
			if (Math.abs(int(curX) - path[checkpoint].mapX) <= 1 && Math.abs(int(curY) - path[checkpoint].mapY) <= 1)
			{//если дошел до чекпойнта то следующий
				if (checkpoint < path.length-1){checkpoint++;}
			}
			;
			
			if (checkpoint == path.length-1) //если дошел до конца
			{
				
				if (Math.abs((this.x/global.TILE_WIDTH)-global.LEVEL_TARGET_X)<=1 && Math.abs((this.y/global.TILE_HEIGHT)-global.LEVEL_TARGET_Y)<=1  ) {//если дошел до финиша
					global.lives--;
					trace("finish");
					this.toDelete = true;
					deadCount = 0;
					
					
				}else {//если стоит у базы
					//trace(int(this.x/global.TILE_WIDTH),int(this.y/global.TILE_HEIGHT));
					/*
					var tx:int = global.LEVEL_TARGET_X; var ty:int = global.LEVEL_TARGET_Y;
					if (global.ownBase && global.ownBase.builded) { tx = global.ownBase.target_x; ty = global.ownBase.target_y;}
					
					path = global.findPath(global.nodes[int(x / global.TILE_WIDTH)][int(y / global.TILE_HEIGHT)], global.nodes[tx][ty]);
					//checkpoint = 0;
					*/
				}
				
				
				/*
				this.x = curX = targetX = path[0].mapX;
				this.y = curY = targetY = path[0].mapY;
				*/
			}
		
			}
		}
	
	}

}