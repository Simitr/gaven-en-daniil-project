using Godot;
using System;

public partial class PrologStart : Node
{
    [Export] public Timer timerTest { get; set; }
    [Export] public Sprite2D Logo;
    [Export] public float requiemTime = 10.0f;
    [Export] public AudioStreamPlayer2D fonMusic;
    [Export] public Sprite2D progressBar;
    [Export] public Sprite2D horseprogressBar;
    public string state;
    public bool next = false;
    public float holdTime = 0.0f;
    private Tween volumeTween;
 

    public override void _Ready()
    {
        timerTest.Timeout += OnTimerTimeout;
        timerTest.Start();
        state = "start";
        progressBar.Modulate = new Color(1, 1, 1, 0); 
        horseprogressBar.Modulate = new Color(1, 1, 1, 0);
        Logo.Modulate = new Color(1,1,1,0);

        fonMusic.Play();
    }

    public override void _Process(double delta)
    {
         if (next)
            {
     
            progressBar.Modulate = new Color(1, 1, 1, 1);
            horseprogressBar.Modulate = new Color(1, 1, 1, 1);
  
                if (horseprogressBar.Position.X < 607)
                {
                    horseprogressBar.Position += new Vector2(6 * (float)delta, 0);
                }
                else
                {
                    GetTree().ChangeSceneToFile("res://scenes/prologue_scene/PrologForReal.tscn");
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
                state = "fonMusic";
                timerTest.Start();
                break;
            case "fonMusic":
                var tween2 = CreateTween();
                tween2.TweenProperty(Logo, "modulate:a", 0.0f, 2.0f);
             
                timerTest.WaitTime = 2.0;
                state = "next";
                timerTest.Start();

                fonMusic.VolumeDb = -20;

                volumeTween = CreateTween();
                volumeTween.TweenProperty(fonMusic, "volume_db", -10, 2f);
                fonMusic.Play();
                break;
            case "next":
                 next = true;
                
                break;

        }
 
    }
}
