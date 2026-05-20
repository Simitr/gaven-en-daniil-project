using Godot;
using System;

public partial class IdleState : State
{
	[Export] public CharacterBody2D character;
	[Export] public AnimatedSprite2D animatedSprite;
	public Vector2 direction;
	public int x = 0;
	// Called when the node enters the scene tree for the first time.

	public override void Enter()
	{
		animatedSprite.Play("idle");
	}
	public override void Update(float delta)
	{
		var dir = GameInput.MovementInput();
		if (dir != Vector2.Zero)
		{
			fsm.ChangeState("Walk");
		}
	   
	}
}
