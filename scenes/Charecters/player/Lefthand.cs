using Godot;
using System;

public partial class Lefthand : Node2D
{
    [Export] AnimatedSprite2D LampL;
    [Export] AnimatedSprite2D LampR;
    [Export] AnimatedSprite2D HandsAnimation;
    [Export] AnimatedSprite2D PlayerAnimation;
    public string currentAnimation = "";

    public override void _Process(double delta)
    {
        if (Global.Aremd)
        {
            Vector2 dir = GetGlobalMousePosition() - GlobalPosition;

            float angle = Mathf.RadToDeg(dir.Angle());

            if (angle < 0)
                angle += 360;

            
 

            if (PlayerAnimation.Animation == "walking" || PlayerAnimation.Animation == "walkinLeftGun" || PlayerAnimation.Animation == "walkingGun" || PlayerAnimation.Animation == "walkingback")
            {
                
                if (PlayerAnimation.Frame == 1 || PlayerAnimation.Frame == 3)
                {
                    HandsAnimation.Position = new Vector2(1, -2);
                    LampL.Position = new Vector2(1, -2);
                    LampR.Position = new Vector2(1, -2);
                }
                else
                {
                    HandsAnimation.Position = new Vector2(1, -3);
                    LampL.Position = new Vector2(1, -3);
                    LampR.Position = new Vector2(1, -3);
                }
                
                if (angle >= 90 && angle < 280)

                {
                    LampR.Visible = false;

                    if (PlayerAnimation.Animation != "walkingLeftGun")
                    {
                        PlayerAnimation.Play("walkinLeftGun");
                    }

                    HandsAnimation.Play("handsWalkingLeft");
                    if (angle >= 90 && angle < 130)
                    {
                        HandsAnimation.Frame = 0;
                    }
                    else if (angle >= 130 && angle < 170)
                    {
                        HandsAnimation.Frame = 1;
                    }
                    else if (angle >= 170 && angle < 200)
                    {
                        HandsAnimation.Frame = 2;
                    }
                    else if (angle >= 200 && angle < 280)
                    {
                        HandsAnimation.Frame = 3;
                    }
                    HandsAnimation.Visible = true;
                    LampL.Play("LampLeftWalking");

                    LampL.Visible = true;

                }
                else
                {
                 


                    LampL.Visible = false;
                    if (PlayerAnimation.Animation != "walkingGun")
                    {
                        PlayerAnimation.Play("walkingGun");
                    }

                    HandsAnimation.Play("handsWalkingRight");
                    if (angle >= 280 && angle < 350)
                    {
                        HandsAnimation.Frame = 3;
                    }
                    else if (angle >= 335)
                    {
                        HandsAnimation.Frame = 2;
                    }
                    else if (angle >= 15 && angle < 40)
                    {

                        HandsAnimation.Frame = 1;
                    }
                    else if (angle >= 40 && angle < 90)
                    {
                        HandsAnimation.Frame = 0; // вправ

                    }
                 
                    HandsAnimation.Visible = true;
                    LampR.Play("LampRightWalking");

                    LampR.Visible = true;
                }



            }

            if (PlayerAnimation.Animation == "walkingDown")
            {
                if (PlayerAnimation.Frame == 1 || PlayerAnimation.Frame == 4)
                {
                    HandsAnimation.Position = new Vector2(1, -2);
                    LampL.Position = new Vector2(1, -2);
                    LampR.Position = new Vector2(1, -2);
                }
                else
                {
                    HandsAnimation.Position = new Vector2(1, -3);
                    LampL.Position = new Vector2(1, -3);
                    LampR.Position = new Vector2(1, -3);
                }
                HandsAnimation.Play("hadsWalkingDown");
                HandsAnimation.Visible = true;
              
                if (angle >= 90 && angle < 280)

                {
                    LampL.Play("LampLeftWalkingDown");
                    LampL.Visible = false;
                    LampR.Visible = true;
                }
                else
                {
                    LampR.Play("LampRightWalkingDown");
                    LampL.Visible = true;
                    LampR.Visible = false;
                }


                if (angle >= 40 && angle < 90)
                {
                    HandsAnimation.Frame = 7; // вправ

                }


                else if (angle >= 90 && angle < 130)
                {


                    HandsAnimation.Frame = 0;

                }
                else if (angle >= 130 && angle < 170)
                {

                    HandsAnimation.Frame = 1;
                }
                else if (angle >= 170 && angle < 200)
                {

                    HandsAnimation.Frame = 2;
                }
                else if (angle >= 200 && angle < 280)
                {

                    HandsAnimation.Frame = 3;
                }



                else if (angle >= 280 && angle < 350)
                {

                    HandsAnimation.Frame = 4;
                }
                else if (angle >= 335)
                {
                    HandsAnimation.Frame = 5;
                }
                else if (angle >= 15 && angle < 40)
                {

                    HandsAnimation.Frame = 6;
                }
            }


        }
        else
        {
            LampL.Visible = false;
            LampR.Visible = false;
            HandsAnimation.Visible = false;
        }

    }
}