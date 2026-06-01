<?php
error_reporting(0); // ← adiciona essa linha
ini_set('display_errors', 0);

include __DIR__ . "/../dao/UsuarioDAO.php";

header("Content-type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

$dao = new UsuarioDAO();
$acao = $_GET["acao"] ?? "";

// LÊ O ENVELOPE ENVIADO PELO FLUTTER (POST)
$dados = json_decode(file_get_contents("php://input"), true);

switch ($acao) {

    case "listar":
        $usuario = $dao->listar();
        echo json_encode($usuario);
        break;

    case "login":
        // Pegando do envelope POST com a mesma simplicidade
        $email = $dados["email"] ?? "";
        $senha = $dados["senha"] ?? "";
        
        $usuario = $dao->buscarPorEmail($email);
        
        // Mantive o seu padrão md5 conforme o modelo
        if ($usuario && $usuario->senha === md5($senha)) {
            $usuario->senha = null;
            echo json_encode($usuario);
        } else {
            http_response_code(401);
            echo json_encode(["erro" => "Email ou senha incorretos."]);
        }
        break;

    case "cadastrar":
        // Pegando do envelope POST com a mesma simplicidade
        $nome_usuario  = $dados["nome_usuario"] ?? "";
        $email = $dados["email"] ?? "";
        $senha = $dados["senha"] ?? "";
        
        if (trim($nome_usuario) == "" || trim($email) == "" || trim($senha) == "") {
            http_response_code(400);
            echo json_encode(["erro" => "Preencha todos os campos."]);
            break;
        }
        
        $dao->inserir($nome_usuario, $email, $senha);
        echo json_encode(["mensagem" => "Cadastro realizado com sucesso!"]);
        break;

    case "atualizar":
        $id = $dados["id"] ?? "";
        $nome_usuario = $dados["nome_usuario"] ?? "";
        $email = $dados["email"] ?? "";

        if (trim($nome_usuario) == "" || trim($email) == "") {
            http_response_code(400);
            echo json_encode(["erro" => "Preencha todos os campos."]);
            break;
        }

        $dao->atualizar($id, $nome_usuario, $email);
        echo json_encode(["mensagem" => "Perfil atualizado com sucesso!"]);
        break;

        default:
            http_response_code(400);
            echo json_encode(["erro" => "Acao invalida."]);
            break;

    case "excluir":
    $id = $dados["id"] ?? "";

    if (trim($id) == "") {
        http_response_code(400);
        echo json_encode(["erro" => "ID inválido."]);
        break;
    }

    $dao->excluir($id);
    echo json_encode(["mensagem" => "Usuário excluído com sucesso!"]);
    break;    
}