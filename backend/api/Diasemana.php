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

$dao = new DiasemanaDAO();
$acao = $_GET["acao"] ?? "";
// LÊ O ENVELOPE ENVIADO PELO FLUTTER (POST)
$dados = json_decode(file_get_contents("php://input"), true);

switch ($acao) {

    case "listar":
        $id_diasemana = $_GET["id_diasemana"] ?? "";
        $diasemana = $dao->listarPorDiasemana($id_diasemana);
        echo json_encode($diasemana);
        break;
    
    case "inserir":
        $nome_dia = $dados["nome_dia"] ?? "";
        
        if (trim($nome_dia) == "") {
            http_response_code(400);
            echo json_encode(["erro" => "Nome do dia obrigatório."]);
            break;
        }
        
        $dao->inserir($nome_dia);
        echo json_encode(["mensagem" => "Dia da semana criado com sucesso!"]);
        break;
    
    case "excluir":
        $id_diasemana = $dados["id_diasemana"] ?? "";
        $dao->excluir($id_diasemana);
        echo json_encode(["mensagem" => "Dia da semana excluído com sucesso!"]);
        break;
    default:
        http_response_code(400);
        echo json_encode(["erro" => "Acao invalida."]);
        break;
}
