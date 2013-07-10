package gordon.core
{
	import gordon.core.interfaces.ITick;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	/**
	 * 循环管理器 
	 * 通过循环管理器可以对每一frame应该执行的事务进行管理。
	 */
	public class Looper
	{
		private static var _instance:Looper = null;
		
		private var _tickedComponents:Array = new Array();
		private var _animatedComponents:Array = new Array();
		private var _scheduledEvents:Array = new Array();
		private var _running:Boolean = false;
		private var _lastTime:Number = -1;
		private var _elapsed:Number = 0;
		private var _interpolation:Number = 0;
		private var _mainSprite:Sprite;
		private var _gameTime:Number = 0;
		private var _delayTime:int = 1000/25;//按照帧频25，每帧的时间
		private var _cumulativeTime:int = 0;//累计延迟时间
		private var _oldTime:int = 0;
		private var _newTime:int = 0;
		private var _stage:Stage;

		public static function getInstance():Looper
		{
			if (!_instance)
				_instance = new Looper();
			
			return _instance;
		}
		
		public function Looper()
		{
			
		}
		
		/**
		 * Destroys this method.
		 */
		public function destroy():void
		{
			if (_running)
				stop();
			_tickedComponents = null;
			_animatedComponents = null;
			_scheduledEvents = null;
			_instance = null;
		}
		
		public function get running():Boolean
		{
			return _running;
		}
		
		public function get gameTime():Number
		{
			return _gameTime;
		}
		
		/**
		 * Starts the game loop.
		 * 传入舞台
		 */
		public function run(mainSprite:Sprite):void
		{
			if (_running)
				throw new Error("正在运行，无法再次运行");
			
			_running = true;
			_mainSprite = mainSprite;
			_lastTime = -1;
			_elapsed = 0;
			_oldTime = getTimer();
			
			_mainSprite.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/**
		 * 停止
		 */
		public function stop():void
		{
			if (!_running)
				throw new Error("已经停止，无法再停止");
			
			_running = false;
			_mainSprite.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/**
		 * 添加enterframe的组件
		 */
		public function addTickedComponent(component:ITick):void
		{
			//			trace('add tick component...');
			_tickedComponents.sortOn("tickPriority", Array.DESCENDING | Array.NUMERIC);
			addComponent(component, _tickedComponents);
		}
		
		/**
		 * 去除enterframe组件
		 */
		public function removeTickedComponent(component:ITick):void
		{
			removeComponent(component, _tickedComponents);
		}
		
		/**
		 * 是否已经添加了组件
		 */
		public function hasTickedComponent(component:ITick):Boolean
		{
			return _tickedComponents.indexOf(component) != -1;
		}
		
		/**
		 * enterframe...
		 */		
		private function onEnterFrame(event:Event):void
		{
			_newTime = getTimer();
			_cumulativeTime +=(_newTime - _oldTime);
			var count:int = Math.round(_cumulativeTime/_delayTime);
			//			trace(new_time - old_time+'    '+Math.round(cumulative_time/delay_time));
			if( count>0 && count <= 3 )
			{
				advance();
				_cumulativeTime = 0;
			}
			else if( count > 3 )
			{
				while(_cumulativeTime >= _delayTime)
				{
					advance();
					_cumulativeTime = _cumulativeTime-_delayTime;
				}
			}
			else
			{
				advance();
				_cumulativeTime = 0;
			}
			
			_oldTime = getTimer();
		}
		
		/**
		 * The primary advance call in the loop.
		 */
		private function advance():void
		{
			for each (var tickedComponent:ITick in _tickedComponents)
			tickedComponent.onTick();
			
			//			var n:int = _scheduledEvents.length - 1;
			//			for (var i:int = n; i >= 0; i--)
			//			{
			//				var scheduledEvent:ScheduledEventInfo = _scheduledEvents[i];
			//				if (scheduledEvent.time <= gameTime)
			//				{
			//					_scheduledEvents.splice(i, 1);
			//					scheduledEvent.event(scheduledEvent.param);
			//				}
			//			}
			//			
			//			_gameTime++;
		}
		/**
		 * 添加组件
		 */
		private function addComponent(component:Object, array:Array):void
		{
			if (array.indexOf(component) != -1)
				throw new Error("这个组件已经添加过了。");
			
			array.push(component);
		}
		
		/**
		 * 去除组件
		 */
		private function removeComponent(component:Object, array:Array):void
		{
			if (array.indexOf(component) == -1)
				throw new Error("没有找到该组件，无法删除组件");
			
			array.splice(array.indexOf(component), 1);
		}
	}
}