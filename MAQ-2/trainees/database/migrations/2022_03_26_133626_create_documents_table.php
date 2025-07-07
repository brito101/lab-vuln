<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateDocumentsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('documents', function (Blueprint $table) {
            $table->id();
            $table->string('document_person')->nullable(); //CPF
            $table->string('document_registry')->nullable(); //RG
            $table->string('registration')->nullable(); //Atestado de matrícula
            $table->string('historic')->nullable(); //Histórico Escolar
            $table->string('declaration')->nullable(); //Declaração da Instituição de Ensino
            $table->string('residence')->nullable(); //Comprovante de residência
            $table->foreignId('user_id')
                ->constrained()
                ->onUpdate('cascade')
                ->onDelete('cascade');
            $table->softDeletes();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('documents');
    }
}
