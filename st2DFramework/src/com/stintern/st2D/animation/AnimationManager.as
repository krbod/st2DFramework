package com.stintern.st2D.animation
{
    import com.stintern.st2D.animation.datatype.Animation;
    import com.stintern.st2D.animation.datatype.AnimationFrame;
    import com.stintern.st2D.animation.datatype.AnimationPlayData;
    import com.stintern.st2D.display.sprite.STSprite;
    
    import flash.utils.Dictionary;

    /**
     * 재생중인 애니메이션 전체를 관리하는 클래스입니다.
     * @author 신동환
     */
    public class AnimationManager
    {
        // 싱글톤 관련 변수들
        private static var _instance:AnimationManager;
        private static var _creatingSingleton:Boolean = false;
        
        private var _playSprite:Dictionary = new Dictionary; //sprite의 uv좌표를 바꿔주기 위해 sprite를 저장해 두어야 합니다.
        private var _playAnimationData:Dictionary = new Dictionary; //재생중인 애니메이션들의 데이터 입니다.
        private var _isPlaying:Boolean = true; //전체 애니메이션의 재생을 통제하기 위한 변수입니다.
        
        public function AnimationManager()
        {
            if (!_creatingSingleton){
                throw new Error("[AnimationManager] 싱글톤 클래스 - new 연산자를 통해 생성 불가");
            }
        }
        
        public static function get instance():AnimationManager
        {
            if (!_instance){
                _creatingSingleton = true;
                _instance = new AnimationManager();
                _creatingSingleton = false;
            }
            return _instance;
        }

        /**
         * 애니메이션을 사용하겠다고 Sprite를 등록하는 함수입니다. 
         * @param sprite 애니메이션을 사용하고 싶은 Sprite
         * @param animationName 사용할 애니메이션의 이름
         */
        public function addSprite(sprite:STSprite, animationName:String):void
        {
            _playSprite[sprite] = sprite;
            _playAnimationData[sprite] = new AnimationPlayData(AnimationData.instance.animationData[sprite.path], animationName);
            _playSprite[sprite].frame.width = _playAnimationData[sprite].getPlayAnimationFrame().width;
            _playSprite[sprite].frame.height = _playAnimationData[sprite].getPlayAnimationFrame().height;
        }
        
        /**
         * AnimationManager에서 원하는 STSprite를 제거하는 기능입니다.</br>
         * 정확히 말하면 key 값을 제거 하여 더이상 애니메이션 되지 않게 할 뿐이고, 원본 데이터는 그대로 남아있습니다.
         * @param sprite 애니메이션을 제거할 STSprite
         */
        public function removeSprite(sprite:STSprite):void
        {
            if(sprite in _playSprite)
            {
                _playAnimationData[sprite].clear();
                delete _playAnimationData[sprite];
                delete _playSprite[sprite];
            }
            else trace("존재하지 않는 STSprite에 대한 삭제 시도입니다.");
        }
        
        /**
         * 애니메이션을 다음 프레임으로 이동 시킵니다. 
         */
        private function nextFrame(idx:STSprite):AnimationFrame
        {
            var playAnimation:Animation = _playAnimationData[idx].getPlayAnimation();
           
            if(_playAnimationData[idx].isPlaying)
            {
                //현재 애니메이션 프레임 유지할 경우.
                if(_playAnimationData[idx].delayCnt < _playAnimationData[idx].getDelayNum())
                {
                    _playAnimationData[idx].delayCnt++;
                }
                //유지 시간(pauseFrameCnt)이 다되서 다음 프레임으로 넘어갈 때
                else
                {
                    //FlowIdx 가 0부터 시작이라서 -1을 해줘야 합니다.
                    //아직 다음으로 넘어갈 프레임이 존재하는 경우. 즉 애니메이션이 종료되지 않았을때
                    if(_playAnimationData[idx].playAnimationFlowIdx < (playAnimation.animationFlow.length-1))
                    {
                        _playAnimationData[idx].delayCnt = 0;
                        _playAnimationData[idx].playAnimationFlowIdx++;
                    }
                    //현재 애니메이션이 완료되어 다음 애니메이션으로 넘어가야 할 때
                    else
                    {
                        //다음 애니메이션이 존재할경우
                        if(playAnimation.nextAnimationName != null)
                        {
                            _playAnimationData[idx].playAnimationName = playAnimation.nextAnimationName;
                            _playAnimationData[idx].delayCnt = 0;
                            _playAnimationData[idx].playAnimationFlowIdx = 0;
                            
                            nextFrame(idx);
                        }
                        //다음 애니메이션이 존재하지 않을경우
                        else
                        {
                            idx.isVisible = false;
                            _playAnimationData[idx].isPlaying = false;
                            _playAnimationData[idx].delayCnt = 0;
                            _playAnimationData[idx].playAnimationFlowIdx = 0;
                        }
                    }
                }
            }
            //현재 애니메이션의 프레임을 반환합니다.
            return _playAnimationData[idx].getPlayAnimationFrame();
        }
        
        /**
         * 애니메이션을 업데이트 하는 함수입니다.<br> 
         * 애니메이션이 현재 사용가능한지 확인하고, 사용가능하면 다음 Frame으로 이동시킵니다.
         */
        public function update():void
        {
            var playFrame:AnimationFrame;
            
            //전체 애니메이션 업데이트 중지
            if(_isPlaying == false) return;
            
            for each( var sprite:STSprite in _playSprite )
            {
                //0,1 -> 현재 이미지,xml 로딩 중, 2 -> 로딩 완료
                if(_playAnimationData[sprite].animationData["available"] == 2)
                {
                    //다음 프레임으로 이동
                    playFrame = nextFrame(sprite);
                    
                    //uv좌표 변경하는 방식
                    sprite.frame.width = playFrame.width;
                    sprite.frame.height = playFrame.height;
                    sprite.setUVCoord(playFrame.x/sprite.textureWidth, playFrame.y/sprite.textureHeight, playFrame.width/sprite.textureWidth, playFrame.height/sprite.textureHeight);
                }
            }
            
            playFrame = null;
        }
        
        /**
         * 애니메이션을 변경하는 함수입니다.</br>
         * 이 함수를 사용하기 위해서는  addSprite() 함수를 먼저 이용해 sprite를 등록해야 합니다.
         * @param idx 애니메이션을 변경할 STsprite
         * @param name 변경할 애니메이션 이름
         */
        public function setAnimation(idx:STSprite, name:String):void
        {
            if(idx != null) _playAnimationData[idx].setPlayAnimation(name);
        }
        
        /**
         * 특정 STSprite의 애니메이션을 정지시키는 함수입니다. 
         * @param idx 정지시킬 STSprite
         */
        public function pauseAnimation(idx:STSprite):void
        {
            if(idx != null)
            {
                _playAnimationData[idx].isPlaying = false;
            }
        }

        /**
         * 특정 STSprite의 애니메이션을 재생하는 함수입니다.
         * @param idx 재생할 STSprite
         */
        public function playAnimation(idx:STSprite):void
        {
            if(idx != null)
            {
                _playAnimationData[idx].isPlaying = true;
            }
        }
        
        /**
         * 모든 STSprite의 애니메이션을 정지시키는 함수입니다.</br>
         * 메뉴창을 띄우는 등 애니메이션을 멈춰야 할 일이 있을때 사용하면 되겠습니다.
         */
        public function allPause():void
        {
            _isPlaying = false;
        }
        
        /**
         * allPause로 인해 정지된 애니메이션을 다시 재생하도록 하는 함수입니다.
         */
        public function allPauseCancle():void
        {
            _isPlaying = true;
        }
    }
}