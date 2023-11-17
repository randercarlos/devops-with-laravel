<?php

namespace api\tests\Feature;

use api\app\Models\Post;
use api\app\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Notification;
use Illuminate\Support\Facades\Queue;
use Symfony\Component\HttpFoundation\Response;
use api\tests\TestCase;

class PublishPostTest extends TestCase
{
    use RefreshDatabase;

    /** @test */
    public function it_should_publish_a_post()
    {
        Queue::fake();

        Notification::fake();

        $user = User::factory()->create();

        $post = Post::factory()->unpublished()->create();

        $this->actingAs($user);

        $this->patchJson(route('posts.publish', ['post' => $post]), [])
            ->assertStatus(Response::HTTP_NO_CONTENT);

        $this->getJson(route('posts.show', ['post' => $post]))
            ->assertStatus(Response::HTTP_OK);
    }

    /** @test */
    public function it_should_return_404_if_post_is_unpublished()
    {
        $user = User::factory()->create();

        $post = Post::factory()->unpublished()->create();

        $this->actingAs($user);

        $this->getJson(route('posts.show', ['post' => $post]))
            ->assertStatus(Response::HTTP_NOT_FOUND);
    }
}
