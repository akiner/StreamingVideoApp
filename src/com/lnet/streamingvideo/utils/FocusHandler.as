package com.lnet.streamingvideo.utils {
	import com.demonsters.debugger.MonsterDebugger;
	import com.lnet.streamingvideo.events.ApplicationEvent;
	import com.lnet.streamingvideo.events.ApplicationEventBus;
	import com.lnet.streamingvideo.views.BrowseView;
	import com.lnet.streamingvideo.views.PlayerView;
	import com.lnet.streamingvideo.views.SearchResultsView;
	import com.lnet.streamingvideo.views.SearchView;
	import com.lnet.utils.InteractiveSessionManager;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	import mx.core.FlexGlobals;

	public class FocusHandler {
		private var currentKey:String;
		
		private var _browseView:BrowseView;
		private var _searchView:SearchView;
		private var _searchResultsView:SearchResultsView;
		private var _playerView:PlayerView;
		private var isTyping:Boolean;
		private var preSearchState:String;
		
		public static const SEARCH_DEFAULT_TEXT:String = "Begin Typing to Search";
		
		public function FocusHandler() {
			init();
		}

		private function init():void {
			isTyping = false;
			FlexGlobals.topLevelApplication.addEventListener(KeyboardEvent.KEY_UP, handleKeyPress, false, 0, true);
		}

		private function handleKeyPress(event:KeyboardEvent):void {
		MonsterDebugger.trace("FocusHandler::handleKeyPress","Handling Key Press");
			preSearchState = FlexGlobals.topLevelApplication.currentState;
			if (userIsTyping(event)) {
				if (!isTyping){
					FlexGlobals.topLevelApplication.focusManager.setFocus(searchView.searchTxt);
					initSearch(event);
				}
			} else {
				currentKey = KeyHandler.keyPressed(event.keyCode);
				switch(FlexGlobals.topLevelApplication.currentState) {
					case "default":
						handleKeyPressInBrowseView();
						break;
					case "results":
						handleKeyPressInResultsView();
						break;
					case "videoPlaying":
						handleKeyPressInVideoPlayerView();
						break;
					case "search":
						handleKeyPressInSearchView();
						break;
					default:
						MonsterDebugger.trace("FocusHandler::constructor","Keyboard event not handled!!!");
						break;
				}
			}
		}

		private function userIsTyping(event:KeyboardEvent):Boolean {
			if(KeyHandler.isAlphaKey(event.keyCode) || KeyHandler.isNumericKey(event.keyCode)) { // what other keys do we need to catch??
				return true;
			} else {
				return false;
			}
		}

		private function initSearch(event:KeyboardEvent):void {
			isTyping = true;
			FlexGlobals.topLevelApplication.currentState = "search";
			searchView.searchTxt.text = "";
			searchView.searchTxt.insertText(KeyHandler.keyPressed(event.keyCode));
			searchView.searchTxt.cursorManager.showCursor();
		}

		private function handleKeyPressInBrowseView():void {
			switch(currentKey) {
				case "select":
					handleCategorySelect();
					break;
				case "back":
//					if(browseView.browseViewModel.currentCategoryList[0].name == browseView.browseViewModel.allCategoryList[0].name) {
					if(browseView.browseViewModel.currentCategoryList == browseView.browseViewModel.allCategoryList) {
						MonsterDebugger.trace("FocusHandler::handleKeyPressInBrowseView","------------------------GO BACK TO DEFAULT CATEGORIES--------------------------");
						browseView.browseViewModel.currentCategoryList = browseView.browseViewModel.defaultCategoryList;
					} else {
						MonsterDebugger.trace("FocusHandler::handleKeyPressInBrowseView","------------------------EXIT SERVICE--------------------------");
						FlexGlobals.topLevelApplication.dispatchEvent(new Event(InteractiveSessionManager.SERVICE_COMPLETE));
					}
					break;
				default:
					break;
			}
		}
		
		private function handleCategorySelect():void {
			if (browseView.categoryList.selectedItem.name == "All Categories") {
				browseView.browseViewModel.currentCategoryList = browseView.browseViewModel.allCategoryList;
			} else {
				browseView.currentState = "lostFocus";
				FlexGlobals.topLevelApplication.currentState = "results";
				FlexGlobals.topLevelApplication.focusManager.setFocus(searchResultsView.videoList);
			}
		}
		
		private function handleKeyPressInResultsView():void {
			switch(currentKey) {
				case "select":
					try{
						FlexGlobals.topLevelApplication.currentState = "videoPlaying";
						ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.VIDEO_SELECTED, searchResultsView.videoList.selectedItem));
					}catch(e:Error){
					}
					break;
				case "back":
					returnToBrowseView();
					break;
				default:
					break;
			}
		}
		
		private function handleKeyPressInSearchView():void {
			switch(currentKey) {
				case "select":
					isTyping = false;
					browseView.currentState = "lostFocus";
					FlexGlobals.topLevelApplication.currentState = "results";
					FlexGlobals.topLevelApplication.focusManager.setFocus(searchResultsView.videoList);
					searchResultsView.videoList.selectedIndex = 0;
					ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.SEARCH_REQUESTED, searchView.searchTxt.text));
					searchView.searchTxt.text = SEARCH_DEFAULT_TEXT;
					break;
				case "back":
					isTyping = false;
					searchView.searchTxt.text = SEARCH_DEFAULT_TEXT;
					returnToBrowseView();
					break;
				default:
					break;
			}
		}

		private function returnToBrowseView():void {
			browseView.currentState = "hasFocus";
			searchResultsView.videoList.selectedIndex = 0;
			browseView.browseViewModel.getCategoryResults(browseView.categoryList.selectedItem.name, browseView.categoryList.selectedItem.url);
			FlexGlobals.topLevelApplication.currentState = "default";
			FlexGlobals.topLevelApplication.focusManager.setFocus(browseView.categoryList);
		}

		
		private function handleKeyPressInVideoPlayerView():void {
			switch(currentKey) {
				case "back":
					FlexGlobals.topLevelApplication.currentState = "results";
					FlexGlobals.topLevelApplication.focusManager.setFocus(searchResultsView.videoList);
					playerView.endOfVideoOverlay.visible = false;
					ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.STOP_VIDEO));
					break;
				case "pause":
					ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.PAUSE_VIDEO));
					break;
				case "play":
					if(!playerView.endOfVideoOverlay.visible) {
						ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.PLAY_VIDEO));
					} else {
						ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.VIDEO_SELECTED, playerView.playerViewModel.selectedVideo));
