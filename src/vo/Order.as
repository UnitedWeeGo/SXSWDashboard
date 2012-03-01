package vo
{
	import model.OrderModel;

	public class Order
	{
		private var _xml:XML;
		public var orderId:String;
		public var orderPlacedDate:Date;
		public var name:String;
		public var sandwiches:Array;
		public var chips:Array;
		public var drinks:Array;
		
		public function Order()
		{
			sandwiches = [];
			chips = [];
			drinks = [];
		}
		public function processXML(xml:XML):void
		{
			_xml = xml;
			orderId = xml.@orderId;
			
			var lastId:int = parseInt(OrderModel.getInstance().lastOrderId);
			var newId:int = parseInt(orderId);
			if (newId > lastId) OrderModel.getInstance().lastOrderId = newId.toString();
			
			orderPlacedDate = isoToDate(xml.@timestamp);
			name = xml.Customer.name[0];
			
			var sandwichList:XMLList = xml.MenuItem.(categoryFriendlyName=="Sandwiches");
			for (var a:int=0; a<sandwichList.length(); a++)
			{
				var sandXML:XML = sandwichList[a];
				var sandwich:Sandwich = new Sandwich();
				sandwich.name = sandXML.name;
				var optionsXMLList:XMLList = sandXML.MenuItemOption;
				var opts:String = '';
				for (var b:int=0; b<optionsXMLList.length(); b++)
				{
					var optsXML:XML = optionsXMLList[b];
					opts += optsXML.name + ( b < optionsXMLList.length()-1 ? ', ' : '' );
				}
				sandwich.options = opts;
				sandwiches.push(sandwich);
			}

			var chipsList:XMLList = xml.MenuItem.(categoryFriendlyName=="Sides");
			for (var c:int=0; c<chipsList.length(); c++)
			{
				var chipsXML:XML = chipsList[c];
				var chipsO:Chips = new Chips();
				chipsO.name = chipsXML.name;
				chips.push(chipsO);
			}
			
			var drinksList:XMLList = xml.MenuItem.(categoryFriendlyName=="Drinks");
			for (var d:int=0; d<drinksList.length(); d++)
			{
				var drinksXML:XML = drinksList[d];
				var drink:Drink = new Drink();
				drink.name = drinksXML.name;
				drinks.push(drink);
			}
		}
		private function isoToDate(value:String):Date {
			var dateStr:String = value;
			dateStr = dateStr.replace(/\-/g, "/");
			dateStr += " GMT-0000";
			return new Date(Date.parse(dateStr));
		}
		public function get friendlyTime():String
		{
			return getFormattedTime(STANDARD, orderPlacedDate);
		}
		
		
		
		private const STANDARD:uint = 12;
		private const MILITARY:uint = 24;
		
		private function getFormattedTime(timeFormat:uint, date:Date):String
		{
//			var date:Date = new Date();
			var hour:uint = date.getHours();
			var currentTime:String;
			var timeExtention:String;
			
			switch(timeFormat)
			{
				case 24:
					hour = (hour == 0) ? 12 : hour;
					timeExtention = "";
					break;
				case 12:
					if (hour > 12){
						hour = (hour == 12) ? 12 : hour - 12;
						timeExtention = "PM";
					}else{
						hour = (hour == 0) ? 12 : hour ;
						timeExtention = "AM";
					}
					break;
			}
			currentTime = hour.toString();
			currentTime += ":";
			currentTime += doubleDigitFormat( date.getMinutes() );
//			currentTime += ":";
//			currentTime += doubleDigitFormat( date.getSeconds() );
			currentTime += timeExtention;
			
			return currentTime;
		}
		
		private function doubleDigitFormat($num:uint):String
		{
			if ($num < 10)
			{
				return ("0" + $num);
			}
			return String($num);
		}
	}
}
/*
<Order orderId="576" timestamp="2012-02-29 03:05:15">
	<MenuItem itemPrice="0">
	  <name><![CDATA[Detention]]></name>
	  <categoryFriendlyName><![CDATA[Sandwiches]]></categoryFriendlyName>
	  <MenuItemOption addlCost="0">
		<name><![CDATA[Roast Beef]]></name>
	  </MenuItemOption>
	  <MenuItemOption addlCost="0">
		<name><![CDATA[Provolone]]></name>
	  </MenuItemOption>
	  <MenuItemOption addlCost="0">
		<name><![CDATA[Onions]]></name>
	  </MenuItemOption>
	  <MenuItemOption addlCost="0">
		<name><![CDATA[Red Peppers]]></name>
	  </MenuItemOption>
	  <MenuItemOption addlCost="0">
		<name><![CDATA[Green Peppers]]></name>
	  </MenuItemOption>
	  <MenuItemOption addlCost="0">
		<name><![CDATA[Mushroom]]></name>
	  </MenuItemOption>
	  <MenuItemOption addlCost="0">
		<name><![CDATA[Mayo]]></name>
	  </MenuItemOption>
	  <MenuItemOption addlCost="0">
		<name><![CDATA[Oil]]></name>
	  </MenuItemOption>
	  <MenuItemOption addlCost="0">
		<name><![CDATA[Vinegar]]></name>
	  </MenuItemOption>
	  <MenuItemOption addlCost="4">
		<name><![CDATA[Upgrade to 12 inch sandwich]]></name>
	  </MenuItemOption>
	</MenuItem>
	<MenuItem itemPrice="0.5">
	  <name><![CDATA[Jalapeno]]></name>
	  <categoryFriendlyName><![CDATA[Sides]]></categoryFriendlyName>
	</MenuItem>
	<MenuItem itemPrice="0">
	  <name><![CDATA[Dublin Dr. Pepper]]></name>
	  <categoryFriendlyName><![CDATA[Drinks]]></categoryFriendlyName>
	</MenuItem>
	<Customer>
	  <name><![CDATA[Nick]]></name>
	</Customer>
  </Order>
*/