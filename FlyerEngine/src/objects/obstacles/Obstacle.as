package objects.obstacles
{
import objects.*;
	import flash.display.Bitmap;
	import flash.geom.Point;

import org.osflash.signals.Signal;

public class Obstacle extends GameObject
	{
		public function Obstacle(position:Point, id:String = "xtree01a")
		{
			super(position, id);

            _setTexture(_states[_state.x][_state.y]);
            _setPivot (_pivots[_state.x][_state.y]);
		}

        public override function onHit():void
        {
            if (_firstHit)
            {
                _firstHit = false;
            }
        }
	}
}