using Godot;
using System;

public partial class walkArmed : State
{
    [Export] public CharacterBody2D character;
    [Export] public AnimatedSprite2D animatedSprite;
    [Export] public float speed = 90f;
    [Export] AnimatedSprite2D LampL;
    [Export] AnimatedSprite2D LampR;
    [Export] AnimatedSprite2D HandsAnimation;
    public bool position;

    public enum Side { Left, Right }



    public override void Update(float delta)
    {
        var dir = GameInput.MovementInput();

        if (dir == Vector2.Zero)
        {
            fsm.ChangeState("Idle");
            return;
        }

        character.Velocity = dir * speed;
        character.MoveAndSlide();
    }

    public override void _Process(double delta)
    {
        if (!Global.Aremd)
        {
            LampL.Visible = false;
            LampR.Visible = false;
            HandsAnimation.Visible = false;
            return;
        }

        if (fsm.CurrentState != this)
            return;

        HandsAnimation.Visible = true;

        // направление мыши
        Vector2 mouseDir = character.GetGlobalMousePosition() - character.GlobalPosition;
        float angle = Mathf.RadToDeg(mouseDir.Angle());
        if (angle < 0) angle += 360;

        // направление движения
        Vector2 move = GameInput.MovementInput();

        // Позиция рук
  
       

    

        // -----------------------------
        // 1) ОПРЕДЕЛЯЕМ СТОРОНУ ОДИН РАЗ
        // -----------------------------
        Side side;

        if (angle >= 90 && angle < 280)
            side = Side.Left;
        else
            side = Side.Right;

        // -----------------------------
        // 2) АНИМАЦИЯ ВНИЗ (по движению)
        // -----------------------------
        if (move.Y > 0 && move.X == 0)
        {
            if (animatedSprite.Frame == 1 || animatedSprite.Frame == 4)
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
            animatedSprite.Play("walkingDown");
            HandsAnimation.Play("handsWalkingDown");

            // твои углы ↓
            if (angle >= 40 && angle < 90) HandsAnimation.Frame = 7;
            else if (angle >= 90 && angle < 130) HandsAnimation.Frame = 0;
            else if (angle >= 130 && angle < 170) HandsAnimation.Frame = 1;
            else if (angle >= 170 && angle < 200) HandsAnimation.Frame = 2;
            else if (angle >= 200 && angle < 280) HandsAnimation.Frame = 3;
            else if (angle >= 280 && angle < 350) HandsAnimation.Frame = 4;
            else if (angle >= 335) HandsAnimation.Frame = 5;
            else if (angle >= 15 && angle < 40) HandsAnimation.Frame = 6;

            // лампа строго по стороне
            if (side == Side.Left)
            {

                LampL.Visible = false;
                LampR.Visible = true;
                LampR.Play("LampRightWalkingDown");
            }
            else
            {
                LampL.Visible = true;
                LampR.Visible = false;
                LampL.Play("LampLeftWalkingDown");

            }

            return;
        }

        // -----------------------------
        // 3) ВЛЕВО / ВПРАВО (по углу мыши)
        // -----------------------------
        if (side == Side.Left)
        {
            animatedSprite.Play("walkinLeftGun");
            HandsAnimation.Play("handsWalkingLeft");

            if (animatedSprite.Frame == 2 )
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

            // твои углы ↓
            if (angle >= 90 && angle < 130) HandsAnimation.Frame = 0;
            else if (angle >= 130 && angle < 170) HandsAnimation.Frame = 1;
            else if (angle >= 170 && angle < 200) HandsAnimation.Frame = 2;
            else if (angle >= 200 && angle < 280) HandsAnimation.Frame = 3;

            LampL.Visible = true;
            LampR.Visible = false;
            LampL.Play("LampLeftWalking");
        }
        else
        {
            animatedSprite.Play("walkingGun");
            HandsAnimation.Play("handsWalkingRight");


            if (animatedSprite.Frame == 2 )
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

            // твои углы ↓
            if (angle >= 280 && angle < 350) HandsAnimation.Frame = 3;
            else if (angle >= 335) HandsAnimation.Frame = 2;
            else if (angle >= 15 && angle < 40) HandsAnimation.Frame = 1;
            else if (angle >= 40 && angle < 90) HandsAnimation.Frame = 0;

            LampL.Visible = false;
            LampR.Visible = true;
            LampR.Play("LampRightWalking");
        }
    }
}
