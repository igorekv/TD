package {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author igorek
	 */
	public class button extends Sprite {
		private var tileWidth:int = 50; //ширина спрайта
		private var tileHeight:int = 80; //высота спрайта
		private var displayBitmapData:BitmapData = new BitmapData(tileWidth, tileHeight, true, 0xffffff); //данные спрайта на экране
		private var displayBitmap:Bitmap = new Bitmap(displayBitmapData); //картинка спрайта на экране
		private var BlitPoint:Point = new Point(0, 0); //точка начала копирования пикселей
		private var blitRect:Rectangle = new Rectangle(0, 0, tileWidth, tileHeight); //прямоугольник область копирования пикселей
		
		private var sprite:Sprite = new Sprite();
		public static const BUILD:int = 0;
		public static const SOLDIER:int = 1;
		private var type:int;
		private var state:int=0;
		private var execCost:int;
		//state active passive roll down
		public function button(_type:int,_cost:int=0){
			type = _type;
			execCost = _cost;
			/*sprite.graphics.beginFill(0xAAAAFF, 0.5);
			sprite.graphics.drawRect(0, 0, 50, 80);
			sprite.graphics.endFill();
			addChild(sprite);
			*/
			update();
			addChild(displayBitmap);
			addEventListener(MouseEvent.ROLL_OVER, rollover);
			addEventListener(MouseEvent.CLICK, click);
			addEventListener(MouseEvent.ROLL_OUT, rollout);
			}
		
		private function rollover(e:MouseEvent):void {
			if (state != 2) { state = 2; update();}
			//trace("rolover");
		}
		
		private function rollout(e:MouseEvent):void {
			//trace("rolover");
			if (state != 0) { state = 0; update();}
		}
		
		public function update() {
			//if(state==0){
			if (state == 1) { state = 0; }
			var tmp:int = 0;
			if (global.money <= execCost) { tmp++; }
			if (type == SOLDIER ) {
				if(global.ownBase==null || !global.ownBase.builded){
								
				tmp++; trace('nobase' ); 
				}
				}
				
			if (tmp != 0) { state = 1 };
			//}
			displayBitmapData.lock();
			blitRect.x = state * tileWidth;
			blitRect.y = type*tileHeight;
			
			displayBitmapData.copyPixels(global.buttonBitmap.bitmapData, blitRect, BlitPoint);
			displayBitmapData.unlock();
			
		}
		
		private function click(e:MouseEvent):void {
			//trace('click');
			global.cleanSelection();
			if(global.money>=execCost){
			if (type == BUILD){
				
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
			
			if (type == SOLDIER){
			global.money -= execCost;
			global.ownBase.getPosition();
			//trace("position", global.ownBase.target_x, global.ownBase.target_y);
			var mariner = new soldier(global.ownBase.x+global.TILE_WIDTH+8, global.ownBase.y+global.TILE_HEIGHT*3,global.ownBase.x+10,global.ownBase.y+10);
			global.myArmy.push(mariner);
			global.uiMenu.layer1.addChild(mariner);
			}//build
			
			
			}
		}
		
		
	}

}