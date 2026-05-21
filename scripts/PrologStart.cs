using Godot;
using System;

public partial class PrologStart : Node
{
    [Export] public Timer timerTest { get; set; }
    [Export] public Sprite2D Logo;
    [Export] public Label Label;
    public string state;

    public override void _Ready()
    {
        timerTest.Timeout += OnTimerTimeout;
        timerTest.Start();
        state = "start";
        Logo.Modulate = new Color(1,1,1,0);
        Label.Modulate = new Color(1, 1, 1, 0);
    }

    public override void _Process(double delta)
    {
         
    }

    private void OnTimerTimeout()
    {
        switch (state)
        {
            case "start":
                var tween = CreateTween();
                tween.TweenProperty(Logo, "modulate:a", 1.0f, 2.0f);
                timerTest.WaitTime = 4.0;
                state = "music";
                timerTest.Start();
                break;
            case "music":
                var tween2 = CreateTween();
                tween2.TweenProperty(Logo, "modulate:a", 0.0f, 2.0f);
                var tween3 = CreateTween();
                tween3.TweenProperty(Label, "modulate:a", 1.0f, 2.0f);
                break;
            
         }
        //GetTree().ChangeSceneToFile("res://scenes/prologue_scene/PrologForReal.tscn");
    }
}
