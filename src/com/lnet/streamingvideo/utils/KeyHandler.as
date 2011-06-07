package com.lnet.streamingvideo.utils {
	import com.demonsters.debugger.MonsterDebugger;
	
	public class KeyHandler	{
		public static function keyPressed(keyCode:uint):String {
			var keyToReturn:String;
			switch (keyCode) {
				case 38:
					keyToReturn = "upArrow";
					break;
				case 40:
					keyToReturn = "downArrow";
					break;
				case 39:
					keyToReturn = "rightArrow";
					break;
				case 37:
					keyToReturn = "leftArrow";
					break;
				case 13:
				case 125:
					keyToReturn = "select";
					break;
				case 27:
					keyToReturn = "back";
					break;
				case 19:
					keyToReturn = "pause";
					break;
				case 119:
					keyToReturn = "play";
					break;
				case 122:
					keyToReturn = "skipBack";
					break;
				case 120:
					keyToReturn = "skipForward";
					break;
				case 48:
					keyToReturn = "0";
					break;
				case 49:
					keyToReturn = "1";
					break;
				case 50:
					keyToReturn = "2";
					break;
				case 51:
					keyToReturn = "3";
					break;
				case 52:
					keyToReturn = "4";
					break;
				case 53:
					keyToReturn = "5";
					break;
				case 54:
					keyToReturn = "6";
					break;
				case 55:
					keyToReturn = "7";
					break;
				case 56:
					keyToReturn = "8";
					break;
				case 57:
					keyToReturn = "9";
					break;
				case 65:
					keyToReturn = "a";
					break;
				case 66:
					keyToReturn = "b";
					break;
				case 67:
					keyToReturn = "c";
					break;
				case 68:
					keyToReturn = "d";
					break;
				case 69:
					keyToReturn = "e";
					break;
				case 70:
					keyToReturn = "f";
					break;
				case 71:
					keyToReturn = "g";
					break;
				case 72:
					keyToReturn = "h";
					break;
				case 73:
					keyToReturn = "i";
					break;
				case 74:
					keyToReturn = "j";
					break;
				case 75:
					keyToReturn = "k";
					break;
				case 76:
					keyToReturn = "l";
					break;
				case 77:
					keyToReturn = "m";
					break;
				case 78:
					keyToReturn = "n";
					break;
				case 79:
					keyToReturn = "o";
					break;
				case 80:
					keyToReturn = "p";
					break;
				case 81:
					keyToReturn = "q";
					break;
				case 82:
					keyToReturn = "r";
					break;
				case 83:
					keyToReturn = "s";
					break;
				case 84:
					keyToReturn = "t";
					break;
				case 85:
					keyToReturn = "u";
					break;
				case 86:
					keyToReturn = "v";
					break;
				case 87:
					keyToReturn = "w";
					break;
				case 88:
					keyToReturn = "x";
					break;
				case 89:
					keyToReturn = "y";
					break;
				case 90:
					keyToReturn = "z";
					break;
				default:
					MonsterDebugger.trace("KeyHandler::keyPressed","Key not currently being handled::"+keyCode);
					keyToReturn = "undefined";
					break;
			}
			return keyToReturn;
		}
		
		public static function isNumericKey(keyCode:uint):Boolean {
			if (keyCode >=48 && keyCode <=57) {
				MonsterDebugger.trace("KeyHandler::isNumericKey","A numeric key was pressed");
				return true;
			} else {
				return false;
			}
		}
		
		public static function isAlphaKey(keyCode:uint):Boolean {
			if (keyCode >=65 && keyCode <=90) {
				MonsterDebugger.trace("KeyHandler::isAlphaKey","An alpha key was pressed");
				return true;
			} else {
				return false;
			}
		}
	}
}