using Godot;
using System;

public partial class WalkingState : State
{
	[Export] public CharacterBody2D character;
	[Export] public AnimatedSprite2D animatedSprite;
    [Export] public AnimatedSprite2D Legs;
    [Export] public float speed = 90f;


	public override void Update(float delta)
	{
        if (Input.IsActionJustPressed("armed"))
        {
            Global.Aremd = !Global.Aremd;
        }
        if (!Global.Aremd)
		{
			var dir = GameInput.MovementInput();
			if (dir == Vector2.Zero)
			{
				fsm.ChangeState("Idle");
			}

			if (dir.X < 0)
			{
				animatedSprite.Play("walkingback");
			}
			else if (dir.X > 0)
			{
				animatedSprite.Play("walking");
			}
			else if (dir.Y > 0)
			{
				animatedSprite.Play("walkingDown");
			}

             if (dir.Y < 0)
            {
                Legs.Play("walkingUp");
                Legs.Visible = true;
             
                if (Legs.Frame == 1 || Legs.Frame == 4)
                {
                    animatedSprite.Position = new Vector2(-2, -14);

                }
                else
                {
                    animatedSprite.Position = new Vector2(-2, -15);

                }
              
                animatedSprite.Play("WalkingUp");
            }
			else
			{
                Legs.Visible = false;
            }

            character.Velocity = dir * speed;
			character.MoveAndSlide();
		}
		else
		{

			fsm.ChangeState("WalkAremd");
		}
	}

}
