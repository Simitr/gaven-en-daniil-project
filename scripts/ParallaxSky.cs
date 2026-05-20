using Godot;
using System;

public partial class ParallaxSky : Node 
{
    [Export] public Parallax2D Parallax; // теперь видно в инспекторе
    [Export] public float ScrollSpeed = 10f;
    [Export] public Parallax2D Parallax2; // теперь видно в инспекторе
    [Export] public float ScrollSpeed2 = 20f;
    private bool isMoving = false;

    public override void _Process(double delta)
    {

        if (Input.IsActionPressed("walkRight"))
        {
            Parallax.ScrollOffset += new Vector2((float)(-ScrollSpeed * delta), 0);
            Parallax2.ScrollOffset += new Vector2((float)(-ScrollSpeed2 * delta), 0);
        }
    }
}


