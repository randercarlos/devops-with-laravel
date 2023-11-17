<?php

namespace api\app\Models;

use api\app\Events\PostPublishedEvent;
use api\app\Models\User;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Post extends Model
{
    use HasFactory;

    protected $guarded = [];

    protected $casts = [
        'publish_at' => 'date',
    ];

    public function author(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function publish(): void
    {
        $this->publish_at = now();

        $this->is_published = true;

        $this->save();

        PostPublishedEvent::dispatch($this);
    }
}
