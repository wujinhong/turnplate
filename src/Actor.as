package
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.system.System;
	import flash.utils.getQualifiedClassName;

	public class Actor
	{
		protected var _actor_name:String;  // 演员名称
		
		protected var _body:MovieClip = new MovieClip();  // 演员component
		
		protected var _scene:DisplayObjectContainer; //演员当前演出场景
		
		protected var _binded_actor:Object = {}; // 捆绑上的演员
		
		protected var _binded_data:Object = {};	// 绑定的数据
		

		protected var _ThenCallAtFrame:Object;
		
	    protected var _playToThenCallback:Function;
	    
	    protected var _living:Boolean = true; //是否存活着
		
		private var _scale_balance_lock:Boolean = false;
		
		private var _scale_x:Number;
		
		private var _scale_y:Number;
		
		protected var _width:Number;
		
		protected var _height:Number;
		
		public function Actor(name:String)
		{
			if(getQualifiedClassName(this)=='com.fanhougame.framework.view::Actor')
			{
				throw new Error('Error: Actor 是抽象类，不能实体化');
			}
			this._actor_name = name;
			this._scene = null;
		}
		
		private var _resitArr:Array = [];
		/**
		 *注册悬浮提示 
		 * @param mc
		 * @param info
		 * 
		 */		
		public function registTip(mc:DisplayObject,info:String):void
		{
			if(_resitArr.indexOf(mc) < 0)
			{
				_resitArr.push(mc);
			}
		}
		/**
		 * 
		 * @param mc
		 * 
		 */		
		protected function unRegistTip(mc:DisplayObject):void
		{
			if(_resitArr.indexOf(mc) >= 0)
			{
				_resitArr.splice(mc);
			}
		}
		
		/**
		 * 删除tooltips 
		 * 
		 */		
		private function clearAllTips():void
		{
			while(_resitArr.length > 0)
			{
				unRegistTip(_resitArr[0]);
			}
			_resitArr = [];
		}
		
		/**
		 * 在指定场景开始演出
		 **/
		public function act(scene:DisplayObjectContainer):void
		{
			this._scene = scene;
			if (scene)
			scene.addChild(this._body);
			actFinished();
		}
		protected function actFinished():void
		{
			
		}
		/**
		 * 把自己和其他演员捆绑在一起
		 **/
		public function bindActor(actor:Actor, layer:String=null, x:Number=0, y:Number=0):void
		{
			if(layer)
			{
				var to_layer:MovieClip = this.body.getChildByName(layer) as MovieClip;
				
				if(to_layer)
				{
					actor.act(to_layer);
				}
				else
				{
					throw new Error('bindActor 找不到:'+layer);
				}
			}
			else
			{
				actor.act(this._body);
			}
			
			this._binded_actor[actor.Name] = actor;
			actor.screenPosition=new Point(x,y);
		}
		
		/**
		 * 把自己和其他演员捆绑在一起
		 **/
		public function bindLayer(actor:Actor, layer:DisplayObjectContainer=null, x:Number=0, y:Number=0):void
		{
			if(layer)
			{
				if(layer)
				{
					actor.act(layer);
				}
				else
				{
					throw new Error('bindActor 找不到:'+layer.name);
				}
			}
			else
			{
				actor.act(this._body);
			}
			
			this._binded_actor[actor.Name] = actor;
			actor.screenPosition=new Point(x,y);
		}
		
		/**
		 * 和指定演员解除绑定
		 **/
		public function unbindActor(actor_name:String):void
		{
			if(this._binded_actor[actor_name])
			{
				(this._binded_actor[actor_name] as Actor).cleanUp();
				this._binded_actor[actor_name] = null;
			}
		}
		
		/**
		 * 绑定数据
		 **/
		public function bindData(model:Model,property:String,func:Function):void
		{
			if(property == 'model')
			{
				throw new Error('model 为关键字不能作为参数名!');
			}
			if(this._binded_data[model.Name]) // 如果该模型存在
			{
				if(!this._binded_data[model.Name][property]) // 如果该参数未被绑定
				{	
					this._binded_data[model.Name][property] = [];
				}
			}
			else
			{
				this._binded_data[model.Name] = {};
				this._binded_data[model.Name]['model'] = model;
				this._binded_data[model.Name][property] = [];
			}
			this._binded_data[model.Name][property].push(func);
			
			model.bind(property,func);
		}
		
		/**
		 * 解除数据绑定
		 **/
		public function unbindData(model_name:String, property:String, func:Function):void
		{
			if(this._binded_data[model_name] && this._binded_data[model_name][property])
			{
				var index:int = this._binded_data[model_name][property].indexOf(func);
				if(index>=0)
				{
					this._binded_data[model_name].model.unbind(property,func); // 解除绑定
					this._binded_data[model_name][property][index] = null
				}
			}
		}
		/**
		 * 执行cleanup前执行
		 **/ 
		protected function clear():void
		{
			
		}

		/**
		 * 清空Actor
		 **/	
		public function cleanUp():void
		{ 
			clear();
			clearAllTips();
			_living = false;
			
			this.cleanUpBindData();
			this.cleanUpbody();
//			gc();
		}
		
		protected function cleanUpBindData():void
		{
			for(var i:String in this._binded_actor)
			{
				this.unbindActor(i);  // 清除 绑定演员
			}
			this._binded_actor = null;
			
			// 清除绑定数据
			for(var model:String in this._binded_data)
			{
				for(var property:String in this._binded_data[model])
				{
					if(property!='model')
					{
						for each(var func:Function in this._binded_data[model][property])
						{
							this.unbindData(model,property,func);
						}
					}
				}
			}
			this._binded_data = null;
		}
		
		protected function cleanUpbody():void
		{
		
			if (this._body && this._body.parent!=null)
			{
				this._body.parent.removeChild(this._body);
			}
			
			this._body = null;
		}
		
		private function gc():void
		{
			System.gc();
		}
		 
		
		/**
		 * 演员移动相对位移
		 **/
		public function move(x:Number,y:Number):void
		{
			if(this._body != null)
			{
				this.moveTo(new Point(this._body.x+x, this._body.y+y));
			}
		}
		
		/**
		 * 演员移动到指定位置, speed 为0时，为立刻到达
		 **/
		public function moveTo(position:Point, time:Number = 0, callback:Function=null):void
		{
			this.screenPosition = position;
		}
	
		/**
		 * 演员旋转指定角度
		 **/
		public function rotateTo(point:Point):void
		{
			this.rotation = Math.atan2(point.y-this.y,point.x-this.x)*180/Math.PI
		}
	
		/**
		 *  动画从指定frame开始执行， gotoAndPlay
		 **/
		public function playAt(frame:Object):void
		{
			if(this._body != null)
			{
				this._body.gotoAndPlay(frame);
			}
		}
		
		/**
		 *  动画停到指定frame. gotoAndStop
		 **/
		public function stopAt(frame:Object):void
		{
			if(this._body != null)
			{
				this._body.gotoAndStop(frame);
			}
		}
		
		
		public function hitTestObject(obj:DisplayObject):Boolean
		{
			return this._body.hitTestObject(obj);
		}
		
		
//-------------------------------------------------------------------------------------
		/**
		 * 获取演员名
		 **/
		public function get Name():String
		{
			return this._actor_name;
		}
		
		/**
		 * 获取 Actor 的Body.
		 **/
		public function get body():MovieClip
		{
			return this._body;
		}
				
		/**
		 * 设置演员 x 坐标
		 **/
		public function set x(value:Number):void
		{
			this._body.x = value;
		}
		
		/**
		 * 获取演员 x 坐标
		 **/
		public function get x():Number
		{
			return this._body.x;
		}
		
		/**
		 * 设置演员 y 坐标
		 **/
		public function set y(value:Number):void
		{
			this._body.y = value;
		}
		
		/**
		 * 获取演员y 坐标
		 **/
		public function get y():Number
		{
			return this._body.y;
		}
		
		/**
		 * 设置演出位置
		 **/
		public function set screenPosition(point:Point):void
		{
			if (this.alive)
			{
				this._body.x = point.x;
				this._body.y = point.y;
			}
		}
		
		/**
		 * 获取演出位置
		 **/
		public function get screenPosition():Point
		{
			if (!this._body) this.printf('.screenPosition error');
			return new Point(this._body.x,this._body.y);
		}
		
		public function set visible(value:Boolean):void
		{
			this._body.visible = value;
		}
		public function get visible( ):Boolean
		{
			return	this._body.visible 
		}
		public function set scaleX(value:Number):void
		{
			this._body.scaleX = value;
			if (this._scale_balance_lock)
			{
				this._body.scaleY = value;
			}
			this._scale_x = value;
		}
		
		public function set scaleY(value:Number):void
		{
			this._body.scaleY = value;	
			if (this._scale_balance_lock)
			{
				this._body.scaleX = value;
			}
			this._scale_y = value;
		}
		public function get scaleX():Number
		{
			return this._body.scaleX 
		}
		
		public function get scaleY( ):Number
		{
			return this._body.scaleY;
		}
		/**
		 * 锁定xy scale值比例
		 **/ 
		public function get scale_balance_lock():Boolean
		{
			return _scale_balance_lock;
		}
		/**
		 * 锁定xy scale值比例
		 **/ 
		public function set scale_balance_lock(value:Boolean):void
		{
			_scale_balance_lock = value;
		}
		/**
		 * 设置演员宽度
		 **/
		public function set width(value:Number):void
		{
			var scale:Number = value / this._width;
			this.scaleX = scale;
		}
		
		/**
		 * 获取演员宽度
		 **/
		public function get width():Number
		{
			return this._width;
		}
		
		/**
		 * 设置演员高度
		 **/
		public function set height(value:Number):void
		{
			var scale:Number = value / this._height;
			this.scaleY = scale;
		}
		
		
		
		/**
		 * 获取演员高度
		 **/
		public function get height():Number
		{
			return this._body.height;
		}
		
		
		/**
		 * 设置演员角度
		 **/
		public function get rotation():Number
		{
			return this._body.rotation;
		}
		
		/**
		 * 获取演员角度
		 **/
		public function set rotation(value:Number):void
		{
			this._body.rotation=value;
		}
		
		public function get alive():Boolean
		{
			return this._living
		}
		
		public function get baseProperty():Object
		{
			var o:Object = 
			{
				'x':this.x,
				'y':this.y,
				'width':this.width,
				'height':this.height		
			}
			return o;
		}
		
		/**
		 * 获取自己身上的绑定对象 
		 * @return 
		 */		
		public function getbindActor(actor_name:String):Actor
		{
			return this._binded_actor[actor_name] as Actor;
		}

		public function get scene():DisplayObjectContainer
		{
			return _scene;
		}

	}
}