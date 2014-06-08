package com.stintern.st2D.tests.turnX3.maingame
{
	public class Gravity
	{
		// Singleton
		private static var _instance:Gravity;
		private static var _creatingSingleton:Boolean = false;
		
		private var _direction:uint;
		
		public static var DIRECTION_DOWN:uint = 0;
		public static var DIRECTION_LEFT:uint = 1;
		public static var DIRECTION_UP:uint = 2;
		public static var DIRECTION_RIGHT:uint = 3;
		
		public function Gravity()
		{
			if (!_creatingSingleton){
				throw new Error("[Gravity] This class is singletone. please use the instance");
			}
		}
		
		public static function get instance():Gravity
		{
			if (!_instance){
				_creatingSingleton = true;
				_instance = new Gravity();
				_creatingSingleton = false;
			}
			return _instance;
		}
		
		public function rotateLeft():void
		{
			_direction = (++_direction) % 4;				
		}
		
		public function rotateRight():void
		{
			if( _direction == DIRECTION_DOWN )
				_direction = DIRECTION_RIGHT;
			else
				_direction--
		}
		
		public function rotate180():void
		{
			_direction += 2;
			_direction = _direction % 4;
		}
		
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