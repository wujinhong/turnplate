package
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class TurnplateCtrl extends Sprite
	{
		private var _tp:MovieClip;
		/**中间大扇形对应的字符串位置，从0开始**/
		public var idx:int = 0;
		/**玩家最高第几战，从1开始**/
		private var top:int = 0;
		/**每次旋转，扇形旋转次数，从1开始**/
		private var time:int = 0;
		private var _list:Vector.<String>;
		private var leng:uint;
		private var _lastBtn:MovieClip;
		/**单击挑战执行的方法，此方法要有一个int参数**/
		private var _func:Function;
		
		public function TurnplateCtrl(tp:MovieClip, list:Vector.<String>, func:Function)
		{
			_tp = tp;
			_list = list;
			_func = func;
			init();
		}
		private function init():void
		{
			leng = _list.length;
			top = leng - 2;
			idx = top - 1;
			
			_tp.addFrameScript( 9, down, _tp.totalFrames - 1, up );
			
			initTF();
			firstBtn();
			
			initBtn();
		}
		private function firstBtn():void
		{
			_tp.btns.btn0.tf.text = "返回\n第" + top + "战";
		}
		/**
		 *单击按钮面板的六个可单击状态
		 */
		private function mouseEnabled():void
		{
			if ( idx + 2 >= leng )
			{
				_tp.btns.btn1.mouseEnabled = false;
			}
			else
			{
				_tp.btns.btn1.mouseEnabled = true;
			}
			if ( idx + 1 >= leng )
			{
				_tp.btns.btn2.mouseEnabled = false;
			}
			else
			{
				_tp.btns.btn2.mouseEnabled = true;
			}
			if ( idx <= 0 ) 
			{
				_tp.btns.btn3.mouseEnabled = false;
			}
			else
			{
				_tp.btns.btn3.mouseEnabled = true;
			}
			
			if ( idx <= 1)
			{
				_tp.btns.btn4.mouseEnabled =  false;
			}
			else
			{
				_tp.btns.btn4.mouseEnabled = true;
			}
			
			if ( idx <= 2)
			{
				_tp.btns.btn5.mouseEnabled =  false;
			}
			else
			{
				_tp.btns.btn5.mouseEnabled = true;
			}
		}
		/**
		 *单击按钮面板的六个文本，以及一个大扇形的文本
		 */
		private function initTF():void
		{
			_tp.btns.btn1.tf.text = _list[ idx + 2 ] + "\n" + (idx + 3);
			_tp.btns.btn2.tf.text = _list[ idx + 1 ] + "\n" + (idx + 2);
			
			//大扇形的文本
			_tp.btns.btn.tf.text = _list[ idx ] + "\n" + (idx + 1);
			
			if ( idx <= 0)
			{
				_tp.btns.btn3.tf.text = "";
			}
			else
			{
				_tp.btns.btn3.tf.text = _list[ idx - 1 ] + "\n" + (idx + 0);
			}
			
			if ( idx <= 1)
			{
				_tp.btns.btn4.tf.text = "";
			}
			else
			{
				_tp.btns.btn4.tf.text = _list[ idx - 2 ] + "\n" + (idx - 1);
			}
			
			if ( idx <= 2)
			{
				_tp.btns.btn5.tf.text = "";
			}
			else
			{
				_tp.btns.btn5.tf.text = _list[ idx - 3 ] + "\n" + (idx - 2);
			}
		}
		/**
		 * 底部动画10个文本，以及三个大扇形的文本
		 */
		private function initAnimateTF():void
		{
			if ( idx + 4 >= leng )
			{
				_tp.circle.mc0.tf.text = "";
			}
			else
			{
				_tp.circle.mc0.tf.text = _list[ idx + 4 ] + "\n" + (idx + 5);
			}
			
			if ( idx + 3 >= leng )
			{
				_tp.circle.mc1.tf.text = "";
			}
			else
			{
				_tp.circle.mc1.tf.text = _list[ idx + 3 ] + "\n" + (idx + 4);
			}
			
			if ( idx + 2 >= leng )
			{
				_tp.circle.mc2.tf.text = "";
			}
			else
			{
				_tp.circle.mc2.tf.text = _list[ idx + 2 ] + "\n" + (idx + 3);
			}
			
			if ( idx + 1 >= leng )
			{
				_tp.circle.mc3.tf.text = "";
			}
			else
			{
				_tp.circle.mc3.tf.text = _list[ idx + 1 ] + "\n" + (idx + 2);
			}
			
			_tp.circle.mc4.tf.text = _list[ idx ] + "\n" + (idx + 1);
			_tp.circle.mc5.tf.text = _list[ idx ] + "\n" + (idx + 1);
			
			if ( idx <= 0 )
			{
				_tp.circle.mc6.tf.text = "";
			}
			else
			{
				_tp.circle.mc6.tf.text = _list[ idx - 1 ] + "\n" + (idx + 0);
			}
			if ( idx <= 1 )
			{
				_tp.circle.mc7.tf.text = "";
			}
			else
			{
				_tp.circle.mc7.tf.text = _list[ idx - 2 ] + "\n" + (idx - 1);
			}
			
			if ( idx <= 2 )
			{
				_tp.circle.mc8.tf.text = "";
			}
			else
			{
				_tp.circle.mc8.tf.text = _list[ idx - 3 ] + "\n" + (idx - 2);
			}
			
			if ( idx <= 3 )
			{
				_tp.circle.mc9.tf.text = "";
			}
			else
			{
				_tp.circle.mc9.tf.text = _list[ idx - 4 ] + "\n" + (idx - 3);
			}
			
			//三个大扇形的文本
			_tp.frame.angle0.tf.text = _list[ idx + 1 ] + "\n" + (idx + 2);
			_tp.frame.angle1.tf.text = _list[ idx ] + "\n" + (idx + 1);
			if ( idx <= 0 )
			{
				_tp.frame.angle2.tf.text = "";
			}
			else
			{
				_tp.frame.angle2.tf.text = _list[ idx - 1 ] + "\n" + (idx - 0);
			}
		}
		
		private function initBtn():void
		{
			_tp.stop();
			_tp.btns.btn.btn.addEventListener( MouseEvent.CLICK, fire );
			var l:uint = 6;
			while( --l >= 0 )
			{
				_tp.btns["btn" + l].buttonMode = true;
				_tp.btns["btn" + l].stop();
				_tp.btns["btn" + l].mouseChildren = false;
			}
			_tp.btns.addEventListener( MouseEvent.CLICK, run );
			
			/*mc.btns.addEventListener( MouseEvent.MOUSE_OVER, onOver );
			mc.btns.addEventListener( MouseEvent.MOUSE_OUT, onOut );*/
			
			_tp.btns.addEventListener (MouseEvent.MOUSE_OVER, onOver1 );
			_tp.btns.addEventListener (MouseEvent.MOUSE_OUT, onOut1 );
		}
		private function onOut1(evt:MouseEvent):void
		{
			_tp.btns.removeEventListener(MouseEvent.MOUSE_MOVE, onMove );
			_lastBtn = null;
		}
		private function onOver1(evt:MouseEvent):void
		{
			_tp.btns.addEventListener (MouseEvent.MOUSE_MOVE, onMove );
		}
		private function onMove(e:MouseEvent):void
		{
			var btn:MovieClip = null;
			for (var i:int = 0;i < 6; i++ )
			{
				var mcBtn:MovieClip = _tp.btns["btn" + i];
				var mc1:MovieClip = mcBtn.getChildAt( 0 ) as MovieClip;
				var bmp:Bitmap = mc1.getChildAt( 0 ) as Bitmap;
				if (bmp.bitmapData.hitTest( new Point(0, 0), 0xFF, new Point(mcBtn.mouseX, mcBtn.mouseY)))
				{
					btn = mcBtn;
					//					trace(mcBtn.name);
				}
			}
			
			if ( btn == null )
			{
				if ( _lastBtn )
				{
					_lastBtn.gotoAndStop(1);
				}
				_lastBtn = btn;
			}
			else
			{
				if (btn != _lastBtn)
				{
					if ( _lastBtn )
					{
						_lastBtn.gotoAndStop(1);
					}
					btn.gotoAndStop( 3 );
					_lastBtn = btn;
				}
			}
		}
		/*private function onOver(e:MouseEvent):void
		{
		switch( e.target.name )
		{
		case "btn0":
		case "btn1":
		case "btn2":
		case "btn3":
		case "btn4":
		case "btn5":
		{
		e.target.gotoAndStop( 3 );
		break;
		}
		}
		}
		private function onOut(e:MouseEvent):void
		{
		switch( e.target.name )
		{
		case "btn0":
		case "btn1":
		case "btn2":
		case "btn3":
		case "btn4":
		case "btn5":
		{
		e.target.gotoAndStop( 1 );
		break;
		}
		}
		}*/
		private function fire(e:MouseEvent):void
		{
			_func( idx );
		}
		private function run(e:MouseEvent):void
		{
			if (_lastBtn == null)
			{
				return;
			}
			
			switch( _lastBtn.name )
			{
				case "btn0":
				{
					if ( idx + 3 != top )
					{
						time = top - idx - 3;
						initAnimateTF();
						_tp.play();
						_tp.btns.visible = false;
						_lastBtn.gotoAndStop( 1 );
					}
					break;
				}
				case "btn1":
				{
					if ( _list.length - idx > 2 )
					{
						time = 2;
						initAnimateTF();
						_tp.play();
						_tp.btns.visible = false;
						_lastBtn.gotoAndStop( 1 );
					}
					break;
				}
				case "btn2":
				{
					if ( _list.length - idx > 1 )
					{
						time = 1;
						initAnimateTF();
						_tp.play();
						_tp.btns.visible = false;
						_lastBtn.gotoAndStop( 1 );
					}
					break;
				}
				case "btn3":
				{
					if ( _list.length - idx > 1 )
					{
						time = 1;
						initAnimateTF();
						_tp.gotoAndPlay( 11 );
						_tp.btns.visible = false;
						_lastBtn.gotoAndStop( 1 );
					}
					break;
				}
				case "btn4":
				{
					if ( _list.length - idx > 1 )
					{
						time = 2;
						initAnimateTF();
						_tp.gotoAndPlay( 11 );
						_tp.btns.visible = false;
						_lastBtn.gotoAndStop( 1 );
					}
					break;
				}
				case "btn5":
				{
					if ( _list.length - idx > 1 )
					{
						time = 3;
						initAnimateTF();
						_tp.gotoAndPlay( 11 );
						_tp.btns.visible = false;
						_lastBtn.gotoAndStop( 1 );
					}
					break;
				}
			}
		}
		protected function destroyTurn(e:Event):void
		{
			_tp.addFrameScript( 9, null, _tp.totalFrames - 1, null );
			
			_tp.btns.btn.btn.removeEventListener( MouseEvent.CLICK, fire );
			_tp.btns.removeEventListener( MouseEvent.CLICK, run );
			/*mc.btns.removeEventListener( MouseEvent.MOUSE_OVER, onOver );
			mc.btns.removeEventListener( MouseEvent.MOUSE_OUT, onOut );*/
		}
		
		private function down():void
		{
			idx++;
			if ( --time > 0)
			{
				_tp.gotoAndPlay( 1 );
				initAnimateTF();
			}
			else
			{
				initTF();
				_tp.btns.visible = true;
				_tp.gotoAndStop( 1 );
				onMove( null );
			}
		}
		
		private function up():void
		{
			idx--;
			if ( --time > 0)
			{
				_tp.gotoAndPlay( 11 );
				initAnimateTF();
			}
			else
			{
				initTF();
				_tp.btns.visible = true;
				_tp.gotoAndStop( 1 );
				onMove( null );
			}
		}
	}
}