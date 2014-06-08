package com.stintern.st2D.tests.turnX3.maingame
{
	public class GameBoard
	{
		// Singleton
		private static var _instance:GameBoard;
		private static var _creatingSingleton:Boolean = false;
		
		// Main game board
		private var _boardArray:Vector.<Vector.<uint>> = null;	// 2 Dimension Vector
		
		public function GameBoard()
		{
			if (!_creatingSingleton){
				throw new Error("[GameBoard] This class is singletone. please use the instance");
			}
		}
		
		public static function get instance():GameBoard
		{
			if (!_instance){
				_creatingSingleton = true;
				_instance = new GameBoard();
				_creatingSingleton = false;
			}
			return _instance;
		}
	
		
		public function setBoardAt(level:uint):void
		{
			var mapInfo:Vector.<uint> = LevelManager.instance.mapInfo;
			var rowCount:uint = LevelManager.instance.rowCount;
			var colCount:uint = LevelManager.instance.colCount;
			
			if( _boardArray == null )
			{
				_boardArray = new Vector.<Vector.<uint>>();
			}
			
			for(var i:uint=0; i<rowCount; ++i)
			{
				var colVector:Vector.<uint> = new Vector.<uint>();
				for(var j:uint=0; j<colCount; ++j)
				{
					colVector.push(mapInfo[i * colCount + j]);
				}
				_boardArray.push(colVector);
			}
			
			mapInfo = null;
		}
		
		public function get boardArray():Vector.<Vector.<uint>>
		{
			return _boardArray;
		}
		
		public function exchangeBoardValue(from:uint, to:uint):void
		{
			var rowCount:uint = LevelManager.instance.rowCount;
			var colCount:uint = LevelManager.instance.colCount;
			
			for(var i:uint=0; i<rowCount; ++i)
			{
				for(var j:uint=0; j<colCount; ++j)
				{
					if( _boardArray[i][j] == from )
					{
						_boardArray[i][j] = to;
					}
				}
			}
		}
		
	}
}