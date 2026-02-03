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