//						ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.VIDEO_SELECTED, searchResultsView.videoList.selectedI/tem));
					}
					FlexGlobals.topLevelApplication.focusManager.setFocus(searchResultsView.videoList);//?
					break;
				case "skipBack":
					ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.SKIP_BACK_VIDEO));
					break;
				case "skipForward":
					ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.SKIP_FORWARD_VIDEO));
					break;
				case "select":
					if(playerView.endOfVideoOverlay.visible) {
						FlexGlobals.topLevelApplication.focusManager.setFocus(searchResultsView.videoList);//?
						ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.VIDEO_SELECTED, playerView.relatedVideosList.selectedItem));
					}
					break;
				default:
					MonsterDebugger.trace("FocusHandler::handleKeyPressInVideoPlayerView","Key not found!!!");
					break;
			}
		}

		public function get browseView():BrowseView {
			return _browseView;
		}

		public function set browseView(value:BrowseView):void {
			_browseView = value;
		}

		public function get searchView():SearchView {
			return _searchView;
		}

		public function set searchView(value:SearchView):void {
			_searchView = value;
		}

		public function get searchResultsView():SearchResultsView {
			return _searchResultsView;
		}

		public function set searchResultsView(value:SearchResultsView):void {
			_searchResultsView = value;
		}

		public function get playerView():PlayerView {
			return _playerView;
		}

		public function set playerView(value:PlayerView):void {
			_playerView = value;
		}
	}
}