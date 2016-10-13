package {
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.getTimer;
	import flash.net.ObjectEncoding;
	
	public class MahoushoujyoArcueid extends MovieClip {
		// movement constants
		static const gravity:Number = .004;
		private var bianshen:int=0;
		private var firemahou:int=0;
		// screen constants
		static const edgeDistance:Number = 200;

		// object arrays
		private var fixedObjects:Array;
		private var otherObjects:Array;
		
		// hero and enemies
		private var hero:Object;
		private var enemies:Array;
		private var superenemies:Array;
		private var airenemies:Array;
		private var bullets:Array;
		private var bosses:Array ;
		
		// game state
		private var playerObjects:Array;
		private var gameScore:int;
		private var gameMode:String = "start";
		private var playerLives:int;
		private var lastTime:Number = 0;
		
		// start game
		public function startPlatformGame() {
			playerObjects = new Array();
			gameScore = 0;
			gameMode = "play";
			playerLives = 10;
		}
		
		// start level
		public function startGameLevel() {
			
			// create characters
			createHero();
			addEnemies();
			addSuperEnemies();
			addAirEnemies();
			addBosses();
			// examine level and note all objects
			examineLevel();
			bullets = new Array();
			
			// add listeners
			this.addEventListener(Event.ENTER_FRAME,gameLoop);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownFunction);
			stage.addEventListener(KeyboardEvent.KEY_UP,keyUpFunction);
			
			// set game state
			gameMode = "play";
			addScore(0);
			showLives();
			stage.addEventListener(Event.ENTER_FRAME,checkForHits);
			playerObjects = new Array();
		}
		
		// creates the hero object and sets all properties
		public function createHero() {
			hero = new Object();
			hero.mc = gamelevel.hero;
			hero.dx = 0.0;
			hero.dy = 0.0;
			hero.inAir = false;
			hero.direction = 1;
			hero.animstate = "stand";
			hero.walkAnimation = new Array(2,3,4,5,6,7,8);
			hero.animstep = 0;
			hero.animstate = "attack";
			hero.attackAnimation = new Array(17,18,19,20);
			hero.animstate="mahou";
			hero.mahouAnimation= new Array(22,23,24,25);
			hero.jump = false;
			hero.attack =false;
			hero.mahou=false;
			hero.moveLeft = false;
			hero.moveRight = false;
			hero.jumpSpeed = .8;
			hero.walkSpeed = .2;
			hero.width = 20.0;
			hero.height = 40.0;
			hero.startx = hero.mc.x;
			hero.starty = hero.mc.y;
		}
		
		public function fireBullet() {
			if (hero.direction == 1) {
			var b:Bullet = new Bullet(hero.mc.x,hero.mc.y,900);
			gamelevel.addChild(b);
			bullets.push(b);
			} else if (hero.direction == -1) {
			var bb:Bullet = new Bullet(hero.mc.x,hero.mc.y,-900);
			gamelevel.addChild(bb);
			bullets.push(bb);
			}
		}
		public function checkForHits(event:Event) {
			for(var n:int=bullets.length-1;n>=0;n--){ 
				for (var i:int=enemies.length-1;i>=0;i--) {
					if (bullets[n].hitTestObject(enemies[i].mc)) {
						enemyDie(i);
						gamelevel.removeChild(bullets[n]);
						bullets.splice(n,1);
					}
				}
				for (var j:int=superenemies.length-1;j>=0;j--) {
					if (bullets[n].hitTestObject(superenemies[j].mc)) {
						superenemyDie(j);
						gamelevel.removeChild(bullets[n]);
						bullets.splice(n,1);
					}
				}
				for(var m:int=bosses.length-1;m>=0;m--) {
					if (bullets[n].hitTestObject(bosses[m].mc)) {
						bossDie(m);
						gamelevel.removeChild(bullets[n]);
						bullets.splice(n,1);
					}
				}
			}
		}

		// finds all enemies in the level and creates an object for each
		public function addSuperEnemies() {
			superenemies = new Array();
			var i:int = 1;
			while (true) {
				if (gamelevel["superenemy"+i] == null) break;
				var superenemy = new Object();
				superenemy.mc = gamelevel["superenemy"+i];
				superenemy.dx = 0.0;
				superenemy.dy = 0.0;
				superenemy.inAir = false;
				superenemy.direction = 1;
				superenemy.animstate = "stand"
				superenemy.walkAnimation = new Array(2,3,4,5,6,7,8,9,10,11,12,13);
				superenemy.animstep = 0;
				superenemy.jump = false;
				superenemy.moveRight = true;
				superenemy.moveLeft = false;
				superenemy.jumpSpeed = 1.0;
				superenemy.walkSpeed = .1;
				superenemy.width = 30.0;
				superenemy.height = 30.0;
				superenemies.push(superenemy);
				i++;
			}
		}
		public function addEnemies() {
			enemies = new Array();
			var i:int = 1;
			while (true) {
				if (gamelevel["enemy"+i] == null) break;
				var enemy = new Object();
				enemy.mc = gamelevel["enemy"+i];
				enemy.dx = 0.0;
				enemy.dy = 0.0;
				enemy.inAir = false;
				enemy.direction = 1;
				enemy.animstate = "stand"
				enemy.walkAnimation = new Array(2,3,4,5);
				enemy.animstep = 0;
				enemy.jump = false;
				enemy.moveRight = true;
				enemy.moveLeft = false;
				enemy.jumpSpeed = 1.0;
				enemy.walkSpeed = .08;
				enemy.width = 30.0;
				enemy.height = 30.0;
				enemies.push(enemy);
				i++;
			}
		}
		public function addAirEnemies() {
			airenemies = new Array();
			var i:int = 1;
			while (true) {
				if (gamelevel["airenemy"+i] == null) break;
				var airenemy = new Object();
				airenemy.mc = gamelevel["airenemy"+i];
				airenemy.dx = 0.0;
				airenemy.dy = 0.0;
				airenemy.inAir = false;
				airenemy.direction = 1;
				airenemy.animstate = "stand"
				airenemy.walkAnimation = new Array(2,3,4,5,6,7,8,9,10,11);
				airenemy.animstep = 0;
				airenemy.jump = false;
				airenemy.moveRight = true;
				airenemy.moveLeft = false;
				airenemy.jumpSpeed = 1.0;
				airenemy.walkSpeed = .08;
				airenemy.width = 30.0;
				airenemy.height = 30.0;
				airenemies.push(airenemy);
				i++;
			}
		}
		
		public function addBosses() {
			bosses = new Array();
			var i:int = 1;
			while (true) {
				if (gamelevel["boss"+i] == null) break;
				var boss = new Object();
				boss.lives = 10;
				boss.mc = gamelevel["boss"+i];
				boss.dx = 0.0;
				boss.dy = 0.0;
				boss.inAir = false;
				boss.direction = 1;
				boss.animstate = "stand"
				boss.walkAnimation = new Array(2,3,4,5,6,7,8,9,10,11,12,13,14);
				boss.animstep = 0;
				boss.jump = false;
				boss.moveRight = true;
				boss.moveLeft = false;
				boss.jumpSpeed = 0.80;
				boss.walkSpeed = .18;
				boss.width = 100.0;
				boss.height = 100.0;
				bosses.push(boss);
				i++;
			}
		}
		// look at all level children and note walls, floors and items
		public function examineLevel() {
			fixedObjects = new Array();
			otherObjects = new Array();
			for(var i:int=0;i<this.gamelevel.numChildren;i++) {
				var mc = this.gamelevel.getChildAt(i);
				
				// add floors and walls to fixedObjects
				if ((mc is Floor) || (mc is Wall)) {
					var floorObject:Object = new Object();
					floorObject.mc = mc;
					floorObject.leftside = mc.x;
					floorObject.rightside = mc.x+mc.width;
					floorObject.topside = mc.y;
					floorObject.bottomside = mc.y+mc.height;
					fixedObjects.push(floorObject);
					
				// add treasure, key and door to otherOjects
				} else if ((mc is Treasure) || (mc is Key) || (mc is Door) || (mc is Chest)||(mc is ball)||(mc is wand)) {
					otherObjects.push(mc);
				}
			}
		}
		
		// note key presses, set hero properties
		public function keyDownFunction(event:KeyboardEvent) {
			if (gameMode != "play") return; // don't move until in play mode
			
			if (event.keyCode == 37) {
				hero.moveLeft = true;
			} else if (event.keyCode == 39) {
				hero.moveRight = true;
			} else if (event.keyCode == 90) {
				if (!hero.inAir) {
					if (bianshen==1){
				hero.attack = true;
					}
				}
			}
				else if (event.keyCode == 38) {
				if (!hero.inAir) {
					hero.jump = true;
				}
			}	
			else if (event.keyCode == 88) {
				if (firemahou==1){
					hero.mahou=true;
				fireBullet();
				}
				}
		}
		
		public function keyUpFunction(event:KeyboardEvent) {
			if (event.keyCode == 37) {
				hero.moveLeft = false;
			} else if (event.keyCode == 39) {
				hero.moveRight = false;
			}
		}
		
		// perform all game tasks
		public function gameLoop(event:Event) {
			
			// get time differentce
			if (lastTime == 0) lastTime = getTimer();
			var timeDiff:int = getTimer()-lastTime;
			lastTime += timeDiff;
			
			// only perform tasks if in play mode
			if (gameMode == "play") {
				moveCharacter(hero,timeDiff);
				moveEnemies(timeDiff);
				moveSuperEnemies(timeDiff);
				moveAirEnemies(timeDiff);
				moveBosses(timeDiff);
				checkCollisions();
				scrollWithHero();
			}
		}
		
		// loop through all enemies and move them
		public function moveEnemies(timeDiff:int) {
			for(var i:int=0;i<enemies.length;i++) {
				
				// move
				moveCharacter(enemies[i],timeDiff);
				
				// if hit a wall, turn around
				if (enemies[i].hitWallRight) {
					enemies[i].moveLeft = true;
					enemies[i].moveRight = false;
				} else if (enemies[i].hitWallLeft) {
					enemies[i].moveLeft = false;
					enemies[i].moveRight = true;
				}
			}
		}
				public function moveAirEnemies(timeDiff:int) {
			for(var i:int=0;i<airenemies.length;i++) {
				
				// move
				moveCharacter(airenemies[i],timeDiff);
				
				// if hit a wall, turn around
				if (airenemies[i].hitWallRight) {
					airenemies[i].moveLeft = true;
					airenemies[i].moveRight = false;
				} else if (airenemies[i].hitWallLeft) {
					airenemies[i].moveLeft = false;
					airenemies[i].moveRight = true;
				}
			}
		}
		public function moveSuperEnemies(timeDiff:int) {
			for(var i:int=0;i<superenemies.length;i++) {
				
				// move
				moveCharacter(superenemies[i],timeDiff);
				
				// if hit a wall, turn around
				if (superenemies[i].hitWallRight) {
					superenemies[i].moveLeft = true;
					superenemies[i].moveRight = false;
				} else if (superenemies[i].hitWallLeft) {
					superenemies[i].moveLeft = false;
					superenemies[i].moveRight = true;
				}
			}
		}
				public function moveBosses(timeDiff:int) {
			for(var i:int=0;i<bosses.length;i++) {
				
				// move
				moveCharacter(bosses[i],timeDiff);
				var n:int = Math.random()*200;
				if (n>195) {
					bosses[i].jump = true;
				}
						
				
				// if hit a wall, turn around
				if (bosses[i].hitWallRight) {
					var k:int = Math.random()*100;
					if (k>99) {
						bosses[i].jump = true;
						bosses[i].moveLeft = false;
						bosses[i].moveRight = true;
					
					}
					else{ 
						bosses[i].moveLeft = true;
						bosses[i].moveRight = false;
					}
					
				}
				else if (bosses[i].hitWallLeft) {
					var m:int = Math.random()*100;
				if (m>99) {
					bosses[i].jump = true;
					bosses[i].moveLeft = true;
					bosses[i].moveRight = false;
					
				}else 
					{
					bosses[i].moveLeft = false;
					bosses[i].moveRight = true;
					}
					
				}
			}
		}
		// primary function for character movement
		public function moveCharacter(char:Object,timeDiff:Number) {
			if (timeDiff < 1) return;

			// assume character pulled down by gravity
			var verticalChange:Number = char.dy*timeDiff + timeDiff*gravity;
			if (verticalChange > 10.0) verticalChange = 10.0;
			char.dy += timeDiff*gravity;
			
			// react to changes from key presses
			var horizontalChange = 0;
			var newAnimState:String = "stand";
			var newDirection:int = char.direction;
			if (char.moveLeft) {
				// walk left
				horizontalChange = -char.walkSpeed*timeDiff;
				newAnimState = "walk";
				newDirection = -1;
			} else if (char.moveRight) {
				// walk right
				horizontalChange = char.walkSpeed*timeDiff;
				newAnimState = "walk";
				newDirection = 1;
			} if (char.attack) {
				newAnimState = "attack";
				char.moveLeft=false;
				char.moveRight=false;
			} 
			if (char.mahou) {
				newAnimState = "mahou";
				
			} 
			if (char.jump) {
				// start jump
				char.jump = false;
				char.dy = -char.jumpSpeed;
				verticalChange = -char.jumpSpeed;
				newAnimState = "jump";
			}

			
			// assume no wall hit, and hanging in air
			char.hitWallRight = false;
			char.hitWallLeft = false;
			char.inAir = true;
					
			// find new vertical position
			var newY:Number = char.mc.y + verticalChange;
		
			// loop through all fixed objects to see if character has landed
			for(var i:int=0;i<fixedObjects.length;i++) {
				if ((char.mc.x+char.width/2 > fixedObjects[i].leftside) && (char.mc.x-char.width/2 < fixedObjects[i].rightside)) {
					if ((char.mc.y <= fixedObjects[i].topside) && (newY > fixedObjects[i].topside)) {
						newY = fixedObjects[i].topside;
						char.dy = 0;
						char.inAir = false;
						break;
					}
				}
			}
			
			// find new horizontal position
			var newX:Number = char.mc.x + horizontalChange;
		
			// loop through all objects to see if character has bumped into a wall
			for(i=0;i<fixedObjects.length;i++) {
				if ((newY > fixedObjects[i].topside) && (newY-char.height < fixedObjects[i].bottomside)) {
					if ((char.mc.x-char.width/2 >= fixedObjects[i].rightside) && (newX-char.width/2 <= fixedObjects[i].rightside)) {
						newX = fixedObjects[i].rightside+char.width/2;
						char.hitWallLeft = true;
						break;
					}
					if ((char.mc.x+char.width/2 <= fixedObjects[i].leftside) && (newX+char.width/2 >= fixedObjects[i].leftside)) {
						newX = fixedObjects[i].leftside-char.width/2;
						char.hitWallRight = true;
						break;
					}
				}
			}
			
			// set position of character
			char.mc.x = newX;
			char.mc.y = newY;
			
			// set animation state
			if (char.inAir) {
				newAnimState = "jump";
			}
			char.animstate = newAnimState;
			
			// move along walk cycle
			if (char.animstate == "walk") {
				char.animstep += timeDiff/60;
				if (char.animstep > char.walkAnimation.length) {
					char.animstep = 0;
				}
				char.mc.gotoAndStop(char.walkAnimation[Math.floor(char.animstep)]);
				
			// not walking, show stand or jump state
			} else if (char.animstate == "attack") {
				char.animstep += timeDiff/60;
				char.mc.gotoAndStop(char.attackAnimation[Math.floor(char.animstep)]);
				if (char.animstep > char.attackAnimation.length) {
					char.animstep = 0;
					hero.attack = false;
					}
				}
				else if (char.animstate == "mahou") {
				char.animstep += timeDiff/60;
				char.mc.gotoAndStop(char.mahouAnimation[Math.floor(char.animstep)]);
				if (char.animstep > char.mahouAnimation.length) {
					char.animstep = 0;
					hero.mahou = false;
					}
				}
			else {
				char.mc.gotoAndStop(char.animstate);
			}
			
			// changed directions
			if (newDirection != char.direction) {
				char.direction = newDirection;
				char.mc.scaleX = char.direction;
			}
		}
		
		// scroll to the right or left if needed
		public function scrollWithHero() {
			var stagePosition:Number = gamelevel.x+hero.mc.x;
			var rightEdge:Number = stage.stageWidth-edgeDistance;
			var leftEdge:Number = edgeDistance;
			if (stagePosition > rightEdge) {
				gamelevel.x -= (stagePosition-rightEdge);
				if (gamelevel.x < -(gamelevel.width-stage.stageWidth)) gamelevel.x = -(gamelevel.width-stage.stageWidth);
			}
			if (stagePosition < leftEdge) {
				gamelevel.x += (leftEdge-stagePosition);
				if (gamelevel.x > 0) gamelevel.x = 0;
			}
		}
		
		// check collisions with enemies, items
		public function checkCollisions() {
			
			// enemies
			for(var i:int=enemies.length-1;i>=0;i--) {
				if (hero.mc.hitTestObject(enemies[i].mc)) {
					
					// is the hero jumping down onto the enemy?
					if (hero.inAir && (hero.dy > 0)) {
						enemyDie(i);
					} else if (hero.attack == true && hero.direction + enemies[i].direction == 0) {
						enemyDie(i);
					}
					else {
						heroDie();
					}
				}
			}
			for(var k:int=airenemies.length-1;k>=0;k--) {
				if (hero.mc.hitTestObject(airenemies[k].mc)) {
					
					// is the hero jumping down onto the enemy?
					if (hero.inAir && (hero.dy > 0)) {
						airenemyDie(k);
					}
					else {
						heroDie();
					}
				}
			}
			for(var n:int=bosses.length-1;n>=0;n--) {
				if (hero.mc.hitTestObject(bosses[n].mc)) {
						heroDie();
					}
				}
			for(var j:int=superenemies.length-1;j>=0;j--) {
				if (hero.mc.hitTestObject(superenemies[j].mc)) {
					if (hero.attack == true && hero.direction + superenemies[j].direction == 0) {
						superenemyDie(j);
					}else {
						heroDie();
					}
				}
			}
			
			// items
			for(i=otherObjects.length-1;i>=0;i--) {
				if (hero.mc.hitTestObject(otherObjects[i])) {
					getObject(i);
				}
			}
		}
		
		// remove enemy
		public function enemyDie(enemyNum:int) {
			var pb:PointBurst = new PointBurst(gamelevel,"Got Em!",enemies[enemyNum].mc.x,enemies[enemyNum].mc.y-20);
			gamelevel.removeChild(enemies[enemyNum].mc);
			enemies.splice(enemyNum,1);
		}
		public function airenemyDie(airenemyNum:int) {
			var pb:PointBurst = new PointBurst(gamelevel,"Got King kirakira!",airenemies[airenemyNum].mc.x,airenemies[airenemyNum].mc.y-20);
			gamelevel.removeChild(airenemies[airenemyNum].mc);
			airenemies.splice(airenemyNum,1);
		}
		public function superenemyDie(superenemyNum:int) {
			var pb:PointBurst = new PointBurst(gamelevel,"Got SuperEm!",superenemies[superenemyNum].mc.x,superenemies[superenemyNum].mc.y-20);
			gamelevel.removeChild(superenemies[superenemyNum].mc);
			superenemies.splice(superenemyNum,1);
		}
		public function bossDie(n:int) {
			var pb:PointBurst = new PointBurst(gamelevel,"Got BOSS!",bosses[n].mc.x,bosses[n].mc.y-20);
			bosses[n].lives -= 1;
			trace(bosses[n].lives);
			if (bosses[n].lives == 0) {
			gamelevel.removeChild(bosses[n].mc);
			bosses.splice(n,1);
			}
		}
		
		// enemy got player
		public function heroDie() {
			// show dialog box
			var dialog:Dialog = new Dialog();
			dialog.x = 275;
			dialog.y = 200;
			addChild(dialog);
		
			if (playerLives == 0) {
				gameMode = "gameover";
				dialog.message.text = "Game Over!";
			} else {
				gameMode = "dead";
				dialog.message.text = "You die!";
				playerLives--;
			}
			
			hero.mc.gotoAndPlay("die");
		}
		
		// player collides with objects
		public function getObject(objectNum:int) {
			// award points for treasure
			if (otherObjects[objectNum] is Treasure) {
				heroDie();
				
			// got the key, add to inventory
			} else if (otherObjects[objectNum] is Key) {
				var pb:PointBurst = new PointBurst(gamelevel,"Got Key!" ,otherObjects[objectNum].x,otherObjects[objectNum].y);
				playerObjects.push("Key");
				gamelevel.removeChild(otherObjects[objectNum]);
				otherObjects.splice(objectNum,1);
				
			// hit the door, end level if hero has the key
			} else if (otherObjects[objectNum] is ball) {
				bianshen=1;
				var dialog:Dialog = new Dialog();
			dialog.x = 275;
			dialog.y = 200;
			addChild(dialog);
				dialog.message.text ="press down Z to attack enemy!" ;
				var pb2:PointBurst = new PointBurst(gamelevel,"You Got the baseball bat!" ,otherObjects[objectNum].x,otherObjects[objectNum].y);
				playerObjects.push("ball");
				gamelevel.removeChild(otherObjects[objectNum]);
				otherObjects.splice(objectNum,1);

			} 
			 else if (otherObjects[objectNum] is wand) {
				firemahou=1;
				var dialog:Dialog = new Dialog();
			dialog.x = 275;
			dialog.y = 200;
			addChild(dialog);
				dialog.message.text ="press down X to fire Bullet!" ;
				var pb3:PointBurst = new PointBurst(gamelevel,"You Got the wand!" ,otherObjects[objectNum].x,otherObjects[objectNum].y);
				playerObjects.push("wand");
				gamelevel.removeChild(otherObjects[objectNum]);
				otherObjects.splice(objectNum,1);

			} 
			else if (otherObjects[objectNum] is Door) {
				if (playerObjects.indexOf("Key") == -1) return;
				if (otherObjects[objectNum].currentFrame == 1) {
					otherObjects[objectNum].gotoAndPlay("open");
					levelComplete();
				}
				
			// got the chest, game won
			} else if (otherObjects[objectNum] is Chest) {
				otherObjects[objectNum].gotoAndStop("open");
				gameComplete();
			}
					
		}
		
		// add points to score
		public function addScore(numPoints:int) {
			gameScore += numPoints;
			
		}
		
		// update player lives
		public function showLives() {
			livesDisplay.text = String(playerLives);
		}
		
		// level over, bring up dialog
		public function levelComplete() {
			gameMode = "done";
			var dialog:Dialog = new Dialog();
			dialog.x = 275;
			dialog.y = 200;
			addChild(dialog);
			dialog.message.text = "Level Complete!";
		}
		
		// game over, bring up dialog
		public function gameComplete() {
			gameMode = "gameover";
			var dialog:Dialog = new Dialog();
			dialog.x = 275;
			dialog.y = 200;
			addChild(dialog);
			dialog.message.text = "You Got the Treasure!";
		}
		
		// dialog button clicked
		public function clickDialogButton(event:MouseEvent) {
			removeChild(MovieClip(event.currentTarget.parent));
			
			// new life, restart, or go to next level
			if (gameMode == "dead") {
				// reset hero
				showLives();
				hero.mc.x = hero.startx;
				hero.mc.y = hero.starty;
				gameMode = "play";
			} else if (gameMode == "gameover") {
				cleanUp();
				gotoAndStop("start");
			} else if (gameMode == "done") {
				cleanUp();
				nextFrame();
			}
			
			// give stage back the keyboard focus
			stage.focus = stage;
		}			
		
		// clean up game
		public function cleanUp() {
			removeChild(gamelevel);
			this.removeEventListener(Event.ENTER_FRAME,gameLoop);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownFunction);
			stage.removeEventListener(KeyboardEvent.KEY_UP,keyUpFunction);
		}
		
	}
	
}