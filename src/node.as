package
{
	
	/**
	 * ...
	 * @author igorek
	 */
	public class node
	{
		public var x:int;
		public var y:int;
		public var mapX:int;
		public var mapY:int;
		public var parentNode:node;
		public var g:int=0;
		public var h:int=0;
		public var f:int=0;
		public var k:int=0;
		public var nodeName:String;
		private var count:int;
		private var full:Vector.<int> = new Vector.<int>();
		private var stack:Vector.<int> = new Vector.<int>(global.UNIT_PER_SECTOR);
		public function node(_x:int, _y:int, _k:int = 0)
		{
			x = _x;
				y = _y;
			k = _k;
			nodeName = String(x) + "x" + String(y);
		}
		
		public function toString():String
		{
			return String(f);
			//return String(k) ;
		}
		public function leave(slot:int):void {
			count--;
			stack[slot] = 0;
		}
		public function copy():node {
			var cpy:node = new node(this.x, this.y, this.k);
			return cpy;
		}
		public function checkSpace():Boolean
		{
			if (count < global.UNIT_PER_SECTOR)
			{
				return true;
			}
			else
			{
				return false
			}
		
		}
		
		public function getPosition():Vector.<int> {
			if (checkSpace()) { count++; 
			var slot:int = stack.indexOf(0); stack[slot] = 1;
			var angle:int = 360 / global.UNIT_PER_SECTOR * slot;
			var coord:Vector.<int> = new Vector.<int>();
			coord.push(x*global.SECTOR_WIDTH+global.SECTOR_WIDTH/2+(Math.cos((angle +90)* global.degree) * global.SECTOR_WIDTH*0.3));
			coord.push(y*global.SECTOR_WIDTH+global.SECTOR_HEIGHT/2+(Math.sin((angle+90) * global.degree) * global.SECTOR_HEIGHT*0.3));
			coord.push(slot);
			return coord;
			} else { return full };
			}
	
	}

}