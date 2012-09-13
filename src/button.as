package {
	import flash.display.Sprite;
	import flash.events.Event;
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
		private const ACTIVE:int = 0;
		private const PASSIVE:int = 1;
		private const ROLLOVER:int = 2;
		private var sprite:Sprite = new Sprite();
		public static const BUILD:int = 0;
		public static const SOLDIER:int = 1;
		private var type:int;
		private var state:int=0;
		private var execCost:int;
		private var defaultPos:int = global.TOPMENU_HEIGHT + global.MAP_HEIGHT;
		private var buttonSize:int = 32;
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
			if (state != PASSIVE) { 
				state = ROLLOVER; update();
				addEventListener(Event.ENTER_FRAME, displayButton);
				
				}
			//trace("rolover");
		}
		internal function displayButton(e:Event):void {
			if (state == ROLLOVER && this.y>defaultPos-buttonSize) { this.y-=3;}
			if (state != ROLLOVER) { this.y++;
			if (this.y > defaultPos) { this.y = defaultPos;
				removeEventListener(Event.ENTER_FRAME, displayButton);
				}
			}
		}
		private function rollout(e:MouseEvent):void {
			//trace("rolover");
			if (state != ACTIVE) { state = 0; update();}
		}
		
		public function update() {
			//if(state==0){
			if (state == PASSIVE) { state = ACTIVE; }
			var tmp:int = 0;
			if (global.money <= execCost) { tmp++; }
			if (type == BUILD && global.ownBase != null && global.ownBase.builded) { state = 1;}
			if (type == SOLDIER ) {
				if(global.ownBase==null || !global.ownBase.builded){
								
				tmp++; //trace('nobase',global.ownBase); 
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
			if (type == BUILD && state==2){//нажатие на кнопку  строить базу
				
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
			
			if (type == SOLDIER && state == 2 ) {
			
			//global.ownBase.getPosition();
			//trace("position", global.ownBase.target_x, global.ownBase.target_y);
			var mariner = new soldier(global.ownBase.x, global.ownBase.y + global.TILE_HEIGHT * 1.5);// , global.ownBase.x + 10, global.ownBase.y + 10);
			if(mariner.setTarget(global.ownBase.x - 32, global.ownBase.y + global.TILE_HEIGHT * 1.5)){
			
			global.myArmy.push(mariner);
			global.uiMenu.layer1.addChild(mariner);
			global.money -= execCost;
			}else { mariner = null;}
			}//build
			
			
			}
		}
		
		
	}

}