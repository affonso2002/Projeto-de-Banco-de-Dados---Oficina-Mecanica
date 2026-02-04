-- Quais clientes estão cadastrados?
      SELECT nome, telefone FROM Cliente;

-- Quais ordens estão finalizadas?
      SELECT * 
      FROM Ordem_Servico
      WHERE status = 'Finalizada';

-- Qual o valor total gasto com peças em cada OS?
      SELECT 
          os.id_os,
          SUM(p.valor_unitario * op.quantidade) AS total_pecas
      FROM Ordem_Servico os
      JOIN OS_Peca op ON os.id_os = op.id_os
      JOIN Peca p ON op.id_peca = p.id_peca
      GROUP BY os.id_os;

-- Quais serviços ordenados pelo valor da mão de obra?
      SELECT descricao, valor_mao_obra
      FROM Servico
      ORDER BY valor_mao_obra DESC;

-- Quais ordens tiveram gasto com peças acima de R$200?
      SELECT 
          os.id_os,
          SUM(p.valor_unitario * op.quantidade) AS total
      FROM Ordem_Servico os
      JOIN OS_Peca op ON os.id_os = op.id_os
      JOIN Peca p ON op.id_peca = p.id_peca
      GROUP BY os.id_os
      HAVING total > 200;

-- Quais serviços foram realizados, por qual mecânico e para qual cliente?
      SELECT 
          c.nome AS cliente,
          v.modelo AS veiculo,
          s.descricao AS servico,
          m.nome AS mecanico
      FROM Ordem_Servico os
      JOIN Veiculo v ON os.id_veiculo = v.id_veiculo
      JOIN Cliente c ON v.id_cliente = c.id_cliente
      JOIN OS_Servico oss ON os.id_os = oss.id_os
      JOIN Servico s ON oss.id_servico = s.id_servico
      JOIN Mecanico m ON oss.id_mecanico = m.id_mecanico;

-- Qual o valor total de cada OS considerando serviços e peças?
      SELECT 
          os.id_os,
          COALESCE(SUM(DISTINCT s.valor_mao_obra), 0) +
          COALESCE(SUM(p.valor_unitario * op.quantidade), 0) AS valor_total
      FROM Ordem_Servico os
      LEFT JOIN OS_Servico oss ON os.id_os = oss.id_os
      LEFT JOIN Servico s ON oss.id_servico = s.id_servico
      LEFT JOIN OS_Peca op ON os.id_os = op.id_os
      LEFT JOIN Peca p ON op.id_peca = p.id_peca
      GROUP BY os.id_os;

-- As ordens são de baixo, médio ou alto custo?
      SELECT 
          os.id_os,
          SUM(p.valor_unitario * op.quantidade) AS total_pecas,
      CASE
        WHEN SUM(p.valor_unitario * op.quantidade) < 100 THEN 'Baixo custo'
        WHEN SUM(p.valor_unitario * op.quantidade) BETWEEN 100 AND 300 THEN 'Custo médio'
        ELSE 'Alto custo'
      END AS classificacao
      FROM Ordem_Servico os
      JOIN OS_Peca op ON os.id_os = op.id_os
      JOIN Peca p ON op.id_peca = p.id_peca
      GROUP BY os.id_os;

-- Quais mecânicos ainda não participaram de nenhuma OS?
      SELECT m.nome
      FROM Mecanico m
      WHERE NOT EXISTS (
          SELECT 1
          FROM OS_Servico os
          WHERE os.id_mecanico = m.id_mecanico
      );
-- Quais clientes têm mais de um veículo cadastrado?
      SELECT 
          c.nome,
          COUNT(v.id_veiculo) AS qtd_veiculos
      FROM Cliente c
      JOIN Veiculo v ON c.id_cliente = v.id_cliente
      GROUP BY c.id_cliente
      HAVING COUNT(v.id_veiculo) > 1;

