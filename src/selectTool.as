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
		private var nX:int;
		private var nY:int;
		public function selectTool(x:int,y:int):void 
		{
			mX = x; mY = y;
			this.graphics.lineStyle(1, 0x00FFDD, 0.5);
			this.graphics.beginFill(0x00FFDD,0.2);
			this.graphics.drawRect(mX, mY, 10, 10);
			this.graphics.endFill();
			
		}
		public function draw(x:int, y:int) :void{
			nX = x;
			nY = y;
			this.graphics.clear();
			this.graphics.lineStyle(1, 0x00FFDD, 0.5);
			this.graphics.beginFill(0x00FFDD,0.2);
			this.graphics.drawRect(mX, mY, x-mX, y-mY);
			this.graphics.endFill();
			
		}
		

		
		public function select(_x:int, _y:int):void {
			var len:int = global.myArmy.length;
			var tmp:int = 0;
			var selectedArray:Vector.<soldier> = new Vector.<soldier>;
			for (var i:int = 0; i < len; i++) {
			//if (mX < global.myArmy[i].x && global.myArmy[i].x < x && mY < global.myArmy[i].y && global.myArmy[i].y < y ) 
			if (this.hitTestObject(global.myArmy[i]))
			{ 
				//var curSolder:soldier = global.myArmy[i];
				//trace();
				//trace(global.destCalc(mX+Math.abs(mX-nX)/2, mY+Math.abs(mY-nY)/2,curSolder.x,curSolder.y,2));
				//if(tmp<global.UNIT_PER_SECTOR){global.myArmy[i].select = true; tmp++; }};
				
				if (global.myArmy[i].toString() != "[object myBase]") { selectedArray.push(global.myArmy[i]); }
			}
			}
			if(selectedArray.length>0){
			var	centerX:int = mX + Math.abs(mX - nX) / 2;
			var centerY:int = mY + Math.abs(mY - nY) / 2;
			for (var k:int = 0; k < 6; k++) 
			{
			var nearest:soldier = selectedArray[0]; var dest:int = 1000;
			for (var j:int = 0; j < selectedArray.length; j++) 
			{
				var tmpdest:int=global.destCalc(centerX, centerY, selectedArray[j].x, selectedArray[j].y, 2)
				if (tmpdest<dest && !selectedArray[j].select) { nearest = selectedArray[j];dest=tmpdest };
			}
			nearest.select = true;
			}
			}
			
		}
	}

}