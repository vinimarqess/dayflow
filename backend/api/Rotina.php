<?php
error_reporting(0);
ini_set('display_errors', 0);

include __DIR__ . "/../dao/RotinaDAO.php";

header("Content-type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

$dao = new RotinaDAO();
$acao = $_GET["acao"] ?? "";
$dados = json_decode(file_get_contents("php://input"), true);

switch ($acao) {

    case "inserir":
        $nome = $dados["nome"] ?? "";
        $descricao = $dados["descricao"] ?? "";
        $id_usuario = $dados["id_usuario"] ?? "";

        if (trim($nome) == "") {
            http_response_code(400);
            echo json_encode(["erro" => "Nome obrigatório."]);
            break;
        }

        $dao->inserir($nome, $descricao, $id_usuario);
        echo json_encode(["mensagem" => "Rotina criada com sucesso!"]);
        break;

    case "listar":
        $id_usuario = $_GET["id_usuario"] ?? "";
        $rotinas = $dao->listarPorUsuario($id_usuario);
        echo json_encode($rotinas);
        break;

    case "atualizar":
        $id_rotina = $dados["id_rotina"] ?? "";
        $nome = $dados["nome"] ?? "";
        $descricao = $dados["descricao"] ?? "";

        $dao->atualizar($id_rotina, $nome, $descricao);
        echo json_encode(["mensagem" => "Rotina atualizada com sucesso!"]);
        break;

    case "marcarAtiva":
        $id_rotina = $dados["id_rotina"] ?? "";
        $id_usuario = $dados["id_usuario"] ?? "";

        $dao->marcarAtiva($id_rotina, $id_usuario);
        echo json_encode(["mensagem" => "Rotina marcada como ativa!"]);
        break;

    case "excluir":
        $id_rotina = $dados["id_rotina"] ?? "";
        $dao->excluir($id_rotina);
        echo json_encode(["mensagem" => "Rotina excluída com sucesso!"]);
        break;

    default:
        http_response_code(400);
        echo json_encode(["erro" => "Acao invalida."]);
        break;
}