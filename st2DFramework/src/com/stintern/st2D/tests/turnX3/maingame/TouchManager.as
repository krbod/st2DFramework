package com.stintern.st2D.tests.turnX3.maingame
{
	import com.stintern.st2D.basic.Camera;
	import com.stintern.st2D.basic.StageContext;
	import com.stintern.st2D.display.SceneManager;
	import com.stintern.st2D.tests.turnX3.maingame.block.HelperManager;
	import com.stintern.st2D.tests.turnX3.maingame.layer.MainGameLayer;
	import com.stintern.st2D.tests.turnX3.maingame.layer.UILayer;
	import com.stintern.st2D.tests.turnX3.utils.Resources;
	import com.stintern.st2D.ui.ButtonInfo;
	import com.stintern.st2D.utils.scheduler.Scheduler;
	
	import flash.geom.Vector3D;

	public class TouchManager
	{
		private var _isMouseDown:Boolean;
		private var _helperManager:HelperManager;
		
		private var _movingSpriteRow:uint, _movingSpriteCol:uint;
		
		private var _rotateDegree:Number = 0.0;
		
		public function TouchManager()
		{
		}
		
		public function init(helperManager:HelperManager):void
		{
			_helperManager = helperManager;
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
			// If realeasing position is out of board
			
			
			// If not, change the board array 
			_helperManager.setupHelper(buttonInfo.tag, _movingSpriteRow, _movingSpriteCol);
			
			// Update the count of helper blocks
			var uiLayer:UILayer = SceneManager.instance.getCurrentScene().getLayerByTag(Resources.LAYER_UI) as UILayer;
			
			uiLayer.updateCountText(_helperManager.boxCount, _helperManager.arrowCount, _helperManager.iceCount);
			_isMouseDown = false;
		}
		
		public function callbackRotateLeftClicked(buttonInfo:ButtonInfo):void
		{
			var scheduler:Scheduler = new Scheduler();
			scheduler.addFunc(500 / 90, rotateLeft, 0);
			
			var camera:Camera = (SceneManager.instance.getCurrentScene().getLayerByTag(Resources.LAYER_MAINGAME) as MainGameLayer).camera;
			var degree:Number = _rotateDegree;
			
			scheduler.startScheduler();
			function rotateLeft():void
			{
				camera.rotate(_rotateDegree, new Vector3D(0.0, 0.0, 1.0));
				_rotateDegree++;
				if( _rotateDegree >= degree + 90.0 )
				{
					scheduler.stopScheduler();
					scheduler = null;
					
					Gravity.instance.rotateLeft();
				}
			}
		}

		public function callbackRotateRightClicked(buttonInfo:ButtonInfo):void
		{
			var scheduler:Scheduler = new Scheduler();
			scheduler.addFunc(500 / 90, rotateRight, 0);
			
			var camera:Camera = (SceneManager.instance.getCurrentScene().getLayerByTag(Resources.LAYER_MAINGAME) as MainGameLayer).camera;
			var degree:Number = _rotateDegree;
			
			scheduler.startScheduler();
			function rotateRight():void
			{
				camera.rotate(_rotateDegree, new Vector3D(0.0, 0.0, 1.0));
				_rotateDegree--;
				if( _rotateDegree <= degree - 90 )
				{
					scheduler.stopScheduler();
					scheduler = null;
					
					Gravity.instance.rotateRight();
				}
			}
		}
		
		public function callbackRotate180Clicked(buttonInfo:ButtonInfo):void
		{
			var scheduler:Scheduler = new Scheduler();
			scheduler.addFunc(500 / 180, rotateRight, 0);
			
			var camera:Camera = (SceneManager.instance.getCurrentScene().getLayerByTag(Resources.LAYER_MAINGAME) as MainGameLayer).camera;
			var degree:Number = _rotateDegree;
			
			scheduler.startScheduler();
			function rotateRight():void
			{
				camera.rotate(_rotateDegree, new Vector3D(0.0, 0.0, 1.0));
				_rotateDegree++;
				if( _rotateDegree >= degree + 180 )
				{
					scheduler.stopScheduler();
					scheduler = null;
					
					Gravity.instance.rotate180();
				}
			}
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