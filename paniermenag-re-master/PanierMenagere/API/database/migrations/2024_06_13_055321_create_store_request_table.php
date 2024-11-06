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
        Schema::create('store_request', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('first_name');
            $table->string('last_name');
            $table->string('email')->unique();
            $table->string('password');
            $table->string('country_code');
            $table->string('mobile');
            $table->text('name');
            $table->string('lat');
            $table->string('lng');
            $table->text('address')->nullable();
            $table->text('descriptions')->nullable();
            $table->text('cover')->nullable();
            $table->string('open_time')->nullable();
            $table->string('close_time')->nullable();
            $table->integer('cid')->nullable();
            $table->text('zipcode')->nullable();
            $table->text('extra_field')->nullable();
            $table->tinyInteger('status');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('store_request');
    }
};
