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
        Schema::create('rating', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->integer('uid')->nullable();
            $table->integer('pid')->nullable();
            $table->integer('did')->nullable();
            $table->integer('sid')->nullable();
            $table->double('rate', 10, 2)->nullable();
            $table->text('msg')->nullable();
            $table->string('way')->nullable();
            $table->date('timestamp')->nullable();
            $table->tinyInteger('status')->default(0);
            $table->text('extra_field')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('rating');
    }
};
