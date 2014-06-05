package com.stintern.st2D.animation.datatype
{
    /**
     * 스프라이트 시트에 존재 하는 각각의 이미지들을 Frame 단위로 나눠서 저장하기 위한 클래스입니다. 
     * @author 신동환
     */
    public class AnimationFrame
    {
        private var _name:String;
        private var _x:Number;
        private var _y:Number;
        private var _width:int;
        private var _height:int;
        private var _pivotX:Number;
        private var _pivotY:Number;
        private var _left:Number;
        private var _top:Number;
        private var _frameWidth:int;
        private var _frameHeight:int;
		private var _anchorX:Number;
		private var _anchorY:Number;
        private var _fontFamily:String;
        private var _fontSize:Number;
        private var _fontColor:uint;
        private var _text:String;
        
        /**
         * Frame 생성자입니다.
         * @param name Frame의 이름
         * @param x 스프라이트 시트에서 Frame의 x 좌표
         * @param y 스프라이트 시트에서 Frame의 y 좌표
         * @param width 스프라이트 시트에서 Frame의 가로 길이
         * @param height 스프라이트 시트에서 Frame의 세로 길이
         * @param frameX 스프라이트 시트 만들 때 공백을 자르기 전, 원래 이미지에서의 Frame의 x 좌표
         * @param frameY 스프라이트 시트 만들 때 공백을 자르기 전, 원래 이미지에서의 Frame의 y 좌표
         * @param frameWidth 스프라이트 시트 만들 때 공백을 자르기 전, 원래 이미지에서의 Frame의 가로 길이
         * @param frameHeight 스프라이트 시트 만들 때 공백을 자르기 전, 원래 이미지에서의 Frame의 세로 길이
         */
        public function AnimationFrame(name:String, x:Number, y:Number, width:int, height:int, pivotX:Number, pivotY:Number, left:Number, top:Number, frameWidth:int, frameHeight:int, anchorX:Number, anchorY:Number, fontFamily:String, fontColor:uint, fontSize:Number, text:String)
        {
            _name = name;
            _x = x;
            _y = y;
            _width = width;
            _height = height;
            _pivotX = pivotX;
            _pivotY = pivotY;
            _left = left;
            _top = top;
            _frameWidth = frameWidth;
            _frameHeight = frameHeight;
			_anchorX = anchorX;
			_anchorY = anchorY;
            _fontFamily = fontFamily;
            _fontSize = fontSize;
            _fontColor = fontColor;
            _text = text;
        }
        
        public function get name():String     {return _name;}
        public function get x():Number           {return _x;}
        public function get y():Number           {return _y;}
        public function get width():int       {return _width;}
        public function get height():int      {return _height;}
        public function get pivotX():Number      {return _pivotX;}
        public function get pivotY():Number      {return _pivotY;}
        public function get left():Number          {return _left;}
        public function get top():Number          {return _top;}
        public function get frameWidth():int  {return _frameWidth;}
        public function get frameHeight():int {return _frameHeight;}
		public function get anchorX():Number  {return _anchorX;}
		public function get anchorY():Number {return _anchorY;}
        public function get fontFamily():String  {return _fontFamily;}
        public function get fontSize():Number {return _fontSize;}
        public function get fontColor():uint  {return _fontColor;}
        public function get text():String {return _text;}
        
        public function set name(value:String):void     {_name        = value;}
        public function set x(value:Number):void           {_x           = value;}
        public function set y(value:Number):void           {_y           = value;}
        public function set width(value:int):void       {_width       = value;}
        public function set height(value:int):void      {_height      = value;}
        public function set pivotX(value:Number):void      {_pivotX      = value;}
        public function set pivotY(value:Number):void      {_pivotY      = value;}
        public function set left(value:Number):void          {_left = value;}
        public function set top(value:Number):void          { _top = value;}
        public function set frameWidth(value:int):void  {_frameWidth  = value;}
        public function set frameHeight(value:int):void {_frameHeight = value;}
		public function set anchorX(value:Number):void  {_anchorX  = value;}
		public function set anchorY(value:Number):void {_anchorY = value;}
        public function set fontFamily(value:String):void  {_fontFamily  = value;}
        public function set fontSize(value:Number):void {_fontSize = value;}
        public function set fontColor(value:uint):void  {_fontColor  = value;}
        public function set text(value:String):void {_text = value;}
	}
}