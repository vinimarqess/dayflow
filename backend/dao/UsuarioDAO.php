<?php

include __DIR__ . "/../model/Usuario.php";

class UsuarioDAO {

    // Método privado para conectar ao banco de dados MySQL do XAMPP
    private function conectar() {
        return new mysqli("localhost", "root", "", "dayflow", 3306);
    }

    // 1. LISTAR USUÁRIOS
    public function listar() {
        $con = $this->conectar();
        $res = $con->query("SELECT * FROM usuario ORDER BY nome_usuario");
        $lista = [];
        
        while (($linha = $res->fetch_assoc()) != NULL) {
            $u = new Usuario();
            $u->id    = $linha["id"];
            $u->nome_usuario  = $linha["nome_usuario"];
            $u->email = $linha["email"];
            // senha não entra na listagem comum
            array_push($lista, $u);
        }
        
        $con->close();
        return $lista;
    }

    // 2. BUSCAR POR EMAIL (Para o fluxo de Login)
    public function buscarPorEmail($email) {
        $con = $this->conectar();
        
        // Proteção simples contra caracteres maliciosos
        $emailLimpo = $con->real_escape_string($email);
        
        $res = $con->query("SELECT * FROM usuario WHERE email = '$emailLimpo'");
        $linha = $res->fetch_assoc();
        $con->close();
        
        if (!$linha) return null; // Se não achar o email, retorna vazio
        
        $u = new Usuario();
        $u->id    = $linha["id"];
        $u->nome_usuario  = $linha["nome_usuario"];
        $u->email = $linha["email"];
        $u->senha = $linha["senha"]; // Pega a senha criptografada para validar na API
        
        return $u;
    }

    // 3. INSERIR NOVO USUÁRIO (Para o fluxo de Cadastro)
    public function inserir($nome_usuario, $email, $senha) {
        $con = $this->conectar();
        
        // Limpeza dos dados antes de salvar
        $nomeLimpo  = $con->real_escape_string($nome_usuario);
        $emailLimpo = $con->real_escape_string($email);
        
        // Criptografia MD5 idêntica ao que a sua API de login vai checar
        $senhaCriptografada = md5($senha);
        
        $con->query("INSERT INTO usuario (nome_usuario, email, senha) 
                     VALUES ('$nomeLimpo', '$emailLimpo', '$senhaCriptografada')");
                     
        $con->close();
    }
}