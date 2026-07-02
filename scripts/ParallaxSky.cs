using Godot;
using System;
using System.Threading;
using static Godot.WebSocketPeer;
using static System.Net.Mime.MediaTypeNames;

public partial class ParallaxSky : Node
{
	[Export] public Parallax2D Parallax;
	[Export] public Parallax2D Parallax2;
	[Export] public Parallax2D Parallax3;
	[Export] public Parallax2D Parallax4;
	[Export] public CharacterBody2D Player;
	[Export] public AnimatedSprite2D animatieCharacter;
	[Export] public AudioStreamPlayer2D music;
    [Export] public AudioStreamPlayer2D fall;
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
	[Export] public Sprite2D trap;
 
   
	public string state = "";
	public bool isatrap = false;
	public bool end = false;


    private GameStateC _state;
    public override void _Ready()
	{
        _state = GetNode<GameStateC>("/root/GameStateC");
 

        if (_state.IsMoving)
        {
            Player.Position = new Vector2(160, Player.Position.Y);
            animatieCharacter.Play("idle");
            music.Play();

            // восстанавливаем логику таймера, которая раньше срабатывала
            // автоматически через 1 секунду после входа в idle
            timer.WaitTime = 1f;
            state = "start";
            timer.Start();
        }
        else
        {
            horseAudio.Play();
        }

        timer.Timeout += OnTimerTimeout;
        var tween = CreateTween();
        tween.TweenProperty(blackBackground, "modulate:a", 0f, 2.0f);

    }

	public override void _Process(double delta)
	{

        if (!IsInsideTree())
            return;


        if (!_state.IsMoving)
		{


			//horseAudio.Seek(5f);
			if (Player.Position.X < 160)
			{
				animatieCharacter.Play("walking");
				Player.Velocity = Vector2.Right * 90;
				Player.MoveAndSlide();

			}
			else
			{
				animatieCharacter.Play("idle");
				horseAudio.Stop();
                _state.IsMoving = true;
				music.Play();
			}

			timer.WaitTime = 1f;
			state = "start";
			timer.Start();
		}
		if (!end)
		{
			if (_state.IsMoving)
			{
				if (!_state.Zalupa)
				{
					GetTree().ChangeSceneToFile("res://scenes/Items/dProlog.tscn");
                    _state.Zalupa = true;
                    return;
                }
                    var twee = CreateTween();
                    twee.TweenProperty(blackBackground, "modulate:a", 0f, 0.2f);
                    var tweenmusic = CreateTween();
					tweenmusic.TweenProperty(music, "volume_db", -10, 2f);


					if (Input.IsActionPressed("walkRight"))
					{
						if (Input.IsActionPressed("walkUp") && animatieCharacter.Position.Y > 45)
						{
							animatieCharacter.Position -= new Vector2(0, 2 * (float)delta);
						}
						if (Input.IsActionPressed("walkDown") && animatieCharacter.Position.Y < 55)
						{
							animatieCharacter.Position += new Vector2(0, 2 * (float)delta);
						}
						if (isatrap)
						{
							trap.Position += new Vector2((float)(-GroundStartSpeed * delta), 0);
							if (trap.Position < new Vector2(290, 235))
							{
								trap.Position = new Vector2(290, 185 + animatieCharacter.Position.Y);
								trap.Visible = true;
								end = true;
							}
						}
						animatieCharacter.Play("walking");




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
						if (isatrap)
						{
							trap.Position += new Vector2((float)(-GroundStartSpeed * delta), 0);

						}
						animatieCharacter.Play("idle");
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
		else
		{
			 animatieCharacter.Play("fall");
			if (animatieCharacter.Frame == 0)
			{
				fall.Play();
			}
			if (animatieCharacter.Frame == 4)
			{
				music.Stop();
                horseAudio.Stop();
                var tween = CreateTween();
                tween.TweenProperty(blackBackground, "modulate:a", 1f, 0.2f); 
               
            }
			else if (animatieCharacter.Frame == 6)
			{
                GetTree().ChangeSceneToFile("res://scenes/AllLevel_scenes/Level1.tscn");
 
            }
        }

	}
	private void OnTimerTimeout()
	{
        GD.Print("Привет, мир!");
        switch (state)
		{
			case "start":
				isatrap = true;


				break;




		}
	}
 

}



