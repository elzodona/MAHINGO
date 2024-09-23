<?php

use App\Models\User;
use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('necklaces', function (Blueprint $table) {
            $table->id();
            $table->string('identifier');
            $table->longtext('photo');
            $table->date('enabled_at');
            $table->date('desabled_at');
            $table->integer('battery')->nullable();
            $table->string('position')->nullable();
            $table->integer('temperature')->nullable();
            $table->integer('heart_rate')->nullable();
            $table->string('localisation')->nullable();
            $table->string('etat')->nullable();
            $table->softDeletes();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('necklaces');
    }
};
