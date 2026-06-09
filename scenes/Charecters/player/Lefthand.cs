using Godot;
using System;

public partial class Lefthand : Node2D
{
    [Export] AnimatedSprite2D an;
    public override void _Process(double delta)
    {
        Vector2 dir = GetGlobalMousePosition() - GlobalPosition;

        float angle = Mathf.RadToDeg(dir.Angle());

        if (angle < 0)
            angle += 360;

        if (angle >= 40 && angle < 90)
        {
            an.Frame = 7; // вправ
        }


        else if (angle >= 90 && angle < 130)
        {


            an.Frame = 0;

        }
        else if (angle >= 130 && angle < 170)
        {
            an.Frame = 1;
        }
        else if (angle >= 170 && angle < 200)
        {
            an.Frame = 2;
        }
        else if (angle >= 200 && angle < 250)
        {
            an.Frame = 3;
        }
        else if (angle >= 295 && angle < 350)
        {
            an.Frame = 4;
        }
        else if (angle >= 335)
        {
            an.Frame = 5;
        }
        else if (angle >= 15 && angle < 40)
        {
            an.Frame = 6;
        }
    }
}