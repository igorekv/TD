package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author igorek
	 */
	public class soldier extends Sprite
	{
		private var state:int;

		private var sprite:Sprite = new Sprite();
		public var select:Boolean = false;
		private var targetX:int;
		private var targetY:int;
		private var curX:Number;
		private var curY:Number;
		private var rangeofFire:int = 100;//levelup?
		public var rateofFire:int = 5;//levelup
		private var fireTimer:int = rateofFire;
		private var targetEnemy:enemy;
		private var targetEnemyX:int=0;
		private var targetEnemyY:int = 0;
		private var damage:int = 10;
		
		
		public function soldier(x:int,y:int) 
		{
			this.x=curX = targetX = x; this.y=curY = targetY = y;
			
			this.addEventListener(Event.ENTER_FRAME, draw)	;
			sprite.graphics.beginFill(0x33cc33);
			sprite.graphics.drawRect(0, 0, 10, 10);
			sprite.graphics.endFill();
			sprite.x = -5; sprite.y = -5;
			addChild(sprite);
			addEventListener(MouseEvent.CLICK, onclick);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			
		}
		private function mouseDown(e:MouseEvent):void {
			global.startSelect = true;
			
			}
		public function draw(e:Event):void {//при выводе на экран
			sprite.graphics.clear();
		if (select) { sprite.graphics.lineStyle(2, 0xFF0033); }
			sprite.graphics.beginFill(0x33cc33);
			sprite.graphics.drawRect(0, 0, 10, 10);
			sprite.graphics.endFill();
			if(int(curX)!=targetX){
			var len:Number = destCalc(Math.abs(curX - targetX), Math.abs(curY - targetY));
			
			curX +=(targetX - curX) / len;
			curY+= (targetY - curY) / len;}
			this.x = curX; this.y = curY;
			checkFire();
			
		}
		private function destCalc(x:int, y:int):Number {
		return Math.sqrt((x*x) + (y *y));	
		}
		private function checkFire():void {
			if (fireTimer < 0) { fireTimer = rateofFire;
			//если цель в не зоны огня
			//if (global.tmp) { trace('после удаления',targetEnemy.toDelete); }
			if (targetEnemy != null) { if (destCalc(Math.abs(targetEnemy.x - this.x), Math.abs(targetEnemy.y - this.y)) > rangeofFire || targetEnemy.toDelete) { targetEnemy = null; }; }
			//выбираем цель если она не выбрана
			if (targetEnemy == null) { 
			var dest:Number = 0; var minDest:Number = rangeofFire;	
			for (var i:int= 0; i < global.foeArmy.length; i++)
				{
					dest = destCalc(Math.abs(global.foeArmy[i].x - this.x), Math.abs(global.foeArmy[i].y - this.y));
					
					if (dest <rangeofFire && dest<minDest)
					{
						minDest = dest; targetEnemy = global.foeArmy[i];
						/**/
						
						
					}
					
				}
				
				if (targetEnemy != null) {  targetEnemyX = targetEnemy.x; targetEnemyY = targetEnemy.y; }
			}
			
			if (targetEnemy != null ) {//если есть цель то можно стрелять
				if (targetEnemyX != targetEnemy.x) { 
				
				var dX:int = (targetEnemyX - targetEnemy.x);
				var dY:int = (targetEnemyY - targetEnemy.y);
				var dst:int = destCalc(this.x - targetEnemy.x, this.y - targetEnemy.y)/19;// 20 - скорости пули на скорость движения / скорости стрельбы
				targetEnemyX = targetEnemy.x;
				targetEnemyY = targetEnemy.y;
					var ang:int = getAngle(this.x-targetEnemy.x+(dX*dst), this.y-targetEnemy.y+(dY*dst));
						var sprt:bullet = new bullet(1, ang+Math.random()*2,damage,rangeofFire);
						sprt.x = this.x;
						sprt.y = this.y;
						parent.addChild(sprt);
						global.stat_bulletCount++;
				}
				
				}//конец стрельбы
			}
			fireTimer--;
			
		}
		
		
		private function getAngle(x:int, y:int):int {
			return Math.atan2(y,x)*global.radian+180;
		}
		
		
		private function onclick(e:MouseEvent):void {
			trace('click');
			global.startSelect = false;
			var len:int = global.myArmy.length; for (var i:int = 0; i < len; i++) { if (global.myArmy[i].select) { global.myArmy[i].select = false; }; } //очищаем выделение
			if (select) { select = false;}else{ select = true;}
		}
		
		public function setTarget(x:int, y:int):void {
			
			targetX = x-(global.spread/2)+Math.random()*global.spread; targetY = y-(global.spread/2)+Math.random()*global.spread;
			
			
		}
	
		
	}

}