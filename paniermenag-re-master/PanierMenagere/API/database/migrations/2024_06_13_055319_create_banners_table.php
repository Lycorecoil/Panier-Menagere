<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('banners', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->integer('city_id')->nullable();
            $table->string('cover')->nullable();
            $table->tinyInteger('position')->default(1);
            $table->text('link')->nullable();
            $table->tinyInteger('type')->default(1);
            $table->text('message')->nullable();
            $table->text('extra_field')->nullable();
            $table->date('from')->nullable();
            $table->date('to')->nullable();
            $table->tinyInteger('status')->default(1);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('banners');
    }
};
