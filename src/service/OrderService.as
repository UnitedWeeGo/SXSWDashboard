package service
{
	import events.ServiceEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.setInterval;
	
	import model.OrderModel;

	public class OrderService extends EventDispatcher
	{
		public static var instance:OrderService;
		
		public static function getInstance():OrderService
		{
			if( instance == null ) instance = new OrderService( new SingletonEnforcer() );
			return instance;
		}
		
		public function OrderService(e:SingletonEnforcer)
		{
			setInterval(getOrders, OrderModel.getInstance().refreshRateInSeconds * 1000);
		}
		
		public function getOrders():void
		{
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE, handleCallSuccess);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, orderCallFail);
			xmlLoader.load( new URLRequest(OrderModel.getInstance().endpoint + '/orders.php?orderId=' + OrderModel.getInstance().lastOrderId + '&instanceId=' + OrderModel.getInstance().instanceId) );
		}
		public function orderComplete(orderId:String):void
		{
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE, handleOrderCompleted);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, dispatchCallFail);
			xmlLoader.load( new URLRequest(OrderModel.getInstance().endpoint + '/ordercomplete.php?orderId=' + orderId + '&instanceId=' + OrderModel.getInstance().instanceId) );
		}
		
		private function handleOrderCompleted(event:Event):void
		{
			var xml:XML = new XML(event.target.data);
			
			if (xml.@result == '200')
			{
				OrderModel.getInstance().removeOrderWithId(xml.@id);
				var ev:ServiceEvent = new ServiceEvent(ServiceEvent.CALL_SUCCESS);
				dispatchEvent(ev);
			}
			else if (xml.@result == '300')
			{
				// ignore 
			}
		}
		
		private function handleCallSuccess(event:Event):void
		{
			var xml:XML = new XML(event.target.data);
			OrderModel.getInstance().processNewOrders(xml);
		}
		// Fail handlers
		private function dispatchCallFail(event:IOErrorEvent):void
		{
			var ev:ServiceEvent = new ServiceEvent(ServiceEvent.CALL_FAIL);
			dispatchEvent(ev);
		}
		private function orderCallFail(event:IOErrorEvent):void
		{
			trace('orderCallFail, do nothing it\'ll try again');
		}
	}
}

internal class SingletonEnforcer{}