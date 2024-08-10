<?php

namespace App\Listeners;

use App\Events\PostPublishedEvent;
use App\Models\User;
use App\Notifications\PostPublishedNotification;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Support\Collection;

class SendPostPublishedNotifications implements ShouldQueue
{
    use InteractsWithQueue;

    public $queue = 'notifications';

    public function handle(PostPublishedEvent $event): void
    {
        User::where('id', '!=', $event->post->author->id)
            ->take(5)
            ->get()
//                ->each
//                ->notify(
//                    (new PostPublishedNotification($event->post))->onQueue('notifications')
//                );
            ->each(function(User $user) use ($event) {
                try {
                    $user->notify(
                        (new PostPublishedNotification($event->post))->onQueue('notifications')
                    );
                }
                catch(\Exception $exception) {
                    logger()->error("Falha ao enviar a notificação de post publicado para o email {$user->email} do usuário {$user->name}");
                    logger()->error($exception->getMessage());
                }
            });
    }
}
