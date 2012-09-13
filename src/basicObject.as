package  
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author igorek
	 */
	public class basicObject extends Sprite
	{
		public var select:Boolean = false;//флаг выбран/невыбран
		public var toDelete:Boolean = false;
		public var toRemove:Boolean = false;
		public var sprite:Sprite = new Sprite();//выводимый спрайт(в будущем битмап
		public var oldX:int = 0;
		public var oldY:int = 0;
		public var life:int = 100;
		public function basicObject() 
		{
			
		}
		
		
		
	}

}