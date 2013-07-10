package com.fanhougame.framework.view
{
	/**
	 * PopUpScreen 处理UI上对话框的相关事件...
	 * 
	 ***/ 
	public class PopUpScreen extends AssetActor
	{
		
		public function PopUpScreen(actor_name:String, link_name:String)
		{
			super(actor_name, link_name);
			this.sendNotification(actor_name+'CREATED');
		}
		
		
		
	}
}