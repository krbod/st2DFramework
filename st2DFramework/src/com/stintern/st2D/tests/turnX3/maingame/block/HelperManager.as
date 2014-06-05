package com.stintern.st2D.tests.turnX3.maingame.block
{
	public class HelperManager
	{
		private var _boxCount:uint;
		private var _arrowCount:uint;
		private var _iceCount:uint;
		
		public function HelperManager()
		{
		}
		
		/**
		 * setting the count of each helper blocks
		 *  
		 * @param box count of box helper block
		 * @param arrow count of arrow helper block
		 * @param ice count of ice helper block
		 */
		public function setCounts(box:uint, arrow:uint, ice:uint):void
		{
			_boxCount = box;
			_arrowCount = arrow;
			_iceCount = ice;
		}
		
		public function get boxCount():uint
		{
			return _boxCount;
		}
		
		public function get arrowCount():uint
		{
			return _arrowCount;
		}
		
		public function get iceCount():uint
		{
			return _iceCount;
		}
	}
}