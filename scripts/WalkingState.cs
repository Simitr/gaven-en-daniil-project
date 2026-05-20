using Godot;
using System;

public partial class WalkingState : State
{
	[Export] public CharacterBody2D character;
	[Export] public AnimatedSprite2D animatedSprite;
	[Export] public float speed = 90f;

 
	public override void Update(float delta)
	{
		var dir = GameInput.MovementInput();
		if (dir == Vector2.Zero)
		{
			fsm.ChangeState("Idle");
		}
		else if (dir.X < 0 )
		{
			animatedSprite.Play("walkingback");
		}
		else if (dir.X > 0 || dir.Y != 0)
		{
			animatedSprite.Play("walking");
		}

		character.Velocity = dir * speed;
		character.MoveAndSlide();


	}


}
