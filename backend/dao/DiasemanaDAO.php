<?php
include __DIR__ . "/../models/Diasemana.php";

class DiasemanaDAO {

    private function conectar() {
        return new mysqli("localhost", "root", "", "dayflow", 3306);
    }

    // 1. LISTAR POR ROTINA
    public function listarPorRotina($id_rotina) {
        $con = $this->conectar();
        $res = $con->query("SELECT * FROM diasemana WHERE id_rotina='$id_rotina' ORDER BY id_diasemana");
        $lista = [];

        while (($linha = $res->fetch_assoc()) != NULL) {
            $d = new Diasemana();
            $d->id_diasemana = $linha["id_diasemana"];
            $d->nome         = $linha["nome"];
            $d->id_rotina    = $linha["id_rotina"];
            array_push($lista, $d);
        }

        $con->close();
        return $lista;
    }

    // 2. INSERIR
    public function inserir($nome, $id_rotina) {
        $con = $this->conectar();
        $nomeLimpo = $con->real_escape_string($nome);
        $con->query("INSERT INTO diasemana (nome, id_rotina) VALUES ('$nomeLimpo', '$id_rotina')");
        $con->close();
    }

    // 3. EXCLUIR
    public function excluir($id_diasemana) {
        $con = $this->conectar();
        $con->query("DELETE FROM diasemana WHERE id_diasemana='$id_diasemana'");
        $con->close();
    }


    /////////////////////////////////////////////////////////////////////////
    // 4 atualizar  
    public function atualizar($id_diasemana, $nome) {
        $con = $this->conectar();
        $nomeLimpo = $con->real_escape_string($nome);
        $con->query("UPDATE diasemana SET nome='$nomeLimpo' WHERE id_diasemana='$id_diasemana'");
        $con->close();
    }
}