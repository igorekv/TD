package  
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class buddy extends basicObject
	{
		internal const STAY:int = 0;
		internal const WALK:int = 1;
		internal const FIRE:int = 2;
		internal var state:int;//состояние
		internal var oldState:int= 0;
		internal var statBar:statusBar;
		internal var targetEnemy:basicObject;//ссылка на цель
		//internal var targetEnemy:buddy;//ссылка на цель
		internal var targetEnemyX:int=0;//координаты цели
		internal var targetEnemyY:int = 0;
		
		//изменяемые параметры
		
		internal var rangeofFire:int = 100;//levelup?
		internal var rateofFire:int = 5;//levelup
		internal var damage:int = 10;
		internal var speed:int = 10;
		
		internal var fireTimer:int = rateofFire;
		internal var step:int=0;
		
		internal var intTimer:int = 0;
		internal var mainTimer:Timer;
		
		internal var animationTimer:Timer;
		internal var animationSpeed:int = 1;
		internal var currentFrame:int = 0;
		internal var row:int = 0;
		internal var totalFrames:int = 8;
		internal var displayBitmapData:BitmapData; //данныеспрайа на экране
		internal var displayBitmap:Bitmap ; //картинка спрайта на экране
		internal var BlitPoint:Point = new Point(0, 0); //точка начала копирования пикселей
		internal var blitRect:Rectangle////прямоугольник область копирования пикселей
		internal var tileWidth:int = 22;
		internal var tileHeight:int = 16;
		internal var texture:Bitmap;
		
		public function buddy() 
		{
			
			
			
		}
		
		internal function changeState(newState:int):int {
			oldState = state;
			state = newState;
			return state;
			
		}
		internal function animateSprite(e:TimerEvent=null):void {
			trace('upd');
			if(step==0){step=1}else{step=0}
			displayBitmapData.lock();
			blitRect.x = currentFrame * tileWidth;
			blitRect.y = 0;
			
			displayBitmapData.copyPixels(texture.bitmapData, blitRect, BlitPoint);
			displayBitmapData.unlock();
			//currentFrame++;
			//if (currentFrame > totalFrames) { currentFrame = 0 };
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
				
				
				//if (global.ownBase && global.ownBase.builded) { }
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
				var dY:int = (targetEnemy.oldY - targetEnemy.y);;
				
				var dst:int = destCalc(this.x - targetEnemy.x, this.y - targetEnemy.y)/5;// 20 - скорости пули на скорость движения / скорости стрельбы
				targetEnemyX = targetEnemy.x;
				targetEnemyY = targetEnemy.y;
					var ang:int = getAngle(this.x-targetEnemy.x+(dX*dst), this.y-targetEnemy.y+(dY*dst));
					if(targetEnemy.toString()=='[object myBase]'){ang=getAngle(this.x-(targetEnemy.x+global.HALF_SECTOR), this.y-(targetEnemy.y+global.HALF_SECTOR));}	;
					var sprt:bullet = new bullet(1, ang+Math.random()*2,damage,rangeofFire,enemyList);
						sprt.x = this.x+8;
						sprt.y = this.y+8;
						
						var testfx:sfx = new sfx(sfx.SHOT);
						
						displayFlame(testfx, ang);
						
						global.uiMenu.layer1.addChild(testfx);
						if (ang > 180) { global.uiMenu.layer1.swapChildren(this, testfx);}
						global.magazine.push(sprt);
						
						global.uiMenu.layer1.addChild(sprt);
						global.stat_bulletCount++;
					}
				}//конец стрельбы
			}
			fireTimer--;
			
		}
		
		private function displayFlame(flame:sfx, angle:int) {
			flame.rotation = angle-180;
			angle=angle-180;
			var dx:int = 0; var dy:int = 0;
			dx = Math.abs(angle / 12);
			if (angle > 0) { dy = Math.abs(angle / 90); } else { dy = 0 - Math.abs(angle / 90);}
			
			//trace(dx, dy);
			flame.x = this.x+dx;
			flame.y = this.y+8+dy;
			
		}
		
		
	}

}