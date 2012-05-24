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
		public static var test:Bitmap = new Bitmap();
		public static var bulletBitmap:Bitmap=new Bitmap();
		public function global() 
		{
		
			
			
			
		}
		
		public static function loadBitmap(path:String,dest:Bitmap) {
		var loader:Loader = new Loader();
		loader.load(new URLRequest(path)); //загрузка спрайтлиста	
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event) { onLoadComplete(e, dest);
})

		}
		
		public static function onLoadComplete(e:Event,dest:Bitmap):void
		{
			var bitmapdata:BitmapData = e.target.loader.content.bitmapData; //loader.content.bitmapData; //получаем данные о спрайтах	
			dest.bitmapData = bitmapdata;
			
		}
		
	}

}