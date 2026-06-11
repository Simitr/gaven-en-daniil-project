using Godot;
using System;

public partial class IdleState : State
{
	[Export] public CharacterBody2D character;
	[Export] public AnimatedSprite2D animatedSprite;
    [Export] AnimatedSprite2D LampL;
    [Export] AnimatedSprite2D LampR;
    [Export] AnimatedSprite2D HandsAnimation;
    public Vector2 direction;
	public int x = 0;
    public bool down = false;
    public bool up = false;
    public enum Side { Left, Right }
    // Called when the node enters the scene tree for the first time.

    public override void Enter()
	{
         
            LampL.Visible = false;
            LampR.Visible = false;
            HandsAnimation.Visible = false;
       

        if (animatedSprite.Animation == "walking")
		{
			animatedSprite.Play("idle");
		}
		else if (animatedSprite.Animation == "walkingback")
		{
			animatedSprite.Play("idleLeft");
		}
		else if (animatedSprite.Animation == "walkingDown")
		{
			animatedSprite.Play("idleDown");
		}
        else
        {
           // animatedSprite.Play("idle");
        }
       
       
	}
	public override void Update(float delta)
	{
		var dir = GameInput.MovementInput();
		if (dir != Vector2.Zero && !Global.Aremd)
		{
			fsm.ChangeState("Walk");
		}
		else if (dir != Vector2.Zero && Global.Aremd)
        {
			fsm.ChangeState("WalkAremd");
		}

        if (Global.Aremd)
        {
            

            Vector2 mouseDir = character.GetGlobalMousePosition() - character.GlobalPosition;
            float angle = Mathf.RadToDeg(mouseDir.Angle());
            if (angle < 0) angle += 360;
            Side side;

            if (angle >= 90 && angle < 280)
                side = Side.Left;
            else
                side = Side.Right;

            if (angle >= 50 && angle < 130)
            {
                animatedSprite.Play("idleDownGun");
                down = true;
                HandsAnimation.Play("handsWalkingDown");

                HandsAnimation.Visible = true;
                if (side == Side.Right) HandsAnimation.Frame = 7;
                else if (side == Side.Left) HandsAnimation.Frame = 0;
                if (side == Side.Left)
                {

                    LampL.Visible = false;
                    LampR.Visible = true;
                    LampR.Play("LampRightWalkingDown");
                }
                else
                {
                    LampL.Visible = true;
                    LampR.Visible = false;
                    LampL.Play("LampLeftWalkingDown");

                }
            }
            else
            {
                down = false;
            }

            if(angle >= 240 && angle < 320)
            {
                LampL.Visible = false;
                LampR.Visible = false;
                HandsAnimation.Visible = false;
                if (side == Side.Right) animatedSprite.Frame = 1;
                else if (side == Side.Left) animatedSprite.Frame = 0;
                animatedSprite.Play("idleUpGun");
                up = true;
            }
            else
            {
                up = false;
            }


            if (side == Side.Right && !down && !up)
            {

                animatedSprite.Play("idleGun");
                
                if (angle >= 280 && angle < 350) HandsAnimation.Frame = 3;
                else if (angle >= 335) HandsAnimation.Frame = 2;
                else if (angle >= 15 && angle < 40) HandsAnimation.Frame = 1;
                HandsAnimation.Play("handsWalkingRight");
                HandsAnimation.Visible = true;
                LampL.Visible = false;
                LampR.Visible = true;
                LampR.Play("LampRightWalking");
            }
            else if (side == Side.Left && !down && !up)
            {

                animatedSprite.Play("idleLeftGun");

                   if (angle >= 130 && angle < 170) HandsAnimation.Frame = 1;
                else if (angle >= 170 && angle < 200) HandsAnimation.Frame = 2;
                else if (angle >= 200 && angle < 280) HandsAnimation.Frame = 3;
                HandsAnimation.Play("handsWalkingLeft");
                HandsAnimation.Visible = true;
                LampL.Visible = true;
                LampR.Visible = false;
                LampL.Play("LampLeftWalking");
            }
        }
        else
        {
            if (animatedSprite.Animation == "idleGun")
            {
                animatedSprite.Play("idle");
            }
            else if (animatedSprite.Animation == "idleLeftGun")
            {
                animatedSprite.Play("idleLeft");
            }
            else if (animatedSprite.Animation == "idleDownGun")
            {
                animatedSprite.Play("idleDown");
            }

        }
    }
}
