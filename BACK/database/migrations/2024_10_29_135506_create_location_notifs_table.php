<?php

use App\Models\Animal;
use App\Models\User;
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('location_notifs', function (Blueprint $table) {
            $table->id();
            $table->foreignIdFor(User::class)->constrained()->nullable();
            $table->foreignIdFor(Animal::class)->constrained()->nullable();
            $table->enum('etat', ['lu', 'non_lu']);
            $table->date('dateSave');
            $table->float('altitude');
            $table->float('longitude');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('location_notifs');
    }
};
