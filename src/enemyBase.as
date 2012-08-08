package  
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author igorek
	 */
	
	
	public class enemyBase extends Sprite
	{
		private var spawnTimer:Timer;
		private var waveTimer:Timer;
		private var counter:int=0;
		private var waveNumber:int = 0;
		private var Finish:Boolean = false;
		private var tick:int = 100;
		private var ms:int= 10;
		public function enemyBase() 
		{
		
			//запускаем таймер первой волны  wave[0][0]
			waveTimer = new Timer(1000, global.levelInfo.wave[0][0].startTimer/ms);// trace('start WaveTimer', global.levelInfo.wave[0][0].startTimer);
			global.time = global.levelInfo.wave[0][0].startTimer/ms;
			waveTimer.start();
			waveTimer.addEventListener(TimerEvent.TIMER, waveTick);
			waveTimer.addEventListener(TimerEvent.TIMER_COMPLETE, waveStart);	
			//запускаем таймер спавна wave[0][0]
			spawnTimer = new Timer(global.levelInfo.wave[0][0].startTimer*tick, 1);//trace('start spawnTimer', global.levelInfo.wave[0][0].startTimer);
			spawnTimer.start();
			spawnTimer.addEventListener(TimerEvent.TIMER, spawn);
			
			
		}
		
		private function spawn(e:TimerEvent):void {
			
			var dummy:enemy = new enemy(0,global.levelInfo.wave[waveNumber][counter].startPos, global.levelInfo.wave[waveNumber][counter].unitLevel);
			global.foeArmy.push(dummy);
			global.uiMenu.layer1.addChild(dummy);
			
			//trace('spawn',global.levelInfo.wave[waveNumber][counter].unitHealth);
			counter++;
			if (counter < global.levelInfo.wave[waveNumber].length) { 
			spawnTimer = new Timer(global.levelInfo.wave[waveNumber][counter].startTimer * tick, 1); //trace('new spawnTimer', global.levelInfo.wave[waveNumber][counter].startTimer);
			spawnTimer.addEventListener(TimerEvent.TIMER, spawn);
			spawnTimer.start();
		
			}else {
			//trace("cond:",waveNumber + 1, global.levelInfo.wave.length);
				if(waveNumber+1<global.levelInfo.wave.length){
			waveNumber++; counter = 0;
			spawnTimer = new Timer(global.levelInfo.wave[waveNumber][counter].startTimer*tick, 1);//trace('new spawnTimer #', global.levelInfo.wave[waveNumber][counter].startTimer);
			spawnTimer.addEventListener(TimerEvent.TIMER, spawn);
			spawnTimer.start();
			}else { Finish = true; }
			counter = 0;
			}
			
			
			
		}
		
		
		
		private function waveTick(e:TimerEvent):void {
			//trace(global.levelTime.currentCount);
			global.time--; 
		}
		
		private function waveStart(e:TimerEvent):void {
			//считаем все секунды до конца + первое время следующей волны если она есть
			if(!Finish){
			var newTimer:int = global.levelInfo.wave[waveNumber][(global.levelInfo.wave[waveNumber].length - 1)].fullTime;
			if (waveNumber + 1 < global.levelInfo.wave.length) { newTimer += +global.levelInfo.wave[waveNumber + 1][0].fullTime; } else { global.lastWave = true; }
			waveTimer = new Timer(1000, newTimer/ms); 
			global.time = newTimer/ms;
			waveTimer.start();
			waveTimer.addEventListener(TimerEvent.TIMER, waveTick);
			waveTimer.addEventListener(TimerEvent.TIMER_COMPLETE, waveStart);
			}
			
			//trace('wave', newTimer);
			
		}
	
		
		
		public function findNewPath() {
			//trace(global.foeArmy.length);
			for (var i = 0; i < global.foeArmy.length;i++ ) {
				
				global.foeArmy[i].findNewPath();
			
				}
			
		}
		
	}

}