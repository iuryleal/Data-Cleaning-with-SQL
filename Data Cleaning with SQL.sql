-- TRATANDO dCLIENTES --
SELECT 
	UPPER(NomeCliente) AS NomeCliente,
    UPPER(UltimoNomeContato) AS UltimoNomeContato,
    UPPER(PrimeiroNomeContato) AS PrimeiroNomeContato,
    CASE WHEN Sexo = "F"
		THEN "FEMININO"
        WHEN Sexo = "M"
        THEN "MASCULINO"
	END AS Sexo,
    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Telefone, ".", ""), "(", ""), ")", ""), "+", ""), "-", ""), " ", "") AS Telefone1,
    UPPER(Endereco) AS Endereco,
    UPPER(COALESCE(Complemento, "NAO INFORMADO")) AS Complemento,
    UPPER(Cidade) AS Cidade,
    CASE WHEN Estado = "SÃO PAULO"
		THEN "SP"
        WHEN Estado = "RIO DE JANEIRO"
        THEN "RJ"
        WHEN Estado = "PERNAMBUCO"
        THEN "PE"
        ELSE UPPER(COALESCE(Estado, "NAO INFORMADO")) 
        END AS Estado,
    COALESCE(NULLIF(CEP, " "), "-1") AS CEP,
    UPPER(CASE WHEN Pais = "EUA"
		THEN "Estados Unidos"
        ELSE Pais
	END) AS Pais,    
    COALESCE(NumeroEmpregadoVendedor, -1) AS NumeroEmpregadoVendedor,
    LimiteCredito
FROM clientes;

-- TRATANDO detalhespedidos -- 

-- Checando se há algum valor nulos em alguma das colunas
SELECT *
FROM detalhespedidos
WHERE NumeroPedido IS NULL
OR NumeroLinhaPedido IS NULL
OR CodigoProduto IS NULL
OR QuantidadePedida IS NULL
OR PrecoUnitario IS NULL;

-- PADRONIZANDO QTD CASAS DECIMAIS DA COLUNA "PrecoUnitario"
ALTER TABLE detalhespedidos
MODIFY COLUMN PrecoUnitario DECIMAL(10,2);

SELECT *
FROM detalhespedidos;
-- TRATANDO empregados --

SELECT
	NumeroEmpregado,
    UPPER(UltimoNome) AS UltimoNome,
    UPPER(PrimeiroNome) AS PrimeiroNome,
    REPLACE(Ramal, "x", "") AS Ramal,
    UPPER(CorreioEletronico) AS CorreioEletronico,
    CodigoEscritorio,
    COALESCE(SeReportaPara, -1) AS SeReportaPara,
    UPPER(Cargo) AS Cargo
FROM empregados;

-- TRATANDO ESCRITORIOS --
SELECT
	CodigoEscritorio,
    UPPER(Cidade) AS Cidade,
    REPLACE(Telefone, " ", "") AS Telefone,
    UPPER(Endereco) AS Endereco,
    UPPER(COALESCE(Complemento, "NAO INFORMADO")) AS Complemento,
    UPPER(COALESCE(NULLIF(Estado, " "), "NAO INFORMADO")) AS Estado,
    UPPER(Pais) AS Pais,
    REPLACE(REPLACE(CEP, "-", ""), " ", "") AS CEP,
    UPPER(Territorio) AS Territorio
FROM escritorios;


-- TRATANDO PAGAMENTOS --
-- PADRONIZADO QTD CASAS DECIMAIS DA COLUNA "ValorPago" --
ALTER TABLE pagamentos
MODIFY COLUMN ValorPago DECIMAL(10,2);

SELECT
	NumeroCliente AS NumeroCliente,
    NumeroVerificacao AS NumeroVerificacao,
    DATE_FORMAT(DataPagamento, "%d/%m/%Y") AS DataPagamento,
    ValorPago AS ValorPago
FROM pagamentos;

-- TRATANDO PEDIDOS --
SELECT
	NumeroPedido AS NumeroPedido,
    DATE_FORMAT(DataPedido, "%d/%m/%Y") AS DataPedido,
	CASE WHEN Situacao = "AGUARDANDO" AND DataEntrega IS NULL
		THEN COALESCE(DataEntrega, "AGUARDANDO")
		WHEN Situacao = "CANCELADO" AND DataEntrega IS NULL
        THEN COALESCE(DataEntrega, "01/01/1900")
        WHEN DataEntrega IS NULL
        THEN "NAO INFORMADO"
        ELSE DATE_FORMAT(DataEntrega, "%d/%m/%Y")
		END AS DataEntrega,
    UPPER(Situacao) AS Situacao,
    UPPER(COALESCE(Comentario, "SEM COMENTÁRIO")) AS Comentario,
    NumeroCliente AS NumeroCliente
FROM pedidos;

-- TRANTADO PRODUTOS -- 
-- PADRONIZANDO CASAS DECIMAIS DA COLUNA "PrecoCompra" --
ALTER TABLE produtos
MODIFY COLUMN PrecoCompra DECIMAL(10,2);

SELECT
	CodigoProduto AS CodigoProduto,
    UPPER(NomeProduto) AS Produto,
    UPPER(CASE WHEN NomeLinha = "CARROS VINTAGE" OR NomeLinha = "CARROS CLÁSSICOS"
		THEN "CARROS"
        ELSE NomeLinha
        END) AS CategoriaLinha,
    UPPER(NomeLinha) AS SubCategoriaLinha,
    UPPER(NomeFornecedor) AS Fornecedor,
    QuantidadeEstoque AS QuantidadeEstoque,
    PrecoCompra AS PrecoCompra
FROM produtos;