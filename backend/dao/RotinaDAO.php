<?php

include __DIR__ . "/../models/Rotina.php";

class RotinaDAO {

    private function conectar() {
        return new mysqli("localhost", "root", "", "dayflow", 3306);
    }

    // 1. INSERIR ROTINA
    public function inserir($nome, $descricao, $id_usuario) {
        $con = $this->conectar();
        $nomeLimpo = $con->real_escape_string($nome);
        $descLimpa = $con->real_escape_string($descricao);

        $con->query("INSERT INTO rotina (nome, descricao, id_usuario)
                     VALUES ('$nomeLimpo', '$descLimpa', '$id_usuario')");
        $con->close();
    }

    // 2. LISTAR ROTINAS DO USUARIO
    public function listarPorUsuario($id_usuario) {
        $con = $this->conectar();
        $res = $con->query("SELECT * FROM rotina WHERE id_usuario='$id_usuario' ORDER BY nome");
        $lista = [];

        while (($linha = $res->fetch_assoc()) != NULL) {
            $r = new Rotina();
            $r->id_rotina  = $linha["id_rotina"];
            $r->nome       = $linha["nome"];
            $r->descricao  = $linha["descricao"];
            $r->ativa      = $linha["ativa"];
            $r->id_usuario = $linha["id_usuario"];
            array_push($lista, $r);
        }

        $con->close();
        return $lista;
    }

    // ATUALIZAR ROTINA
    public function atualizar($id_rotina, $nome, $descricao) {
        $con = $this->conectar();
        $nomeLimpo = $con->real_escape_string($nome);
        $descLimpa = $con->real_escape_string($descricao);

        $con->query("UPDATE rotina SET nome='$nomeLimpo', descricao='$descLimpa'
                     WHERE id_rotina='$id_rotina'");
        $con->close();
    }

    // Rotina ativa
    public function marcarAtiva($id_rotina, $id_usuario) {
        $con = $this->conectar();
        $con->query("UPDATE rotina SET ativa=0 WHERE id_usuario='$id_usuario'");
        $con->query("UPDATE rotina SET ativa=1 WHERE id_rotina='$id_rotina'");
        $con->close();
    }

    // 5. EXCLUIR ROTINA 
    public function excluir($id_rotina) {
        $con = $this->conectar();
        $con->query("DELETE FROM rotina WHERE id_rotina='$id_rotina'");
        $con->close();
    }
}