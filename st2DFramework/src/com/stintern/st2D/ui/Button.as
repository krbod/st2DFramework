package com.stintern.st2D.ui
{
    import com.stintern.st2D.animation.AnimationData;
    import com.stintern.st2D.animation.datatype.AnimationFrame;
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.Sprite;
    import com.stintern.st2D.utils.Vector2D;
    
    import flash.events.MouseEvent;
    import flash.geom.Point;
    
    public class Button extends UIBase
    {
        private var _normalSprite:Sprite;
        private var _clickedSprite:Sprite;
		
		private var _buttonInfo:ButtonInfo;
		private var _isMouseDown:Boolean;
        
        public function Button()
        {
			_buttonInfo = new ButtonInfo();
        }
        
        public function dispose():void
        {
			_buttonInfo = null;
			
            StageContext.instance.stage.removeEventListener(MouseEvent.CLICK, eventMouseClick);
            StageContext.instance.stage.removeEventListener(MouseEvent.MOUSE_DOWN, eventMouseDown);
            StageContext.instance.stage.removeEventListener(MouseEvent.MOUSE_UP, eventMouseUp);
        }
        
        public function createButton(batchSprite:BatchSprite, normalImage:String, clickedImage:String, onClick:Function, onMouseDown:Function=null, onMouseUp:Function=null):void
        {
            _normalSprite = new Sprite();
            _normalSprite.createSpriteWithBatchSprite(batchSprite, normalImage);
            batchSprite.addSprite(_normalSprite);
            
            _clickedSprite = new Sprite();
            _clickedSprite.createSpriteWithBatchSprite(batchSprite, clickedImage);
            batchSprite.addSprite(_clickedSprite);
            _clickedSprite.isVisible = false;
            
            callbackClick = onClick;
            callbackMouseDown = onMouseDown;
            callbackMouseUp = onMouseUp;
            
            var frame:AnimationFrame = AnimationData.instance.animationData[batchSprite.path]["frame"][normalImage];
            _normalSprite.position.x = frame.pivotX;
            _normalSprite.position.y = StageContext.instance.screenHeight - frame.pivotY;
            
            _normalSprite.setAnchorPoint(frame.anchorX, frame.anchorY);
            
            frame = AnimationData.instance.animationData[batchSprite.path]["frame"][clickedImage];
            _clickedSprite.position.x = frame.pivotX;
            _clickedSprite.position.y = StageContext.instance.screenHeight - frame.pivotY;
            
            _clickedSprite.setAnchorPoint(frame.anchorX, frame.anchorY);
            
            StageContext.instance.stage.addEventListener(MouseEvent.CLICK, eventMouseClick);
            StageContext.instance.stage.addEventListener(MouseEvent.MOUSE_DOWN, eventMouseDown);
			StageContext.instance.stage.addEventListener(MouseEvent.MOUSE_MOVE, eventMouseMove);
            StageContext.instance.stage.addEventListener(MouseEvent.MOUSE_UP, eventMouseUp);
        }
        
        public function setPosition(x:Number, y:Number):void
        {
            _normalSprite.setTranslation(new Vector2D(x, y));
            _clickedSprite.setTranslation(new Vector2D(x, y));
        }
        
        public function setAnchorPoint(x:Number, y:Number):void
        {
            _normalSprite.setAnchorPoint(x, y);
            _clickedSprite.setAnchorPoint(x, y);
        }
        
        public function eventMouseClick(event:MouseEvent):void
        {
            if( _normalSprite.rect.containsPoint(new Point(event.stageX, (StageContext.instance.screenHeight - event.stageY)) ))
            {
				_buttonInfo.x = event.stageX;
				_buttonInfo.y = event.stageY;
				
				_buttonInfo.name = this.name;
				_buttonInfo.tag = this.tag;
				
				if( callbackClick != null )
				{
                	callbackClick(_buttonInfo);
				}
            }
        }
        
        public function eventMouseDown(event:MouseEvent):void
        {
			// If button is on invisible state, Mouse event isn't occured.
			if( _normalSprite.isVisible == false )
			{
				return;
			}
			
            if( _normalSprite.rect.containsPoint(new Point(event.stageX, StageContext.instance.screenHeight - event.stageY)) )
            {
                _normalSprite.isVisible = false;
                _clickedSprite.isVisible = true;
                
                if( callbackMouseDown != null )
                {
					_buttonInfo.x = event.stageX;
					_buttonInfo.y = event.stageY;
					
					_buttonInfo.name = this.name;
					_buttonInfo.tag = this.tag;
					
                    callbackMouseDown(_buttonInfo);
                }
				
				_isMouseDown = true;
            }
        }
		
		public function eventMouseMove(event:MouseEvent):void
		{
			if( !_isMouseDown )
				return;
			
			_normalSprite.isVisible = false;
			_clickedSprite.isVisible = true;
			
			if( callbackMouseMove != null )
			{
				_buttonInfo.x = event.stageX;
				_buttonInfo.y = event.stageY;
				
				_buttonInfo.name = this.name;
				_buttonInfo.tag = this.tag;
				
				callbackMouseMove(_buttonInfo);
			}
		}
        
        public function eventMouseUp(event:MouseEvent):void
        {
			if( !_isMouseDown )
				return;
			
            _normalSprite.isVisible = true;
            _clickedSprite.isVisible = false;
            
            if( callbackMouseUp != null )
            {
				_buttonInfo.x = event.stageX;
				_buttonInfo.y = event.stageY;
				
				_buttonInfo.name = this.name;
				_buttonInfo.tag = this.tag;
				
                callbackMouseUp(_buttonInfo);
            }
			
			_isMouseDown = false;
        }

		public function setVisible(isVisible:Boolean):void
		{
			if( isVisible )
			{
				_normalSprite.isVisible = true;
			}
			else
			{
				_normalSprite.isVisible = false;
			}
			
		}
		
    }
}