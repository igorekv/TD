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
		public function enemyBase() 
		{
		
			//запускаем таймер первой волны  wave[0][0]
			waveTimer = new Timer(1000, global.levelInfo.wave[0][0].startTimer);// trace('start WaveTimer', global.levelInfo.wave[0][0].startTimer);
			global.time = global.levelInfo.wave[0][0].startTimer;
			waveTimer.start();
			waveTimer.addEventListener(TimerEvent.TIMER, waveTick);
			waveTimer.addEventListener(TimerEvent.TIMER_COMPLETE, waveStart);
			//запускаем таймер спавна wave[0][0]
			spawnTimer = new Timer(global.levelInfo.wave[0][0].startTimer*1000, 1);//trace('start spawnTimer', global.levelInfo.wave[0][0].startTimer);
			spawnTimer.start();
			spawnTimer.addEventListener(TimerEvent.TIMER, spawn);
			
			
		}
		
		private function waveTick(e:TimerEvent) {
			//trace(global.levelTime.currentCount);
			global.time--; 
		}
		
		private function waveStart(e:TimerEvent) {
			//считаем все секунды до конца + первое время следующей волны если она есть
			if(!Finish){
			var newTimer = global.levelInfo.wave[waveNumber][(global.levelInfo.wave[waveNumber].length - 2)].fullTime;
			if (waveNumber + 1 < global.levelInfo.wave.length) { newTimer += +global.levelInfo.wave[waveNumber + 1][0].fullTime; } else { global.lastWave = true; }
			waveTimer = new Timer(1000, newTimer); trace('new waveTimer', newTimer);
			global.time = newTimer;
			waveTimer.start();
			waveTimer.addEventListener(TimerEvent.TIMER, waveTick);
			waveTimer.addEventListener(TimerEvent.TIMER_COMPLETE, waveStart);
			}
			
			//trace('wave', newTimer);
			
		}
	
		private function spawn(e:TimerEvent) {
			
			//trace('spawn',global.levelTime.currentCount);
			//trace('spawn',counter,global.levelInfo.wave[counter][0],global.levelInfo.wave.length);
			//trace("[" + waveNumber + "][" + counter + "]");
			var dummy:enemy = new enemy(0, 150);
			global.foeArmy.push(dummy);
			global.uiMenu.layer1.addChild(dummy);
			
			trace('spawn',global.levelInfo.wave[waveNumber][counter].unitHealth);
			counter++;
			if (counter < global.levelInfo.wave[0].length-1) { 
			spawnTimer = new Timer(global.levelInfo.wave[waveNumber][counter].startTimer * 1000, 1); //trace('new spawnTimer', global.levelInfo.wave[waveNumber][counter].startTimer);
			spawnTimer.addEventListener(TimerEvent.TIMER, spawn);
			spawnTimer.start();
		
			}else {
			//trace("cond:",waveNumber + 1, global.levelInfo.wave.length);
				if(waveNumber+1<global.levelInfo.wave.length){
			waveNumber++; counter = 0;
			spawnTimer = new Timer(global.levelInfo.wave[waveNumber][counter].startTimer*1000, 1);//trace('new spawnTimer #', global.levelInfo.wave[waveNumber][counter].startTimer);
			spawnTimer.start();
			spawnTimer.addEventListener(TimerEvent.TIMER, spawn);
			
			}else { trace('finish'); Finish = true; }
			counter = 0;
			}
			
			
			
		}
		
	}

}