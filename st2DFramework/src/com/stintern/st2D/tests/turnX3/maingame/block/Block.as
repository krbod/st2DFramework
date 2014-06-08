package com.stintern.st2D.tests.turnX3.maingame.block
{
	import com.stintern.st2D.display.sprite.Sprite;

	public class Block extends Sprite
	{
		private var _rowIndex:uint;
		private var _colIndex:uint;
		
		private var _type:uint;
		
		/** type of block */
		public static var TYPE_OF_BLOCK_PANG:uint = 0;
		public static var TYPE_OF_BLOCK_ANI:uint = 1;
		public static var TYPE_OF_BLOCK_MONG:uint = 2;
		
		public static var TYPE_OF_BLOCK_OPEN_PANG:uint = 8;
		
		public static var TYPE_OF_BLOCK_EMPTY:uint = 9;
		
		public static var TYPE_OF_BLOCK_BOX:uint = 10;
		public static var TYPE_OF_BLOCK_ARROW:uint = 11;
		public static var TYPE_OF_BLOCK_ICE:uint = 12;
		
		public static var TYPE_OF_BLOCK_HEART:uint = 20;
		
		public function Block()
		{
		}
		
		public function get rowIndex():uint
		{
			return _rowIndex;
		}
		public function set rowIndex(index:uint):void
		{
			_rowIndex = index;
		}
		
		public function get colIndex():uint
		{
			return _colIndex;
		}
		public function set colIndex(index:uint):void
		{
			_colIndex = index;
		}
		
		public function get type():uint
		{
			return _type;
		}
		public function set type(type:uint):void
		{
			_type = type;	
		}
			
	}
}