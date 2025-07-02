<?php

use Illuminate\Support\Facades\Route;

Route::prefix('laravel')->group(function () {
    Route::get('/', function () {
        return 'Hello from Laravel, deployment through pipeline';
    });
});

// Health check route for ALB
Route::get('/health', function () {
    return response('OK', 200);
});

