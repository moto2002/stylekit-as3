package org.stylekit.css.style
{
	import flash.events.EventDispatcher;	
	import org.stylekit.css.StyleSheet;
	import org.stylekit.css.selector.MediaSelector;
	
	import org.stylekit.css.value.URLValue;
		
	/**
	* An Import encapsulates a single @import statement within an owning StyleSheet object.
	*/
	public class Import extends EventDispatcher
	{
		protected var _styleSheet:StyleSheet;
		protected var _styleInsertionIndex:uint;
		protected var _animationInsertionIndex:uint;
		protected var _fontFaceInsertionIndex:uint;
		
		/**
		* A reference to a <code>MediaSelector</code> object used to restrict this instance to a specific set of media types.
		*/ 
		protected var _mediaSelector:MediaSelector;
		
		/**
		* A the URLValue resulting from the parsed url('whatever.css') statement.
		*/
		protected var _urlValue:URLValue;
		
		/**
		* Instiates a new Import object within an owning <code>StyleSheet</code> instance.
		* @param styleInsertionIndex A <code>uint</code> indicating the index at which loaded styles should be injected into the parent StyleSheet.
		* @param animationInsertionIndex A <code>uint</code> indicating the index at which loaded @keyframe blocks should be injected into the parent StyleSheet.
		* @param fontFaceInsertionIndex A <code>uint</code> indicating the index at which loaded @font-face blocks should be injected into the parent StyleSheet.
		*/
		public function Import(ownerStyleSheet:StyleSheet, styleInsertionIndex:uint=0, animationInsertionIndex:uint=0, fontFaceInsertionIndex:uint=0) 
		{
			this._styleSheet = ownerStyleSheet;
			this._styleInsertionIndex = styleInsertionIndex;
			this._animationInsertionIndex = animationInsertionIndex;
			this._fontFaceInsertionIndex = fontFaceInsertionIndex;
		}
		
		public function get urlValue():URLValue
		{
			return this._urlValue;
		}
		
		public function set urlValue(u:URLValue):void
		{
			this._urlValue = u;
		}
		
		public function set mediaSelector(ms:MediaSelector):void
		{
			this._mediaSelector = ms;
		}
		
		public function get mediaSelector():MediaSelector
		{
			return this._mediaSelector;
		}
	}
}