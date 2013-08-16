package customEvents 
{
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Solveig Hansen
	 */
	public class MenuEvent extends Event 
	{
		public static const BUTTON_CLICK:String = "buttonClick";
		public var params:Object;
		
		public function MenuEvent(type:String, prmz:Object = null, bubbles:Boolean = false) 
		{
			super(type, bubbles);
			
			this.params = prmz;
			
		}
		
	}

}