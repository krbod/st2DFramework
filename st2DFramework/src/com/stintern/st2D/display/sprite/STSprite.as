package com.stintern.st2D.display.sprite
{
    import com.stintern.st2D.animation.AnimationData;
    import com.stintern.st2D.animation.datatype.AnimationFrame;
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.utils.AssetLoader;
    import com.stintern.st2D.utils.Vector2D;
    
    import flash.display.Bitmap;
    import flash.display3D.Context3D;
    import flash.display3D.Context3DTextureFormat;
    import flash.geom.Matrix3D;
    import flash.geom.Rectangle;
    import flash.geom.Vector3D;
    
    public class STSprite extends BaseSprite 
    {
        private var _position:Vector2D = new Vector2D(0.0, 0.0);
        private var _scale:Vector2D = new Vector2D(1.0, 1.0);
        private var _rotateAxis:Vector3D = new Vector3D(0.0, 0.0, 0.0);
        private var _rotateDegree:Number = 0;
        
        private var _frame:Rectangle = new Rectangle(0, 0, 0, 0);
        private var _depth:Number = 0;

        private var _modelMatrix:Matrix3D = new Matrix3D();
        
        /**
        *  이미지를 연속해서 생성할 때 AssetLoader 가 이미지를 비동기적으로 불러오면서 용량이 작아 먼저 불려진 이미지가 
        *  STSpriteManager 의 STSprite 컨테이너에 먼저 추가되서 출력 시 먼저 그려질 수 가 있기 때문에 이를 방지하기 위해
        *  Sprite 를 생성한 순서를 가짐
         */
        private var _zOrder:int = -1;  // 이미지가 생성된 순서 
        
        private var _isMoving:Boolean;
        private var _increaseX:Number;         //지금 움직이는중이면 얼마만큼씩 움직여야 하는지
        private var _increaseY:Number;         //지금 움직이는중이면 얼마만큼씩 움직여야 하는지
        private var _destX:int;                //이동중일때 목적지의 좌표
        private var _destY:int;                //이동중일때 목적지의 좌표
               
        public function STSprite()
        {
            super();
            
            indexData.push( 0, 1, 2, 0, 2, 3 );
            vertexData.push(
                    //X, Y, Z,              U, V,            R,  G, B, A
                    -0.5, 0.5,  0.5,      0,  0,              1.0,1.0,1.0,1.0,
                    0.5,  0.5,  0.5,      1,  0,             0.0,0.0,1.0,1.0,
                    0.5,  -0.5, 0.5,      1,  1,             0.0,1.0,0.0,1.0,
                    -0.5, -0.5, 0.5,      0,  1,             1.0,0.0,0.0,1.0
                );
            
            _isMoving = false;
            _increaseX = 0;
            _increaseY = 0;
            _destX = 0;
            _destY = 0;
        }
        
        /**
         * 파일 경로를 이용해서 스프라이트를 생성합니다.  
         * @param path  이미지 경로
         * @param onCreated 스프라이트가 생성된 후 불려질 콜백 함수
         * @param onProgress 스프라이트가 생성되는 과정에서 불려질 콜백 함수
         * @param x 스프라이트를 처음에 위치시킬 X 좌표
         * @param y 스프라이트를 처음에 위치시킬 Y 좌표
         */
        public function createSpriteWithPath(path:String, onCreated:Function, onProgress:Function = null,  x:Number=0, y:Number=0 ):void
        {
            this.path = path;
            
            position.x = x;
            position.y = y;
                        
            AssetLoader.instance.loadImageTexture(path, onComplete, onProgress);
            function onComplete(object:Object, zOrder:uint):void
            {
                this.zOrder = zOrder;
                
                initBuffer();
                initTexture((object as Bitmap));
                
                update();
                
                onCreated(this);
            }
        }
        
        public function createSpriteWithBatchSprite(batchSprite:BatchSprite, imageName:String, onCreated:Function, x:Number = 0, y:Number=0):void
        {
            if( batchSprite == null )
            {
                throw new Error("batchSprite is null");
            }
            
            // BatchSprite 에서 사용할 이미지의 UV 좌표를 읽어옵니다.
            var uvCoord:Array = getUVCoord(imageName);
            if( uvCoord == null )
            {
                throw new Error("아직 애니메이션 데이터가 로딩중입니다.");  
            }
            
            this.path = path;
            
            position.x = x;
            position.y = y;
            
            this.zOrder = AssetLoader.instance.increaseImageNo();
            
            

        }
        
        /**
         * Batchsprite 이미지에서 스프라이트가 사용할 이미지의 uv 좌표를 알아옵니다. 
         * @param imageName xml 상에 기입된 이미지의 이름
         * @return uv 좌표
         */
        private function getUVCoord(imageName:String):Array
        {
            var uvCoord:Array = new Array();
            
            if(AnimationData.instance.animationData[path]["available"] == 2)
            {
                //현재 프레임 정보
                var tempFrame:AnimationFrame = AnimationData.instance.animationData[path]["frame"][imageName];
                
                //uv좌표 변경하는 방식
                frame.width = tempFrame.width;
                frame.height = tempFrame.height;
                
                uvCoord.push(tempFrame.x/textureWidth, tempFrame.y/textureHeight);                                                              //left top
                uvCoord.push(tempFrame.x/textureWidth + tempFrame.width/textureWidth, tempFrame.y/textureHeight);           //right top
                uvCoord.push(tempFrame.x/textureWidth + tempFrame.width/textureWidth, tempFrame.y/textureHeight + tempFrame.height/textureHeight);           //right bottom
                uvCoord.push(tempFrame.x/textureWidth, tempFrame.y/textureHeight + tempFrame.height/textureHeight);           //left bottom
                
                tempFrame = null;
                
                return uvCoord;
            }
            
            return null;
        }
                
        /**
         * 스프라이트에 사용할 텍스쳐를 초기화합니다. 
         * @param bitmap 텍스쳐에 사용할 비트맵객체
         * @param useMipMap 비트맵 밉맵을 생성할 지 여부
         */
        public function initTexture(bitmap:Bitmap, useMipMap:Boolean=true):void
        {
            textureData = bitmap;
            _frame.width = textureData.width;
            _frame.height = textureData.height;
            
            var context:Context3D = StageContext.instance.context; 
            texture = context.createTexture(bitmap.width, bitmap.height, Context3DTextureFormat.BGRA, false);
            if( useMipMap )
            {
                uploadTextureWithMipmaps(texture, bitmap.bitmapData);                
            }
            else
            {
                texture.uploadFromBitmapData(bitmap.bitmapData);
            }
        }
        
        /**
         * 스프라이트의 Scale, Rotation, Translation 을 변경합니다. 
         */
        public function update():void
        {
            //스프라이트가 이동중이면 이동시킵니다.
            move();
            
            _modelMatrix.identity();
            
            // scale
            _modelMatrix.appendScale(_frame.width * scale.x, _frame.height * scale.y, 1);
            
            // rotate
            _modelMatrix.appendRotation( _rotateDegree, _rotateAxis );
            
            // translate
            _modelMatrix.appendTranslation(_position.x, _position.y, _depth);
            
        }
        
        /**
         * UV 좌표값을 입력합니다. 
         */
        public function setUVCoord(u:Number, v:Number, width:Number, height:Number):void
        {
            if(vertexBuffer != null)
            {
                vertexData[3] = u;
                vertexData[4] = v;
                
                vertexData[3+9] = u+width;
                vertexData[4+9] = v;
                
                vertexData[3+9*2] = u+width;
                vertexData[4+9*2] = v+height;
                
                vertexData[3+9*3] = u;
                vertexData[4+9*3] = v+height;
                
                vertexBuffer.uploadFromVector(vertexData, 0, vertexData.length/9);
            }
        }
        
        /**
         * 스프라이트를 확대 및 축소 시킵니다.  <br/>
         * 사용한 파라미터 axis 는 값을 복사한 뒤 null 로 셋팅됩니다.
         * @param scale 확대 및 축소 시킬 비율
         */
        public function setScale(scale:Vector2D):void
        {
            _scale.x = scale.x;
            _scale.y = scale.y;
            
            scale = null;
        }
        
        /**
         * 스프라이트를 회전시킵니다. <br/>
         * 사용한 파라미터 axis 는 값을 복사한 뒤 null 로 셋팅됩니다.
         * @param degree 회전할 각도
         * @param axis 회전 축
         */
        public function setRotate(degree:Number, axis:Vector3D):void
        {
            _rotateDegree = degree;
            _rotateAxis.x = axis.x;
            _rotateAxis.y = axis.y;
            _rotateAxis.z = axis.z;
            
            axis = null;
        }
        
        /**
         * 스프라이트를 이동시킵니다. <br/>
         * 사용한 파라미터 translation 는 값을 복사한 뒤 null 로 셋팅됩니다.
         * @param translation 이동할 지점
         */
        public function setTranslation(translation:Vector2D):void
        {
            _position.x = translation.x;
            _position.y = translation.y;
            
            translation = null;
        }
        
        
        /**
         * 사용한 자원을 해제합니다. 
         */
        public function dispose():void
        {
            AssetLoader.instance.removeImage(path);
            
            if( texture != null )
                texture.dispose();
            texture = null;
            
            if( textureData.bitmapData != null )
                textureData.bitmapData.dispose(); 
            textureData.bitmapData = null;
            
            _modelMatrix = null;
            _rotateAxis = null;
            
            _scale = null;
            _position = null;
            _rotateAxis = null;
            
            _position = null;
        }
        
        /**
         * 스프라이트 출력에 필요한 버퍼를 초기화합니다. 
         */
        private function initBuffer():void
        {
            var context:Context3D = StageContext.instance.context; 
            
            vertexBuffer = context.createVertexBuffer(vertexData.length/9, 9); 
            vertexBuffer.uploadFromVector(vertexData, 0, vertexData.length/9);
            
            indexBuffer = context.createIndexBuffer(indexData.length);
            indexBuffer.uploadFromVector(indexData, 0, indexData.length);
        }
        
        /**
         * update에서 호출되는 함수로, STSprite를 이동시켜야 할 경우 이동시키는 함수입니다. 
         */
        private function move():void
        {
            //움직이는 중이면
            if(_isMoving)
            {
                //원하는 지점에 도달 하였으면
                if((Math.abs(_destX - _position.x) <= 1) && (Math.abs(_destY - _position.y) <= 1)) 
                {
                    _isMoving = false;
                }
                //원하는 지점에 아직 도달하지 못했으면
                else
                {
                    _position.x += _increaseX;
                    _position.y += _increaseY;
                }
            }
        }
        
        /**
         * 특정 좌표로 STSprite를 이동시키는 함수입니다.</br>
         * time으로 이동 거리를 나눈값을 더해서 이동합니다. 
         * @param x 이동할 좌표 x
         * @param y 이동할 좌표 y
         * @param time 이동을 완료하는데 얼마나 시간을 걸리게 할 것인지
         */
        public function moveTo(x:int, y:int, second:int):void
        {
            _isMoving = true;
            _destX = x;
            _destY = y;
            _increaseX = (x - _position.x)/(second*60);
            _increaseY = (y - _position.y)/(second*60);
        }
        
        /**
         * STSprite의 현재 위치에서 x,y만큼 이동 시키는 함수입니다.
         * @param x 현재 좌표에 더할 좌표
         * @param y 현재 좌표에 더할 좌표
         * @param second 이동을 완료하는데 얼마나 시간을 걸리게 할 것인지
         */
        public function moveBy(x:int, y:int, second:int):void
        {
            moveTo(_position.x + x, _position.y + y, second);
        }

        /** Property */
        public function get numTriangle():int
        {
            return indexData.length/3;
        }
        
        public function get modelMatrix():Matrix3D
        {
            return _modelMatrix;
        }
        public function set modelMatrix(modelMatrix:Matrix3D):void
        {
            _modelMatrix = modelMatrix;
        }
       
        public function get depth():Number
        {
            return _depth;
        }
        public function set depth(depth:Number):void
        {
            _depth = depth;
        }
        
        public function get left():Number
        {
            return _position.x - this.textureData.width * 0.5;
        }
        public function get right():Number
        {
            return _position.x + this.textureData.width * 0.5;
        }
        public function get top():Number
        {
            return _position.y + this.textureData.height * 0.5;
        }
        public function get bottom():Number
        {
            return _position.y - this.textureData.height * 0.5;
        }
        
        public function get rect():Rectangle
        {
            return new Rectangle(this.left, this.bottom, this.width, this.height);
        }
        
        public function get position():Vector2D
        {
            return _position;
        }
        public function set position(position:Vector2D):void
        {
            _position = position;
        }
        
        public function get scale():Vector2D
        {
            return _scale;
        }

        public function get frame():Rectangle
        {
            return _frame;
        }
          
        public function set frame(value:Rectangle):void
        {
            _frame = value;
         }
        
        /**
         * 텍스쳐의 가로 길이를 리턴합니다. 
         */
        public function get textureWidth():Number
        {            
            return this.textureData.width;
        }
        /**
         * 텍스쳐의 세로 길이를 리턴합니다. 
         */
        public function get textureHeight():Number
        {
            return this.textureData.height;
        }
        
        /**
        * 프레임의 가로 길이를 리턴합니다. 
        */
        public function get width():Number
        {            
            return _frame.width;
        }
        /**
        * 프레임의 세로 길이를 리턴합니다. 
        */
        public function get height():Number
        {
            return _frame.height;
        }
        
        public function get zOrder():int
        {
            return _zOrder;
        }
        public function set zOrder(zOrder:int):void
        {
            _zOrder = zOrder;
        }

    }
}
