package com.lnet.pandora.data {
	import com.demonsters.debugger.MonsterDebugger;

	public class Song {
		private var _title:String;
		private var _artist:String;
		private var _album:String;
		private var _albumArt:String;
		private var _totalTime:String;
		
		public function Song(song:Object) {
			try{
				_title = song.songName;
				_artist = song.artistName;
				_album = song.albumName;
				_albumArt = song.albumArtUrl;
			} catch(e:Error) {
				MonsterDebugger.trace("Song::Song","ERROR:: Could not set song data");
			}
		}

		public function get title():String {
			return _title;
		}

		public function set title(value:String):void {
			_title = value;
		}

		public function get artist():String {
			return _artist;
		}

		public function set artist(value:String):void {
			_artist = value;
		}

		public function get album():String {
			return _album;
		}

		public function set album(value:String):void {
			_album = value;
		}

		public function get albumArt():String {
			return _albumArt;
		}

		public function set albumArt(value:String):void {
			_albumArt = value;
		}
	}
}