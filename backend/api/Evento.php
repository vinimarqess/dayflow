<?php
error_reporting(0);
ini_set('display_errors', 0);

include __DIR__ . "/../dao/EventoDAO.php";

header("Content-type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

$dao = new EventoDAO();
$acao = $_GET["acao"] ?? "";
$dados = json_decode(file_get_contents("php://input"), true);

switch ($acao) {

    case "inserir":
        $nome = $dados["nome"] ?? "";
        $descricao  = $dados["descricao"] ?? "";
        $data = $dados["data"] ?? "";
        $hora = $dados["hora"] ?? "";
        $alarme = $dados["alarme"] ?? null;
        $id_usuario = $dados["id_usuario"] ?? "";

        if (trim($nome) == "" || trim($data) == "" || trim($hora) == "") {
            http_response_code(400);
            echo json_encode(["erro" => "Preencha os campos obrigatórios."]);
            break;
        }

        $dao->inserir($nome, $descricao, $data, $hora, $alarme, $id_usuario);
        echo json_encode(["mensagem" => "Evento criado com sucesso!"]);
        break;
        
    case "atualizar":
        $id_evento = $dados["id_evento"] ?? "";
        $nome  = $dados["nome"] ?? "";
        $descricao = $dados["descricao"] ?? "";
        $data = $dados["data"] ?? "";
        $hora = $dados["hora"] ?? "";
        $alarme = $dados["alarme"] ?? null;

        $dao->atualizar($id_evento, $nome, $descricao, $data, $hora, $alarme);
        echo json_encode(["mensagem" => "Evento atualizado com sucesso!"]);
        break;

    case "listar":
        $id_usuario = $dados["id_usuario"] ?? $_GET["id_usuario"] ?? "";
        $eventos = $dao->listarPorUsuario($id_usuario);
        echo json_encode($eventos);
        break;

    case "excluir":
        $id_evento = $dados["id_evento"] ?? "";
        $dao->excluir($id_evento);
        echo json_encode(["mensagem" => "Evento excluído com sucesso!"]);
        break;

    default:
        http_response_code(400);
        echo json_encode(["erro" => "Acao invalida."]);
        break;
}