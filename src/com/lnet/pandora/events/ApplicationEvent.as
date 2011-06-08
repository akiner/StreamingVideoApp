package com.lnet.pandora.events {
	import flash.events.Event;
	
	public class ApplicationEvent extends Event {
		public static const SONG_LOADED:String = "songLoaded";
		public static const STATION_SELECTED:String = "stationSelected";
		public static const TRACK_READY_TO_PLAY:String = "trackReadyToPlay";
		public static const NEW_TRACK_REQUESTED:String = "newTrackRequested";
		public static const GET_NEXT_TRACK:String = "getNextTrack";
		public static const SELECT_STATION:String = "selectStation";
		public static const STATION_LIST_LOADED:String = "stationListLoaded";
		public static const UPDATE_SELECTED_INDEX:String = "updateSelectedIndex";
		public static const RESET_FOCUS:String = "resetFocus";
		public static const PLAY_SONG:String = "playSong";
		public static const PAUSE_SONG:String = "pauseSong";
		public static const LOGIN_ERROR:String = "loginError";
		public static const SOUND_READY:String = "soundReady";
		public static const SONG_LIST_INITIALIZED:String = "songListInitialized";
		
		public var data:Object;
		public var optionalData:Object;
		public var optionalData2:Object;
		
		public function ApplicationEvent(type:String, eventData:Object=null, optionalDataField:Object=null, optionalDataField2:Object=null, 
										 bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			data = eventData;
			if(optionalDataField != null) {
				optionalData = optionalDataField;
			}
			if(optionalDataField2 != null) {
				optionalData2 = optionalDataField2;
			}
		}
	}
}