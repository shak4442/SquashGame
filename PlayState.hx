package;

import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.*;
import flixel.util.FlxTimer;

class PlayState extends FlxState
{
     public static inline var playerSpeed:Int = 400;

    //variables to modify
    var player1:FlxSprite;
    var player2:FlxSprite;
    var ball:FlxSprite;
    var topwall:FlxSprite;
    var leftwall:FlxSprite;
    var rightwall:FlxSprite;
    var player1Score=0;
    var player2Score=0;
    var player1ScoreDisplay:FlxText;
    var result:FlxText;
    var player1Flag=1;
    var player2Flag=0;
    var maxScore=3;


    override public function create():Void
    {

        super.create();
        //paddle1 model
        player1 = new FlxSprite(100,450);
        player1.makeGraphic(100,20,FlxColor.BLUE);
        player1.immovable=true;
        add(player1);
        //paddle2 model
        player2 = new FlxSprite(440,450);
        player2.makeGraphic(100,20,FlxColor.RED);
        player2.immovable=true;
        add(player2);
        //score display
        player1ScoreDisplay= new FlxText(30,40,"Player 1 0 \nPlayer 2 0 \n ", 15);
        add(player1ScoreDisplay);
        //ball model
        ball=new flixel.FlxSprite(120,400);
        ball.makeGraphic(10,10,FlxColor.WHITE);
        ball.elasticity=1;
        ball.maxVelocity.set(10000,10000);
        ball.velocity.y=100;
        add(ball);
        //wall model
        topwall = new FlxSprite();
        topwall.makeGraphic(640,10,FlxColor.BLACK);
        topwall.immovable=true;
        add(topwall);
        //wall model
        leftwall = new FlxSprite();
        leftwall.makeGraphic(10,480,FlxColor.BLACK);
        leftwall.immovable=true;
        add(leftwall);
        //wall model
        rightwall = new FlxSprite(630,10);
        rightwall.makeGraphic(10,480,FlxColor.BLACK);
        rightwall.immovable = true;
        add(rightwall);

    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        //controls for paddles
        player1.velocity.x=0;
        player2.velocity.x=0;
        //player1 controls
        if(FlxG.keys.anyPressed(["LEFT"]) && player1.x>10){
            player1.velocity.x = -playerSpeed;
        }
        if(FlxG.keys.anyPressed(["A"]) && player2.x>10){
            player2.velocity.x = -playerSpeed;
        }
        //player2 controls
        if(FlxG.keys.anyPressed(["RIGHT"]) && player1.x<540){
            player1.velocity.x = playerSpeed;
        }
        if(FlxG.keys.anyPressed(["D"]) && player2.x<540){
            player2.velocity.x = playerSpeed;
        }
        //collision detection of ball with environment
        FlxG.collide(ball,leftwall);
        FlxG.collide(ball,rightwall);
        FlxG.collide(ball,topwall);

        //collision with player1
        if( player1Flag==1){
           if(FlxG.collide(ball,player1,onHit)){
            player1Flag=0;
            player2Flag=1;
            //change color for ease of play
            topwall.makeGraphic(640,10,FlxColor.BLUE);
            leftwall.makeGraphic(10,480,FlxColor.BLUE);
            rightwall.makeGraphic(10,480,FlxColor.BLUE);
            ball.makeGraphic(10,10,FlxColor.BLUE);
            }
            else{
            //score if ball crosses the screen limits
            if(ball.y>480){
                player2Score++;
                player1Flag=0;
                player2Flag=1;
                //score update
                player1ScoreDisplay.text="Player 1 Score "+player1Score+"\nPlayer 2 Score "+player2Score;
                //player win
                if(player2Score==maxScore){
                    player1ScoreDisplay.text="PLAYER 2 WON";
                    ball.velocity.set();
                    new FlxTimer().start(10,function(timer){FlxG.resetGame();});
                }
                //reset ball of top of player
                resetBall(player2.x+player2.width/2,player2.y-50);
            }               
            }
        }
        //collision with player2
        if(player2Flag==1){
            if(FlxG.collide(ball,player2,onHit)){
            player1Flag=1;
            player2Flag=0;
            //change color for ease of play            
            topwall.makeGraphic(640,10,FlxColor.RED);
            leftwall.makeGraphic(10,480,FlxColor.RED);
            rightwall.makeGraphic(10,480,FlxColor.RED);
            ball.makeGraphic(10,10,FlxColor.RED);
            }
            else{
            	//score if ball crosses the screen limits
                if(ball.y>480){
                    player1Score++;
                    player1Flag=1;
                    player2Flag=0;
                    //score update
                    player1ScoreDisplay.text="Player 1 Score "+player1Score+"\nPlayer 2 Score "+player2Score;
                    //player win
                    if(player1Score==maxScore){
                        player1ScoreDisplay.text="PLAYER 1 WON";
                        ball.velocity.set();
                        new FlxTimer().start(10,function(timer){FlxG.resetGame();});
                    }
                    //reset ball of top of player
                    resetBall(player1.x+player1.width/2,player1.y-50);
            }               
            }
        }
    }
    //onHit function to increase ball speed after hitting paddle
    private function onHit (Ball:FlxObject, Player:FlxObject){
        if(Ball.velocity.x>0 && Ball.velocity.y>0){
            Ball.velocity.x+=100;
            Ball.velocity.y+=100;
        }
        else {
            Ball.velocity.x-=100;
            Ball.velocity.y-=100;
        }

    }
    //resets ball
    public function resetBall(xnew:Float,ynew:Float){
        ball.x=xnew;
        ball.y=ynew;
        ball.velocity.set();
        new FlxTimer().start(3, function(timer){
            ball.velocity.y=100;
        });
    }
}
