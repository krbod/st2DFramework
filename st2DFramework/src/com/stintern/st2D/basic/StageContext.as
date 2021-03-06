package com.stintern.st2D.basic
{
    import com.adobe.utils.AGALMiniAssembler;
    import com.adobe.utils.PerspectiveMatrix3D;
    import com.stintern.st2D.utils.Vector2D;
    
    import flash.display.Stage;
    import flash.display.Stage3D;
    import flash.display.StageAlign;
    import flash.display.StageDisplayState;
    import flash.display.StageScaleMode;
    import flash.display3D.Context3D;
    import flash.display3D.Context3DProgramType;
    import flash.display3D.Program3D;
    import flash.events.Event;
    import flash.geom.Matrix3D;

    public class StageContext
    {
        // 싱글톤 관련 변수들
        private static var _instance:StageContext;
        private static var _creatingSingleton:Boolean = false;
        
        private var _context3D:Context3D;
        private var _shaderProgram:Program3D;
        
        private var _mainCamera:Camera = new Camera();
        
        private var _projectionMatrix:PerspectiveMatrix3D = new PerspectiveMatrix3D();
        private var _viewMatrix:Matrix3D = new Matrix3D();
        
        private var _screenWidth:uint;
        private var _screenHeight:uint;
        
        private var _stage:Stage;
        
        public function StageContext()
        {
            if (!_creatingSingleton){
                throw new Error("[Context] 싱글톤 클래스 - new 연산자를 통해 생성 불가");
            }
            
        }
        
        public static function get instance():StageContext
        {
            if (!_instance){
                _creatingSingleton = true;
                _instance = new StageContext();
                _creatingSingleton = false;
            }
            return _instance;
        }
        
        /**
         * Stage3D 를 초기화하고 그릴 준비를 합니다. 
         * @param stage Application 의 stage 객체
         * @param onInited 초기화 후 불려질 콜백 함수
         */
        public function init(stage:Stage, onInited:Function):void
        {
            _stage = stage;
            
            stage.frameRate = 60;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            stage.displayState = StageDisplayState.FULL_SCREEN;
            
            stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE, onContext3DCreate);
            stage.stage3Ds[0].requestContext3D();
            
//            _screenWidth = stage.fullScreenWidth;
//            _screenHeight = stage.fullScreenHeight;
			
			_screenWidth = 768;
            _screenHeight = 1024;
                
            function onContext3DCreate(event:Event):void 
            {
                var t:Stage3D = event.target as Stage3D;					
                _context3D = t.context3D;
                
                if (_context3D == null) 
                {
                    return;
                }
                
                _context3D.enableErrorChecking = true;
                _context3D.configureBackBuffer(_screenWidth, _screenHeight, 2, true); //(2=antialiased)
                
                initShaders();
                
                _mainCamera.init(-_screenWidth*0.5, -_screenHeight*0.5, _screenWidth, _screenHeight);
                
                onInited();
            }
        }
        
        private function initShaders():void
        {
            var vertexShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
            vertexShaderAssembler.assemble
                ( 
                    Context3DProgramType.VERTEX,
                    // 4x4 matrix multiply to get camera angle	
                    "m44 op, va0, vc0\n" +
                    // tell fragment shader about XYZ
                    "mov v0, va0\n" +
                    // tell fragment shader about UV
                    "mov v1, va1\n" +
                    // tell fragment shader about RGBA
                    "mov v2, va2\n"
                );			
            
            var fragmentShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
            fragmentShaderAssembler.assemble
                ( 
                    Context3DProgramType.FRAGMENT,	
                    "tex ft0, v1, fs0 <2d,linear,repeat>\n" +	
                    "mul ft1, v2, ft0\n" +
                    "mov oc, ft1\n"									
                );
            
            _shaderProgram = _context3D.createProgram();
            _shaderProgram.upload(vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode);
        }
        
        public function translateCamera(translate:Vector2D):void
        {
            _viewMatrix.appendTranslation(translate.x + -_screenWidth*0.5, translate.y + -_screenHeight*0.5, 0);
            translate = null;
        }
        
        /** property */
        
        public function get context():Context3D
        {
            return _context3D;
        }
        
        public function get mainCamera():Camera
        {
            return _mainCamera;
        }
        
        public function get shaderProgram():Program3D
        {
            return _shaderProgram;
        }

        public function get projectionMatrix():Matrix3D
        {
            return _mainCamera.projection;
        }
        
        public function get viewMatrix():Matrix3D
        {
            return _mainCamera.viewMatrix;
        }
        
        public function get screenWidth():uint
        {
            return _screenWidth;
        }
        public function get screenHeight():uint
        {
            return _screenHeight;
        }
        
        public function get stage():Stage
        {
            return _stage;
        }

    }
}