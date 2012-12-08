package screen
{
import boxes.AchievBox;
import boxes.EndBox;
import boxes.PauseBox;

import flash.display3D.textures.Texture;

import flash.geom.Point;

import helpers.AchievDefinitions;

import helpers.MathHelp;
import helpers.OnFrame;
import helpers.SharedSpace;

import maps.Map;
	
import flash.display.Bitmap;

import maps.Map1;

import objects.GameObject;

import objects.Planet;

import objects.Squirrel;
import objects.collectables.Collectable;
import objects.enemies.Enemy;
import objects.enemies.Projectile;
import org.osflash.signals.Signal;
import starling.display.Image;
import starling.display.Sprite;
import starling.display.Stage;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.textures.Texture;

public class GameScreen extends Screen
	{
        protected var map:Map;

        protected var gObjects:Vector.<GameObject>;

        protected var game:Sprite;

        private var squirrel:Squirrel;
        private var globalSquirrel:Squirrel;

        private var _onHitS:Signal;
        private var _onShootS:Signal;
        private var _toGameS:Signal;

        private var center:Point;

        private var pause:Image;

        private var pauseBox:PauseBox;
        private var endBox:EndBox;
        private var achievBox:AchievBox;

        private var _isAchievShowed:Boolean;
        private var _achievQueue:Vector.<AchievBox>;

        private var _score:int;
        private var _id:int;

        private var _nutCount:int;
		
		public function GameScreen(stage:Stage, levelID:int, map:Map = null )
		{		
			super(new GraphicsLoader._bg());

            if (map == null)
                this.map = new Map1();
            else
                this.map = map;

            center = new Point(480,this.map.getPlanet.radius + 450);

            _score = 0;
            _id = levelID;

            _initGame();

            _initPauseButton();

            _initGObjects();

            _initPauseBox();

            _initEndBox();

            _initNutCount();

            _onHitS = new Signal();
            _onHitS.add(_onHit);

            _onShootS = new Signal();
            _onShootS.add(_shootProjectile);

            _toGameS = new Signal();

            _isAchievShowed = false;
            _achievQueue = new Vector.<AchievBox>();

            var _planet:Planet = this.map.getPlanet;
            addChildAt(_planet, 1);

			squirrel = new Squirrel();
            globalSquirrel = new Squirrel();
			addChild(squirrel);
		}

		protected override function _onFrame():void
		{
			super._onFrame();

			_detectCollision();

			_rotateGame();

		}

		private function _detectCollision():void
		{
            var newPoint:Point = new Point(squirrel.x,  squirrel.y);
            newPoint =  MathHelp.rotatePoint(newPoint, center, -game.rotation);
            globalSquirrel.x = newPoint.x;
            globalSquirrel.y = newPoint.y;

            /*for (var i:int = 0; i < gObjects.length;i++)
            {

                if (globalSquirrel.polygon.collides(gObjects[i].polygon))
                {
                    gObjects[i].onHit(_onHitS);
                }
            }

            if (squirrel.hitGround())
            {
                _end();
            }  */


		}

        private function _shootProjectile():void
        {
            var position:Point = new Point();
            var projectile:Projectile = new Projectile(position, squirrel.position);
            gObjects.push(projectile);
            game.addChild(projectile);


        }

        private function _onHit(object:GameObject):void
        {
            if (object is Enemy)
            {
                _score += object.score;
                SharedSpace.setAchievementData(0,1);
                if (SharedSpace.getAchievementData(0) >= AchievDefinitions._a0)
                {

                }
            } else if (object is Collectable)
            {
                gObjects = gObjects.slice(gObjects.indexOf(object), 1);
                game.removeChild(object);
                _score += object.score;

                if (object.getId == "nuttx")
                {
                    _nutCount--;
                    if (_nutCount == 0)
                    {
                       _complete();
                    }
                  }
            }
        }

        private function _end():void
        {
            SharedSpace.setScoreToLevel(_id,  _score);
            addChild(endBox);

        }

        private function _complete():void
        {
            SharedSpace.setScoreToLevel(_id,  _score);
            addChild(endBox);
        }

        private function _initGame():void
        {
            game = new Sprite();
            game.width = 960;
            game.height = 640;
            game.pivotX = center.x;
            game.pivotY = center.y;
            game.x = center.x ;
            game.y = center.y ;
            this.addChild(game);
        }

        private function _initGObjects():void
        {
            gObjects = map.getObjects;
            for each (var object:GameObject in gObjects)
            {
                game.addChild(object);
                object.rotate(center);
            }
        }

        private function _initPauseButton():void
        {
            pause = new Image(GraphicsLoader.pause);
            pause.addEventListener(TouchEvent.TOUCH, _onPauseButton);
            addChild(pause);
        }

        private function _initPauseBox():void
        {
            pauseBox = new PauseBox();
            pauseBox.resumeS.add(_onResume);
            pauseBox.exitS.add(_onExit);
            pauseBox.pauseS.add(_onPause);
            pauseBox.redoS.add(_onRedo);
        }

        private function _initEndBox():void
        {
            endBox = new EndBox();
            endBox.pauseS.add(_onPause);
            endBox.exitS.add(_onExit);
            endBox.redoS.add(_onRedo);
            endBox.nextS.add(_onNext);
        }

        private function _initNutCount():void
        {
            _nutCount = 0;
            for each (var object:GameObject in gObjects)
            {
                if (object.getId == "nuttx")
                {
                    _nutCount++;
                }
            }
        }

        private function _showAchievBox(id:int):void
        {
            if (_isAchievShowed)
            {
               _achievQueue.push(new AchievBox(id));
            } else
            {
               addChild(_achievQueue.pop());
               _isAchievShowed = true;
            }
        }

        private function _rotateGame():void
        {
            if (squirrel.velx == 0)
                game.rotation -= 0;
            else
                game.rotation -= (squirrel.velx*10)/(2*Math.PI*(800-squirrel.y));
        }

        private function _onPauseButton(e:TouchEvent):void
        {
            var touch:Touch = e.getTouch(stage);
            if (touch.phase == TouchPhase.BEGAN)
            {
                addChild(pauseBox);
            }
        }

        private function _onResume():void
        {
            removeChild(pauseBox);
            OnFrame.frameS.add(_onFrame);
            squirrel.resume();
            addChild(pause);
        }

        private function _onPause():void
        {
            removeChild(pause);
            OnFrame.frameS.remove(_onFrame);
            squirrel.pause();
        }

        private function _onExit():void
        {
            _backS.dispatch();
        }

        private function _onRedo():void
        {
            _toGameS.dispatch(_id);
        }

        private function _onNext():void
        {
            _toGameS.dispatch(_id + 1);
        }

        public function get toGameS():Signal
        {
            return _toGameS;
        }





    }
}