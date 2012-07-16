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
		public var g:int;
		public var h:int;
		public var f:int;
		public var k:int;
		public var nodeName:String;
		public function node(_x:int,_y:int,_k:int) 
		{
			x = _x; y = _y;
			k = _k;
			nodeName = String(x) + "x" + String(y);
		}
		public function toString():String {
        return String(f) ;
		//return String(k) ;
		}
	
		}
	

}