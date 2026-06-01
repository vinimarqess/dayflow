<?php 

include __DIR__ . "/../models/Diasemana.php";

class DiasemanaDAO {

    // Metodo privado para conectar ao banco de dados MySQL do XAMPP
    private function conectar() {
        return new mysqli("localhost", "root", "", "dayflow", 3306);
    }

    /////////////////////////////////////////////////////////////////////////
    // 1 LISTAR
    public function listarPorDiasemana($id_diasemana) {
        $con = $this->conectar();
        $res = $con->query("SELECT * FROM diasemana WHERE id_diasemana='$id_diasemana'");
        $lista = [];
        
        while (($linha = $res->fetch_assoc()) != NULL) {
            $d = new Diasemana();
            $d->id = $linha["id_diasemana"];
            $d->nome  = $linha["nome"];
            array_push($lista, $d);
        }
        
        $con->close();
        return $lista;
    }

    /////////////////////////////////////////////////////////////////
    // 2 inserir
    public function inserir($nome) {
        $con = $this->conectar();
        
        // limpeza dos dados
        $nomeLimpo = $con->real_escape_string($nome);
        
        $res = $con->query("INSERT INTO diasemana (nome) VALUES ('$nomeLimpo')");
        $con->close();
        
        return $res; // retorna true ou false
    }

    /////////////////////////////////////////////////////////////////////////
    // 3 excluir    
    public function excluir($id_diasemana) {
        $con = $this->conectar();
        $res = $con->query("DELETE FROM diasemana WHERE id_diasemana='$id_diasemana'");
        $con->close();
        
        return $res; // retorna true ou false
    }

    /////////////////////////////////////////////////////////////////////////
    // 4 atualizar  
    