package com.stintern.st2D.tests
{
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.SceneManager;
    import com.stintern.st2D.display.sprite.Sprite;
    import com.stintern.st2D.tests.batch.BatchSpriteLayer;
    
    import flash.events.MouseEvent;
    
    public class TestLayer extends Layer
    {
        private var sprite1:Sprite;
        private var sprite2:Sprite;
        
        public function TestLayer()
        {            
            var testLayer:BatchSpriteLayer = new BatchSpriteLayer();
            testLayer.tag = 1;
            
            
            SceneManager.instance.getCurrentScene().addLayer(testLayer);
            
            StageContext.instance.stage.addEventListener(MouseEvent.CLICK, onTouch);
        }
        
        override public function update(dt:Number):void
        {
        }
        
        private function onCreated(sprite:Sprite):void
        {
            sprite1 = sprite;
            this.addSprite(sprite1);
        }
        
        private function onCreated2(sprite:Sprite):void
        {
            sprite2 = sprite;
            this.addSprite(sprite2);
        }
        
        private function onTouch(event:MouseEvent):void
        {
            
            //SceneManager.instance.getCurrentScene().getLayerByTag(2).isVisible = false;
            
            //            var testLayer:TRSLayer = new TRSLayer();
//            
//            var scene:Scene = new Scene();
//            scene.addLayer(testLayer);
//            
//            SceneManager.instance.pushScene(scene);
//            
//            StageContext.instance.stage.removeEventListener(MouseEvent.CLICK, onTouch);
        }
        
    }
}