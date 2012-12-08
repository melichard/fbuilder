package {


import Box2D.Collision.b2AABB;

import flash.display.Bitmap;

import flash.display.Sprite;
import flash.display.StageDisplayState;
import flash.display.StageScaleMode;
import flash.geom.Rectangle;
import flash.media.AudioPlaybackMode;
import flash.system.Capabilities;
import flash.text.TextField;

import starling.core.Starling;
import starling.events.Event;

public class AirFlyer extends Sprite {

    [Embed(source='splash.png')]
    public var splash:Class;

    public var load:Bitmap;

    public function AirFlyer() {

        //addChild(new Stats());

        stage.frameRate = 60;
        stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;

        load = new splash();
        load.x = Capabilities.screenResolutionX - load.width/2;
        load.y = Capabilities.screenResolutionY - load.height/2;
        addChild(load);

        Starling.handleLostContext = true;
        Starling.multitouchEnabled = true;
        var starling:Starling = new Starling(MainEngine_HS, stage, new Rectangle(0,0,Capabilities.screenResolutionX,  Capabilities.screenResolutionY));
        starling.start();
        starling.addEventListener(Event.CONTEXT3D_CREATE, _loaded);
        starling.showStats = true;
    }


    private function _loaded(e:Event):void
    {
        removeChild(load);
    }
}
}
