package {
	import flash.display.*;
	import flash.events.*;
	import flash.utils.getTimer;
	
	public class Bullet extends MovieClip {
		private var dx:Number; // vertical speed
		private var lastTime:int;
		private var bullet:Object ;
		
		public function Bullet(x,y:Number, speed: Number) {
			bullet = new Array();
			// set start position
			this.x = x;
			this.y = y;
			// get speed
			dx = speed;
			// set up animation
			lastTime = getTimer();
			addEventListener(Event.ENTER_FRAME,moveBullet);
		}
		
		public function moveBullet(event:Event) {
			// get time passed
			var timePassed:int = getTimer()-lastTime;
			lastTime += timePassed;
			
			// move bullet
			this.x += dx*timePassed/1000;
			
			// bullet past top of screen
			
		}

		// delete bullet from stage and plane list
		

	}
}