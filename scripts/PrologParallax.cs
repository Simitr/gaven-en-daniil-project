using Godot;
using System;

public partial class PrologParallax : Node
{
    [Export] public Sprite2D sky;
    [Export] public Sprite2D sky2;
    [Export] public Sprite2D back;
    [Export] public Sprite2D back2;
    [Export] public Sprite2D grass;
    [Export] public float speedGrass = 80f;
    [Export] public float speedSky = 50f;
    [Export] public float speedBack = 75f;

    private const float SkyWidth = 512f;
    public override void _Process(double delta)
    {
        Vector2 dir = Vector2.Zero;
        if (Input.IsActionPressed("walkRight"))
            dir.X += 1;
        if (dir == Vector2.Zero)
        {
            
        }
  
        else if (dir.X > 0 )
        {
            sky.Position -= dir * speedSky * (float)delta;
            sky2.Position -= dir * speedSky * (float)delta;
            back.Position -= dir * speedSky * (float)delta;
            back2.Position -= dir * speedSky * (float)delta;
            grass.Position -= dir * speedGrass * (float)delta;

        }
        if (sky.Position.X <= -SkyWidth/2)
        {
            sky.Position = new Vector2(sky2.Position.X + SkyWidth, sky.Position.Y);
        }

        
        if (sky2.Position.X <= -SkyWidth/2)
        {
            sky2.Position = new Vector2(sky.Position.X + SkyWidth  , sky2.Position.Y);
        }

        if (back.Position.X <= -SkyWidth / 2)
        {
            back.Position = new Vector2(back.Position.X + SkyWidth, back.Position.Y);
        }


        if (back2.Position.X <= -SkyWidth / 2)
        {
            back2.Position = new Vector2(back2.Position.X + SkyWidth, back2.Position.Y);
        }



    }
}
