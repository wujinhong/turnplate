package gordon.view
{
	import flash.display.DisplayObjectContainer;
	
	public class Scene extends Show
	{
		protected var _fragments:Array = [];  // 片段管理器
		
		public function Scene(scene_name:String)
		{
			super(scene_name);
		}
		
		/**
		 *  显示当前演出
		 **/
		public function action(stage:DisplayObjectContainer):void
		{
			stage.addChild(this._stage);
		}
		
		/**
		 * 加入片段
		 **/
		public function addFragment(fragment:Fragment, layer:String=null, x:Number = 0, y:Number = 0):void
		{
			if(this._fragments[fragment.Name])
				throw new Error('Error: Fragment '+fragment.Name+' 重复！');
				
			this._fragments[fragment.Name] = fragment;
			
			if(layer == null || !this._layers[layer])
				fragment.play(this._stage,x,y);
			else
				fragment.play(this._layers[layer],x,y);
		}
		
		public function getFragement(fragment_name:String):Fragment
		{
			return this._fragments[fragment_name];
		}
		
		/**
		 * 移除指定片段
		 **/
		public function removeFragment(fragment_name:String):void
		{
			if(this._fragments[fragment_name])
			{
				(this._fragments[fragment_name] as Fragment).cleanUp();
				this._fragments[fragment_name] = null;
			}
		}
		
		/**
		 *  清空
		 **/
		override public function cleanUp():void
		{
			for(var i:String in this._fragments)  // 清除片段
			{
				this.removeFragment(i);
			}
			for (var j:String in this._layers)
			{
				this.removeLayer(j);
			}
			super.cleanUp();
		}
		
	}
}