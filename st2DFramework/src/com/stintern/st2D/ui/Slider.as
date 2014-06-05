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

    public class Slider extends UIBase
    {
        // 슬라이더 이미지 관련
        private var _barSprite:Sprite;
        private var _buttonSprite:Sprite;
        
        // 슬라이더 값
        private var _minValue:Number =  0.0;
        private var _maxValue:Number = 100.0;
        private var _currentValue:Number;
        
        // 슬라이더 타입
        private var _type:uint = SLIDER_TYPE_HORIZONTAL_BAR;
        
        public static var SLIDER_TYPE_HORIZONTAL_BAR:uint = 0;
        public static var SLIDER_TYPE_VERTICAL_BAR:uint = 1;
        
        //슬라이더 버튼 드래그 관련
        private var _oldTouch:Number;
        private var _isMoving:Boolean = false;
        private var _minCoord:Number;
        private var _maxCoord:Number;
        
        /**
         * 슬라이더 바를 생성합니다. 
         * @param batchSprite 슬라이더 바를 나타낼 이미지가 들어있는 배치스프라이트
         * @param barImage 슬라이더 바의 이미지 이름
         * @param buttonImage 슬라이더 바 버튼의 이미지 이름
         * @param type 슬라이더 바 타입
         * @param onClick 슬라이더 바를 클릭했을 때의 콜백함수
         * @param onMouseDown 슬라이더 바 버튼을 클릭해서 움직일 때의 콜백함수
         * @param onMouseUp 슬라이더 바 버튼을 움직이다 놓았을 때 호출되는 콜백함수
         * 
         */
        public function createSlider(batchSprite:BatchSprite, barImage:String, buttonImage:String, type:uint = 0, onClick:Function = null, onMouseMove:Function = null, onMouseUp:Function = null):void
        {
            // 슬라이더 바 이미지 초기화
            _barSprite = initSprite(batchSprite, barImage);
            _buttonSprite = initSprite(batchSprite, buttonImage);
            
            _type = type;
            
            // 콜백함수 등록
            callbackClick = onClick;
            callbackMouseMove = onMouseMove;
            callbackMouseUp = onMouseUp;

            // 이벤트 등록
            StageContext.instance.stage.addEventListener(MouseEvent.CLICK, eventMouseClick);
            StageContext.instance.stage.addEventListener(MouseEvent.MOUSE_DOWN, eventMouseDown);
            StageContext.instance.stage.addEventListener(MouseEvent.MOUSE_MOVE, eventMouseMove);
            StageContext.instance.stage.addEventListener(MouseEvent.MOUSE_UP, eventMouseUp);
            
            _currentValue = (_maxValue - _minValue) / 2;
            switch( _type )
            {
                case Slider.SLIDER_TYPE_HORIZONTAL_BAR:
                    _oldTouch = _buttonSprite.position.x;
                    _minCoord =  AnimationData.instance.animationData[batchSprite.path]["frame"][barImage].left;
                    _maxCoord =  _minCoord + AnimationData.instance.animationData[batchSprite.path]["frame"][barImage].width;
                    break;
                
                case Slider.SLIDER_TYPE_VERTICAL_BAR:
                    _oldTouch = _buttonSprite.position.y;
                    _minCoord =  AnimationData.instance.animationData[batchSprite.path]["frame"][barImage].bottom;
                    _maxCoord =  AnimationData.instance.animationData[batchSprite.path]["frame"][barImage].height;
                    break;
            }
            
        }
        
        private function initSprite(batchSprite:BatchSprite, name:String):Sprite
        {
            var sprite:Sprite = new Sprite();
            sprite.createSpriteWithBatchSprite(batchSprite, name);
            batchSprite.addSprite(sprite);
            
            var frame:AnimationFrame = AnimationData.instance.animationData[batchSprite.path]["frame"][name];
            
            sprite.position.x = frame.pivotX;
            sprite.position.y = StageContext.instance.screenHeight - frame.pivotY;
            sprite.setAnchorPoint(frame.anchorX, frame.anchorY);
            
            return sprite;
        }
        
        public function eventMouseClick(event:MouseEvent):void
        {
            if( _barSprite.rect.containsPoint(new Point(event.stageX, StageContext.instance.screenHeight - event.stageY)) )
            {
                if( callbackClick != null )
                {
                    callbackClick();
                }
            }
        }
        
        public function eventMouseDown(event:MouseEvent):void
        {
            if( _buttonSprite.rect.containsPoint(new Point(event.stageX, StageContext.instance.screenHeight - event.stageY)) )
            {
                _isMoving = true;
            }
        }
        
        /**
         * 슬라이더를 터치해서 움직이는 상태일 때 호출되는 콜백 함수입니다. 
         */
        public function eventMouseMove(event:MouseEvent):void
        {
            if( !_isMoving )
                return;
            
            var diff:Number;
            
            //슬라이더 버튼을 움직임
            switch( _type )
            {
                case Slider.SLIDER_TYPE_HORIZONTAL_BAR:
                    diff = event.stageX - _oldTouch;
                    _buttonSprite.position.x += diff;
                    
                    if( _buttonSprite.position.x <= _minCoord )
                    {
                        _buttonSprite.position.x = _minCoord;
                        _oldTouch = _minCoord; 
                    }
                    else if( _buttonSprite.position.x >= _maxCoord )
                    {
                        _buttonSprite.position.x = _maxCoord;
                        _oldTouch = _maxCoord; 
                    }
                    else
                    {
                        _oldTouch = event.stageX;
                    }
                    
                    _currentValue = (_buttonSprite.position.x - _minCoord ) / (_maxCoord - _minCoord ) * (_maxValue - _minValue );;
                    break;
                
                case SLIDER_TYPE_VERTICAL_BAR:
                    diff = event.stageY - _oldTouch;
                    _buttonSprite.position.y += diff;
                    
                    if( _buttonSprite.position.y <= _minCoord )
                    {
                        _buttonSprite.position.y = _minCoord;
                        _oldTouch = _minCoord; 
                    }
                    else if( _buttonSprite.position.y >= _maxCoord )
                    {
                        _buttonSprite.position.y = _maxCoord;
                        _oldTouch = _maxCoord; 
                    }
                    else
                    {
                        _oldTouch = event.stageY;
                    }
                    
                    _currentValue = (_buttonSprite.position.y - _minCoord ) / (_maxCoord - _minCoord ) * (_maxValue - _minValue );;
                    break;
            }
            
            if( callbackMouseMove != null )
            {
                callbackMouseMove();
            }
        }
        
        /**
         * 슬라이더를 터치해서 움직이다가 놓았을 때 콜백 함수입니다. 
         */
        public function eventMouseUp(event:MouseEvent):void
        {
            _isMoving = false;
            
            if( callbackMouseUp != null )
            {
                callbackMouseUp();
            }
        }
        
        public function setBarPosition(x:Number, y:Number):void
        {
            _barSprite.setTranslation(new Vector2D(x, y));
        }
        
        public function setBarAnchorPoint(x:Number, y:Number):void
        {
            _barSprite.setAnchorPoint(x, y);
        }
        
        public function setButtonPosition(x:Number, y:Number):void
        {
            _buttonSprite.setTranslation(new Vector2D(x, y));
        }
        
        public function setButtonAnchorPoint(x:Number, y:Number):void
        {
            _buttonSprite.setAnchorPoint(x, y);
        }
        
        /** property */
        
        public function get minValue():Number
        {
            return _minValue;
        }
        public function set minValue(value:Number):void
        {
            _minValue = value;
        }
        
        public function get maxValue():Number
        {
            return _maxValue;
        }
        public function set maxValue(value:Number):void
        {
            _maxValue= value;
        }
        
        public function get value():Number
        {
            return _currentValue;
        }
        public function set value(value:Number):void
        {
            _currentValue = value;
            
            var percent:Number = _currentValue / (_maxValue - _minValue);
            
            switch( _type )
            {
                case Slider.SLIDER_TYPE_HORIZONTAL_BAR:
                    _buttonSprite.position.x = (_maxCoord - _minCoord) * percent + _minCoord;
                    break;
                
                case Slider.SLIDER_TYPE_VERTICAL_BAR:
                    _buttonSprite.position.y = (_maxCoord - _minCoord) * percent + _minCoord;
                    break;
            }
        }
    }
}