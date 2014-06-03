package com.stintern.st2D.animation.datatype
{
    /**
     * 스프라이트 시트에 존재 하는 각각의 이미지들을 Frame 단위로 나눠서 저장하기 위한 클래스입니다. 
     * @author 신동환
     */
    public class AnimationFrame
    {
        private var _name:String;
        private var _x:int;
        private var _y:int;
        private var _width:int;
        private var _height:int;
        private var _pivotX:int;
        private var _pivotY:int;
        private var _left:int;
        private var _top:int;
        private var _frameWidth:int;
        private var _frameHeight:int;
        
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
        public function AnimationFrame(name:String, x:int, y:int, width:int, height:int, pivotX:int, pivotY:int, left:int, top:int, frameWidth:int, frameHeight:int)
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
        }
        
        public function get name():String     {return _name;}
        public function get x():int           {return _x;}
        public function get y():int           {return _y;}
        public function get width():int       {return _width;}
        public function get height():int      {return _height;}
        public function get pivotX():int      {return _pivotX;}
        public function get pivotY():int      {return _pivotY;}
        public function get left():int          {return _left;}
        public function get top():int          {return _top;}
        public function get frameWidth():int  {return _frameWidth;}
        public function get frameHeight():int {return _frameHeight;}
        
        public function set name(value:String):void     {_name        = value;}
        public function set x(value:int):void           {_x           = value;}
        public function set y(value:int):void           {_y           = value;}
        public function set width(value:int):void       {_width       = value;}
        public function set height(value:int):void      {_height      = value;}
        public function set pivotX(value:int):void      {_pivotX      = value;}
        public function set pivotY(value:int):void      {_pivotY      = value;}
        public function set left(value:int):void          {_left = value;}
        public function set top(value:int):void          { _top = value;}
        public function set frameWidth(value:int):void  {_frameWidth  = value;}
        public function set frameHeight(value:int):void {_frameHeight = value;}
    }
}