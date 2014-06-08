package com.stintern.st2D.ui
{
    import com.stintern.st2D.animation.datatype.AnimationFrame;
    import com.stintern.st2D.basic.StageContext;
    
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;

    public class Text extends UIBase
    {
        private var _textField:TextField;
        private var _text:String;
        
        public function Text()
        {
            super();
        }
        
        public function dispose():void
        {
            StageContext.instance.stage.removeEventListener(MouseEvent.CLICK, eventMouseClick);
        }
        
        public function init(frame:AnimationFrame):void
        {
            _text = frame.text;
            
            var myFormat:TextFormat = new TextFormat();  
            myFormat.color = frame.fontColor;
            myFormat.size = frame.fontSize;
            myFormat.font = frame.fontFamily;
            
            _textField = new TextField();
            _textField.selectable = false;
            //_textField.autoSize = TextFieldAutoSize.RIGHT;
            _textField.defaultTextFormat = myFormat;
            _textField.text = _text;
            _textField.x = frame.pivotX;
            _textField.y = frame.pivotY;
            _textField.autoSize = TextFieldAutoSize.LEFT;
            
            
            StageContext.instance.stage.addChild(_textField);
            StageContext.instance.stage.addEventListener(MouseEvent.CLICK, eventMouseClick);
        }
        
        public function get text():String
        {
            return _text;
        }
        public function set text(text:String):void
        {
            _text = text;
            _textField.text = _text;
            
            _textField.autoSize = TextFieldAutoSize.LEFT;
        }
        
        public function eventMouseClick(event:MouseEvent):void
        {
            var rect:Rectangle = new Rectangle(_textField.x, _textField.y, _textField.width, _textField.height);
            if( rect.containsPoint(new Point(event.stageX, event.stageY)) )
            {
                if( callbackClick != null )
                    callbackClick();
            }
        }
        
		public function setVisible(isVisible:Boolean):void
		{
			_textField.visible = isVisible;
		}
        
    }
}