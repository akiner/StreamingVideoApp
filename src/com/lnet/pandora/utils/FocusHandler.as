package com.lnet.pandora.utils {
	import com.demonsters.debugger.MonsterDebugger;
	import com.lnet.pandora.events.ApplicationEvent;
	import com.lnet.pandora.events.ApplicationEventBus;
	import com.lnet.pandora.views.CreateNewStationView;
	import com.lnet.pandora.views.LoginView;
	import com.lnet.pandora.views.SongListView;
	import com.lnet.pandora.views.StationListView;
	
	import flash.events.KeyboardEvent;
	
	import mx.core.FlexGlobals;
	import mx.managers.IFocusManagerComponent;
	
	public class FocusHandler {
		private var currentKey:String;
		
		private var _createNewStationView:CreateNewStationView;
		private var _loginView:LoginView;
		private var _songListView:SongListView;
		private var _stationListView:StationListView;
		private var isTyping:Boolean;
		private var preSearchState:String;
		private var controller:Controller;
		
		public static const SEARCH_DEFAULT_TEXT:String = "Begin Typing to Search";
		
		public function FocusHandler() {
			MonsterDebugger.trace("FocusHandler::FocusHandler","Created!");
			isTyping = false;
			controller = new Controller();
			FlexGlobals.topLevelApplication.stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyPress, false, 0, true);
		}
		
		public function handleKeyPress(event:KeyboardEvent):void {
			MonsterDebugger.trace("FocusHandler::handleKeyPress","Handling Key Press in::"+FlexGlobals.topLevelApplication.currentState);
			if (userIsTyping(event)) {
				if (!isTyping && FlexGlobals.topLevelApplication.currentState == "default"){
					FlexGlobals.topLevelApplication.focusManager.setFocus(createNewStationView.stationName);
					initCreateStation(event);
					
				} else if(!isTyping && FlexGlobals.topLevelApplication.currentState == "login") {
					isTyping = true;
					loginView.username.cursorManager.hideCursor();
				}
			} else {
				currentKey = KeyHandler.keyPressed(event.keyCode);
				switch(FlexGlobals.topLevelApplication.currentState) {
					case "login":
						handleKeyPressInLoginView();
						break;
					case "createStation":
						handleKeyPressInCreateStationView();
						break;
					case "default":
						handleKeyPressInDefaultView();
						break;
					default:
						MonsterDebugger.trace("FocusHandler::constructor","Keyboard event not handled!!!");
						break;
				}
			}
		}
		
		private function handleKeyPressInDefaultView():void {
			switch(currentKey) {
				case "select":
//					controller.setSelectedStation(stationListView.stationList.selectedItem);
					break;
				case "rightArrow":
					controller.playNextSong();
//					controller.getNextTrack();
					MonsterDebugger.trace("FocusHandler::handleKeyPressInDefaultView","Arrowed right");
					break;
				case "play":
					ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.PLAY_SONG));
					break;
				case "pause":
					ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.PAUSE_SONG));
					break;
				default:
					break;
			}
		}
		
		private function handleKeyPressInLoginView():void {
			switch(currentKey) {
				case "select":
					MonsterDebugger.trace("FocusHandler::handleKeyPressInLoginView","Attempting to login user");
					isTyping = false;
					controller.loginUser(loginView.username.text, loginView.password.text);
					break;
				case "downArrow":
					var nextComponent:IFocusManagerComponent = loginView.focusManager.getNextFocusManagerComponent();
					loginView.focusManager.setFocus(nextComponent);    
					break;
				case "upArrow":
					var prevComponent:IFocusManagerComponent = loginView.focusManager.getNextFocusManagerComponent();
					loginView.focusManager.setFocus(prevComponent);    
					break;
				default:
					break;
			}
		}
		
		private function handleKeyPressInCreateStationView():void {
			switch(currentKey) {
				case "select":
					controller.createNewStation(createNewStationView.stationName.text);
					returnToDefaultState();
					break;
				case "back":
					returnToDefaultState();
					break;
				default:
					break;
			}
		}
		
		private function returnToDefaultState():void {
			isTyping = false;
			createNewStationView.stationName.text = SEARCH_DEFAULT_TEXT;
			createNewStationView.currentState = "default";
			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.RESET_FOCUS));
		}
		
		
		private function userIsTyping(event:KeyboardEvent):Boolean {
			if(KeyHandler.isAlphaKey(event.keyCode) || KeyHandler.isNumericKey(event.keyCode)) {
				return true;
			} else {
				return false;
			}
		}
		
		private function initCreateStation(event:KeyboardEvent):void {
			MonsterDebugger.trace("FocusHandler::initCreateStation","Initializing create station...");
			isTyping = true;
			FlexGlobals.topLevelApplication.currentState = "createStation";
			createNewStationView.stationName.text = "";
			createNewStationView.currentState = "selected";
			createNewStationView.stationName.insertText(String.fromCharCode(event.charCode));
			createNewStationView.stationName.cursorManager.showCursor();
		}
		
		public function get createNewStationView():CreateNewStationView {
			return _createNewStationView;
		}
		
		public function set createNewStationView(value:CreateNewStationView):void {
			_createNewStationView = value;
		}
		
		public function get loginView():LoginView {
			return _loginView;
		}
		
		public function set loginView(value:LoginView):void {
			_loginView = value;
		}
		
		public function get songListView():SongListView {
			return _songListView;
		}
		
		public function set songListView(value:SongListView):void {
			_songListView = value;
		}
		
		public function get stationListView():StationListView {
			return _stationListView;
		}
		
		public function set stationListView(value:StationListView):void {
			_stationListView = value;
		}
		
	}
}