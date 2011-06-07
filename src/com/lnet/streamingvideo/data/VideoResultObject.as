package com.lnet.streamingvideo.data {
	import com.lnet.streamingvideo.utils.TextFormatter;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	[Bindable]
	public class VideoResultObject {
		private var _title:String;
		private var _description:String;
		private var _published:String;
		private var _author:String;
		private var _views:String;
		private var _thumbnail:String;
		private var _videoID:String;
		private var _rating:String;
		private var _duration:String;
		private var _relatedVideoURL:String;
		
		public function VideoResultObject(video:Object) {
			try {_title = video.media$group.media$title.$t}
				catch(e:Error) {_title = ""}
			try {_description = video.media$group.media$description.$t}
				catch(e:Error) {_description = ""}
			try {_author = video.author[0].name.$t}
				catch(e:Error) {_author = ""}
			try {_views = TextFormatter.FormatNumWithCommas(video.yt$statistics.viewCount)}
				catch(e:Error) {_views = ""}
			try {_published = video.published.$t}
				catch(e:Error) {_published = ""}
			try {_videoID = video.media$group.yt$videoid.$t}
				catch(e:Error) {}
			try {_thumbnail = video.media$group.media$thumbnail[0].url}
				catch(e:Error) {}
			try {_rating = video.gd$rating.average}
				catch(e:Error) {}
			try {_duration = video.media$group.yt$duration.seconds}
				catch(e:Error) {}
			try {
				var linksList:Array = video.link;
				for each(var link:Object in linksList) {
					if(link.rel == "http://gdata.youtube.com/schemas/2007#video.related"){
						_relatedVideoURL = link.href;
					}
				}
				MonsterDebugger.trace("VideoResultObject::VideoResultObject","Related Vid URL::"+_relatedVideoURL);
			}catch(e:Error){}
		}

		public function get title():String {
			return _title;
		}

		public function get published():String {
			return _published;
		}

		public function get author():String {
			return _author;
		}

		public function get thumbnail():String {
			return _thumbnail;
		}

		public function get description():String {
			return _description;
		}

		public function get videoID():String {
			return _videoID;
		}

		public function get views():String {
			return _views;
		}
		
		public function get rating():String {
			return _rating;
		}

		public function get duration():String {
			return _duration;
		}

		public function get relatedVideoURL():String {
			return _relatedVideoURL;
		}

	}
}