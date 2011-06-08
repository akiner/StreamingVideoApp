package com.lnet.pandora.layouts {
	import com.demonsters.debugger.MonsterDebugger;
	
	import mx.core.ILayoutElement;
	
	import spark.components.supportClasses.GroupBase;
	import spark.layouts.VerticalLayout;
	
	public class StationListLayout extends VerticalLayout {
		public function StationListLayout() {
			super();
		}
		
		override public function measure():void {
			super.measure();
		}
		
		override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			var layoutTarget:GroupBase = layoutTarget;
			if(!layoutTarget)
				return;
			var count:int = layoutTarget.numElements;
			
			var contentWidth:Number = 0;
			
			for (var i:int = 0; i < count; i++)	{
				var element:ILayoutElement = layoutTarget.getElementAt(i);
				
				element.setLayoutBoundsSize(NaN,NaN);
				
				var elementWidth:Number = element.getLayoutBoundsWidth();
				var elementHeight:Number = element.getLayoutBoundsHeight();
				contentWidth += elementWidth;
				
				MonsterDebugger.trace("StationListLayout::updateDisplayList","Is Selected::"+element);
			}
			target.setContentSize(contentWidth, target.contentHeight);
		}
	}
}