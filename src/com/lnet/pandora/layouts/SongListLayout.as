package com.lnet.pandora.layouts{
	
	import com.demonsters.debugger.MonsterDebugger;
	
	import mx.core.ILayoutElement;
	import mx.events.PropertyChangeEvent;
	import mx.formatters.NumberBase;
	
	import spark.components.supportClasses.GroupBase;
	import spark.layouts.HorizontalLayout;
	
	public class SongListLayout extends HorizontalLayout {
		public function SongListLayout() {
			super();
		}
		
		override public function measure():void {
			super.measure();
		}
		
		override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			var target:GroupBase = this.target;
			if (!target)
				return;
			
			// Adjust the position of the elements
			var contentWidth:Number = 0;	
			var count:int = target.numElements;
			for (var i:int = 0; i < count; i++)	{
				contentWidth += target.width;
				var element:ILayoutElement = target.getElementAt(i);
				
				var maxPosition:Number = target.contentWidth- target.width;
				
				MonsterDebugger.trace("SongListLayout::updateDisplayList","maxPosition"+maxPosition);
				if (!element || !element.includeInLayout)
					continue;
				
				if (maxPosition >= 0)
					horizontalScrollPosition = maxPosition;
			}
			
			target.setContentSize(contentWidth, target.contentHeight);
		}
	}
}