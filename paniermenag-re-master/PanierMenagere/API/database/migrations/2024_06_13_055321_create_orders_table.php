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
        Schema::create('orders', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->integer('uid');
            $table->string('store_id');
            $table->datetime('date_time');
            $table->string('paid_method');
            $table->string('order_to');
            $table->text('orders');
            $table->text('notes')->nullable();
            $table->text('address')->nullable();
            $table->string('driver_id')->nullable();
            $table->text('assignee')->nullable();
            $table->double('total', 10, 2)->nullable();
            $table->double('tax', 10, 2)->nullable();
            $table->double('grand_total', 10, 2)->nullable();
            $table->double('discount', 10, 2)->nullable();
            $table->double('delivery_charge', 10, 2)->nullable();
            $table->tinyInteger('wallet_used')->default(0);
            $table->double('wallet_price', 10, 2)->nullable();
            $table->text('coupon_code')->nullable();
            $table->text('extra')->nullable();
            $table->text('pay_key')->nullable();
            $table->text('status')->nullable();
            $table->tinyInteger('payStatus')->default(0);
            $table->text('extra_field')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('orders');
    }
};
