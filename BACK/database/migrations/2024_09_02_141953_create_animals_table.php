<?php

use App\Models\Necklace;
use App\Models\Categorie;
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
        Schema::create('animals', function (Blueprint $table) {
            $table->id();
            $table->longtext('photo')->nullable();
            $table->string('name');
            $table->date('date_birth');
            $table->enum('sexe', ['Male','Female']);
            $table->string('race');
            $table->integer('taille');
            $table->integer('poids');
            $table->foreignIdFor(Necklace::class)->constrained()->onDelete('cascade');
            $table->foreignIdFor(Categorie::class)->constrained()->onDelete('cascade');
            $table->foreignIdFor(User::class)->constrained()->onDelete('cascade');
            $table->softDeletes();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('animals');
    }
};
