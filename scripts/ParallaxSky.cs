using Godot;
using System;
using System.Threading;
using static System.Net.Mime.MediaTypeNames;

public partial class ParallaxSky : Node
{
    [Export] public Parallax2D Parallax;
    [Export] public Parallax2D Parallax2;
    [Export] public Parallax2D Parallax3;
    [Export] public Parallax2D Parallax4;
    [Export] public CharacterBody2D Player;
    [Export] public Label StopPressD;
    [Export] public Label PressD;
    [Export] public AudioStreamPlayer2D music;
    [Export] public Godot.Timer timer;
    [Export] public AudioStreamPlayer2D horseAudio;
    [Export] public ColorRect blackBackground;
    public float SkyStartSpeed = 1f;
    public float BackStartSpeed = 0f;
    public float GroundStartSpeed = 0f;
    public float GrassStartSpeed = 0f;
    [Export] public float SkyMaxSpeed = 10f;
    [Export] public float GroundMaxSpeed = 40f;
    [Export] public float GrassMaxSpeed = 50f;
    [Export] public float BackMaxSpeed = 15f;
    private bool isMoving = false;
    public string state = "";

    public override void _Ready()
    {
        StopPressD.Modulate = new Color(1, 1, 1, 0);
        PressD.Modulate = new Color(1, 1, 1, 0);
        timer.Timeout += OnTimerTimeout;
        horseAudio.Play();
    }

    public override void _Process(double delta)
    {
        var tween5 = CreateTween();
        tween5.TweenProperty(blackBackground, "modulate:a", 0f, 2.0f);
 

        if (!isMoving)
        {
          
             
            //horseAudio.Seek(5f);
            if (Player.Position.X < 160)
            {
                Player.Velocity = Vector2.Right * 90;
                Player.MoveAndSlide();
            }
            else
            {
                horseAudio.Stop();
                isMoving = true;
                music.Play();
            }

            timer.WaitTime = 5f;
            state = "start";
            timer.Start();
        }
        if (isMoving)
        {
           
            var tweenmusic = CreateTween();
           tweenmusic.TweenProperty(music, "volume_db", -10, 2f);
           

            if (Input.IsActionPressed("walkRight"))
            {
             // horseAudio.Play();
               
                PressD.Modulate = new Color(1, 1, 1, 0);
            

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
               horseAudio.Play();
                
          // horseAudio.Stop();

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
            if (Input.IsActionJustReleased("walkRight"))
            {
                timer.WaitTime = 5f;
                state = "start";
                timer.Start();
            }
            }


    }
    private void OnTimerTimeout()
    {
        switch (state)
        {
            case "start":
                if (!Input.IsActionPressed("walkRight"))
                {
                    PressD.Modulate = new Color(1, 1, 1, 1);
                }
  

                break;
            

        }
    }
}


