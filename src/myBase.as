package  
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author igorek
	 */
	public class myBase extends Sprite
	{
		private var sprite:Sprite;
		public var builded:Boolean = false;
		public var target_x:int;
		public var target_y:int;
		public var health:int = 100;
		private var cnter:int = 0;
		public function myBase() 
		{
			sprite = new Sprite();	
			sprite.graphics.beginFill(0x00FF00, 0.2);
				sprite.graphics.drawRect(0, 0, global.SECTOR_WIDTH , global.SECTOR_HEIGHT);
				sprite.graphics.endFill();
				addChild(sprite);
		}
		
		public function build():void {
			builded = true;
			changeNodes(true);
			getPosition();
			//target_x = int((this.x+(this.width/2)) / global.TILE_WIDTH);
			//target_y = int((this.y +(this.height / 2)) / global.TILE_HEIGHT);
			
		}
		
		private function changeNodes(setup:Boolean):void {
			for (var i:int = 0; i < global.NODES_PER_SECTOR; i++) {
				for (var j:int = 0; j < global.NODES_PER_SECTOR; j++) {
				if (setup) { global.nodes[i+x/global.TILE_WIDTH][j+y/global.TILE_HEIGHT].k += 100;}else{global.nodes[i][j].k -= 100}
				}
			}
			
			
		}
		
		public function getPosition():void {
			cnter++;
			var angle:int = Math.random()*360;
			
			target_x=(x+8+global.SECTOR_WIDTH/2+(Math.cos((angle +90)* global.degree) * global.SECTOR_WIDTH*1))/global.TILE_WIDTH;
			target_y=(y+8+global.SECTOR_HEIGHT/2+(Math.sin((angle+90) * global.degree) * global.SECTOR_HEIGHT*1))/global.TILE_HEIGHT;
			//if (cnter == 10) { builded = false; global.foeBase.findNewPath();}
			
		}
		
	}

}