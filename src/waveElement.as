package  
{
	/**
	 * ...
	 * @author igorek
	 */
	public class waveElement 
	{
		public var startTimer:int = 0;
		public var unitHealth:int = 50;
		public var fullTime:int = 0;
		public function waveElement(_timer:int,_health:int,_fullTime:int) 
		{
			startTimer = _timer;
			unitHealth = _health;
			fullTime = _fullTime;
		}

		
	}

}