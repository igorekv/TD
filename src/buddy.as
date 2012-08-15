package  
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author igorek
	 */
	public class buddy extends Sprite
	{
		
		internal var statBar:statusBar;
		internal var targetEnemy:buddy;//ссылка на цель
		internal var targetEnemyX:int=0;//координаты цели
		internal var targetEnemyY:int = 0;
		public var oldX:int = 0;
		public var oldY:int = 0;
		//изменяемые параметры
		public var life:int = 100;
		internal var rangeofFire:int = 100;//levelup?
		internal var rateofFire:int = 5;//levelup
		internal var damage:int = 10;
		internal var speed:int = 10;
		
		internal var fireTimer:int = rateofFire;
		public var toDelete:Boolean = false;
		public var toRemove:Boolean = false;
		public var sprite:Sprite = new Sprite();//выводимый спрайт(в будущем битмап
		internal var intTimer:int = 0;
		internal var mainTimer:Timer;
		public function buddy() 
		{
			
			
			
		}
		
		
		
		internal function getAngle(x:int, y:int):int {
			return Math.atan2(y,x)*global.radian+180;
		}
		
		internal function destCalc(x:int, y:int):Number {
		return Math.sqrt((x*x) + (y *y));	
		}
		
		internal function checkFire(enemyList:Array):void {
			
			if (fireTimer < 0) { fireTimer = rateofFire;
			//если цель в не зоны огня
			//if (global.tmp) { trace('после удаления',targetEnemy.toDelete); }
			
			if (targetEnemy != null) { if (global.destCalc(targetEnemy.x,targetEnemy.y ,this.x, this.y,1) > rangeofFire+10 || targetEnemy.toDelete) {
				if (enemyList == global.myArmy) { trace("сброс цели");}
				targetEnemy = null; }; }
			//выбираем цель если она не выбрана
			if (targetEnemy == null) { 
			
				
			var dest:Number = 0; var minDest:Number = rangeofFire+(rangeofFire/10);	
			for (var i:int= 0; i < enemyList.length; i++)
				{
					
					var dstx:int = Math.abs(enemyList[i].x - this.x);
					var dsty:int = Math.abs(enemyList[i].y - this.y);
					if (dstx > dsty) { dest = 1.4 * dsty + (dstx - dsty);}else{dest = 1.4 * dstx + (dsty - dstx);}
					
					//dest = destCalc(dstx,dsty );
					
					if (dest <rangeofFire+(rangeofFire/10) && dest<minDest)
					{
						
						if (!enemyList[i].toDelete) {
	
							minDest = dest; targetEnemy = enemyList[i];}
						/**/
						
						
					}
					
				}
				
				
				if (targetEnemy != null) {  targetEnemyX = targetEnemy.x; targetEnemyY = targetEnemy.y; }
			}
			
			
			if (targetEnemy != null) {
				
				var dstx:int = Math.abs(targetEnemy.x - this.x);
				var dsty:int = Math.abs(targetEnemy.y - this.y);
				if(destCalc(dstx,dsty )<rangeofFire){ //если есть цель то можно стрелять
				
				//if (targetEnemyX != targetEnemy.x) { 
				
				//var dX:int = (targetEnemyX - targetEnemy.x);
				//var dY:int = (targetEnemyY - targetEnemy.y);
				var dX:int = (targetEnemy.oldX - targetEnemy.x);
				var dY:int = (targetEnemy.oldY - targetEnemy.y);
				
				var dst:int = destCalc(this.x - targetEnemy.x, this.y - targetEnemy.y)/5;// 20 - скорости пули на скорость движения / скорости стрельбы
				targetEnemyX = targetEnemy.x;
				targetEnemyY = targetEnemy.y;
					var ang:int = getAngle(this.x-targetEnemy.x+(dX*dst), this.y-targetEnemy.y+(dY*dst));
						var sprt:bullet = new bullet(1, ang+Math.random()*2,damage,rangeofFire,enemyList);
						sprt.x = this.x;
						sprt.y = this.y;
						
						global.magazine.push(sprt);
						//trace(global.magazine.length);
						//trace(parent.name);
						
						global.uiMenu.layer1.addChild(sprt);
						global.stat_bulletCount++;
						//if(global.foeArmy == enemyList){trace('цель',targetEnemy)}
				//}
			}
			//else{targetEnemyX = targetEnemy.x;
			//targetEnemyY = targetEnemy.y;}
				}//конец стрельбы
			}
			fireTimer--;
			
		}
		
		
		
		
	}

}