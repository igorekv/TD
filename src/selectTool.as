package  
{
	import flash.display.Shape;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author igorek
	 */
	public class selectTool extends Shape
	{
		private var mX:int;
		private var mY:int;
		public function selectTool(x:int,y:int):void 
		{
			mX = x; mY = y;
			this.graphics.lineStyle(1, 0x00FFDD, 0.5);
			this.graphics.beginFill(0x00FFDD,0.2);
			this.graphics.drawRect(mX, mY, 10, 10);
			this.graphics.endFill();
			
		}
		public function draw(x:int, y:int) :void{
			this.graphics.clear();
			this.graphics.lineStyle(1, 0x00FFDD, 0.5);
			this.graphics.beginFill(0x00FFDD,0.2);
			this.graphics.drawRect(mX, mY, x-mX, y-mY);
			this.graphics.endFill();
			
		}
		
		public function select(x:int, y:int):void {
			var len:int = global.myArmy.length;
		for (var i:int = 0; i < len; i++) {
			if (mX < global.myArmy[i].x && global.myArmy[i].x < x && mY < global.myArmy[i].y && global.myArmy[i].y < y ) { global.myArmy[i].select = true; };
			}
		}
	}

}