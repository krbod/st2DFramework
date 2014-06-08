package com.stintern.st2D.tests.turnX3.maingame
{
	public class LevelManager
	{
		// Singleton
		private static var _instance:LevelManager;
		private static var _creatingSingleton:Boolean = false;
		
		private var _rowCount:uint;
		private var _colCount:uint;
		private var _aniCount:uint;
		
		private var _currentLevel:uint;
		private var _mapInfo:Vector.<uint> = new Vector.<uint>();
		
		public function LevelManager()
		{
			if (!_creatingSingleton){
				throw new Error("[LevelManager] This class is singletone. please use the instance");
			}
			
		}
		
		public static function get instance():LevelManager
		{
			if (!_instance){
				_creatingSingleton = true;
				_instance = new LevelManager();
				_creatingSingleton = false;
			}
			return _instance;
		}
		
		public function setCurrentLevel(level:uint):void
		{
			// TEST
			_mapInfo.push(
				9, 9, 9, 9, 9, 9, 9, 9, 9, 9,
				9, 9, 9, 2, 2, 2, 2, 9, 9, 9,
				9, 9, 9, 9, 9, 9, 9, 9, 9, 9,
				0, 8, 8, 8, 8, 8, 8, 8, 8, 0,
				0, 9, 9, 9, 9, 9, 9, 9, 9, 0,
				0, 9, 9, 9, 9, 9, 9, 9, 9, 0,
				0, 9, 9, 9, 9, 9, 9, 9, 9, 0,
				0, 9, 9, 9, 9, 9, 9, 9, 9, 0,
				0, 9, 9, 9, 9, 9, 9, 9, 9, 1,
				0, 9, 9, 9, 9, 9, 9, 9, 9, 1,
				1, 9, 9, 9, 9, 9, 9, 9, 9, 0,
				0, 9, 9, 9, 9, 9, 9, 9, 9, 0,
				0, 0, 0, 0, 0, 1, 0, 0, 0, 0 
			);
			
			_currentLevel = 1;
			_aniCount = 4;
			
			_rowCount = 13;
			_colCount = 10;
		}
		
		/**
		 * Get current map's information after reading the levelinfo
		 *  
		 * @param level 
		 * @return 
		 */
		public function get mapInfo():Vector.<uint>
		{
			return _mapInfo;
		}
		
		/** property */
		
		public function get rowCount():uint
		{
			return _rowCount;
		}
		public function set rowCount(rowCount:uint):void
		{
			_rowCount = rowCount;
		}
		
		public function get colCount():uint
		{
			return _colCount;
		}
		public function set colCount(colCount:uint):void
		{
			_colCount = colCount;
		}
		
		public function get currentLevel():uint
		{
			return _currentLevel;
		}
		public function set currentLevel(currentLevel:uint):void
		{
			_currentLevel = currentLevel;
		}
		
		public function get aniCount():uint
		{
			return _aniCount;
		}
	}
}