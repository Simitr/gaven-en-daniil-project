using Godot;

public static class GameInput
{
    public static Vector2 MovementInput()
    {
        Vector2 dir = Vector2.Zero;

        if (Input.IsActionPressed("walkRight"))
            dir.X += 1;

        if (Input.IsActionPressed("walkLeft"))
            dir.X -= 1;

        if (Input.IsActionPressed("walkDown"))
            dir.Y += 1;

        if (Input.IsActionPressed("walkUp"))
            dir.Y -= 1;

        return dir.Normalized();
    }
}
