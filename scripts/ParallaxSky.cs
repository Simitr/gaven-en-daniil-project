using Godot;
using System;
using System.Threading;

public partial class ParallaxSky : Node 
{
    [Export] public Parallax2D Parallax; 
    [Export] public Parallax2D Parallax2;
    [Export] public Parallax2D Parallax3;
    [Export] public Parallax2D Parallax4;
    public float SkyStartSpeed = 1f;
    public float BackStartSpeed = 0f;
    public float GroundStartSpeed = 0f;
    public float GrassStartSpeed = 0f;
    [Export] public float SkyMaxSpeed = 10f;
    [Export] public float GroundMaxSpeed = 40f;
    [Export] public float GrassMaxSpeed = 50f;
    [Export] public float BackMaxSpeed = 15f;
    private bool isMoving = false;

    public override void _Ready()
    {
        
    }

    public override void _Process(double delta)
    {

        if (Input.IsActionPressed("walkRight"))
        {
     
            var tween = CreateTween();
            tween.TweenProperty(this, "SkyStartSpeed", SkyMaxSpeed, 1.5f);
            var tween2 = CreateTween();
            tween2.TweenProperty(this, "BackStartSpeed", BackMaxSpeed, 1.5f);
            var tween3 = CreateTween();
            tween3.TweenProperty(this, "GroundStartSpeed", GroundMaxSpeed, 1.5f);
            var tween4 = CreateTween();
            tween4.TweenProperty(this, "GrassStartSpeed", GrassMaxSpeed, 1.5f);
            Parallax.ScrollOffset += new Vector2((float)(-SkyStartSpeed * delta), 0);
            Parallax2.ScrollOffset += new Vector2((float)(-BackStartSpeed * delta), 0);
            Parallax3.ScrollOffset += new Vector2((float)(-GroundStartSpeed * delta), 0);
            Parallax4.ScrollOffset += new Vector2((float)(-GrassStartSpeed * delta), 0);
        }
        else
        {
            var tween = CreateTween();
            tween.TweenProperty(this, "SkyStartSpeed", 1, 1.0f);
            var tween2 = CreateTween();
            tween2.TweenProperty(this, "BackStartSpeed", 0, 1.0f);
            var tween3 = CreateTween();
            tween3.TweenProperty(this, "GroundStartSpeed", 0, 1.0f);
            var tween4 = CreateTween();
            tween4.TweenProperty(this, "GrassStartSpeed", 0, 1.0f);
            Parallax.ScrollOffset += new Vector2((float)(-SkyStartSpeed * delta), 0);
            Parallax2.ScrollOffset += new Vector2((float)(-BackStartSpeed * delta), 0);
            Parallax3.ScrollOffset += new Vector2((float)(-GroundStartSpeed * delta), 0);
            Parallax4.ScrollOffset += new Vector2((float)(-GrassStartSpeed * delta), 0);
            if (BackStartSpeed < 5)
            {
                BackStartSpeed = 0;
            }
            if (GroundStartSpeed < 5)
            {
                GroundStartSpeed = 0;
            }
            if (GrassStartSpeed < 5)
            {
                GrassStartSpeed = 0;
            }


        }
    }
}


