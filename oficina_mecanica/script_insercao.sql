INSERT INTO Cliente VALUES
(NULL, 'João Silva', '99999-1111', 'joao@email.com'),
(NULL, 'Maria Santos', '98888-2222', 'maria@email.com');

INSERT INTO Veiculo VALUES
(NULL, 'ABC-1234', 'Gol', 2015, 1),
(NULL, 'XYZ-9876', 'Civic', 2020, 2);

INSERT INTO Mecanico VALUES
(NULL, 'Carlos', 'Motor'),
(NULL, 'André', 'Suspensão');

INSERT INTO Servico VALUES
(NULL, 'Troca de óleo', 120.00),
(NULL, 'Alinhamento', 150.00);

INSERT INTO Peca VALUES
(NULL, 'Filtro de óleo', 40.00),
(NULL, 'Óleo 5W30', 60.00);

INSERT INTO Ordem_Servico VALUES
(NULL, '2024-10-01', 'Finalizada', 1),
(NULL, '2024-10-02', 'Em andamento', 2);

INSERT INTO OS_Servico VALUES
(1, 1, 1),
(1, 2, 2);

INSERT INTO OS_Peca VALUES
(1, 1, 1),
(1, 2, 4);
