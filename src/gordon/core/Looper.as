package gordon.core
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import gordon.core.interfaces.ITick;
	
	/**
	 * 循环管理器 
	 * 通过循环管理器可以对每一frame应该执行的事务进行管理。
	 */
	public class Looper
	{
		private static var _instance:Looper = null;
		
		private var _ticks:Vector.<ITick> = new Vector.<ITick>();
		private var _running:Boolean = false;
		private var _lastTime:Number = -1;
		private var _elapsed:Number = 0;
		private var _interpolation:Number = 0;
		private var _stage:Stage;
		private var _gameTime:Number = 0;
		private var _delayTime:int;//按照帧频，每帧的时间
		private var _cumulativeTime:int = 0;//累计延迟时间
		private var _oldTime:int = 0;
		private var _newTime:int = 0;

		public static function get():Looper
		{
			if (!_instance)
				_instance = new Looper();
			
			return _instance;
		}
		
		public function Looper( s:Singleton )
		{
			if ( s == null ) 
			{
				throw new Error( "此对象是单例，请通过get()获得" );
			}
		}
		
		/**
		 * Destroys this method.
		 */
		public function destroy():void
		{
			if (_running)
				stop();
			_ticks = null;
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
		public function init( sprite:Stage ):void
		{
			if (_running)
				throw new Error("正在运行，无法再次运行");
			
			_running = true;
			_stage = sprite;
			_delayTime = 1000 /  _stage.frameRate;
			_lastTime = -1;
			_elapsed = 0;
			_oldTime = getTimer();
			
			_stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		/**
		 * run  the game loop again.
		 */
		public function run():void
		{
			if (_running)
				throw new Error("正在运行，无法再次运行");
			
			_running = true;
			_delayTime = 1000 /  _stage.frameRate;
			_lastTime = -1;
			_elapsed = 0;
			_oldTime = getTimer();
			
			_stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/**
		 * 停止
		 */
		public function stop():void
		{
			if ( !_running )
				throw new Error("已经停止，无法再停止");
			
			_running = false;
			_stage.removeEventListener( Event.ENTER_FRAME, onEnterFrame );
		}
		
		/**
		 * 添加enterframe的组件
		 */
		public function addTickedComponent( ticker:ITick ):void
		{
			_ticks.sort( function( ui1:ITick, ui2:ITick ):Number
			{
				if( ui1.priority > ui2.priority )
				{
					return 1;
				}
				else if( ui1.priority < ui2.priority )
				{
					return -1;
				}
				else
				{
					return 0;
				}
			} );
			addComponent( ticker, _ticks );
		}
		
		/**
		 * 去除enterframe组件
		 */
		public function removeTickedComponent(component:ITick):void
		{
			removeComponent(component, _ticks);
		}
		
		/**
		 * 是否已经添加了组件
		 */
		public function hasITick(component:ITick):Boolean
		{
			return _ticks.indexOf(component) != -1;
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
			for each ( var tick:ITick in _ticks )
				tick.onTick();
		}
		/**
		 * 添加组件
		 */
		private function addComponent( ticker:ITick, array:Vector.<ITick> ):void
		{
			if (array.indexOf(ticker) != -1)
				throw new Error("这个组件已经添加过了。");
			
			array.push( ticker );
			
			if ( array.length == 1 )
			{
				run();
			}
		}
		
		/**
		 * 去除组件
		 */
		private function removeComponent(component:ITick, vector:Vector.<ITick>):void
		{
			if (vector.indexOf(component) == -1)
				throw new Error("没有找到该组件，无法删除组件");
			
			vector.splice(vector.indexOf(component), 1);
			
			if ( vector.length == 0 )
			{
				stop();
			}
		}
	}
}
internal class Singleton{}