package
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	
	/**
	 * ...
	 * @author igorek
	 */
	public class bullet extends Sprite
	{
		
		private var tileWidth:int = 9; //ширина спрайта
		private var tileHeight:int = 9; //высота спрайта
		private var displayBitmapData:BitmapData = new BitmapData(tileWidth, tileHeight, true, 0xffffff); //данные спрайта на экране
		private var displayBitmap:Bitmap = new Bitmap(displayBitmapData); //картинка спрайта на экране
		private var BlitPoint:Point = new Point(0, 0); //точка начала копирования пикселей
		private var blitRect:Rectangle = new Rectangle(0, 0, tileWidth, tileHeight); //прямоугольник область копирования пикселей
		private var bulletType:int = 0;
		private var bulletAngle:int = 0;
		private var bulletSpeed:int = 5
		private var bulletRange:int = 60
		private var bulletDist:int =0
		private var ballisticY:Number = 0;
		private var ballisticOld:Number = 0;
		private var frame:int = 0;
		private var damage:int;
		private var hitTestBox:Shape = new Shape();
		public var toRemove:Boolean = false;
		private var enemyList:Array;
		private var dx:Number;
		private var dy:Number;
		private var mainTimer:Timer;
		
		public function bullet(bType:int, bAngle:int,dmg:int,dist:int,_enemyList:Array)
		{
			
			bulletRange = dist;
			hitTestBox.graphics.beginFill(0xFF0000,0);
			hitTestBox.graphics.drawRect(-2, -2, 4, 4);
			hitTestBox.graphics.endFill();
			addChild(hitTestBox);
			enemyList = _enemyList;
			this.damage = dmg;
			this.bulletAngle = bAngle
			this.bulletType = bType;
			mainTimer = new Timer(20);
			mainTimer.start();
			mainTimer.addEventListener(TimerEvent.TIMER, onEnterFrame); //событие на таймер
			displayBitmap.x = -tileWidth / 2;
			displayBitmap.y = -tileHeight / 2;
			this.rotation = bulletAngle + 180;
			addChild(displayBitmap); //выводим обьект на экран
			dx=Math.cos(bulletAngle * global.degree) * bulletSpeed;
			dy = Math.sin(bulletAngle * global.degree)* bulletSpeed;
			updateSprite();	
			
		}
	
		
		private function onEnterFrame(e:TimerEvent):void
		{
			
			this.x += dx;
			if (bulletType == 2) {
				ballisticY = Math.sin((Math.PI / bulletRange) * bulletDist) * 80;
				
				this.y = this.y + ballisticOld + dy  - ballisticY;
				
				this.rotation = global.getAngle( ballisticY - ballisticOld,Math.cos(bulletAngle * global.degree) * bulletSpeed)+90;
				//trace(global.getAngle(ballisticY-ballisticOld,1));
				ballisticOld = ballisticY;
			}else {
				this.y += dy;
			}
			
			
			switch(bulletType) {
				
			case 0:
			if (frame == 2){frame = 0;var Fire:fire = new fire(this.x, this.y, this.scaleX, bulletAngle, bulletSpeed,global.FIRE);parent.addChild(Fire);}
			break;
			case 1:
			break;
			case 2:
			if (frame == 2){frame = 0;var Fire:fire = new fire(this.x, this.y, this.scaleX, bulletAngle, bulletSpeed,global.SMOKE);parent.addChild(Fire);}
			break;
			}
			
			
			frame++;
			if (bulletRange/bulletSpeed == bulletDist)
			{
				prepareToDelete();
				//parent.removeChild(this);
				//trace('boom');
			}else{
			bulletDist++;
			
			checkHit();
		}
		}
		
		private function prepareToDelete() {
			mainTimer.stop();
			mainTimer.removeEventListener(TimerEvent.TIMER, onEnterFrame);
			toRemove = true;
		}
		
		private function checkHit():void {//проверка поподания
			//hitTestObject
			
			for (var i:int= 0; i < enemyList.length; i++)
				{
			if (enemyList[i]!=null && hitTestBox.hitTestObject(enemyList[i].sprite)) { 
				prepareToDelete(); //removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				//parent.removeChild(this);
				
				if(enemyList[i].toString()=='[object myBase]'){var fx:sfx = new sfx(sfx.SCRAP);}else{ var fx:sfx = new sfx(sfx.BLOOD);}
				fx.rotation = bulletAngle-180;
				fx.x = this.x; fx.y = this.y;
				global.uiMenu.layer1.addChild(fx);
				enemyList[i].hit(damage);
				break;
				}
				}
		}
		
		private function updateSprite():void
		{
			
			displayBitmapData.lock();
			blitRect.x = bulletType * tileWidth;
			blitRect.y = 0;
			
			displayBitmapData.copyPixels(global.bulletBitmap.bitmapData, blitRect, BlitPoint);
			displayBitmapData.unlock();
		}
	
	}

}