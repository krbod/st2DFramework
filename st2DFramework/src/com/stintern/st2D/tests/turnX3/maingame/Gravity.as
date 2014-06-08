package com.stintern.st2D.tests.turnX3.maingame
{
	public class Gravity
	{
		private var _direction:uint;
		
		public static var DIRECTION_DOWN:uint = 0;
		public static var DIRECTION_UP:uint = 1;
		public static var DIRECTION_LEFT:uint = 2;
		public static var DIRECTION_RIGHT:uint = 3;
		
		public function get direction():uint
		{
			return _direction;
		}
		public function set direction(direction:uint):void
		{
			_direction = direction;
		}
			
	}
}