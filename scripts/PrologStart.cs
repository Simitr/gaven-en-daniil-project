using Godot;
using System;

public partial class PrologStart : Node
{
    [Export] public Timer timerTest { get; set; }
    [Export] public Sprite2D Logo;
    [Export] public Label Label;
    [Export] public float requiemTime = 10.0f;
    [Export] public AudioStreamPlayer2D Player;
    public string state;
    public bool next = false;
    public float holdTime = 0.0f;
    private Tween volumeTween;

    public override void _Ready()
    {
        timerTest.Timeout += OnTimerTimeout;
        timerTest.Start();
        state = "start";
        Logo.Modulate = new Color(1,1,1,0);
        Label.Modulate = new Color(1, 1, 1, 0);
        Player.Play();
    }

    public override void _Process(double delta)
    {
         if (next)
            {

            if (Input.IsActionPressed("walkRight"))
                {
                
                volumeTween = CreateTween();
                volumeTween.TweenProperty(Player, "volume_db", -10, 5f);
                var tween4 = CreateTween();
                tween4.TweenProperty(Label, "modulate:a", 0.0f, 2.0f);
                holdTime += (float)delta;
                if(holdTime >= requiemTime)
                {
                    GetTree().ChangeSceneToFile("res://scenes/prologue_scene/PrologForReal.tscn");
                }
            }
            else
            {
                

                var tween5 = CreateTween();
                tween5.TweenProperty(Label, "modulate:a", 1.0f, 2.0f);
            }
            if (Input.IsActionJustPressed("walkRight"))
            {
                Player.Play();
            }
            else if (Input.IsActionJustReleased("walkRight"))
            {
                Player.Stop();
            }
            
        }
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
             
                timerTest.WaitTime = 2.0;
                state = "next";
                timerTest.Start();
                
                Player.VolumeDb = -30; 
                Player.Play();
                break;
            case "next":
                 next = true;
                var tween4 = CreateTween();
                tween4.TweenProperty(Label, "modulate:a", 1.0f, 2.0f);
                break;

        }
 
    }
}
