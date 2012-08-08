package  
{
	/**
	 * ...
	 * @author igorek
	 */
	public class waveElement 
	{
		public var startTimer:int = 0;
		public var unitLevel:int = 1;
		public var fullTime:int = 0;
		public var startPos:int = 0;
		public function waveElement(_timer:int,_health:int,_startPosition:int,_fullTime:int) 
		{
			startTimer = _timer;
			unitLevel = _health;
			fullTime = _fullTime;
			startPos = _startPosition;
			
		}

		
	}

}