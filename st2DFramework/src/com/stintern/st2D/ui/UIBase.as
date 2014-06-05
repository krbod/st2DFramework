package com.stintern.st2D.ui
{
    public class UIBase
    {
        
        private var _callbackOnClick:Function = null;
        private var _callbackOnMouseDown:Function = null;
        private var _callbackOnMouseMove:Function = null;
        private var _callbackOnMouseUp:Function = null;
        
        public function UIBase()
        {
        }
        
        
        
        /** property */
        
        public function get callbackClick():Function
        {
            return _callbackOnClick;
        }
        public function set callbackClick(callback:Function):void
        {
            _callbackOnClick = callback;
        }
        
        public function get callbackMouseDown():Function
        {
            return _callbackOnMouseDown;
        }
        public function set callbackMouseDown(callback:Function):void
        {
            _callbackOnMouseDown = callback;
        }
        
        public function get callbackMouseMove():Function
        {
            return _callbackOnMouseMove;
        }
        public function set callbackMouseMove(callback:Function):void
        {
            _callbackOnMouseMove = callback;
        }
        
        public function get callbackMouseUp():Function
        {
            return _callbackOnMouseUp;
        }
        public function set callbackMouseUp(callback:Function):void
        {
            _callbackOnMouseUp = callback;
        }
    }
}