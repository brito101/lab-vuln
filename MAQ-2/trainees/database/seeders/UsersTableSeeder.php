<?php

namespace Database\Seeders;

use DateTime;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class UsersTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        DB::table('users')->insert([
            [
                'name'      => 'Programador',
                'email'     => env('PROGRAMMER_EMAIL'),
                'password'  => bcrypt(env('PROGRAMMER_PASSWD')),
                'created_at' => new DateTime('now')
            ],
            [
                'name'      => 'Administrator',
                'email'     => env('ADMIN_EMAIL'),
                'password'  => bcrypt(env('ADMIN_PASSWD')),
                'created_at' => new DateTime('now')
            ],
            /** Testes */
            [
                'name'      => 'Franquiado 1',
                'email'     => 'franquia1@estagio.com',
                'password'  => bcrypt(12345678),
                'created_at' => new DateTime('now')
            ],
            [
                'name'      => 'Franquiado 2',
                'email'     => 'franquia2@estagio.com',
                'password'  => bcrypt(12345678),
                'created_at' => new DateTime('now')
            ],
            [
                'name'      => 'Franquiado 3',
                'email'     => 'franquia3@estagio.com',
                'password'  => bcrypt(12345678),
                'created_at' => new DateTime('now')
            ],
            [
                'name'      => 'Estagiário',
                'email'     => 'estagiario@estagio.com',
                'password'  => bcrypt(12345678),
                'created_at' => new DateTime('now')
            ]
        ]);
    }
}
