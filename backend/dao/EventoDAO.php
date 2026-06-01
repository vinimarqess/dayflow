<?php
include __DIR__ . "/../models/Evento.php";

class EventoDAO {

    // Metodo privado para conectar ao banco de dados MySQL do XAMPP
    private function conectar() {
        return new mysqli("localhost", "root", "", "dayflow", 3306);
    }

    // 1. INSERIR EVENTO
    public function inserir($nome, $descricao, $data, $hora, $alarme, $id_usuario) {
        $con = $this->conectar();

        // limpeza dos dados 
        $nomeLimpo      = $con->real_escape_string($nome);
        $descricaoLimpa = $con->real_escape_string($descricao);
        $alarmeValor    = $alarme ? "'$alarme'" : "NULL";

        $con->query("INSERT INTO evento (nome, descricao, data, hora, alarme, id_usuario)
                     VALUES ('$nomeLimpo', '$descricaoLimpa', '$data', '$hora', $alarmeValor, '$id_usuario')");

        $con->close();
    }

    // 2. LISTAR EVENTOS DO USUÁRIO
    public function listarPorUsuario($id_usuario) {
        $con = $this->conectar();
        $res = $con->query("SELECT * FROM evento WHERE id_usuario='$id_usuario' ORDER BY data, hora");
        $lista = [];

        while (($linha = $res->fetch_assoc()) != NULL) {
            $e = new Evento();
            $e->id_evento   = $linha["id_evento"];
            $e->nome        = $linha["nome"];
            $e->descricao   = $linha["descricao"];
            $e->data        = $linha["data"];
            $e->hora        = $linha["hora"];
            $e->alarme      = $linha["alarme"];
            $e->id_usuario  = $linha["id_usuario"];
            array_push($lista, $e);
        }

        $con->close();
        return $lista;
    }

    // 3. EXCLUIR EVENTO
    public function excluir($id_evento) {
        $con = $this->conectar();
        $con->query("DELETE FROM evento WHERE id_evento='$id_evento'");
        $con->close();
    }

    // ATUALIZAR EVENTO
    public function atualizar($id_evento, $nome, $descricao, $data, $hora, $alarme) {
        $con = $this->conectar();
        $nomeLimpo      = $con->real_escape_string($nome);
        $descricaoLimpa = $con->real_escape_string($descricao);
        $alarmeValor    = $alarme ? "'$alarme'" : "NULL";

        $con->query("UPDATE evento SET nome='$nomeLimpo', descricao='$descricaoLimpa',
                    data='$data', hora='$hora', alarme=$alarmeValor
                    WHERE id_evento='$id_evento'");
        $con->close();
}
}