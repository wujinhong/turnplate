package gordon.view
{
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import gordon.core.Notifier;
	import gordon.model.Model;

	/**
	 * 演出 抽象类
	 **/
	public class Show extends Notifier
	{
		protected var _show_name:String;  // 名称
		
		protected var _stage:Sprite = new Sprite();  // 舞台
		
		protected var _layers:Array = []; // 场景层次
		
		protected var _actors:Array = []; // 演员列表
		
		protected var _binded_data:Object = {};	// 绑定的数据
		
		public function Show(show_name:String)
		{
			if(getQualifiedClassName(this)=='com.fanhougame.framework.view::Show')
			{
				throw new Error('Error: Show 是抽象类，不能实体化');
			}
			this._show_name = show_name;
		}
		
		/**
		 * 获取Show名称
		 **/
		public function get Name():String
		{
			return this._show_name;
		}
		
		/**
		 * 添加场景布局层次
		 **/
		public function addLayer(layer_name:String):void
		{
			this._layers[layer_name] = new Sprite();
			this._stage.addChild(this._layers[layer_name]);
		}
		
		/**
		 * 获取表演层
		 **/
		public function getLayer(layer_name:String):Sprite
		{
			if(this._layers[layer_name])
				return this._layers[layer_name];
			else
				return null;
		}
		
		/**
		 * 移除场景布局层次
		 **/
		public function removeLayer(layer_name:String):void
		{
			if(this._layers[layer_name])
			{
				this._layers[layer_name] = null;
				delete this._layers[layer_name];	
			}
		}
		
		/**
		 *  为当前演出添加演员
		 **/
		public function addActor(actor:Actor, layer:String=null, x:Number=0, y:Number=0):void
		{
			if(this._actors[actor.Name])
				throw new Error('Error: Actor 不能重名!'+actor.Name);
			
			this._actors[actor.Name] = actor;
			
//			this.registerCallback(
//			
//			this.regActorClose(actor);
			
			if(layer == null || !this._layers[layer])  // layer 为空， 或者指定 layer 不存在
				actor.act(this._stage);
			else
				actor.act(this._layers[layer]);
				
			if(x != 0 || y != 0)
			{
				actor.x = x;
				actor.y = y;
			}
		}
		public function regAddActor(actor:Actor, layer:String=null, x:Number=0, y:Number=0):void
		{
			this.addActor(actor, layer, x, y);
			this.regActorClose(actor);
		}
		private function regActorClose(actor:Actor):void
		{
//			var arr:Array = getQualifiedClassName(actor).split('::');
//			var _class_name:String = arr[1];
//			
//			if(!this.hasOwnProperty('close'+_class_name))
//			{
				var actor_class:Class= getDefinitionByName(getQualifiedClassName(actor)) as Class;
				
				if(actor_class.hasOwnProperty('CLOSE'))
				{
					var close_fun:Function = function():void
					{
						removeRegActor.call(this,actor_class, arguments.callee);
					}
					this.registerCallback(actor_class.CLOSE, close_fun);
				}
//			}
		}
		public function removeRegActor(actor_class:Class,fun:Function):void
		{
			if(this.getActor(actor_class.NAME))
			{
				this.removeActor(actor_class.NAME);
				this.removeCallback(actor_class.CLOSE, fun);
			}
		}
		
		/**
		 *  获取指定演员
		 **/
		public function getActor(actor_name:String):Actor
		{
			return this._actors[actor_name];
		}
		
		/**
		 *  为当前演出删除演员
		 **/
		public function removeActor(actor_name:String):void
		{
			if(this._actors[actor_name])
			{
				(this._actors[actor_name] as Actor).cleanUp();
				this._actors[actor_name]=null;
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
					this._binded_data[model_name][property][index] = null;
				}
			}
		}
				
		/**
		 *  清空
		 **/
		public function cleanUp():void
		{
			this.clear();
			
			this.cleanAllCallback();
			
			for(var i:String in this._actors)
			{
				this.removeActor(i);
			}
			this._actors = null;
			
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
			
			this._stage.parent.removeChild(this._stage);
			this._stage = null;
			
			_notification_manager = null;
		}
		
		protected function clear():void{}
	}
}