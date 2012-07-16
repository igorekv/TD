package  
{
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.events.Event;
	/**
	 * ...
	 * @author igorek
	 */
	public class screenManger
	{
		private var mainScreen:Stage;
		private var loadingTxt:TextField = new TextField();
		private var loadingTmp:int = 0;
		private var LOADINGSTATE:Boolean = false;
		private var GAMESTATE:Boolean = false;
		private var TESTSTATE:Boolean = false;
		public function screenManger(stage:Stage) 
		{
			trace('screenManager init');
			mainScreen = stage;
		}
		
		
		public function loading():void {//формируем экран и вешаем событие на каждый кадр
			clearScreen();
			LOADINGSTATE = true;
			loadingTxt.y = Math.random() * 100;
			loadingTxt.text = "loading..." + String(loadingTmp);
			mainScreen.addChild(loadingTxt);
			mainScreen.addEventListener(Event.ENTER_FRAME, loadingDraw);
			}
		public static function loadingDraw(e:Event):void {
				trace('draw');
			}
			
			
	
			public function game():void {
				clearScreen();
				GAMESTATE = true;
				
			}
			
			public function test():void {
				clearScreen();
				TESTSTATE = true;
			}
			
	
			private function clearScreen() {
				if (LOADINGSTATE) {
					LOADINGSTATE = false;
					mainScreen.removeChild(loadingTxt)
					mainScreen.removeEventListener(Event.ENTER_FRAME, loadingDraw);
				}
				if (GAMESTATE) {
					GAMESTATE = false;
					}
				if (TESTSTATE) {
					TESTSTATE = false;
				}
					
			}
			
			
		}
	

}