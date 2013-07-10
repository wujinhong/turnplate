package com.fanhougame.framework.helper.stimuli.loading.loadingtypes
{
	
	import com.fanhougame.framework.helper.stimuli.loading.BulkLoader;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.ApplicationDomain;
	import flash.utils.*;
    /** @private */
	public class ImageItem extends LoadingItem {
        public var loader : Loader;
        private var applicationDomain:ApplicationDomain;
		public function ImageItem(url : URLRequest, type : String, uid : String){
			specificAvailableProps = [BulkLoader.CONTEXT];
			super(url, type, uid);
		}
		
		override public function _parseOptions(props : Object)  : Array{
            _context = props[BulkLoader.CONTEXT] || null;
            
            return super._parseOptions(props);
        }
        
		override public function load() : void{
		    super.load();
		    loader = new Loader();
		    loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler, false, 0, true);
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler, false, 0, true);
            loader.contentLoaderInfo.addEventListener(Event.INIT, onInitHandler, false, 0, true);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false, 100, true);
            loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler, false, 0, true);
            loader.contentLoaderInfo.addEventListener(Event.OPEN, onStartedHandler, false, 0, true);  
            loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, super.onHttpStatusHandler, false, 0, true);
            try{
            	// TODO: test for security error thown.
            	loader.load(url, _context);
            }catch( e : SecurityError){
            	onSecurityErrorHandler(_createErrorEvent(e));
            }
            
		};
		
        public function _onHttpStatusHandler(evt : HTTPStatusEvent) : void{
            _httpStatus = evt.status;
            dispatchEvent(evt);
        }
        
        override public function onErrorHandler(evt : ErrorEvent) : void{
            super.onErrorHandler(evt);
        }
        
        public function onInitHandler(evt : Event) :void{
            dispatchEvent(evt);
        }
        
        override public function onCompleteHandler(evt : Event) : void 
        {
			try
			{
				applicationDomain = LoaderInfo(evt.target).applicationDomain;
				_content = loader.content;
				super.onCompleteHandler(evt);
			}
			catch(e : SecurityError)
			{
				_content = loader;
				super.onCompleteHandler(evt);
			}
	 
		}
		override public function getDefinition(pClassDefinition:String):*
		{
			try
			{
				return applicationDomain.getDefinition(pClassDefinition) as Class;
			}
			catch (err:Error)
			{
				return null;
			}
		}
        
        override public function stop() : void{
            try{
                if(loader){
                    loader.close();
                }
            }catch(e : Error){
                
            }
            super.stop();
        };
        
        /** Gets a  definition from a fully qualified path (can be a Class, function or namespace). 
            @param className The fully qualified class name as a string.
            @return The definition object with that name or null of not found.
        */
        public function getDefinitionByName(className : String) : Object{
            if (loader.contentLoaderInfo.applicationDomain.hasDefinition(className)){
                return loader.contentLoaderInfo.applicationDomain.getDefinition(className);
            }
            return null;
        }
        
        override public function cleanListeners() : void {
            if (loader){
                var removalTarget : Object = loader.contentLoaderInfo;
                removalTarget.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler, false);
                removalTarget.removeEventListener(Event.COMPLETE, onCompleteHandler, false);
                removalTarget.removeEventListener(Event.INIT, onInitHandler, false);
                removalTarget.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false);
                removalTarget.removeEventListener(BulkLoader.OPEN, onStartedHandler, false);
                removalTarget.removeEventListener(HTTPStatusEvent.HTTP_STATUS, super.onHttpStatusHandler, false);
            }
            
        }
        
        override public function isImage(): Boolean{
            return (type == BulkLoader.TYPE_IMAGE);
        }
        
        override public function isSWF(): Boolean{
            return (type == BulkLoader.TYPE_MOVIECLIP);
        }
        
        override public function destroy() : void{
            stop();
            cleanListeners();
            _content = null;
            loader = null;
        }
        
        
	}
	
}
