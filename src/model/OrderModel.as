package model
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.collections.ArrayCollection;
	
	import vo.Order;

	public class OrderModel
	{
		private static var instance:OrderModel;
		private var _orders:ArrayCollection;
		private var _instanceId:String;
		private var _endpoint:String;
		private var _lastOrderId:String = '0';
		
		public function OrderModel( pvt:SingletonEnforcer )
		{
			orders = new ArrayCollection();
			loadConfig();
		}
		public static function getInstance():OrderModel
		{
			if( instance == null ) instance = new OrderModel( new SingletonEnforcer() );
			return instance;
		}
		private function loadConfig():void
		{
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE, processConfigXML);
			xmlLoader.load(new URLRequest("config/config.xml"));
		}
		
		private function processConfigXML(e:Event):void
		{
			var cXML:XML = new XML(e.target.data);
			
			_instanceId = cXML.@instanceId;
			_endpoint = cXML.@endpoint;
		}
		
		public function processNewOrders(xml:XML):void
		{
			var orderList:XMLList = xml.Order;
			for (var a:int=0; a<orderList.length(); a++)
			{
				var order:Order = new Order();
				order.processXML(orderList[a]);
				orders.addItem(order);
			}
		}
		
		public function removeOrderWithId(id:String):void
		{
			for (var i:int=0; i<orders.length; i++)
			{
				var order:Order = orders.getItemAt(i) as Order;
				if (id == order.orderId)
				{
					orders.removeItemAt(i);
					return;
				}
			}
		}
		
		[Bindable]
		public function get orders():ArrayCollection
		{
			return _orders;
		}

		public function set orders(value:ArrayCollection):void
		{
			_orders = value;
		}

		public function get instanceId():String
		{
			return _instanceId;
		}

		public function get endpoint():String
		{
			return _endpoint;
		}

		public function get lastOrderId():String
		{
			return _lastOrderId;
		}

		public function set lastOrderId(value:String):void
		{
			_lastOrderId = value;
		}


	}
}
internal class SingletonEnforcer{}