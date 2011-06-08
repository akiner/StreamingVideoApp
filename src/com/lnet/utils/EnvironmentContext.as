package com.lnet.utils
{
  import com.demonsters.debugger.MonsterDebugger;
  import com.lnet.common.clientd.ClientdConnection;
  import com.lnet.common.clientd.commands.response.ServerResponse;
  import com.lnet.common.clientd.commands.response.resource.GetContextResponse;
  import com.lnet.common.clientd.commands.server.resource.GetContext;
  import com.lnet.common.socket.SocketConnection;
  import com.lnet.common.socket.SocketConnectionEvent;

  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.IEventDispatcher;
  import flash.events.IOErrorEvent;
  import flash.events.SecurityErrorEvent;
  import flash.net.URLLoader;
  import flash.net.URLRequest;

  import mx.events.PropertyChangeEvent;
  import mx.events.PropertyChangeEventKind;

  public class EnvironmentContext extends EventDispatcher
  {
    //--------------------------------------------------------------------------
    //
    // Class Methods
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    // Singleton
    //----------------------------------

    private static var _allowAlloc : Boolean = false;
    private static var _instance   : EnvironmentContext;

    public static function get instance() : EnvironmentContext
    {
      return _instance;
    }

    public static function init( ):void
    {
      // TODO: consider adding LoaderInfo param to avoid dependence on FlexGlobals
      _allowAlloc = true;
      _instance   = new EnvironmentContext();
      _allowAlloc = false;
    }

    //---------------------------------------
    // EventDispatcher Proxy
    //---------------------------------------

    public static function addEventListener( type             : String,
                                             listener         : Function,
                                             useCapture       : Boolean = false,
                                             priority         : int     = 0,
                                             useWeakReference : Boolean = false ):void
    {
      // forward listener registration to instance
      instance.addEventListener( type, listener, useCapture, priority, useWeakReference );
    }

    public static function removeEventListener( type     : String,
                                                listener : Function ):void
    {
      // forward listener resignation to instance
      instance.removeEventListener( type, listener );
    }


    //--------------------------------------------------------------------------
    //
    // Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    // language
    //----------------------------------

    private static const DEFAULT_LANGUAGE : String = 'en';
    private var _language : String;
    public static function get language( ) : String
    {
      return instance.language;
    }

    private function get language( ) : String
    {
      return ( _language ) ? ( _language ) : ( DEFAULT_LANGUAGE );
    }

    private function set language(value:String):void
    {
      _language = value;
    }


    //----------------------------------
    // entryPoint
    //----------------------------------

    /*
    private var _entryPoint : ContextString = null;
    public static function get entryPoint( ) : ContextString
    {
      return instance.entryPoint;
    }

    private function get entryPoint( ) : ContextString
    {
      return _entryPoint;
    }

    private function set entryPoint(value:ContextString):void
    {
      _entryPoint = value;
    }
    */

    //----------------------------------
    // controller
    //----------------------------------

    private var _controller : Boolean = true;
    public static function get controller( ) : Boolean
    {
      return instance.controller;
    }

    private function get controller( ) : Boolean
    {
      return _controller;
    }

    private function set controller(value:Boolean):void
    {
      _controller = value;
    }

    //----------------------------------
    // keySource
    //----------------------------------

    private var _keySource : int = 0;
    public static function get keySource( ) : int
    {
      return instance.keySource;
    }

    private function get keySource( ) : int
    {
      return _keySource;
    }

    private function set keySource(value:int):void
    {
      _keySource = value;
    }

    //----------------------------------
    // keyName
    //----------------------------------

    private static const DEFAULT_KEY_NAME : String = "menu";
    private var _keyName : String;
    public static function get keyName() : String
    {
      return instance.keyName;
    }

    private function get keyName() : String
    {
      return ( _keyName ) ? ( _keyName ) : ( DEFAULT_KEY_NAME );
    }

    private function set keyName( value:String ):void
    {
      _keyName = value;
    }

    //----------------------------------
    // poweronId
    //----------------------------------

    private var _poweronId : String = "";
    public static function get poweronId() : String
    {
      return instance.poweronId;
    }

    private function get poweronId() : String
    {
      return _poweronId;
    }

    private function set poweronId(value:String):void
    {
      _poweronId = value;
    }

    //----------------------------------
    // sessionId
    //----------------------------------

    private var _sessionId : String;
    public static function get sessionId() : String
    {
      return instance.sessionId;
    }

    //[Bindable( event="sessionIdChange" )]
    private function get sessionId() : String
    {
      return _sessionId;
    }

    private function set sessionId( value:String ):void
    {
      var oldValue:String = _sessionId;
      if (oldValue !== value)
      {
        _sessionId = value;
        //if ( hasEventListener("sessionIdChange") )
        //  this.dispatchEvent( new PropertyChangeEvent( "sessionIdChange", false, false, PropertyChangeEventKind.UPDATE, "sessionId", oldValue, value, this) );
      }
    }

    //----------------------------------
    // serviceNum
    //----------------------------------

    private static const DEFAULT_SERVICE_NUM : Number = 1100;//2100;
    private var _serviceNum : Number = NaN;
    public static function get serviceNum() : Number
    {
      return instance.serviceNum;
    }

    private function get serviceNum() : Number
    {
      return ( !isNaN(_serviceNum) ) ? ( _serviceNum ) : ( DEFAULT_SERVICE_NUM );
    }

    private function set serviceNum(value:Number):void
    {
      _serviceNum = value;
    }

    //----------------------------------
    // menuSet
    //----------------------------------

    private static const DEFAULT_MENU_SET : String = "134531";
    private var _menuSet : String;
    public static function get menuSet() : String
    {
      return instance.menuSet;
    }

    private function get menuSet() : String
    {
      return ( _menuSet ) ? ( _menuSet ) : ( DEFAULT_MENU_SET );
    }

    private function set menuSet(value:String):void
    {
      _menuSet = value;
    }

    //----------------------------------
    // appConfigLoader
    //----------------------------------

    private var appConfigLoader:URLLoader;

    //----------------------------------
    // clientd
    //----------------------------------

    public  var bootstrap_url : String = "http://localhost/host/content/marina/hotelHdi/default/1100/service/Bootstrap.hswf";
    private var host          : String = "kirk";
    private var port          : String = "3701";
    private var _clientd      : ClientdConnection;

    public function get clientd():ClientdConnection
    {
      return _clientd;
    }

    /*
    //----------------------------------
    // serviceInfo
    //----------------------------------

    private var serviceInfo : ServiceInfo;

    //----------------------------------
    // mainMenuServiceLink
    //----------------------------------

    private var _mainMenuServiceLink : ServiceLink;

    private var host:String;
    private var port:String;
    public static function get mainMenuServiceLink():ServiceLink
    {
      return instance.mainMenuServiceLink;
    }

    public function get mainMenuServiceLink():ServiceLink
    {
      return _mainMenuServiceLink;
    }

    public function set mainMenuServiceLink(value:ServiceLink):void
    {
      _mainMenuServiceLink = value;
    }


    //----------------------------------
    // mainMenuServiceNum
    //----------------------------------

    public static function get mainMenuServiceNum():Number
    {
      return ( instance.mainMenuServiceLink ) ? ( instance.mainMenuServiceLink.service_number ) :
        ( 1101 );
    }
    //*/


    //--------------------------------------------------------------------------
    //
    // Constructor
    //
    //--------------------------------------------------------------------------

    public function EnvironmentContext()
    {
      super();

      // singleton
      if ( !_allowAlloc )
        throw ( new Error( "Error: EnvironmentContext is a static class and should not be instantiated with the new keyword." ) );

      // initialize debugging
      MonsterDebugger.initialize(this);

      // setup application configuration loader
      appConfigLoader = new URLLoader();

      // instantiate clientd connection
      _clientd = new ClientdConnection();

      // initiate context retrieval
      refresh();
    }


    //--------------------------------------------------------------------------
    //
    // Methods
    //
    //--------------------------------------------------------------------------

    private function configureClientdConnection():void
    {
      // setup clientd connection
      clientd.policyFile = "xmlsocket://" + host + ":8000";
      addSocketEventListeners();

      if ( clientd.connect(host, Number(port) ) )
      {
        // The return value is relatively useless at this point
        // we really have to wait to respond in the event handlers.
      }
      else
      {
        // TODO: handle open failed
      }
    }

    /**
     * Loads the application configuration file.
     *
     * @private
     */
    private function loadAppConfig( ):void
    {
      appConfigLoader.addEventListener( Event.COMPLETE, onAppConfigLoaded );
      appConfigLoader.addEventListener( IOErrorEvent.IO_ERROR, onAppConfigError );
      appConfigLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onAppConfigSecurityError );

      // TODO: create path by referencing swf url
      // open xml file async
      appConfigLoader.load( new URLRequest( "file:///net/solo/host/content/marina/hotelHdi/amp/2100/service/config/config.xml" ) );
      //appConfigLoader.load( new URLRequest( "config/config.xml" ) );
    }

    /**
     * Sentinel to limit concurrent calls to refresh.
     *
     * @private
     */
    private var isRefreshing:Boolean = false;

    /**
     * Initiates a reload operation of the context from various sources.
     * The context load is chained in the following order:
     *
     *   appConfig, launch context, propertyInfo, schedule context
     *
     */
    private function refresh():void
    {
      // limit concurrent calls
      if ( isRefreshing )
        return;

      // TODO: convert event types to constants
      // setup context load chain
      setupAnonymousListener( this, "ConfigurationFileLoaded", configureClientdConnection );
      setupAnonymousListener( this, "ClientdConnectionReady",  requestLaunchContext       );
    //setupAnonymousListener( this, "LaunchContextRetrieved",  requestPropertyInfo        );
    //setupAnonymousListener( this, "PropertyInfoRetrieved",   requestScheduleContext     );
    //setupAnonymousListener( this, "ScheduleInfoRetrieved",   signalRefreshComplete      );
      setupAnonymousListener( this, "LaunchContextRetrieved",  signalRefreshComplete      );

      // initiate context refresh
      isRefreshing = true;
      loadAppConfig();
    }

    /**
     * Requests the launch context for this session from the clientd web service.
     *
     * @private
     */
    private function requestLaunchContext():void
    {
      var command:GetContext = new GetContext();
      clientd.sendRequest( command, onLaunchContextReady );

      //onLaunchContextReady( null );
    }

    /*
    /**
     * Requests property and room information from web service.
     *
     * @private
     *
    private function requestPropertyInfo():void
    {
      // request property info from clientd
      var command:GetPropertyInfo = new GetPropertyInfo();
      clientd.sendRequest( command, onPropertyInfoReady );

      //Logger.debug("GetPropertyInfo.status = " + status );
    }

    /**
     * Requests schedule data for the bootstrap module.
     *
     * @private
     *
    private function requestScheduleContext():void
    {
      // retrieve bootstrap schedule data with Data
      SchedQuery.getServiceAndModule( onScheduleReady, onScheduleFault, serviceNum, uint(menuSet), language );

      Logger.debug( "serviceNum ='" + serviceNum + "'\n" +
        "menuSet    ='" + menuSet    + "'\n" +
        "language   ='" + language   + "'\n"  );
    }
    //*/

    /**
     * Initiates and event to signal to clients that the context
     * has finished loading.
     *
     */
    private function signalRefreshComplete( ):void
    {
      MonsterDebugger.trace( "EnvironmentContext::signalRefreshComplete", "Firing Complete Event" );
      isRefreshing = false;
      dispatchEvent( new Event( Event.COMPLETE ) );
    }


    //--------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    // Configuration File
    //----------------------------------

    /**
     * Event handler called when the application configuration file has finished
     * loading. It extracts the configuration data and continues the initialization
     * of the environment context.
     *
     * @param event
     *
     */
    private function onAppConfigLoaded( event:Event ):void
    {
      // cleanup
      appConfigLoader.removeEventListener( Event.COMPLETE, onAppConfigLoaded );

      // extract configuration data
      var xml  : XML       = new XML( appConfigLoader.data );
      //SchedQuery._endPoint = xml.child( "FlexRemotingGateway" );
      host                 = xml.child( "Host" );
      bootstrap_url        = xml.child( "Flash6Bootstrap" );

      // validate data
      if ( !host )
        return;

      // continue chain
      dispatchEvent( new Event( "ConfigurationFileLoaded" ) );
    }

    private function onAppConfigError( event:IOErrorEvent ):void
    {
      MonsterDebugger.trace( "EnvironmentContext::onAppConfigError", "IOError experienced when attempting to load config file." );
    }

    private function onAppConfigSecurityError( event:SecurityErrorEvent ):void
    {
      MonsterDebugger.trace( "EnvironmentContext::onAppConfigSecurityError", "SecurityError experienced when attempting to load config file." );
    }

    /*
    //----------------------------------
    // Schedule Context
    //----------------------------------

    /**
     * Event handler called when the retrieval of the bootstrap's schedule
     * data completes.
     *
     * @param event
     *
     *
    private function onScheduleReady(event:ResultEvent):void
    {
      serviceInfo = event.result as ServiceInfo;
      Logger.debug( "**********************************************\n" +
        "id         =" + serviceInfo.id             + "\n" +
        "serviceNum =" + serviceInfo.service_number + "\n" +
        "moduelId   =" + serviceInfo.module.id );

      // continue chain
      dispatchEvent( new Event( "ScheduleInfoRetrieved" ) );
    }

    /**
     * Event handler called when the retrieval of the bootstrap's schedule
     * data fails.
     *
     * @param event
     *
     *
    private function onScheduleFault(event:Event):void
    {
      Logger.debug( "Fault while retrieving bootstrap schedule info: " + event );
    }

    //----------------------------------
    // GetPropertyInfo
    //----------------------------------

    /**
     * Event handler called when the getPropertyInfo web service request
     * completes.
     *
     * @param rsp Server response to property information request.
     *
     *
    private function onPropertyInfoReady( rsp:ServerResponse ):void
    {
      // extract property, room, terminal info
      // query bootstrap schedule context

      var propInfo:GetPropertyInfoResponse = rsp.factory.getPropertyInfo();
      Logger.debug("id       = "+propInfo.lodgenetPropertyId);
      Logger.debug("propName = "+propInfo.propertyName);
      Logger.debug("address  = "+propInfo.propertyAddress);
      Logger.debug("city     = "+propInfo.propertyAddress.city);
      var d:Dictionary = propInfo.propertyAddress.addressLines;

      var al:AddressLine = d[1];
      Logger.debug("adress  = " + al.address);
      Logger.debug("tvterm  = " + propInfo.tvtermSummary.termAddress);
      Logger.debug("menuSet = " + propInfo.tvtermSummary.menuSet);
      Logger.debug("room    = " + propInfo.room);
      Logger.debug("roomId  = " + propInfo.room.roomId);
      Logger.debug("checkIn = " + propInfo.room.checkInTime);
      Logger.debug("lastMod = " + propInfo.room.lastModified);
      Logger.debug("hotel   = " + propInfo.room.hotel);
      Logger.debug("credit  = " + propInfo.room.hotel.creditLimit);


      var menuSet : Number = propInfo.tvtermSummary.menuSet;
      instance.menuSet = ( menuSet != 0 ) ? String( menuSet ) : null;

      // continue chain
      dispatchEvent( new Event( "PropertyInfoRetrieved" ) );
    }
    //*/

    //----------------------------------
    // GetContext
    //----------------------------------

    /**
     * Event handler called when the getContext web service call completes.
     *
     * @param rsp Generic server response object encapsulating launch context.
     *
     */
    private function onLaunchContextReady( rsp:ServerResponse ):void
    {
      var contextInfo:GetContextResponse = rsp.factory.getContext();
      language   = contextInfo.context.language;
      //entryPoint = ContextString.parse( contextInfo.context.entryPoint );
      controller = contextInfo.context.controller;
      keySource  = contextInfo.context.keySource;
      keyName    = contextInfo.context.keyName;
      poweronId  = contextInfo.context.poweronId;
      sessionId  = contextInfo.context.sessionId;

      dispatchEvent( new Event( "LaunchContextRetrieved" ) );
    }

    //----------------------------------
    // clientd connection
    //----------------------------------

    /**
     * Event handler to trigger the property information request once
     * the clientd connection is open.
     *
     * @param event PropertyChangeEvent for clientd socket status.
     *
     */
    private function onSocketStatusChange( event:PropertyChangeEvent ):void
    {
      //Logger.debug( "onSockteStatusChange : " + event );
      if ( event.source   !== clientd )                                           return;
      if ( event.property !=  "status" )                                          return;
      if ( event.kind     !=  PropertyChangeEventKind.UPDATE )                    return;
      if ( clientd.status !=  SocketConnection.SOCKET_CONNECTION_STATUS_OPEN )    return;
      if ( event.oldValue !=  SocketConnection.SOCKET_CONNECTION_STATUS_OPENING ) return;

      // continue chain
      dispatchEvent( new Event( "ClientdConnectionReady" ) );
    }

    /**
     * Event handler called when the socket connection to clientd is closed.
     *
     * @param event
     *
     */
    private function onSocketClosed( event:SocketConnectionEvent ):void
    {
      MonsterDebugger.trace( "EnvironmentContext::onSocketClosed", String( event ) );

      removeSocketEventListeners();
    }

    /**
     * Event handler called when the socket connection to clientd experiences
     * an error.
     *
     * @param event
     *
     */
    private function onSocketError( event:SocketConnectionEvent ):void
    {
      MonsterDebugger.trace( "EnvironmentContext::onSocketError", String( event ) );

      removeSocketEventListeners();
    }

    /**
     * Listen for events that signify interuption of clientd communications.
     *
     */
    private function addSocketEventListeners():void
    {
      clientd.addEventListener(SocketConnection.SOCKET_CONNECTION_END, onSocketClosed);
      clientd.addEventListener(SocketConnection.SOCKET_CONNECTION_ERROR, onSocketError);
      clientd.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onSocketStatusChange);
    }

    /**
     * Stop listening for events that signify interuption of clientd communications.
     *
     */
    private function removeSocketEventListeners():void
    {
      clientd.removeEventListener(SocketConnection.SOCKET_CONNECTION_END, onSocketClosed);
      clientd.removeEventListener(SocketConnection.SOCKET_CONNECTION_ERROR, onSocketError);
      clientd.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onSocketStatusChange);
    }

    //----------------------------------
    // Helper
    //----------------------------------

    private static function setupAnonymousListener( ed:IEventDispatcher, type:String, callback:Function ):void
    {
      // TODO: consider adding try/catch around callback method calls
      // TODO: implement listener removal when chain breaks
      var removeListener : Function = function ():void
      {
        ed.removeEventListener(type, eventHandler);
      };

      var eventHandler : Function = function ( e:Event ):void
      {
        removeListener();
        callback( );
      };

      ed.addEventListener(type, eventHandler);
    }
  }
}