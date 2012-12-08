package {
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.text.TextField;

import starling.core.Starling;
import starling.events.Event;

[SWF(width="960", height="540", frameRate="60", backgroundColor="#ffffff")]
public class AirFlyerDesktop extends Sprite {


    [Embed(source='splash.png')]
    public var splash:Class;

    private var load:Bitmap;

    public function AirFlyerDesktop() {

        //addChild(new Stats());
        load = new splash();
        load.x = 480 - load.width/2;
        load.y = 270 - load.height/2;
        addChild(load);

        Starling.handleLostContext = true;
        var starling:Starling = new Starling(MainEngine_HS, stage);
        starling.start();
        starling.addEventListener(Event.CONTEXT3D_CREATE, _loaded);
        starling.showStats = true;

        //addChild(new TheMiner());
    }

    private function _loaded(e:Event):void
    {
        removeChild(load);
    }
}
}
