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
        Schema::create('manage', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->tinyInteger('app_close')->default(1); // 1= open // 0 = closed
            $table->text('message')->nullable();
            $table->string('date_time')->nullable();
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
        Schema::dropIfExists('manage');
    }
};
