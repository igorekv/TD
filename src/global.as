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
		public static var smoke:Bitmap = new Bitmap();
		public static var bulletBitmap:Bitmap=new Bitmap();
		
		
		public static var loadQueue:int = 0;
		public static var loadStatus:int = 0;
		public function global() 
		{
		
			
			
			
		}
		
		public static function loadBitmap(path:String,dest:Bitmap) {
		loadQueue++;
		var loader:Loader = new Loader();
		loader.load(new URLRequest(path)); //загрузка спрайтлиста	
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event) { onLoadComplete(e, dest);
})

		}
		
		public static function onLoadComplete(e:Event,dest:Bitmap):void
		{
			trace('loadBitmap');
			var bitmapdata:BitmapData = e.target.loader.content.bitmapData; //loader.content.bitmapData; //получаем данные о спрайтах	
			dest.bitmapData = bitmapdata;
			loadStatus++;
			
		}
		
	}

}