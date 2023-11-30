<?php

namespace Database\Seeders;

// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use App\Models\Post;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        $existsPosts = Post::exists();
        if (! $existsPosts) {
            Post::factory(100)->create();
        }
    }
}
