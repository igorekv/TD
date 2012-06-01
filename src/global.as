package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	/**
	 * ...
	 * @author igorek
	 */
	public class global 
	{
		private var loader:Loader; //загрузщик
		
		
		//библиотека картинок
		public static const FIRE:int = 0;
		public static const SMOKE:int = 2;
		public static var smoke:Bitmap = new Bitmap();
		public static var bulletBitmap:Bitmap = new Bitmap();
		public static var terrainBitmap:Bitmap = new Bitmap();
		public static const radian:Number = 180 / Math.PI;
		public static const degree:Number = Math.PI / 180;
		
		
		public static var loadQueue:int = 0;
		public static var loadStatus:int = 0;
		public function global() 
		{
		
			
			
			
		}
		
		public static function loadBitmap(path:String,dest:Bitmap):void {
		loadQueue++;
		var loader:Loader = new Loader();
		loader.load(new URLRequest(path)); //загрузка спрайтлиста	
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void { onLoadBitmapComplete(e, dest);})

		}
		
		public static function onLoadBitmapComplete(e:Event,dest:Bitmap):void
		{
			
			var bitmapdata:BitmapData = e.target.loader.content.bitmapData; //loader.content.bitmapData; //получаем данные о спрайтах	
			dest.bitmapData = bitmapdata;
			loadStatus++;
			
		}
		
		
		
		public static function getAngle(x:Number, y:Number):int
		{
			
			if (x != 0) { x = x / (Math.abs(x) + Math.abs(y)); }
			if (y != 0) { y = y / (Math.abs(x) + Math.abs(y)); }
			//if (x > 1) { x = 1; }
			//if (y > 1) { y = 1; }
			
			
			var frAngle:int;
			if (x > 0 && y > 0)
			{
				frAngle = Math.asin(y / (Math.sqrt(x * x + y * y))) * radian;
			}
			if (x <= 0 && y > 0)
			{
				frAngle = 0 - Math.asin(x / (Math.sqrt(x * x + y * y))) * radian + 90;
			}
			if (x <= 0 && y <= 0)
			{
				frAngle = 0 - Math.asin(y / (Math.sqrt(x * x + y * y))) * radian + 180;
			}
			if (x > 0 && y <= 0)
			{
				frAngle = Math.asin(x / (Math.sqrt(x * x + y * y))) * radian + 270;
			}
			//trace("Угол трения:", int(frAngle),"X:",x,y);
			return frAngle;
		}
		
	}

}