<?php
include __DIR__ . "/../models/Habito.php";

class HabitoDAO {

    private function conectar() {
        return new mysqli("localhost", "root", "", "dayflow", 3306);
    }

    // 1. INSERIR
    public function inserir($nome, $horario_inicio, $horario_fim, $id_diasemana) {
        $con = $this->conectar();
        $nomeLimpo      = $con->real_escape_string($nome);
        $horaInicioLimpa = $con->real_escape_string($horario_inicio);
        $horaFimLimpa   = $con->real_escape_string($horario_fim);

        $con->query("INSERT INTO habito (nome, horario_inicio, horario_fim, concluido, id_diasemana)
                     VALUES ('$nomeLimpo', '$horaInicioLimpa', '$horaFimLimpa', 0, '$id_diasemana')");
        $con->close();
    }

    // 2. LISTAR POR DIA
    public function listar($id_diasemana) {
        $con = $this->conectar();
        $res = $con->query("SELECT * FROM habito WHERE id_diasemana='$id_diasemana' ORDER BY horario_inicio");
        $lista = [];

        while (($linha = $res->fetch_assoc()) != NULL) {
            $h = new Habito();
            $h->id_habito      = $linha["id_habito"];
            $h->nome           = $linha["nome"];
            $h->horario_inicio = $linha["horario_inicio"];
            $h->horario_fim    = $linha["horario_fim"];
            $h->concluido      = $linha["concluido"];
            $h->id_diasemana   = $linha["id_diasemana"];
            array_push($lista, $h);
        }

        $con->close();
        return $lista;
    }

    // 3. ATUALIZAR
    public function atualizar($id_habito, $nome, $horario_inicio, $horario_fim) {
        $con = $this->conectar();
        $nomeLimpo       = $con->real_escape_string($nome);
        $horaInicioLimpa = $con->real_escape_string($horario_inicio);
        $horaFimLimpa    = $con->real_escape_string($horario_fim);

        $con->query("UPDATE habito SET nome='$nomeLimpo', horario_inicio='$horaInicioLimpa',
                     horario_fim='$horaFimLimpa' WHERE id_habito='$id_habito'");
        $con->close();
    }

    // 4. EXCLUIR
    public function excluir($id_habito) {
        $con = $this->conectar();
        $con->query("DELETE FROM habito WHERE id_habito='$id_habito'");
        $con->close();
    }

    // 5. ATUALIZAR STATUS (concluído/não concluído)
    public function atualizarStatus($id_habito, $status) {
        $con = $this->conectar();
        $statusLimpo = (int)$status;
        $con->query("UPDATE habito SET concluido='$statusLimpo' WHERE id_habito='$id_habito'");
        $con->close();
    }
}