-- Qual foi o serviço de maior valor em cada OS?
      SELECT 
          os.id_os,
          s.descricao,
          s.valor_mao_obra
      FROM OS_Servico oss
      JOIN Servico s ON oss.id_servico = s.id_servico
      JOIN Ordem_Servico os ON oss.id_os = os.id_os
      WHERE s.valor_mao_obra = (
            SELECT MAX(s2.valor_mao_obra)
            FROM OS_Servico oss2
            JOIN Servico s2 ON oss2.id_servico = s2.id_servico
            WHERE oss2.id_os = oss.id_os
      );

-- Qual o ranking de mecânicos mais ativos?
     SELECT 
          m.nome,
          COUNT(oss.id_servico) AS total_servicos,
          RANK() OVER (ORDER BY COUNT(oss.id_servico) DESC) AS ranking
     FROM Mecanico m
     LEFT JOIN OS_Servico oss ON m.id_mecanico = oss.id_mecanico
     GROUP BY m.id_mecanico;

-- Qual a média de gasto com peças por OS?
      SELECT 
          AVG(total_pecas) AS media_gasto_pecas
      FROM (
          SELECT 
              os.id_os,
              SUM(p.valor_unitario * op.quantidade) AS total_pecas
          FROM Ordem_Servico os
          JOIN OS_Peca op ON os.id_os = op.id_os
          JOIN Peca p ON op.id_peca = p.id_peca
          GROUP BY os.id_os
       ) AS subquery;

-- Quais ordens estão abertas há mais de 30 dias?
     SELECT 
          id_os,
          data_abertura,
          DATEDIFF(CURDATE(), data_abertura) AS dias_aberta
     FROM Ordem_Servico
     WHERE status <> 'Finalizada'
     AND DATEDIFF(CURDATE(), data_abertura) > 30;

-- Quais serviços nunca foram executados?
    SELECT s.descricao
    FROM Servico s
    LEFT JOIN OS_Servico oss ON s.id_servico = oss.id_servico
    WHERE oss.id_servico IS NULL;

-- Quais clientes têm gasto total acima da média?
    SELECT 
          c.nome,
          SUM(p.valor_unitario * op.quantidade) AS gasto_total
    FROM Cliente c
    JOIN Veiculo v ON c.id_cliente = v.id_cliente
    JOIN Ordem_Servico os ON v.id_veiculo = os.id_veiculo
    JOIN OS_Peca op ON os.id_os = op.id_os
    JOIN Peca p ON op.id_peca = p.id_peca
    GROUP BY c.id_cliente
    HAVING gasto_total > (
          SELECT AVG(total)
          FROM (
              SELECT SUM(p2.valor_unitario * op2.quantidade) AS total
              FROM Ordem_Servico os2
              JOIN OS_Peca op2 ON os2.id_os = op2.id_os
              JOIN Peca p2 ON op2.id_peca = p2.id_peca
              GROUP BY os2.id_os
           ) AS media
      );

-- Quanto cada cliente já gerou de faturamento?
     SELECT 
          c.nome,
          SUM(s.valor_mao_obra) + SUM(p.valor_unitario * op.quantidade) AS faturamento
     FROM Cliente c
     JOIN Veiculo v ON c.id_cliente = v.id_cliente
     JOIN Ordem_Servico os ON v.id_veiculo = os.id_veiculo
     LEFT JOIN OS_Servico oss ON os.id_os = oss.id_os
     LEFT JOIN Servico s ON oss.id_servico = s.id_servico
     LEFT JOIN OS_Peca op ON os.id_os = op.id_os
     LEFT JOIN Peca p ON op.id_peca = p.id_peca
     GROUP BY c.id_cliente
     ORDER BY faturamento DESC;

-- Lista unificada de clientes e mecânicos (relatório geral)?
     SELECT nome, 'Cliente' AS tipo
     FROM Cliente
     UNION
     SELECT nome, 'Mecânico' AS tipo
     FROM Mecanico;

