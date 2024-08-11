<?php

namespace App\Http\Controllers;

class GetCurrentEnvironmentController extends Controller
{
    public function __invoke()
    {
        return response()->json([
            'data' => [
                'current-environment' => app()->environment(),
            ],
        ]);
    }
}
