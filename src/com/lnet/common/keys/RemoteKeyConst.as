package com.lnet.common.keys
{
  import flash.utils.Dictionary;
  import flash.events.KeyboardEvent;
  import flash.ui.Keyboard;
  /**
   * @author sbrady
   */
  public class RemoteKeyConst extends Object
  {
    private static var _allKeys:Array     = [
                                            ZERO,ONE,TWO,THREE,FOUR,FIVE,SIX,SEVEN,EIGHT,NINE,
                                            ORDER,MENU,SELECT,BACK,INFO,EXIT,GUIDE,
                                            SKIP_BACK,SKIP_FORWARD,PAUSE,PLAY,RECORD,LIST,STOP,
                                            FUTURE_A,FUTURE_B,FUTURE_C,
                                            DOT_COM,
                                            LEFT,RIGHT,UP,DOWN,
                                            CHANNEL_UP,CHANNEL_DOWN
                                            ];

    /*private static var _allMethods:Array  = [
                                            METHOD_NAME_ZERO,METHOD_NAME_ONE,METHOD_NAME_TWO,METHOD_NAME_THREE,METHOD_NAME_FOUR,METHOD_NAME_FIVE,METHOD_NAME_SIX,METHOD_NAME_SEVEN,METHOD_NAME_EIGHT,METHOD_NAME_NINE,
                                            METHOD_NAME_ORDER,METHOD_NAME_MENU,METHOD_NAME_SELECT,METHOD_NAME_BACK,METHOD_NAME_INFO,METHOD_NAME_EXIT,METHOD_NAME_GUIDE,
                                            METHOD_NAME_SKIP_BACK,METHOD_NAME_SKIP_FORWARD,METHOD_NAME_PAUSE,METHOD_NAME_PLAY,METHOD_NAME_RECORD,METHOD_NAME_LIST,METHOD_NAME_STOP,
                                            METHOD_NAME_FUTURE_A,METHOD_NAME_FUTURE_B,METHOD_NAME_FUTURE_C,
                                            METHOD_NAME_DOT_COM,
                                            METHOD_NAME_LEFT,METHOD_NAME_RIGHT,METHOD_NAME_UP,METHOD_NAME_DOWN,
                                            METHOD_NAME_CHANNEL_UP,METHOD_NAME_CHANNEL_DOWN
                                            ];*/


    private static var _keyMethodMap:Dictionary;

    public static function get ZERO():Number          {return 48;}
    public static function get ONE():Number           {return 49;}
    public static function get TWO():Number           {return 50;}
    public static function get THREE():Number         {return 51;}
    public static function get FOUR():Number          {return 52;}
    public static function get FIVE():Number          {return 53;}
    public static function get SIX():Number           {return 54;}
    public static function get SEVEN():Number         {return 55;}
    public static function get EIGHT():Number         {return 56;}
    public static function get NINE():Number          {return 57;}
    public static function get ORDER():Number         {return Keyboard.F15;}
    public static function get MENU():Number          {return Keyboard.HOME;}
    public static function get SELECT():Number        {return Keyboard.F14;}
    public static function get BACK():Number          {return Keyboard.ESCAPE;}
    public static function get INFO():Number          {return Keyboard.F12;}
    public static function get EXIT():Number          {return Keyboard.END;}
    public static function get GUIDE():Number         {return Keyboard.F13;}
    public static function get SKIP_BACK():Number     {return Keyboard.F11;}
    public static function get SKIP_FORWARD():Number  {return Keyboard.F9;}
    public static function get PAUSE():Number         {return 19;}                 //there appears to be no Keyboard.PAUSE for Flash 10 only AIR
    public static function get PLAY():Number          {return Keyboard.F8;}
    public static function get RECORD():Number        {return Keyboard.F7;}
    public static function get LIST():Number          {return Keyboard.F6;}
    public static function get STOP():Number          {return Keyboard.F5;}
    public static function get FUTURE_A():Number      {return Keyboard.F4;}
    public static function get FUTURE_B():Number      {return Keyboard.F3;}
    public static function get FUTURE_C():Number      {return Keyboard.F2;}
    public static function get DOT_COM():Number       {return 145;}                //there appears to be no Keyboard.PAUSE for Flash 10 only AIR
    public static function get LEFT():Number          {return Keyboard.LEFT;}
    public static function get RIGHT():Number         {return Keyboard.RIGHT;}
    public static function get UP():Number            {return Keyboard.UP;}
    public static function get DOWN():Number          {return Keyboard.DOWN;}
    public static function get CHANNEL_UP():Number    {return Keyboard.PAGE_UP;}
    public static function get CHANNEL_DOWN():Number  {return Keyboard.PAGE_DOWN;}



    public static function get METHOD_NAME_ZERO():String          {return "onRemoteKeyZero";}
    public static function get METHOD_NAME_ONE():String           {return "onRemoteKeyOne";}
    public static function get METHOD_NAME_TWO():String           {return "onRemoteKeyTwo";}
    public static function get METHOD_NAME_THREE():String         {return "onRemoteKeyThree";}
    public static function get METHOD_NAME_FOUR():String          {return "onRemoteKeyFour";}
    public static function get METHOD_NAME_FIVE():String          {return "onRemoteKeyFive";}
    public static function get METHOD_NAME_SIX():String           {return "onRemoteKeySix";}
    public static function get METHOD_NAME_SEVEN():String         {return "onRemoteKeySeven";}
    public static function get METHOD_NAME_EIGHT():String         {return "onRemoteKeyEight";}
    public static function get METHOD_NAME_NINE():String          {return "onRemoteKeyNine";}
    public static function get METHOD_NAME_ORDER():String         {return "onRemoteKeyOrder";}
    public static function get METHOD_NAME_MENU():String          {return "onRemoteKeyMenu";}
    public static function get METHOD_NAME_SELECT():String        {return "onRemoteKeySelect";}
    public static function get METHOD_NAME_BACK():String          {return "onRemoteKeyBack";}
    public static function get METHOD_NAME_INFO():String          {return "onRemoteKeyInfo";}
    public static function get METHOD_NAME_EXIT():String          {return "onRemoteKeyExit";}
    public static function get METHOD_NAME_GUIDE():String         {return "onRemoteKeyGuide";}
    public static function get METHOD_NAME_SKIP_BACK():String     {return "onRemoteKeySkipBack";}
    public static function get METHOD_NAME_SKIP_FORWARD():String  {return "onRemoteKeySkipForward";}
    public static function get METHOD_NAME_PAUSE():String         {return "onRemoteKeyPause";}
    public static function get METHOD_NAME_PLAY():String          {return "onRemoteKeyPlay";}
    public static function get METHOD_NAME_RECORD():String        {return "onRemoteKeyRecord";}
    public static function get METHOD_NAME_LIST():String          {return "onRemoteKeyList";}
    public static function get METHOD_NAME_STOP():String          {return "onRemoteKeyStop";}
    public static function get METHOD_NAME_FUTURE_A():String      {return "onRemoteKeyFuture_A";}
    public static function get METHOD_NAME_FUTURE_B():String      {return "onRemoteKeyFuture_B";}
    public static function get METHOD_NAME_FUTURE_C():String      {return "onRemoteKeyFuture_C";}
    public static function get METHOD_NAME_DOT_COM():String       {return "onRemoteKeyDotCom";}                //there appears to be no Keyboard.PAUSE for Flash 10 only AIR
    public static function get METHOD_NAME_LEFT():String          {return "onRemoteKeyLeft";}
    public static function get METHOD_NAME_RIGHT():String         {return "onRemoteKeyRight";}
    public static function get METHOD_NAME_UP():String            {return "onRemoteKeyUp";}
    public static function get METHOD_NAME_DOWN():String          {return "onRemoteKeyDown";}
    public static function get METHOD_NAME_CHANNEL_UP():String    {return "onRemoteKeyChannelUp";}
    public static function get METHOD_NAME_CHANNEL_DOWN():String  {return "onRemoteKeyChannelDown";}

    public static function get ALL_KEYS_IN_AN_ARRAY():Array
    {
      return _allKeys;
    }
    /*public static function get ALL_METHODS_IN_AN_ARRAY():Array
    {
      return _allMethods;
    }*/

    public static function get keyMethodMap():Dictionary
    {
      //trace("keymethodmap = "+_keyMethodMap)
      if( ! _keyMethodMap)
      {
        _keyMethodMap = new Dictionary();

        _keyMethodMap[ZERO]         = METHOD_NAME_ZERO;
        _keyMethodMap[ONE]          = METHOD_NAME_ONE;
        _keyMethodMap[TWO]          = METHOD_NAME_TWO;
        _keyMethodMap[THREE]        = METHOD_NAME_THREE;
        _keyMethodMap[FOUR]         = METHOD_NAME_FOUR;
        _keyMethodMap[FIVE]         = METHOD_NAME_FIVE;
        _keyMethodMap[SIX]          = METHOD_NAME_SIX;
        _keyMethodMap[SEVEN]        = METHOD_NAME_SEVEN;
        _keyMethodMap[EIGHT]        = METHOD_NAME_EIGHT;
        _keyMethodMap[NINE]         = METHOD_NAME_NINE;
        _keyMethodMap[ORDER]        = METHOD_NAME_ORDER;
        _keyMethodMap[MENU]         = METHOD_NAME_MENU;
        _keyMethodMap[SELECT]       = METHOD_NAME_SELECT;
        _keyMethodMap[BACK]         = METHOD_NAME_BACK;
        _keyMethodMap[INFO]         = METHOD_NAME_INFO;
        _keyMethodMap[EXIT]         = METHOD_NAME_EXIT;
        _keyMethodMap[GUIDE]        = METHOD_NAME_GUIDE;
        _keyMethodMap[SKIP_BACK]    = METHOD_NAME_SKIP_BACK;
        _keyMethodMap[SKIP_FORWARD] = METHOD_NAME_SKIP_FORWARD;
        _keyMethodMap[PAUSE]        = METHOD_NAME_PAUSE;
        _keyMethodMap[PLAY]         = METHOD_NAME_PLAY;
        _keyMethodMap[RECORD]       = METHOD_NAME_RECORD;
        _keyMethodMap[LIST]         = METHOD_NAME_LIST;
        _keyMethodMap[STOP]         = METHOD_NAME_STOP;
        _keyMethodMap[FUTURE_A]     = METHOD_NAME_FUTURE_A;
        _keyMethodMap[FUTURE_B]     = METHOD_NAME_FUTURE_B;
        _keyMethodMap[FUTURE_C]     = METHOD_NAME_FUTURE_C;
        _keyMethodMap[DOT_COM]      = METHOD_NAME_DOT_COM;
        _keyMethodMap[LEFT]         = METHOD_NAME_LEFT;
        _keyMethodMap[RIGHT]        = METHOD_NAME_RIGHT;
        _keyMethodMap[UP]           = METHOD_NAME_UP;
        _keyMethodMap[DOWN]         = METHOD_NAME_DOWN;
        _keyMethodMap[CHANNEL_UP]   = METHOD_NAME_CHANNEL_UP;
        _keyMethodMap[CHANNEL_DOWN] = METHOD_NAME_CHANNEL_DOWN;

      }
      //trace("keymethodmap = "+_keyMethodMap);

      return _keyMethodMap;
    }

    public static function getUsableCode(event:KeyboardEvent):int
    {
      var usableCode:Number = 0;
      if(event.charCode > 0)
      {
        usableCode = event.charCode;
      }
      else if(event.keyCode > 0)
      {
        usableCode = event.keyCode;
      }
      return usableCode;
    }
    public static function translateCodeToMethodName(key:Number):String
    {
      var map:Dictionary = RemoteKeyConst.keyMethodMap;
      return map[key];
    }
    public static function translateEventToMethodName(event:KeyboardEvent):String
    {
      var key:Number = getUsableCode(event);
      return translateCodeToMethodName(key);
    }
  }
}
