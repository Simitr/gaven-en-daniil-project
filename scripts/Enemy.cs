using Godot;

public partial class Enemy : CharacterBody2D
{
    [Export] public float Speed = 100f;

    private Node2D _player;
    private bool _playerChase = false;

    public override void _PhysicsProcess(double delta)
    {
        if (_playerChase && _player != null)
        {
            // направление к игроку
            Vector2 direction = (_player.Position - Position).Normalized();
            Velocity = direction * Speed;
        }
        else
        {
            Velocity = Vector2.Zero;
        }

        MoveAndSlide();
    }

    private void OnDetectionAreaBodyEntered(Node2D body)
    {
        // Проверяем, что вошёл именно игрок
         
            GD.Print("Игрок вошёл в DetectionArea!");
            _player = body;
            _playerChase = true;
         
    }

    private void OnDetectionAreaBodyExited(Node2D body)
    {
         
            GD.Print("Игрок вышел из DetectionArea!");
            _player = null;
            _playerChase = false;
        
    }
}
