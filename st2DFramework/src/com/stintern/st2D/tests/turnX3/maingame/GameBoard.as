package com.stintern.st2D.tests.turnX3.maingame
{
	public class GameBoard
	{
		// Main game board
		private var _boardArray:Vector.<Vector.<uint>>;	// 2 Dimension Vector
		
		public function GameBoard()
		{
			_boardArray = new Vector.<Vector.<uint>>();
		}
		
		public function setBoardAt(level:uint):void
		{
			var mapInfo:Vector.<uint> = LevelManager.instance.mapInfo;
			var rowCount:uint = LevelManager.instance.rowCount;
			var colCount:uint = LevelManager.instance.colCount;
			
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
		
	}
}