<?php

namespace api\database\seeders;

// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use api\app\Models\Post;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
         Post::factory(100)->create();
    }
}
