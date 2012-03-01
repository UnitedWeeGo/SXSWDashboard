package events
{
	import flash.events.Event;
	
	public class ServiceEvent extends Event
	{
		public static const CALL_FAIL:String = 'callFail';
		public static const CALL_SUCCESS:String = 'callSuccess';
		
		public var resultId:String;
		
		public function ServiceEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}