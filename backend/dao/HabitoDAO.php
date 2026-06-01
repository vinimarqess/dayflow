<?php

include __DIR__ . "/../models/Habito.php";

class HabitoDAO {
    // Metodo privado para conectar ao banco de dados MySQL do XAMPP
    private function conectar() {
        return new mysqli("localhost", "root", "", "dayflow", 3306);
    }

    public function inserir($nome, $horario_inicio, $horario_fim, $concluido, $id_diasemana) {
        $con = $this->conectar();

        // limpeza dos dados
        $nomeLimpo = $con->real_escape_string($nome);
        $horario_inicio = $con->real_escape_string($horario_inicio);
        $horario_fim = $con->real_escape_string($horario_fim);
        $concluido = $con->real_escape_string($concluido);
        $id_diasemana = $con->real_escape_string($id_diasemana);

        $con->query("INSERT INTO habito (nome, horario_inicio, horario_fim, concluido, id_diasemana)
                     VALUES ('$nomeLimpo', '$horario_inicio', '$horario_fim', '$concluido', '$id_diasemana')");
        $con->close();
    }

    public function excluir($id_habito) {
        $con = $this->conectar();
        $con->query("DELETE FROM habito WHERE id_habito='$id_habito'");
        $con->close();
    }

    public function atualizar($id_habito, $nome, $horario_inicio, $horario_fim, $concluido) {
        $con = $this->conectar();

        // limpeza dos dados
        $nomeLimpo = $con->real_escape_string($nome);
        $horario_inicio = $con->real_escape_string($horario_inicio);
        $horario_fim = $con->real_escape_string($horario_fim);
        $concluido = $con->real_escape_string($concluido);

        $con->query("UPDATE habito SET nome='$nomeLimpo', horario_inicio='$horario_inicio', 
                     horario_fim='$horario_fim', concluido='$concluido' WHERE id_habito='$id_habito'");
        $con->close();
    }


    public function listar($id_diasemana) {
        $con = $this->conectar();
        $res = $con->query("SELECT * FROM habito WHERE id_diasemana='$id_diasemana'");
        $habito = null;

        if (($linha = $res->fetch_assoc()) != NULL) {
            $habito = new Habito();
            $habito->id_habito     = $linha["id_habito"];
            $habito->nome          = $linha["nome"];
            $habito->horario_inicio = $linha["horario_inicio"];
            $habito->horario_fim   = $linha["horario_fim"];
            $habito->concluido     = $linha["concluido"];
            $habito->id_diasemana  = $linha["id_diasemana"];
            array_push($lista, $h);
        }
        $con->close();
        return $habito;
    }

    // concluído (1) e não concluído (0)
    public function atualizarStatus($id_habito, $status) {
        $con = $this->conectar();

        $statusLimpo = (int)$status; 
        $con->query("UPDATE habito SET concluido='$statusLimpo' WHERE id_habito='$id_habito'");
        $con->close();
    }


}