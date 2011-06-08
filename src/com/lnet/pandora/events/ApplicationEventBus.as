package com.lnet.pandora.events{
	import com.demonsters.debugger.MonsterDebugger;
	
	import flash.events.EventDispatcher;
	
	public class ApplicationEventBus extends EventDispatcher {
		
		protected static var instance:ApplicationEventBus;
		
		public function ApplicationEventBus() {
			MonsterDebugger.trace("ApplicationEventBus::constructor", "Created!");
		}
		
		public static function getInstance():ApplicationEventBus {
			if ( instance == null ) {
				instance = new ApplicationEventBus();
			}
			return instance;
		}
	}
}
//internal class SingletonBlocker {}