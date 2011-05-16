package com.lnet.pandora.utils {
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	public class TrackSound extends EventDispatcher {
		public function TrackSound(target:IEventDispatcher=null) {
			private var scrubBarMC:MovieClip;
			private var soundInstance:Sound;
			private var soundChannelInstance:SoundChannel;
			private var soundPosition:Number;
		}
	}
}