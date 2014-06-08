package com.stintern.st2D.tests.turnX3
{
	import com.stintern.st2D.basic.StageContext;
	import com.stintern.st2D.tests.turnX3.maingame.LevelManager;
	import com.stintern.st2D.tests.turnX3.maingame.block.HelperManager;
	import com.stintern.st2D.tests.turnX3.utils.Resources;
	import com.stintern.st2D.ui.ButtonInfo;

	public class TouchManager
	{
		private var _isMouseDown:Boolean;
		private var _helperManager:HelperManager;
		private var _updateCountTextCallback:Function;
		
		private var _movingSpriteRow:uint, _movingSpriteCol:uint;
		
		public function TouchManager()
		{
		}
		
		public function init(helperManager:HelperManager, updateCountTextCallback:Function):void
		{
			_helperManager = helperManager;
			_updateCountTextCallback = updateCountTextCallback;
		}
		
		public function callbackHelperMouseDown(buttonInfo:ButtonInfo):void
		{
			_isMouseDown = true;
		}
		
		public function callbackHelperMouseMove(buttonInfo:ButtonInfo):void
		{
			if( !_isMouseDown )
				return;
			
			var indices:Array = getIndiceByCoord(buttonInfo.x, buttonInfo.y);
			var revisedCoord:Array = getBlockPosition(indices[0], indices[1]);
			
			_helperManager.moveHelperSprite(buttonInfo.tag, revisedCoord[0], revisedCoord[1]);
			_movingSpriteRow = indices[0];
			_movingSpriteCol = indices[1];
			
			indices = null;
			revisedCoord = null;
		}
		
		public function callbackHelperMouseUp(buttonInfo:ButtonInfo):void
		{
			trace( buttonInfo.tag);
			// If realeasing position is out of board
			
			
			// If not, change the board array 
			_helperManager.setupHelper(buttonInfo.tag, _movingSpriteRow, _movingSpriteCol);
			
			// Update the count of helper blocks
			_updateCountTextCallback();
			
			_isMouseDown = false;
		}
		
		public function getIndiceByCoord(x:Number, y:Number):Array
		{
			var blockSize:Number = StageContext.instance.screenWidth / (LevelManager.instance.colCount + Resources.PADDING);
			
			var row:uint = y / blockSize; 
			var col:uint = x / blockSize - Resources.PADDING*0.5;
			
			return new Array(row, col);
		}
		
		private function getBlockPosition(row:uint, col:uint):Array
		{
			var blockSize:Number = StageContext.instance.screenWidth / (LevelManager.instance.colCount + Resources.PADDING);
			
			return new Array(
				(col + Resources.PADDING*0.5) * blockSize,
				StageContext.instance.screenHeight - blockSize * row
			);
		}
	}
}