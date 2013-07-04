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
		private var idx:int = 0;
		/**玩家最高第几战，从1开始**/
		private var top:int = 0;
		/**每次旋转，扇形旋转次数，从1开始**/
		private var time:int = 0;
		private var _list:Vector.<String>;
		private var leng:uint;
		private var _lastBtn:MovieClip;
		/**单击挑战按钮执行的方法，此方法要有一个int参数**/
		private var _func:Function;
		/** 转盘停止时执行的方法，此方法要有一个int参数**/
		private var _show:Function;
		private var _point:Point;
		/**
		 * @param tp
		 * 	转盘swf
		 * @param list
		 *  转盘内的名字
		 * @param func
		 * 	挑战按钮执行方法
		 * @param show
		 *  转盘停止时执行的方法
		 */		
		public function TurnplateCtrl( tp:MovieClip, list:Vector.<String>, func:Function, show:Function )
		{
			_tp = tp;
			_list = list;
			_func = func;
			_show = show;
			_point = new Point(0, 0);
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
			mouseEnabled();
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
			if ( idx + 2 >= top )
			{
				_tp.btns.btn1.mouseEnabled = false;
				_tp.btns.btn1.gotoAndStop( 1 );
			}
			else
			{
				_tp.btns.btn1.mouseEnabled = true;
				_tp.btns.btn1.gotoAndStop( 2 );
			}
			if ( idx + 1 >= top )
			{
				_tp.btns.btn2.mouseEnabled = false;
				_tp.btns.btn2.gotoAndStop( 1 );
			}
			else
			{
				_tp.btns.btn2.mouseEnabled = true;
				_tp.btns.btn2.gotoAndStop( 2 );
			}
			if ( idx <= 0 ) 
			{
				_tp.btns.btn3.mouseEnabled = false;
				_tp.btns.btn3.gotoAndStop( 1 );
			}
			else
			{
				_tp.btns.btn3.mouseEnabled = true;
				_tp.btns.btn3.gotoAndStop( 2 );
			}
			
			if ( idx <= 1)
			{
				_tp.btns.btn4.mouseEnabled =  false;
				_tp.btns.btn4.gotoAndStop( 1 );
			}
			else
			{
				_tp.btns.btn4.mouseEnabled = true;
				_tp.btns.btn4.gotoAndStop( 2 );
			}
			
			if ( idx <= 2)
			{
				_tp.btns.btn5.mouseEnabled =  false;
				_tp.btns.btn5.gotoAndStop( 1 );
			}
			else
			{
				_tp.btns.btn5.mouseEnabled = true;
				_tp.btns.btn5.gotoAndStop( 2 );
			}
		}
		private function run(e:MouseEvent):void
		{
			if ( _lastBtn == null )
			{
				return;
			}
			
			switch( _lastBtn.name )
			{
				case "btn0":
				{
					if ( idx + 1 != top )
					{
						time = top - idx - 1;
						initAnimateTF();
						_tp.play();
						_tp.btns.visible = false;
					}
					break;
				}
				case "btn1":
				{
					if ( idx + 2 < top )
					{
						time = 2;
						initAnimateTF();
						_tp.play();
						_tp.btns.visible = false;
					}
					break;
				}
				case "btn2":
				{
					if ( idx + 1 < top )
					{
						time = 1;
						initAnimateTF();
						_tp.play();
						_tp.btns.visible = false;
					}
					break;
				}
				case "btn3":
				{
					if ( idx > 0 )
					{
						time = 1;
						initAnimateTF();
						_tp.gotoAndPlay( 11 );
						_tp.btns.visible = false;
					}
					break;
				}
				case "btn4":
				{
					if ( idx > 1 )
					{
						time = 2;
						initAnimateTF();
						_tp.gotoAndPlay( 11 );
						_tp.btns.visible = false;
					}
					break;
				}
				case "btn5":
				{
					if ( idx > 2 )
					{
						time = 3;
						initAnimateTF();
						_tp.gotoAndPlay( 11 );
						_tp.btns.visible = false;
					}
					break;
				}
			}
		}
		
		/**
		 * 发光状态
		 * @param mc
		 */		
		private function state(mc:MovieClip):void
		{
			switch( mc.name )
			{
				case "btn0":
				{
					mc.gotoAndStop( 3 );
					break;
				}
				case "btn1":
				{
					if ( idx + 2 < top )
					{
						mc.gotoAndStop( 3 );
					}
					break;
				}
				case "btn2":
				{
					if ( idx + 1 < top )
					{
						mc.gotoAndStop( 3 );
					}
					break;
				}
				case "btn3":
				{
					if ( idx > 0 ) 
					{
						mc.gotoAndStop( 3 );
					}
					break;
				}
				case "btn4":
				{
					if ( idx > 1)
					{
						mc.gotoAndStop( 3 );
					}
					break;
				}
				case "btn5":
				{
					if ( idx > 2)
					{
						mc.gotoAndStop( 3 );
					}
					break;
				}
			}
		}
		/**
		 * 还原原来按钮状态
		 * @param mc
		 */		
		private function state2(mc:MovieClip):void
		{
			switch( mc.name )
			{
				case "btn0":
				{
					mc.gotoAndStop( 2 );
					break;
				}
				case "btn1":
				{
					if ( idx + 2 < top )
					{
						mc.gotoAndStop( 2 );
					}
					break;
				}
				case "btn2":
				{
					if ( idx + 1 < top )
					{
						mc.gotoAndStop( 2 );
					}
					break;
				}
				case "btn3":
				{
					if ( idx > 0 ) 
					{
						mc.gotoAndStop( 2 );
					}
					break;
				}
				case "btn4":
				{
					if ( idx > 1)
					{
						mc.gotoAndStop( 2 );
					}
					break;
				}
				case "btn5":
				{
					if ( idx > 2)
					{
						mc.gotoAndStop( 2 );
					}
					break;
				}
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
				_tp.btns["btn" + l].mouseChildren = false;
			}
			_tp.btns.btn0.gotoAndStop( 2 );
			_tp.btns.addEventListener( MouseEvent.CLICK, run );
			
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
		/**
		 * 像素碰撞检测
		 * @param e
		 */		
		private function onMove(e:MouseEvent):void
		{
			var btn:MovieClip = null;
			var i:uint = 0;
			while ( i < 6 )
			{
				var mcBtn:MovieClip = _tp.btns["btn" + i++];
				var bmp:Bitmap = MovieClip(mcBtn.getChildAt( 0 )).getChildAt( 0 ) as Bitmap;
				//此按钮的Bitmap.bitmapData是否的碰撞检测 到当前鼠标位置
				if (bmp.bitmapData.hitTest( _point, 0xFF, new Point(mcBtn.mouseX, mcBtn.mouseY)))
				{
					btn = mcBtn;
				}
			}
			//未碰撞检测 到按钮，说明已离开之前按钮，原来之前按钮正常状态
			if ( btn == null )
			{
				if ( _lastBtn )
				{
					state2( _lastBtn );
				}
				_lastBtn = btn;//未碰撞检测 到按钮,_lastBtn置null
			}
			else if (btn != _lastBtn)
			{
				if ( _lastBtn )
				{
					state2( _lastBtn );
				}
				state( btn );
				_lastBtn = btn;
			}
		}
		private function fire(e:MouseEvent):void
		{
			_func( idx + 1 );
		}
		protected function destroyTurn(e:Event):void
		{
			_tp.addFrameScript( 9, null, _tp.totalFrames - 1, null );
			
			_tp.btns.btn.btn.removeEventListener( MouseEvent.CLICK, fire );
			_tp.btns.removeEventListener( MouseEvent.CLICK, run );
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
				mouseEnabled();
				_show( idx + 1 );
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
				mouseEnabled();
				_show( idx + 1 );
			}
		}
	}
}