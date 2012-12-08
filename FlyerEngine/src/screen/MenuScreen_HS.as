package screen {
import boxes.CreditsBox;

import gui.GuiComponent;
import gui.counter.GuiCounter;
import gui.notify.GuiScoreNotify;

import helpers.OnFrame;

import helpers.SharedSpace_HS;

import objects.Planet;

import org.osflash.signals.Signal;

import starling.animation.Juggler;

import starling.animation.Tween;
import starling.core.Starling;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;

public class MenuScreen_HS extends Screen {
    private var _toGameS:Signal;
    private var _toAchievS:Signal;
    private var _toHighScoreS:Signal;

    private var _planet:Planet;
    private var _tree:Image;

    private var _creditsButton:Image;
    private var _creditsBox:CreditsBox;

    private var _achievButton:Image;

    private var _playButton:Image;

    private var _highScoreButton:Image;

    private var _logo:Image;

    private var _fadeCounter:int;

    public function MenuScreen_HS()
    {
        super(new GraphicsLoader._menubg);

        _toGameS = new Signal();
        _toAchievS = new Signal();
        _toHighScoreS = new Signal();

        _creditsBox = new CreditsBox();
        _creditsBox.cancelS.add(_onCancelCredits);

        SharedSpace_HS.setAchievement(1);

        this.addEventListener(Event.ADDED_TO_STAGE, _onAdded);
    }


    private var _component:GuiScoreNotify;

    private function _initHusisComponent():void {
//
//        _component = new GuiScoreNotify();
//        _component._startTime = 200;
//        addChild(_component);

    }

    private function _onAdded(e:Event):void
    {
        removeEventListener(Event.ADDED_TO_STAGE, _onAdded);

        _initCreditsButton();

        _initAchievButton();

        _initPlayButton();

        _initHighScoreButton();

        _initHusisComponent();

        OnFrame.frameS.add(_fadeIn);
    }

    private function _fadeIn():void
    {
//        _fadeCounter++;
//        _logo.alpha += 0.1;
//        if (_logo.alpha > 1)
//            _logo.alpha = 1;
//        if (_fadeCounter < 11)
//            _logo.y++;
//
//        if (_fadeCounter > 10)
//        {
//            _playButton.alpha += 0.1;
//            if (_playButton.alpha > 1)
//                _playButton.alpha = 1;
//            if (_fadeCounter < 11)
//                _playButton.y++;
//        }
//
//        if (_fadeCounter > 20)
//        {
//            _achievButton.alpha += 0.1;
//            if (_achievButton.alpha > 1)
//                _achievButton.alpha = 1;
//            _highScoreButton.alpha += 0.1;
//            if (_highScoreButton.alpha > 1)
//                _highScoreButton.alpha = 1;
//            if (_fadeCounter < 21)
//            {
//                _achievButton.y++;
//                _highScoreButton.y++;
//            }
//        }
//        if (_playButton.alpha == 1 && _achievButton.alpha == 1 && _highScoreButton.alpha == 1)
//        {
//            OnFrame.frameS.remove(_fadeIn);
//        }
    }

    private function _toStage (e:starling.events.TouchEvent):void{
        var touch:Touch = e.getTouch(stage);
        if (touch.phase == TouchPhase.BEGAN)
        {
            _playButton.y = 305;
            _playButton.scaleX = 0.95;
            _playButton.scaleY = 0.95;
        }
        if (touch.phase == TouchPhase.ENDED)
        {
            toGameS.dispatch();
//            _component._set(1);
            _playButton.y = 300;
            _playButton.scaleX = 1;
            _playButton.scaleY = 1;
        }
    }
    private function _initPlayButton():void
    {
        _playButton = new Image(GraphicsLoader.playbtn);
        _playButton.pivotX = _playButton.texture.width/2;
        _playButton.x = stage.stageWidth/2;
        _playButton.y = stage.stageHeight/2 + 100;
        _playButton.addEventListener(TouchEvent.TOUCH, _toStage);
        addChild(_playButton);
    }

    private function _initCreditsButton():void
    {
        _creditsButton = new Image(GraphicsLoader.pause);
        _creditsButton.alpha = 0;
        _creditsButton.x = 0;
        _creditsButton.y = 500;
        _creditsButton.addEventListener(TouchEvent.TOUCH, _onCredits);
        //addChild(_creditsButton);
    }

    private function _initHighScoreButton():void
    {
        //_highScoreButton = new Image(GraphicsLoader.getFrame("highscore_btn"));
        //_highScoreButton.alpha = 0;
        //_highScoreButton.x = 50;
        //_highScoreButton.y = 500;
        //_highScoreButton.addEventListener(TouchEvent.TOUCH, _onHighScore);
        //addChild(_highScoreButton);
    }

    private function _initAchievButton():void
    {
       // _achievButton = new Image(GraphicsLoader.getFrame("achievements_btn"));
       // _achievButton.alpha = 0;
       // _achievButton.x = 600;
       // _achievButton.y = 500;
       // _achievButton.addEventListener(TouchEvent.TOUCH, _onAchiev);
        //addChild(_achievButton);
    }

    private function _onCredits(e:TouchEvent):void
    {
        var touch:Touch = e.getTouch(stage);
        if (touch)
            if (touch.phase == TouchPhase.BEGAN)
            {
                removeChild(_creditsButton);
                addChild(_creditsBox);
            }
    }

    private function _onAchiev(e:TouchEvent):void
    {
        var touch:Touch = e.getTouch(stage);
        if (touch)
            if (touch.phase == TouchPhase.BEGAN)
            {
                removeChild(_achievButton);
                _toAchievS.dispatch();
            }
    }

    private function _onHighScore(e:TouchEvent):void
    {
        var touch:Touch = e.getTouch(stage);
        if (touch)
            if (touch.phase == TouchPhase.BEGAN)
            {
                removeChild(_achievButton);
                _toHighScoreS.dispatch();
            }
    }

    private function _onCancelCredits():void
    {
        removeChild(_creditsBox);
        addChild(_creditsButton);
    }


    public function get toGameS():Signal
    {
        return _toGameS;
    }

    public function get toAchievS():Signal
    {
        return _toAchievS;
    }

    public function get toHighScoreS():Signal
    {
        return _toHighScoreS;
    }
}
}
