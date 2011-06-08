package com.lnet.utils
{
  import com.demonsters.debugger.MonsterDebugger;
  import com.lnet.common.clientd.commands.client.ClientRequestEvent;
  import com.lnet.common.clientd.commands.client.resource.AllocateEdict;
  import com.lnet.common.clientd.commands.client.resource.CleanupEdict;
  import com.lnet.common.clientd.commands.client.resource.DeallocateEdict;
  import com.lnet.common.clientd.commands.client.resource.DeniedEdict;
  import com.lnet.common.clientd.commands.response.ServerResponse;
  import com.lnet.common.clientd.commands.server.resource.Allocate;
  import com.lnet.common.clientd.commands.server.resource.Deallocate;
  import com.lnet.common.clientd.commands.server.resource.Ready;
  import com.lnet.common.keys.RemoteKeyConst;
  
  import flash.display.Stage;
  import flash.events.Event;
  import flash.events.KeyboardEvent;
  
  import mx.core.FlexGlobals;


  public class InteractiveSessionManager extends Object
  {
    //--------------------------------------------------------------------------
    //
    // Class Methods
    //
    //--------------------------------------------------------------------------

    public static const SERVICE_COMPLETE:String = "serviceComplete";

    //----------------------------------
    // Singleton
    //----------------------------------

    private static var _instance : InteractiveSessionManager;
    public static function get instance():InteractiveSessionManager
    {
      if ( !_instance )
        init();
      return _instance;
    }

    public static function init():void
    {
      if ( _instance )
        return;

      _instance = new InteractiveSessionManager();
    }


    //--------------------------------------------------------------------------
    //
    // Constructor
    //
    //--------------------------------------------------------------------------

    public function InteractiveSessionManager()
    {
      super();

      MonsterDebugger.initialize(this);
      EnvironmentContext.init();
      EnvironmentContext.addEventListener( Event.COMPLETE, onEnvironmentContextComplete );
    }

    //--------------------------------------------------------------------------
    //
    // Methods
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    // Helper
    //----------------------------------

    private function setupGlobalRemoteKeyListeners( ):void
    {
      FlexGlobals.topLevelApplication.stage.addEventListener(KeyboardEvent.KEY_UP, onRemoteKeyPress);
      FlexGlobals.topLevelApplication.addEventListener( SERVICE_COMPLETE, onServiceComplete );
    }

    //----------------------------------
    // Clientd Communications
    //----------------------------------

    private function sendReady():void
    {
      var command : Ready = new Ready();
      command.resource = 'amp';
      EnvironmentContext.instance.clientd.sendRequest( command, readyResponseHandler );
    }

    private var processing : Boolean = false;
    private function loadMainMenu():void
    {
      // limit requests
      if ( processing ) return;
      processing = true;

      // construct context
      var context:XML = <context lang="en" entryPoint="service=1101|entry=top" controller="1" keySource="12" keyName="menu" poweronID="" sessionID="" />;
      context.@poweronID = EnvironmentContext.poweronId;
      context.@sessionID = EnvironmentContext.sessionId;

      // configure request
      var allocate:Allocate = new Allocate();
      allocate.context = context.toXMLString();
      allocate.url = EnvironmentContext.instance.bootstrap_url;

      // send request
      EnvironmentContext.instance.clientd.sendRequest(allocate, allocateResponseHandler);
    }

    private function deallocateSession(justMe:Boolean):void {
      var dealloc:Deallocate = new Deallocate();
      dealloc.resource = (justMe) ? "amp" : "all";
      EnvironmentContext.instance.clientd.sendRequest( dealloc, deallocateResponseHandler );
    }

    //----------------------------------
    // Callbacks
    //----------------------------------

    private function allocateResponseHandler( response:ServerResponse ):void
    {
      processing = response.getSuccess();
      MonsterDebugger.trace(  "StreamingVideoApp::allocateResponseHandler", "success = " + response.getSuccess() );
    }

    private function deallocateResponseHandler( response:ServerResponse ):void
    {
      MonsterDebugger.trace( "StreamingVideoApp::deallocateResponseHandler", "success = " + response.getSuccess() );
    }

    private function readyResponseHandler( response:ServerResponse ):void
    {
      MonsterDebugger.trace( "StreamingVideoApp::readyResponseHandler", "success = " + response.getSuccess() );
      setupGlobalRemoteKeyListeners();
    }

    //----------------------------------
    // Edicts
    //----------------------------------

    private function allocateEdict( event:ClientRequestEvent ):void
    {
      var allocateEdict:AllocateEdict = event.edict as AllocateEdict;

      MonsterDebugger.trace( "StreamingVideoApp::allocateEddict", "allocateEdict received" );
    }

    private function deniedEdict( event:ClientRequestEvent ):void
    {
      var deniedEdict:DeniedEdict = event.edict as DeniedEdict;

      MonsterDebugger.trace( "StreamingVideoApp::deniedEddict", "deniedEdict received" );
    }

    private function cleanupEdict( event:ClientRequestEvent ):void
    {
      var cleanupEdict:CleanupEdict = event.edict as CleanupEdict;

      MonsterDebugger.trace( "StreamingVideoApp::cleanupEddict", "cleanupEdict received" );

      deallocateSession(true);
    }

    private function deallocateEdict( event:ClientRequestEvent ):void
    {
      var deallocateEdict:DeallocateEdict = event.edict as DeallocateEdict;

      MonsterDebugger.trace( "StreamingVideoApp::deallocateEddict", "deallocateEdict received" );
    }

    //----------------------------------
    // Event Handlers
    //----------------------------------

    private function onEnvironmentContextComplete( e:Event ):void
    {
      // register edict listeners
      EnvironmentContext.instance.clientd.addEventListener( ClientRequestEvent.RESOURCE_ALLOCATE,   allocateEdict   );
      EnvironmentContext.instance.clientd.addEventListener( ClientRequestEvent.RESOURCE_DENIED,     deniedEdict     );
      EnvironmentContext.instance.clientd.addEventListener( ClientRequestEvent.RESOURCE_CLEANUP,    cleanupEdict    );
      EnvironmentContext.instance.clientd.addEventListener( ClientRequestEvent.RESOURCE_DEALLOCATE, deallocateEdict );

      sendReady();
    }

    private function onRemoteKeyPress( e:KeyboardEvent ):void
    {

      if ( e.keyCode == RemoteKeyConst.MENU )
        loadMainMenu();
      else if ( e.keyCode == RemoteKeyConst.EXIT )
        deallocateSession(false);

      // TODO : handle back key when in correct state
    }

    private function onServiceComplete(event:Event):void
    {
      loadMainMenu();
    }
  }
}