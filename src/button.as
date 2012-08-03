package {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author igorek
	 */
	public class button extends Sprite {
		private var sprite:Sprite = new Sprite();
		public static const BUILD:int = 1;
		private var type:int;
		
		public function button(_type:int){
			type = _type;
			sprite.graphics.beginFill(0xAAAAFF, 0.5);
			sprite.graphics.drawRect(0, 0, 50, 80);
			sprite.graphics.endFill();
			addChild(sprite);
			addEventListener(MouseEvent.ROLL_OVER, rollover);
			addEventListener(MouseEvent.CLICK, click);
		}
		
		private function rollover(e:MouseEvent):void {
			trace("rolover");
		}
		
		private function click(e:MouseEvent):void {
			trace('click');
			if (type == BUILD){
				global.cleanSelection();
				if (global.gameMode() != global.MODE_BUILD) {
					global.ownBase = new myBase();
					global.uiMenu.layer1.addChild(global.ownBase);
					
					global.changeGameMode(global.MODE_BUILD);
				} else {
					global.uiMenu.layer1.removeChild(global.ownBase);
					global.ownBase = null;
					global.changeGameMode(global.MODE_GAME);
				}
			}//build
		}
	}

}