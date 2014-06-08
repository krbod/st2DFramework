package com.stintern.st2D.ui
{
	import com.stintern.st2D.display.sprite.Base;

	public class ButtonInfo extends Base
	{
		private var _x:Number;
		private var _y:Number;
		
		public function ButtonInfo()
		{
		}
		
		public function get x():Number
		{
			return _x;
		}
		public function set x(x:Number):void
		{
			_x = x;
		}
		
		public function get y():Number
		{
			return _y;
		}
		public function set y(y:Number):void
		{
			_y = y;
		}
		
	}
}