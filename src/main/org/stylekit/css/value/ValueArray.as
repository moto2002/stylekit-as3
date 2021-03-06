package org.stylekit.css.value
{
	import org.stylekit.css.parse.ValueParser;
	import org.stylekit.css.value.Value;
	import org.utilkit.util.StringUtil;
	
	/**
	* ValueArray describes a comma-seperated list of homogenous value types, for instance as specified by the "animation-iteration-count"
	* property, which may list several AnimationIterationCountValues as a comma-sep list.
	*/
	public class ValueArray extends Value
	{
		
		protected var _values:Vector.<Value>;
		protected var _valueClass:Class;
		
		public function ValueArray(valueClass:Class = null)
		{
			super();
			this._valueClass = valueClass;
			this._values = new Vector.<Value>();
		}
		
		public function get values():Vector.<Value>
		{
			return this._values;
		}
		
		public function set values(v:Vector.<Value>):void
		{
			this._values = v;
		}
		
		public static function parse(str:String, valueClass:Class = null):ValueArray
		{
			if(valueClass == null)
			{
				valueClass = Value;
			} 
			str = StringUtil.trim(str.toLowerCase());
			var val:ValueArray = new ValueArray();
				val._valueClass = valueClass;
				
				var tokens:Vector.<String> = ValueParser.parseCommaDelimitedString(str);
				for(var i:uint; i < tokens.length; i++)
				{
					val.values.push(valueClass.parse(tokens[i]));
				}
				
			return val;
		}
		
		public function andParse(str:String):void
		{
			str = StringUtil.trim(str.toLowerCase());
			if(this._valueClass == Value || this._valueClass.identify(str))
			{
				this._values.push(this._valueClass.parse(str));
			}
		}
		
		public function valueAt(index:uint):Value
		{
			if(this.values.length == 0)
			{
				return null;
			}
			else if(index > this.values.length-1)
			{
				return this.values[this.values.length-1];
			}
			else
			{
				return this.values[index];
			}
		}
		
		public static function identify(str:String):Boolean
		{
			return true; // all values are eligible
		}
		
		public override function isEquivalent(other:Value):Boolean
		{
			if(other is ValueArray)
			{
				var otherVal:ValueArray = (other as ValueArray); // AS3 precompiler won't work otherwise.aaaargh.
				for(var i:uint = 0; i < this.values.length; i++)
				{
					if(!this.valueAt(i).isEquivalent(otherVal.valueAt(i))) return false;
				}
				for(i=0; i < otherVal.values.length; i++)
				{
					if(!otherVal.valueAt(i).isEquivalent(this.valueAt(i))) return false;
				}
				return true;
			}
			return super.isEquivalent(other);
		}
	}
}