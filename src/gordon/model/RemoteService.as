package gordon.model
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import gordon.core.Notifier;
	
	/**
	 * 数据交互服务
	 * @author 
	 */
	public class RemoteService extends Notifier
	{
		/**
		 * 服务失败
		 */
		public static const FALSE_IN_SERVICE:String = 'false_in_service';
		/**
		 * 服务成功
		 */
		public static const SUCCESS_IN_SERVICE:String = 'success_in_service';
		/**
		 * 服务名称
		 */
		protected var _service_name:String;
		/**
		 * 远程连接地址
		 */
		protected var _gateway_url:String;
		/**
		 * 当前function
		 */
		protected var _current_function:String;
		
		protected var _encode:Boolean = true;
		
		protected var _game:Game = Game.getInstance();
		
		protected var _game_config:GameConfig = GameConfig.getInstance();
		/**
		 * 远程服务
		 */
		public function RemoteService(service_name:String = null)
		{
//			trace('service: JSON');
			this._service_name = service_name;
			//服务地址
			this._gateway_url = this._game_config.service_gateway_url;
		}
		
		public function call(action_name:String,...params):void
		{
			this._current_function = action_name;
			
			var data:URLVariables = new URLVariables();
			data.service = this._service_name;
			data.action = action_name;
			
			data.params = JSON.encode(params);

			var req:URLRequest = new URLRequest(this._gateway_url);
			req.method =URLRequestMethod.POST;
			req.data = data;
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, report);
			loader.addEventListener(Event.COMPLETE, successInService);
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			loader.load(req);
		}
		
		private function report(e:HTTPStatusEvent):void
		{
			if(e.status == 200)
			{
				return;
			}
			if(e.status == 0)
			{
//				trace('报错，特殊环境');
				return;
			}
			
			this.faultInService(e);
			
			switch (e.status)
			{
				case 404: // 找不到指定路径
					this.sendNotification(Game.KEY_ERROR,'errcode',103);
					break;
				case 500:  // 服务器错误
					this.sendNotification(Game.KEY_ERROR,'errcode',104);
					break;
				default:
					this.sendNotification(Game.KEY_ERROR,'errcode',102);
					break;
			}
			
		}
		
		
		protected function successInService(e:Event):void
		{
//			trace('远程服务成功');
			var result:Object = URLLoader(e.target).data;
			//trace('data: '+ result.toString());
			var data:Object = new Object();
			try
			{
				data = JSON.decode(result.toString());
				//Debuger.dump(data);
			}
			catch(e:Error)
			{
				trace("格式错误................");
				return;
			}
			
			// 错误信息
			if(data)
			{
				this.ServiceDoneHandler(data);
			}
		}
		
		/**
		 * 服务失败
		 * @param e
		 */
		protected function faultInService(e:HTTPStatusEvent):void
		{
			//Debuger.dump(e);
			trace('远程服务失败');
			this.sendNotification(FALSE_IN_SERVICE);
		}
		private function ServiceDoneHandler(result:Object):void
		{
			if(result['key_error'])
			{
				this.sendNotification(Game.KEY_ERROR,'key_error');
				return;
			}
			if(result['errcode'])
			{
				if(_game_config.error_list(result['errcode']))
				{
					this.sendNotification(Game.KEY_ERROR,'errcode',result['errcode']);
					return;
				}
			}
			ServiceDone(result);
		}
		/**
		 * @param event
		 */
		protected function ServiceDone(result:Object):void
		{
			this.sendNotification(SUCCESS_IN_SERVICE,result);
		}
		protected function errorHandler(e:IOErrorEvent):void
		{
			trace('请求服务器失败');
			this.sendNotification(Game.KEY_ERROR,'errcode',102);
		}
	}
}