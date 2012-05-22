package  
{
	import flash.display.*;
	import flash.geom.*;
	import flash.events.Event;
	import flash.display.Shape;
	/**
	 * ...
	 * @author igorek
	 */
	public class fire extends Sprite
	{
		private var frame:int = 0;
		public function fire() 
		{
			var fillType:String = GradientType.RADIAL;
			var colors:Array = [0xffff00, 0xffff00];
			var alphas:Array = [1, 0];
			var ratios:Array = [0, 255];
			var matrix:Matrix = new Matrix();
			//var gradRotation:Number = 90 / 180 * Math.PI;
			matrix.createGradientBox(10, 10, 0, 0, 0);
			var spreadMethod:String = SpreadMethod.PAD;

				var spark:Shape = new Shape();	
				this.graphics.beginGradientFill(fillType, colors, alphas, ratios, matrix, spreadMethod);
				this.graphics.drawRect(0,0,10,10);
				this.graphics.endFill();
			this.x = -1+Math.random() * 3;
			this.y = -1 + Math.random() * 3;
			this.alpha = 0.5 + (Math.random() / 2);
			this.scaleX = this.scaleY = Math.random();
			//addChild(this);
			
 
			addEventListener(Event.ENTER_FRAME, onEnterFrame); //событие на каждый кадр
		}
		
		private function onEnterFrame(e:Event):void {
			
			if (frame < 5) {
				this.x += 1;
				this.scaleX += (this.scaleX / 10);
				
			}else {
				this.x += 1;
				var colorInfo:ColorTransform = this.transform.colorTransform;
				colorInfo.color = colorInfo.color - 0x001100; 
				colorInfo.alphaOffset = -12*(frame-5);
				this.transform.colorTransform = colorInfo; 
			}
			frame++;
			if (frame > 30) { this.removeEventListener(Event.ENTER_FRAME, onEnterFrame); parent.removeChild(this); }
		}
		
		
		
	}

}