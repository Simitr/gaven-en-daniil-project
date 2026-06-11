using Godot;
using System;

public partial class WalkingState : State
{
	[Export] public CharacterBody2D character;
	[Export] public AnimatedSprite2D animatedSprite;
	[Export] public float speed = 90f;


	public override void Update(float delta)
	{
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

			character.Velocity = dir * speed;
			character.MoveAndSlide();
		}
		else
		{

			fsm.ChangeState("WalkAremd");
		}
	}

}
