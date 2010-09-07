package org.stylekit.css.value {
	
	/**
	* The Value class represents any value attached to a CSS property. There are several specialised value types such as ColorValue and URLValue,
	* but the basic Value class may be used to store basic string values for any property where a specialised Value type is not required.
	*/
	public class Value
	{
		
		protected var _rawValue:String;
		protected var _stringValue:String;
		protected var _important:Boolean = false;
		
		public function Value()
		{
			
		}
		
		public static function parse(str:String):Value
		{
			var val:Value = new Value();
				val.stringValue = str;
			return val;
		}
		
		public function get important():Boolean
		{
			return this._important;
		}
		
		public function set important(i:Boolean):void
		{
			this._important = i;
		}
		
		public function get stringValue():String
		{
			return this._stringValue;
		}
		
		public function set stringValue(s:String):void
		{
			this._stringValue = s;
		}

		public function set rawValue(s:String):void
		{
			this._rawValue = s;
		}
		
		public function isEquivalent(other:Value):Boolean
		{
			// type matches
			if (this === other)
			{
				return (this._rawValue == other._rawValue);
			}
			
			return false;
		}
	}
}