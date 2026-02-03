Projeto: Banco de Dados – Oficina Mecânica

  1. Contexto do Negócio:
    - Este projeto tem como objetivo modelar e implementar um banco de dados relacional
      para o contexto de uma oficina mecânica. O sistema controla clientes, veículos,
      ordens de serviço, mecânicos, serviços executados e peças utilizadas.
  
  2. Funcionalidades:
    - O banco de dados representa o funcionamento de uma oficina mecânica, responsável por:
    - Cadastrar clientes e seus veículos
    - Registrar ordens de serviço
    - Controlar serviços realizados
    - Gerenciar peças utilizadas
    - Acompanhar mecânicos responsáveis
    - Cada Ordem de Serviço (OS) pode conter vários serviços e várias peças, e cada serviço é executado por um mecânico.
    - Consultas SQL com JOIN, GROUP BY, HAVING e atributos derivados
     
  3. Estrutura do Banco:
      - Cliente
      - Veículo
      - Mecânico
      - Ordem de Serviço
      - Serviço
      - Peça
  
  4. Esquema Lógico (Modelo Relacional):
    - CLIENTE:
      - id_cliente (PK)
      - nome
      - telefone
      - email

     - VEICULO:
        - id_veiculo (PK)
        - placa
        - modelo
        - ano
        - id_cliente (FK)

      - MECANICO:
          - id_mecanico (PK)
          - nome
          - especialidade

      - ORDEM_SERVICO:
          - id_os (PK)
          - data_abertura
          - status
          - id_veiculo (FK)

      - SERVICO:
          - id_servico (PK)
          - descricao
          - valor_mao_obra

      - OS_SERVICO:
          - id_os (FK, PK)
          - id_servico (FK, PK)
          - id_mecanico (FK)
            
       - PECA:
          - id_peca (PK)
          - descricao
          - valor_unitario

        - OS_PECA:
          - id_os (FK, PK)
         
   5. Tecnologias:
      - MySQL
      - SQL
id_peca (FK, PK)

quantidade
