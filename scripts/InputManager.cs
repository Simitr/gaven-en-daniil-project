using Godot;

public partial class InputManager : Node
{
    public override void _Process(double delta)
    {
        if (Input.IsActionJustPressed("armed"))
        {
            Global.Aremd = !Global.Aremd;
        }
    }
}

