<?php
error_reporting(0);
ini_set('display_errors', 0);

include __DIR__ . "/../dao/DiasemanaDAO.php";

header("Content-type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

$dao   = new DiasemanaDAO();
$acao  = $_GET["acao"] ?? "";
$dados = json_decode(file_get_contents("php://input"), true);

switch ($acao) {

    case "listar":
        $id_rotina = $_GET["id_rotina"] ?? "";
        $dias = $dao->listarPorRotina($id_rotina);
        echo json_encode($dias);
        break;
        
    /////////////////////////////////////////////////////////////////////////////
    case "inserir":
        $nome      = $dados["nome"] ?? "";
        $id_rotina = $dados["id_rotina"] ?? ""; // ✅ adicionado

        if (trim($nome) == "") {
            http_response_code(400);
            echo json_encode(["erro" => "Nome do dia obrigatório."]);
            break;
        }

        $dao->inserir($nome, $id_rotina);
        echo json_encode(["mensagem" => "Dia adicionado com sucesso!"]);
        break;

    /////////////////////////////////////////////////////////////////////////////
    case "excluir":
        $id_diasemana = $dados["id_diasemana"] ?? "";
        $dao->excluir($id_diasemana);
        echo json_encode(["mensagem" => "Dia excluído com sucesso!"]);
        break;

    default:
        http_response_code(400);
        echo json_encode(["erro" => "Acao invalida."]);
        break;
    
    /////////////////////////////////////////////////////////////////////////////
    case "atualizar":
        $id_diasemana = $dados["id_diasemana"] ?? "";
        $nome         = $dados["nome"] ?? "";

        if (trim($nome) == "") {
            http_response_code(400);
            echo json_encode(["erro" => "Nome do dia obrigatório."]);
            break;
        }

        $dao->atualizar($id_diasemana, $nome);
        echo json_encode(["mensagem" => "Dia atualizado com sucesso!"]);
        break;
}