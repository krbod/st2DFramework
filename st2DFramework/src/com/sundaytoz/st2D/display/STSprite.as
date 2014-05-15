package com.sundaytoz.st2D.display
{
    import com.sundaytoz.st2D.basic.StageContext;
    import com.sundaytoz.st2D.utils.AssetLoader;
    import com.sundaytoz.st2D.utils.Vector2D;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display3D.Context3D;
    import flash.display3D.Context3DTextureFormat;
    import flash.display3D.IndexBuffer3D;
    import flash.display3D.VertexBuffer3D;
    import flash.display3D.textures.Texture;
    import flash.geom.Matrix;
    import flash.geom.Matrix3D;
    import flash.geom.Rectangle;
    import flash.geom.Vector3D;
    
    public class STSprite extends STObject
    {
        private var _position:Vector2D;
        private var _scale:Vector2D;
        private var _rotate:Vector2D;
        
        private var _depth:Number;
        
        private var _texture:Texture;
        private var _textureData:Bitmap;

        private var _modelMatrix:Matrix3D = new Matrix3D();
        
        private var _path:String;
        
        private var _rotation:Vector3D = new Vector3D();
        private var _translation:Vector3D = new Vector3D();
        
        private static var _meshIndexData:Vector.<uint> = Vector.<uint>  ([ 0, 1, 2, 0, 2, 3, ]);
        private var _meshVertexData:Vector.<Number> = Vector.<Number>
                                ([
                                //X, Y, Z,              U, V,       nX, nY, nZ,     R,  G, B, A
                                -0.5, 0.5,  0.5,      0,  0,      0, 0, 1,        1.0,1.0,1.0,1.0,
                                0.5,  0.5,  0.5,      1,  0,      0, 0, 1,        0.0,0.0,1.0,1.0,
                                0.5,  -0.5, 0.5,      1,  1,      0, 0, 1,        0.0,1.0,0.0,1.0,
                                -0.5, -0.5, 0.5,      0,  1,      0, 0, 1,        1.0,0.0,0.0,1.0
                                ]);
                        
        
        private var _vertexBuffer:VertexBuffer3D;
        private var _indexBuffer:IndexBuffer3D;
        
        /**
        *  이미지를 연속해서 생성할 때 AssetLoader 가 이미지를 비동기적으로 불러오면서 용량이 작아 먼저 불려진 이미지가 
        *  STSpriteManager 의 STSprite 컨테이너에 먼저 추가되서 출력 시 먼저 그려질 수 가 있기 때문에 이를 방지하기 위해
        *  Sprite 를 생성한 순서를 가짐
         */
        private var _zOrder:int = -1;  // 이미지가 생성된 순서 
               
        public function STSprite()
        {
            _position = new Vector2D(0.0, 0.0);
            _depth = 0;
        }
        
        public static function createSpriteWithPath(path:String, onCreated:Function, onProgress:Function = null,  x:Number=0, y:Number=0 ):void
        {
            var sprite:STSprite = new STSprite();
            sprite.path = path;
            
            sprite.position.x = x;
            sprite.position.y = y;
                        
            AssetLoader.instance.loadImageTexture(path, onComplete, onProgress);
            function onComplete(object:Object, zOrder:uint):void
            {
                sprite.zOrder = zOrder;
                
                sprite.initBuffer();
                sprite.initTexture((object as Bitmap));
                
                onCreated(sprite);
            }
        }
                
        public function initTexture(bitmap:Bitmap, useMipMap:Boolean=true):void
        {
            textureData = bitmap;
            
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
        
        public function update():void
        {
            _modelMatrix.identity();
            
            // scale
            _modelMatrix.appendScale(_textureData.width, _textureData.height, 1);
            
            // rotate
            
            // translate
            _modelMatrix.appendTranslation(_position.x, _position.y, _depth);
            
        }
        
        /**
         * UV 좌표값을 입력합니다. 
         */
        public function setUVCoord(u:Number, v:Number, width:Number, height:Number):void
        {
            if(_vertexBuffer != null)
            {
                _meshVertexData[3] = u;
                _meshVertexData[4] = v;
                
                _meshVertexData[3+12] = u+width;
                _meshVertexData[4+12] = v;
                
                _meshVertexData[3+12*2] = u+width;
                _meshVertexData[4+12*2] = v+height;
                
                _meshVertexData[3+12*3] = u;
                _meshVertexData[4+12*3] = v+height;
                
                _vertexBuffer.uploadFromVector(_meshVertexData, 0, _meshVertexData.length/12);
            }
        }
        
        private function initBuffer():void
        {
            var context:Context3D = StageContext.instance.context; 
            
            _vertexBuffer = context.createVertexBuffer(_meshVertexData.length/12, 12); 
            _vertexBuffer.uploadFromVector(_meshVertexData, 0, _meshVertexData.length/12);
            
            _indexBuffer = context.createIndexBuffer(_meshIndexData.length);
            _indexBuffer.uploadFromVector(_meshIndexData, 0, _meshIndexData.length);
        }
        
        
        /**
         * 사용한 자원을 해제합니다. 
         */
        public function clean():void
        {
            AssetLoader.instance.removeImage(_path);
            
            if( _texture != null )
                _texture.dispose();
            _texture = null;
            
            if( _textureData.bitmapData != null )
                _textureData.bitmapData.dispose(); 
            _textureData.bitmapData = null;
            
            _modelMatrix = null;
            _rotation = null;
            _translation = null;
            
            _position = null;
        }
        
        
        /**
         * 밉맵을 만듭니다. 
         */
        private function uploadTextureWithMipmaps(dest:Texture, src:BitmapData):void
        {
            var ws:int = src.width;
            var hs:int = src.height;
            var level:int = 0;
            var tmp:BitmapData;
            var transform:Matrix = new Matrix();
            
            var fillColor:uint = 0x00000000;
            
            tmp = new BitmapData(src.width, src.height, true, fillColor);
            
            while ( ws >= 1 && hs >= 1 )
            { 
                tmp.draw(src, transform, null, null, null, true); 
                dest.uploadFromBitmapData(tmp, level);
                transform.scale(0.5, 0.5);
                level++;
                ws >>= 1;
                hs >>= 1;
                if (hs && ws) 
                {
                    tmp.dispose();
                    tmp = new BitmapData(ws, hs, true, fillColor);
                }
            }
            tmp.dispose();
        }

        /** Property */
        public function get numTriangle():int
        {
            return _meshIndexData.length/3;
        }
        public function get vertexBuffer():VertexBuffer3D
        {
            return _vertexBuffer;
        }
        
        public function get indexBuffer():IndexBuffer3D
        {
            return _indexBuffer;
        }
        
        public function get texture():Texture
        {
            return _texture;
        }
        public function set texture(texture:Texture):void
        {
            _texture = texture;
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
        
        public function get textureData():Bitmap
        {
            return _textureData;
        }
        public function set textureData(bitmap:Bitmap):void
        {
            _textureData = bitmap;
        }
        
        public function get path():String
        {
            return _path;
        }
        public function set path(path:String):void
        {
            _path = path;
        }
        
        
        public function get left():Number
        {
            return _position.x - _textureData.width * 0.5;
        }
        public function get right():Number
        {
            return _position.x + _textureData.width * 0.5;
        }
        public function get top():Number
        {
            return _position.y + _textureData.height * 0.5;
        }
        public function get bottom():Number
        {
            return _position.y - _textureData.height * 0.5;
        }
        
        public function get rect():Rectangle
        {
            return new Rectangle(this.left, this.top, this.width, this.height);
        }
        
        public function get position():Vector2D
        {
            return _position;
        }
        public function set position(position:Vector2D):void
        {
            _position = position;
        }
        
        /**
         * 텍스쳐의 가로 길이를 리턴합니다. 
         */
        public function get width():Number
        {            
            return _textureData.width;
        }
        /**
         * 텍스쳐의 세로 길이를 리턴합니다. 
         */
        public function get height():Number
        {
            return _textureData.height;
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
