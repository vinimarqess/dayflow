<?php
error_reporting(0);
ini_set('display_errors', 0);

include __DIR__ . "/../dao/HabitoDAO.php";

header("Content-type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

$dao   = new HabitoDAO();
$acao  = $_GET["acao"] ?? "";
$dados = json_decode(file_get_contents("php://input"), true);

switch ($acao) {

    case "inserir":
        $nome           = $dados["nome"] ?? "";
        $horario_inicio = $dados["horario_inicio"] ?? "";
        $horario_fim    = $dados["horario_fim"] ?? "";
        $id_diasemana   = $dados["id_diasemana"] ?? "";

        if (trim($nome) == "") {
            http_response_code(400);
            echo json_encode(["erro" => "Nome obrigatório."]);
            break;
        }

        $dao->inserir($nome, $horario_inicio, $horario_fim, $id_diasemana);
        echo json_encode(["mensagem" => "Hábito criado com sucesso!"]);
        break;

    case "listar":
        $id_diasemana = $_GET["id_diasemana"] ?? "";
        $habitos = $dao->listar($id_diasemana);
        echo json_encode($habitos);
        break;

    case "atualizar":
        $id_habito      = $dados["id_habito"] ?? "";
        $nome           = $dados["nome"] ?? "";
        $horario_inicio = $dados["horario_inicio"] ?? "";
        $horario_fim    = $dados["horario_fim"] ?? "";

        $dao->atualizar($id_habito, $nome, $horario_inicio, $horario_fim);
        echo json_encode(["mensagem" => "Hábito atualizado com sucesso!"]);
        break;

    case "atualizarStatus":
        $id_habito = $dados["id_habito"] ?? "";
        $concluido = $dados["concluido"] ?? 0;

        if ($id_habito != "") {
            $dao->atualizarStatus($id_habito, $concluido);
            echo json_encode(["mensagem" => "Status do hábito atualizado!"]);
        } else {
            http_response_code(400);
            echo json_encode(["erro" => "ID do hábito não informado."]);
        }
        break;

    case "excluir":
        $id_habito = $dados["id_habito"] ?? "";
        $dao->excluir($id_habito);
        echo json_encode(["mensagem" => "Hábito excluído com sucesso!"]);
        break;

    default:
        http_response_code(400);
        echo json_encode(["erro" => "Ação inválida."]);
        break;
}