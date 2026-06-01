<?php

include __DIR__ . "/../models/Usuario.php";

class UsuarioDAO {

    // Metodo privado para conectar ao banco de dados MySQL do XAMPP
    private function conectar() {
        return new mysqli("localhost", "root", "", "dayflow", 3306);
    }
    
    /////////////////////////////////////////////////////////////////////////
    // 1. LISTAR
    public function listar() {
        $con = $this->conectar();
        $res = $con->query("SELECT * FROM usuario ORDER BY nome_usuario");
        $lista = [];
        
        while (($linha = $res->fetch_assoc()) != NULL) {
            $u = new Usuario();
            $u->id = $linha["id_usuario"];
            $u->nome_usuario  = $linha["nome_usuario"];
            $u->email = $linha["email"];
            // senha não entra na listagem comum
            array_push($lista, $u);
        }
        
        $con->close();
        return $lista;
    }

    /////////////////////////////////////////////////////////////////////////
    //BUSCAR POR EMAIL
    public function buscarPorEmail($email) {
        $con = $this->conectar();
        
        // protecao contra caracteres maliciosos
        $emailLimpo = $con->real_escape_string($email);
        
        $res = $con->query("SELECT * FROM usuario WHERE email = '$emailLimpo'");
        $linha = $res->fetch_assoc();
        $con->close();
        
        if (!$linha) return null; // se nao achar o email retorna vazio
        
        $u = new Usuario();
        $u->id = $linha["id_usuario"];
        $u->nome_usuario  = $linha["nome_usuario"];
        $u->email = $linha["email"];
        $u->senha = $linha["senha"]; // pega a senha criptografada para validacao
        
        return $u;
    }

    /////////////////////////////////////////////////////////////////////////
    //INSERIR USUARIO 
    public function inserir($nome_usuario, $email, $senha) {
        $con = $this->conectar();
        
        // limpeza dos dados 
        $nomeLimpo = $con->real_escape_string($nome_usuario);
        $emailLimpo = $con->real_escape_string($email);
        
        // Criptografia MD5
        $senhaCriptografada = md5($senha);
        
        $con->query("INSERT INTO usuario (nome_usuario, email, senha) 
                     VALUES ('$nomeLimpo', '$emailLimpo', '$senhaCriptografada')");
                     
        $con->close();
    }
    /////////////////////////////////////////////////////////////////////////
    //ATUALIZAR 
    public function atualizar($id, $nome_usuario, $email) {
        $con = $this->conectar();
        
        $nomeLimpo = $con->real_escape_string($nome_usuario);
        $emailLimpo = $con->real_escape_string($email);
        
        $con->query("UPDATE usuario SET nome_usuario='$nomeLimpo', email='$emailLimpo' 
                    WHERE id_usuario='$id'");
        $con->close();
    }

    /////////////////////////////////////////////////////////////////////////
    //ALTERAR SENHA
    public function alterarSenha($id, $novaSenha) {
        $con = $this->conectar();
        $senhaCriptografada = md5($novaSenha);
        $con->query("UPDATE usuario SET senha='$senhaCriptografada' 
                    WHERE id_usuario='$id'");
        $con->close();
    }
    
    /////////////////////////////////////////////////////////////////////////
    //EXCLUIR
    public function excluir($id) {
        $con = $this->conectar();
        $con->query("DELETE FROM usuario WHERE id_usuario='$id'");
        $con->close();
    }
}