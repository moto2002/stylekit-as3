package org.stylekit.ui.element
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	
	import org.stylekit.css.StyleSheet;
	import org.stylekit.css.StyleSheetCollection;
	import org.stylekit.css.selector.ElementSelector;
	import org.stylekit.css.selector.ElementSelectorChain;
	import org.stylekit.css.style.Style;
	import org.stylekit.events.StyleSheetEvent;
	import org.stylekit.events.UIElementEvent;
	import org.stylekit.ui.BaseUI;
	
	/**
	 * Dispatched when the effective dimensions are changed on the UI element.
	 *
	 * @eventType org.stylekit.events.UIElementEvent.EFFECTIVE_DIMENSIONS_CHANGED
	 */
	[Event(name="uiElementEffectiveDimensionsChanged", type="org.stylekit.events.UIElementEvent")]
	
	public class UIElement extends Sprite
	{
		protected var _children:Vector.<UIElement>;
		protected var _styles:Vector.<Style>;
		
		protected var _styleEligible:Boolean = false;
		
		protected var _effectiveWidth:int;
		protected var _effectiveHeight:int;
		protected var _contentWidth:int;
		protected var _contentHeight:int;

		protected var _parentIndex:uint = 0;
		protected var _parentElement:UIElement;
		
		protected var _baseUI:BaseUI;
		protected var _localStyle:Style;
		
		protected var _elementName:String;
		protected var _elementId:String;
		
		protected var _elementClassNames:Vector.<String>;
		protected var _elementPseudoClasses:Vector.<String>;
		
		public function UIElement()
		{
			super();
			
			this._children = new Vector.<UIElement>();
			
			this._elementClassNames = new Vector.<String>();
			this._elementPseudoClasses = new Vector.<String>();
			
			if (this.baseUI != null)
			{
				this.baseUI.styleSheetCollection.addEventListener(StyleSheetEvent.STYLESHEET_MODIFIED, this.onStyleSheetModified);
			}
		}
		
		public function get parentElement():UIElement
		{
			return this._parentElement;
		}
		
		public function set parentElement(parent:UIElement):void
		{
			this._parentElement = parent;
		}
		
		public function get baseUI():BaseUI
		{
			return this._baseUI;
		}
		
		public function get localStyle():Style
		{
			return this._localStyle;
		}
		
		public function get styleEligible():Boolean
		{
			return this._styleEligible;
		}
		
		public function set styleEligible(styleEligible:Boolean):void
		{
			this._styleEligible = styleEligible;
		}
		
		public function get effectiveWidth():int
		{
			return this._effectiveWidth;
		}
		
		public function get effectiveHeight():int
		{
			return this._effectiveHeight;
		}
		
		public function get contentWidth():int
		{
			return this._contentWidth;
		}
		
		public function get contentHeight():int
		{
			return this._contentHeight;
		}
		
		public function get children():Vector.<UIElement>
		{
			return this._children;
		}
		
		public override function get numChildren():int
		{
			return this._children.length;
		}
		
		public function get firstChild():UIElement
		{
			if (this._children.length >= 1)
			{
				return this._children[0];
			}
			
			return null;
		}
		
		public function get lastChild():UIElement
		{
			if (this._children.length >= 1)
			{
				return this._children[this._children.length - 1];
			}
			
			return null;
		}
		
		public function get styleParent():UIElement
		{
			if(this.parentElement == null)
			{
				return null;
			}
			
			if (this.parentElement.styleEligible)
			{
				return this.parentElement;
			}
			
			return this.parentElement.styleParent;
		}
		
		public function get elementName():String
		{
			return this._elementName;
		}
		
		public function set elementName(elementName:String):void
		{
			this._elementName = elementName;
			
			this.updateStyles();
		}
		
		public function get elementId():String
		{
			return this._elementId;
		}
		
		public function get isFirstChild():Boolean
		{
			return (this.parentIndex == 0);
		}
		
		public function get isLastChild():Boolean
		{
			return (this.parentIndex == this.parent.numChildren);
		}
		
		public function get parentIndex():uint
		{
			return this._parentIndex;
		}
		
		public function hasElementClassName(className:String):Boolean
		{
			return (this._elementClassNames.indexOf(className) > -1);
		}
		
		public function addElementClassName(className:String):Boolean
		{
			if (this.hasElementClassName(className))
			{
				return false;
			}
			
			this._elementClassNames.push(className);
			
			this.updateStyles();
			
			return true;
		}
		
		public function removeElementClassName(className:String):Boolean
		{
			if (this.hasElementClassName(className))
			{
				this._elementClassNames.splice(this._elementClassNames.indexOf(className), 1);
				
				this.updateStyles();
				
				return true;
			}
			
			return false;
		}
		
		public function hasElementPseudoClass(pseudoClass:String):Boolean
		{
			return (this._elementPseudoClasses.indexOf(pseudoClass) > -1);
		}
		
		public function addElementPseudoClass(pseudoClass:String):Boolean
		{
			if (this.hasElementPseudoClass(pseudoClass))
			{
				return false;
			}
			
			this._elementPseudoClasses.push(pseudoClass);
			
			this.updateStyles();
			
			return true;
		}
		
		public function removeElementPseudoClass(pseudoClass:String):Boolean
		{
			if (this.hasElementPseudoClass(pseudoClass))
			{
				this._elementPseudoClasses.splice(this._elementClassNames.indexOf(pseudoClass), 1);
				
				this.updateStyles();
				
				return true;
			}
			
			return false;
		}
		
		public function layoutChildren():void
		{
			
		}
		
		public function redraw():void
		{
			
		}
		
		protected function updateParentIndex(index:uint):void
		{
			this._parentIndex = index;
			
			this.updateStyles();
		}
		
		protected function updateChildrenIndex():void
		{
			for (var i:int = 0; i < this.numChildren; i++)
			{
				this.children[i].updateParentIndex(i);
			}
		}
		
		public function addElement(child:UIElement):UIElement
		{
			return this.addElementAt(child, this._children.length);
		}
		
		public function addElementAt(child:UIElement, index:int):UIElement
		{
			if (child.baseUI != null && child.baseUI != this)
			{
				throw new IllegalOperationError("Child belongs to a different BaseUI, cannot add to this UIElement");
			}
			
			child._parentElement = this;
			child._baseUI = this.baseUI;
			
			child.addEventListener(UIElementEvent.EFFECTIVE_DIMENSIONS_CHANGED, this.onChildDimensionsChanged);
			
			if (index < this._children.length)
			{
				this._children.splice(index, 0, child);
			}
			else
			{
				this._children.push(child);
			}
			
			this.updateChildrenIndex();
			
			return child;
		}
		
		public function removeElement(child:UIElement):UIElement
		{
			var index:int = this._children.indexOf(child);
			
			return this.removeElementAt(index);
		}
		
		public function removeElementAt(index:int):UIElement
		{
			if (index == -1)
			{
				throw new IllegalOperationError("Child does not exist within the UIElement");
			}
			
			var child:UIElement = this._children[index];
			
			child.removeEventListener(UIElementEvent.EFFECTIVE_DIMENSIONS_CHANGED, this.onChildDimensionsChanged);
			
			child._parentElement = null;
			child._baseUI = null;
			
			this._children.splice(index, 1);
			
			this.updateChildrenIndex();
			
			return child;
		}
		
		public function updateStyles():void
		{
			this._styles = new Vector.<Style>();
			
			if (this.baseUI != null)
			{
				for (var i:int = 0; i < this.baseUI.styleSheetCollection.length; ++i)
				{
					var sheet:StyleSheet = this.baseUI.styleSheetCollection.styleSheets[i];
					
					for (var j:int = 0; j < sheet.styles.length; ++j)
					{
						var style:Style = sheet.styles[j];
						
						for (var k:int = 0; k < style.elementSelectorChains.length; ++k)
						{
							var chain:ElementSelectorChain = style.elementSelectorChains[k];
							
							if (this.matchesElementSelectorChain(chain))
							{
								if (this._styles.indexOf(style) == -1)
								{
									this._styles.push(style);
								}
								
								break;
							}
						}
					}
				}
			}
		}
		
		public function matchesElementSelector(selector:ElementSelector):Boolean
		{
			if (selector.elementNameMatchRequired && selector.elementName != null)
			{
				if (selector.elementName != this.elementName)
				{
					return false;
				}
			}
			
			if (selector.elementID != null)
			{
				if (selector.elementID != this.elementId)
				{
					return false;
				}
			}
			
			if (selector.elementClassNames.length > 0)
			{
				for (var i:int = 0; i < selector.elementClassNames.length; i++)
				{
					if (!this.hasElementClassName(selector.elementClassNames[i]))
					{
						return false;
					}
				}
			}
			
			if (selector.elementPseudoClasses.length > 0)
			{
				for (var j:int = 0; j < selector.elementPseudoClasses.length; j++)
				{
					if (!this.hasElementPseudoClass(selector.elementPseudoClasses[j]))
					{
						return false;
					}
				}
			}
			
			return true;
		}
		
		public function matchesElementSelectorChain(chain:ElementSelectorChain):Boolean
		{
			var collection:Vector.<ElementSelector> = chain.elementSelectors.reverse();
			var parent:UIElement = this;
			
			for (var i:int = 0; i < collection.length; i++)
			{
				var selector:ElementSelector = collection[i];
				
				if (parent != null && parent.matchesElementSelector(selector))
				{
					parent = parent.styleParent;
				}
				else
				{
					return false;
				}
			}
			
			return true;
		}
		
		protected function onChildDimensionsChanged(e:UIElementEvent):void
		{
			this.layoutChildren();
		}
		
		protected function onStyleSheetModified(e:StyleSheetEvent):void
		{
			this.updateStyles();
		}
		
		/* Overrides to block the Flash methods when they called outside of this class */
		
		/**
		 * @see UIElement.addElement
		 */
		public override function addChild(child:DisplayObject):DisplayObject
		{
			throw new IllegalOperationError("Method addChild not accessible on a UIElement");
		}
		
		/**
		 * @see UIElement.addElementAt
		 */
		public override function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			throw new IllegalOperationError("Method addChildAt not accessible on a UIElement");
		}
		
		/**
		 * @see UIElement.removeElement
		 */
		public override function removeChild(child:DisplayObject):DisplayObject
		{
			throw new IllegalOperationError("Method removeChild not accessible on a UIElement");
		}
		
		/**
		 * @see UIElement.removeElementAt
		 */
		public override function removeChildAt(index:int):DisplayObject
		{
			throw new IllegalOperationError("Method removeChildAt not accessible on a UIElement");
		}
	}
}