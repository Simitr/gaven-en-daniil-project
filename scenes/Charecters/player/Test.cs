using Godot;
using System;

public partial class Test : CharacterBody2D
{
	 

    public override void _PhysicsProcess(double delta) {

        if (Input.IsActionJustPressed("armed"))
        {
            Global.Aremd = !Global.Aremd;
        }
    }

    
}
