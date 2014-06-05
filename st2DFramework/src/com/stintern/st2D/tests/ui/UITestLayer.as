package com.stintern.st2D.tests.ui
{
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.Sprite;
    import com.stintern.st2D.display.sprite.SpriteAnimation;
    import com.stintern.st2D.ui.Button;
    import com.stintern.st2D.ui.Slider;
    import com.stintern.st2D.ui.Text;
    import com.stintern.st2D.utils.UILoader;
    
    public class UITestLayer extends Layer
    {
        private var _uiLoader:UILoader = new UILoader(); 
        
        private var _text:Text;
        private var _slider:Slider;
        private var _volume:uint = 12;
        
        public function UITestLayer()
        {
            super();
            
            init();
        }
        
        override public function update(dt:Number):void
        {
        }
        
        private function init():void
        {
            _uiLoader.init(this, "res/atlas.png", "res/atlas.xml", loadComplete);
        }
        
        private function loadComplete():void
        {
            var bkgSprite:Sprite = _uiLoader.loadSprite("bkg");
            var button:Button = _uiLoader.loadButton("startButton", "startButtonClicked", onStartClick);
            
            var animation:SpriteAnimation = _uiLoader.loadAnimation("mole");
            animation.playAnimation();
            
            var animation2:SpriteAnimation = _uiLoader.loadAnimation("mole2");
            animation2.playAnimation();
            
            _text = _uiLoader.loadTextField("volumeText");
            _text.callbackClick = onTextClick;
            
            _slider = _uiLoader.loadSlider("VolumeSliderBar", "VolumeSliderButton", Slider.SLIDER_TYPE_HORIZONTAL_BAR);
            _slider.callbackMouseMove = callbackSliderMove;
            _slider.callbackClick = callbackSliderMove;
            
            _slider.value = _volume;
        }
        
        private function onStartClick():void
        {
            
        }
        
        private function callbackSliderMove():void
        {
            _text.text = "Volume " + _slider.value.toFixed(0);
            trace("Volume " + _slider.value);
        }
        
        private function onTextClick():void
        {
        }
    }
}