<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AlterTableUsersAddComplementyCoduments extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('users', function (Blueprint $table) {
            $table->string('document_person')->nullable(); //cpf
            $table->string('document_registry')->nullable(); //RG
            $table->string('issuer')->nullable(); //emissor
            $table->string('date_issue')->nullable(); //data de emissão
            $table->string('work_card')->nullable(); //carteira de trabalho
            $table->string('serie')->nullable(); //número de série
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn('document_person'); //cpf
            $table->dropColumn('document_registry'); //RG
            $table->dropColumn('issuer'); //emissor
            $table->dropColumn('date_issue'); //data de emissão
            $table->dropColumn('work_card'); //carteira de trabalho
            $table->dropColumn('serie'); //número de série
        });
    }
}
