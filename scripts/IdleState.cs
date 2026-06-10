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
        else if (animatedSprite.Animation == "walkingGun")
        {
            animatedSprite.Play("idleGun");
        }
        else
		{
            animatedSprite.Play("idle");
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
	   
	}
}
