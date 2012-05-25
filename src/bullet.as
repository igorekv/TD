package
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author igorek
	 */
	public class bullet extends Sprite
	{
		private const degree:Number = Math.PI / 180;
		private var tileWidth:int = 9; //ширина спрайта
		private var tileHeight:int = 9; //высота спрайта
		private var displayBitmapData:BitmapData = new BitmapData(tileWidth, tileHeight, true, 0xffffff); //данные спрайта на экране
		private var displayBitmap:Bitmap = new Bitmap(displayBitmapData); //картинка спрайта на экране
		private var BlitPoint:Point = new Point(0, 0); //точка начала копирования пикселей
		private var blitRect:Rectangle = new Rectangle(0, 0, tileWidth, tileHeight); //прямоугольник область копирования пикселей
		private var bulletType:int = 0;
		private var bulletAngle:int = 0;
		private var bulletSpeed:int = 3;
		private var bulletRange:int = 50;
		private var bulletDist:int = 0;
		private var ballisticY:Number = 0;
		private var ballisticOld:Number = 0;
		private var frame:int = 0;
		
		public function bullet(bType:int, bAngle:int)
		{
			this.bulletAngle = bAngle
			this.bulletType = bType;
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame); //событие на каждый кадр
			displayBitmap.x = -tileWidth / 2;
			displayBitmap.y = -tileHeight / 2;
			this.rotation = bulletAngle + 180;
			addChild(displayBitmap); //выводим обьект на экран
			
			updateSprite();	
		}
	
		
		private function onEnterFrame(e:Event):void
		{
			
			this.x += Math.cos(bulletAngle * degree) * bulletSpeed;
			if (bulletType == 2) {
				ballisticY = Math.sin((Math.PI / bulletRange) * bulletDist) * 80;
				
				this.y = this.y + ballisticOld + Math.sin(bulletAngle * degree) * bulletSpeed - ballisticY;
				ballisticOld = ballisticY;
			}else {
				this.y += Math.sin(bulletAngle * degree) * bulletSpeed;
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
			if (bulletRange == bulletDist)
			{
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				parent.removeChild(this);
				
			}
			bulletDist++;
		
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