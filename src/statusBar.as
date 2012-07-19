package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class statusBar extends Sprite
	{
		private var sprite:Sprite = new Sprite();
		private var maxLife:int;
		private var Width:int;
		public function statusBar(life:int = 100, ammo:int = 0,wdth:int=10):void
		{
			
			maxLife = life;
			Width = wdth + (life / 100);
			sprite.x = (wdth / 2) - (Width / 2);
			sprite.y = -10;
			addChild(sprite); 
			draw(life);
		}
		
		public function draw(_life:int):void
		{
				
				sprite.graphics.clear();
				sprite.graphics.beginFill(0x00FF00, 0.5);
				sprite.graphics.drawRect(0, 0, Width / (maxLife / _life), 3);
				sprite.graphics.endFill();
				sprite.graphics.beginFill(0xFF0000, 0.5);	
				sprite.graphics.drawRect(Width / (maxLife / _life), 0, Width - Width / (maxLife / _life), 3);
				sprite.graphics.endFill();
				sprite.graphics.beginFill(0x000000, 0);
				sprite.graphics.lineStyle(1, 0xFFFFFF, 0.5);
				sprite.graphics.drawRect(0, 0, Width, 3);
				sprite.graphics.endFill();
				
			
		}
	}

}