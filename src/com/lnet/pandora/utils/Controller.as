package com.lnet.pandora.utils {
	import com.demonsters.debugger.MonsterDebugger;
	import com.lnet.pandora.command.auth.UserLogin;
	import com.lnet.pandora.command.music.Search;
	import com.lnet.pandora.command.station.CreateStation;
	import com.lnet.pandora.command.station.GetPlaylist;
	import com.lnet.pandora.command.user.GetStationList;
	import com.lnet.pandora.events.ApplicationEvent;
	import com.lnet.pandora.events.ApplicationEventBus;
	import com.lnet.pandora.response.music.SearchResponse;
	import com.lnet.pandora.response.station.CreateStationResponse;
	import com.lnet.pandora.response.station.GetPlaylistResponse;
	import com.lnet.pandora.response.station.supportClasses.Station;
	import com.lnet.pandora.response.station.supportClasses.Track;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.rpc.events.FaultEvent;
	
	public class Controller {
		private var nextTrackIndex:uint = 0;
		private var userLoginRequest:UserLogin;
		private var getStationListRequest:GetStationList;
		private var getPlaylistRequest:GetPlaylist;
		private var createNewStationRequest:CreateStation;
		private var soundInstance:Sound;
		private var soundChannelInstance:SoundChannel;
		private var soundPosition:Number;
		private var musicSearchRequest:Search;
		private var stationList:IList;
		private var currentTrack:Track;
		
		private var _currentTrackPos:int;
		private var _selectedStation:Station;
		
		public function Controller() {
			MonsterDebugger.trace("Controller::Controller","Created!");
			ApplicationEventBus.getInstance().addEventListener(ApplicationEvent.PAUSE_SONG, pauseSong, false, 0, true);
			ApplicationEventBus.getInstance().addEventListener(ApplicationEvent.PLAY_SONG, playSong, false, 0, true);
			ApplicationEventBus.getInstance().addEventListener(ApplicationEvent.SELECT_STATION, setSelectedStation, false, 0, true); 
			ApplicationEventBus.getInstance().addEventListener(ApplicationEvent.NEW_TRACK_REQUESTED, getNextTrack, false, 0, true); 
			ApplicationEventBus.getInstance().addEventListener(ApplicationEvent.SONG_LIST_INITIALIZED, getInitSongListTrack, false, 0, true); 
		}
		
		private function playSong(event:ApplicationEvent):void {
			MonsterDebugger.trace("Controller::playSong","Play song");
			soundChannelInstance = soundInstance.play(soundPosition);
		}
		
		private function pauseSong(event:ApplicationEvent):void {
			MonsterDebugger.trace("Controller::pauseSong","Pause song");
			soundPosition = soundChannelInstance.position;
			soundChannelInstance.stop();
		}
		
		public function loginUser(u:String,p:String):void {
			userLoginRequest = new UserLogin();
			userLoginRequest.username = u;
			userLoginRequest.password = p;
			
			userLoginRequest.addEventListener( Event.COMPLETE, onUserLoginComplete );
			userLoginRequest.addEventListener( FaultEvent.FAULT, onUserLoginFault );
			try{
				userLoginRequest.submit();
			}catch(e:Error){
				try{
					userLoginRequest.submit();
				}catch(e:Error){
					MonsterDebugger.trace("Controller::loginUser","Unable to login user...");
					throw new Error("User Login Failed");
				}
			}
		}
		
		private function onUserLoginFault(event:FaultEvent):void {
			MonsterDebugger.trace("Controller::onUserLoginFault","Fault:: " + String( userLoginRequest.fault));
			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.LOGIN_ERROR));
		}
		
		private function onUserLoginComplete( e:Event ):void {
			userLoginRequest.removeEventListener(Event.COMPLETE, onUserLoginComplete);
			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.RESET_FOCUS));
			getStationList();
		}
		
		private function getStationList():void {
			getStationListRequest = new GetStationList();
			getStationListRequest.includeStationArtUrl = true;
			
			getStationListRequest.addEventListener( Event.COMPLETE, onStationListComplete );
			getStationListRequest.addEventListener( FaultEvent.FAULT, onStationListFault );
			getStationListRequest.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
			
			getStationListRequest.submit();
		}
		
		private function onIOError(event:IOErrorEvent):void {
			MonsterDebugger.trace("Controller::onIOError","IOERROR!!!!!!!!!!!!!" + event.text);
		}
		
		private function onStationListFault(event:FaultEvent):void {
			MonsterDebugger.trace("Controller::onStationListFault","Fault:: " + String(getStationListRequest.fault));
		}
		
		private function onStationListComplete(event:Event):void {
			stationList = new ArrayCollection();
			
			for (var i:int = 0; i<getStationListRequest.response.stations.elements.length; i++){
				var station:Station = getStationListRequest.response.stations.elements[i] as Station;
				stationList.addItem(station);
			}
			
			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.STATION_LIST_LOADED,
				stationList));
			
			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.SELECT_STATION,
				stationList[1]));
		}
		
		public function setSelectedStation(event:ApplicationEvent):void {
			_selectedStation = event.data as Station;
			getPlaylist(selectedStation);
			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.STATION_SELECTED, selectedStation));
			MonsterDebugger.trace("Controller::setSelectedStation","Station Selected::"+selectedStation.stationName);
		}
		
		private function getPlaylist(thisStation:Station):void {
			getPlaylistRequest = new GetPlaylist();
			getPlaylistRequest.stationToken = thisStation.stationToken;
			
			getPlaylistRequest.addEventListener( Event.COMPLETE, onPlaylistComplete );
			getPlaylistRequest.addEventListener( FaultEvent.FAULT, onPlaylistFault );
			getPlaylistRequest.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
			
			getPlaylistRequest.submit();
		}
		
		private function onPlaylistFault(event:FaultEvent):void {
			MonsterDebugger.trace("Controller::onPlaylistFault","Fault:: " + String( getPlaylistRequest.fault));
		}
		
		private function onPlaylistComplete(event:Event):void {
			MonsterDebugger.trace("Controller::onPlaylistComplete","Playlist Complete - load first track");
			nextTrackIndex = 0;
			playTrack(getNextTrack());
		}
		
		private function getInitSongListTrack(e:Event):void {
			playTrack(getNextTrack());
			MonsterDebugger.trace("Controller::getInitSongListTrack","Song list initialized...getting track...");
		}
		
		public function getNextTrack(e:Event=null):Track {
			var playlist:GetPlaylistResponse = getPlaylistRequest.response;
			var track:Track = null;
			
			for( var i:uint = nextTrackIndex++ ; i < playlist.items.elements.length ; i++ ) {
				if ( ( track = playlist.items.elements[ i ] as Track ) )
					break;
			}
			
//			currentTrack = track;
			return track;
//			MonsterDebugger.trace("Controller::getNextTrack","Dispatching track ready event...");
//			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.TRACK_READY_TO_PLAY, currentTrack));
		}
		
		private function playTrack( track:Track ):void {
			try	{
				if ( soundChannelInstance )
					soundChannelInstance.stop();
				
				if ( soundInstance )
					soundInstance.close();
			} catch (e:Error) {
				MonsterDebugger.trace("PandoraStandalone::playTrack","sound channel stop error " + e);
			}
			
			if( !track ) return;
			
			soundInstance = new Sound();
			
			soundInstance.addEventListener(IOErrorEvent.IO_ERROR, ioSoundError);
			soundInstance.addEventListener(Event.COMPLETE, soundLoaded);
			
			var req:URLRequest =  new URLRequest( track.audioUrl );
			var context:SoundLoaderContext = new SoundLoaderContext(0, false);
			
			try {
				soundInstance.load(req, context);
				soundChannelInstance = soundInstance.play();
				soundChannelInstance.addEventListener(Event.SOUND_COMPLETE, playNextSong);
				ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.SONG_LOADED, track));
			}
			catch (err:Error) {
				MonsterDebugger.trace("Controller::playTrack","ERROR::"+err.message);
			}
		}

		private function soundLoaded(event:Event):void {
			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.SOUND_READY,
				soundInstance, soundChannelInstance));
			var currentTime:uint = Math.round(soundChannelInstance.position/1000);
			var totalTime:uint = Math.round(soundInstance.length/1000);
		}
		
		private function ioSoundError(e:IOErrorEvent):void {
			MonsterDebugger.trace("PandoraStandalone::ioSoundError","sound channel ioSoundError " + e.text);
			playNextSong();
		}
		
		public function playNextSong(e:Event=null):void {
			playTrack(getNextTrack());
//			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.TRACK_SELECTED, getNextTrack());
		}
		
		public function createNewStation(stationTxt:String):void {
			MonsterDebugger.trace("Controller::createStation","Attempting to create new station for ::"+stationTxt);
			
			musicSearchRequest = new Search();
			musicSearchRequest.searchText = stationTxt;
			musicSearchRequest.includeNearMatches = true;
			
			musicSearchRequest.addEventListener(Event.COMPLETE, onMusicSearchComplete);
			musicSearchRequest.addEventListener(FaultEvent.FAULT, onMusicSearchFault);
			musicSearchRequest.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
			
			musicSearchRequest.submit();
		}
		
		private function onMusicSearchComplete(event:Event):void {
			MonsterDebugger.trace("Controller::onMusicSearchComplete","response::"+musicSearchRequest.response);
			MonsterDebugger.trace("Controller::onMusicSearchComplete","songs::"+musicSearchRequest.response.songs.elements.length);
			MonsterDebugger.trace("Controller::onMusicSearchComplete","artists::"+musicSearchRequest.response.artists.elements.length);
			
			var responseArray:IList = new ArrayCollection();
			var searchResponse:SearchResponse = musicSearchRequest.response as SearchResponse;
			var i:int;
			
			for (i = 0; i < searchResponse.artists.elements.length; i++){
				responseArray.addItem(searchResponse.artists.elements[i]);
			}
			
			responseArray.toArray().sortOn("score");
			
			createStation(responseArray[0].musicToken);
		}
		
		private function createStation(token:String):void {
			createNewStationRequest = new CreateStation();
			createNewStationRequest.musicToken = token;
			
			createNewStationRequest.addEventListener( Event.COMPLETE, onCreateStationComplete );
			createNewStationRequest.addEventListener( FaultEvent.FAULT, onCreateStationFault );
			createNewStationRequest.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
			
			createNewStationRequest.submit();
		}
		
		private function onMusicSearchFault(event:FaultEvent):void {
			MonsterDebugger.trace("Controller::onMusicSearchFault","Fault:: " + String( musicSearchRequest.fault));
		}
		
		private function onCreateStationComplete(event:Event):void {
			MonsterDebugger.trace("Controller::onCreateStationComplete","createNewStationRequest::"+createNewStationRequest.response);
			var stationResponse:CreateStationResponse = createNewStationRequest.response as CreateStationResponse;
			getStationList();
		}
		
		private function onCreateStationFault(event:FaultEvent):void {
			MonsterDebugger.trace("Controller::onCreateStationFault","Fault:: " + String( createNewStationRequest.fault));
		}
		
		public function get currentTrackPos():int {
			return _currentTrackPos;
		}
		
		public function set currentTrackPos(value:int):void {
			_currentTrackPos = value;
		}
		
		public function get selectedStation():Station {
			return _selectedStation;
		}
		
		public function set selectedStation(value:Station):void {
			_selectedStation = value;
		}
	}
}