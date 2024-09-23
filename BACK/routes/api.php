<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserController;
use App\Http\Controllers\AnimalController;
use App\Http\Controllers\NecklaceController;
use App\Http\Controllers\CategorieController;

// Route::get('/user', function (Request $request) {
//     return $request->user();
// })->middleware('auth:sanctum');

Route::prefix('user')->group(function (){
    Route::get('/all', [UserController::class, 'index']);
    Route::post('/add',[UserController::class,'store']);
    Route::get('/show/{id}',[UserController::class,'show']);
    Route::patch('/update/{id}',[UserController::class,'update']);
    Route::delete('/delete/{id}',[UserController::class,'destroy']);
    Route::post('/restore/{id}',[UserController::class,'restore']);
});

Route::prefix('necklace')->group(function (){
    Route::get('/all', [NecklaceController::class, 'index']);
    Route::post('/add',[NecklaceController::class,'store']);
    Route::get('/show/{id}',[NecklaceController::class,'show']);
    Route::patch('/update/{id}',[NecklaceController::class,'update']);
    Route::delete('/delete/{id}',[NecklaceController::class,'destroy']);
    Route::post('/restore/{id}',[NecklaceController::class,'restore']);
});

Route::prefix('category')->group(function (){
    Route::get('/all', [CategorieController::class, 'index']);
    Route::post('/add',[CategorieController::class,'store']);
    Route::get('/show/{id}',[CategorieController::class,'show']);
    Route::patch('/update/{id}',[CategorieController::class,'update']);
    Route::delete('/delete/{id}',[CategorieController::class,'destroy']);
    Route::post('/restore/{id}',[CategorieController::class,'restore']);
});

Route::prefix('animal')->group(function (){
    Route::get('/all', [AnimalController::class, 'index']);
    Route::get('/user/{userId}', [AnimalController::class, 'animalsByUser']);
    Route::post('/add',[AnimalController::class,'store']);
    Route::get('/show/{id}',[AnimalController::class,'show']);
    Route::patch('/update/{id}',[AnimalController::class,'update']);
    Route::delete('/delete/{id}',[AnimalController::class,'destroy']);
    Route::post('/restore/{id}',[AnimalController::class,'restore']);
});

