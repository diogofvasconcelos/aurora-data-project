# Requisito 01 - Semana 1 - Repositório, Banco de Dados e Infraestrutura

## Contexto do desafio

Todos os grupos deverão resolver o mesmo problema técnico.

A empresa fictícia **Rede Comercial Aurora** precisa de um sistema para consultar e analisar seu desempenho comercial. A parte de negócio já está definida pelo professor. Os alunos não deverão criar problema de negócio, KPIs ou regras gerenciais próprias.

O trabalho dos grupos será técnico: projetar a estrutura de dados, criar a infraestrutura, implementar consultas, desenvolver a aplicação, testar e documentar.

O sistema deverá trabalhar apenas com dados comerciais:

- filiais;
- produtos;
- categorias de produtos;
- clientes, se o grupo considerar necessário;
- vendas;
- itens de venda;
- datas ou períodos.

O escopo deve permanecer comercial, concentrado em faturamento, receita, vendas, produtos, categorias e filiais.

## Objetivo geral do projeto

Construir uma solução técnica que permita consultar, filtrar, calcular e apresentar indicadores comerciais da Rede Comercial Aurora a partir de uma base de dados estruturada.

O foco da disciplina é **Projeto de Sistemas**. Portanto, os grupos serão avaliados pela capacidade de transformar requisitos definidos em uma solução técnica organizada, executável e documentada.

## Entregas serão feitas pelo Git

Todas as entregas do projeto deverão ser realizadas pelo repositório Git do grupo.

Na primeira semana, o grupo deve:

- criar um repositório Git para o projeto;
- adicionar todos os integrantes como colaboradores;
- compartilhar o acesso com o professor;
- manter o projeto atualizado nesse repositório;
- realizar todas as entregas futuras pelo mesmo repositório.

O professor avaliará o conteúdo entregue a partir do repositório.

## Perguntas de negócio obrigatórias

A solução técnica deverá permitir responder, ao final do projeto, às 5 perguntas abaixo:

1. Qual foi o faturamento total por mês?
2. Quais filiais tiveram maior receita líquida no período analisado?
3. Quais categorias de produto geraram maior receita líquida?
4. Quais produtos tiveram maior quantidade vendida?
5. Como a margem bruta varia por mês, filial e categoria?

Essas perguntas são obrigatórias. Os grupos não devem substituir por outras perguntas de negócio.

## Indicadores obrigatórios

Os grupos deverão preparar a base de dados para calcular os indicadores abaixo. Estes indicadores são obrigatórios e não devem ser substituídos.

### 1. Faturamento bruto

- O que mede: valor total vendido antes de descontos.
- Fórmula: `quantidade_vendida * preco_unitario`.
- Esperado: mostrar o volume financeiro total das vendas realizadas.

### 2. Desconto total

- O que mede: valor total concedido em descontos.
- Fórmula: soma dos descontos aplicados nas vendas.
- Esperado: permitir avaliar quanto do faturamento bruto foi reduzido por descontos.

### 3. Receita líquida

- O que mede: valor efetivo obtido após descontos.
- Fórmula: `faturamento_bruto - desconto_total`.
- Esperado: mostrar a receita real gerada pelas vendas.

### 4. Custo total

- O que mede: custo dos produtos vendidos.
- Fórmula: `quantidade_vendida * custo_unitario`.
- Esperado: permitir calcular a margem das vendas.

### 5. Margem bruta

- O que mede: resultado financeiro antes de despesas operacionais.
- Fórmula: `receita_liquida - custo_total`.
- Esperado: indicar quanto sobra após descontar o custo dos produtos vendidos.

### 6. Margem bruta percentual

- O que mede: percentual de margem sobre a receita líquida.
- Fórmula: `(margem_bruta / receita_liquida) * 100`.
- Esperado: permitir comparar rentabilidade entre meses, filiais e categorias.

### 7. Quantidade vendida

- O que mede: volume de unidades vendidas.
- Fórmula: soma da quantidade vendida.
- Esperado: identificar produtos e categorias com maior saída comercial.

### 8. Ticket médio

- O que mede: valor médio por venda.
- Fórmula: `receita_liquida / quantidade_de_vendas`.
- Esperado: indicar se as vendas estão concentradas em valores médios maiores ou menores.

## Filtros obrigatórios

A solução final deverá permitir filtrar os dados por:

- período;
- filial;
- produto;
- categoria.

O grupo pode criar filtros adicionais, mas esses são obrigatórios.

## Entrega técnica obrigatória da semana 1

Na primeira semana, o grupo deve entregar pelo repositório Git:

### 1. Repositório criado e compartilhado

O repositório deve conter:

- README inicial;
- integrantes do grupo;
- descrição resumida do projeto;
- instruções iniciais de execução;
- estrutura inicial de pastas.

### 2. Estrutura inicial de pastas

Sugestão mínima:

```text
projeto/
├─ db/
│  ├─ init/
│  │  └─ cria_banco.sql
│  └─ docs/
│     └─ modelo_banco.md
├─ infra/
│  └─ docker/
│     ├─ docker-compose.yml
│     └─ README.md
├─ docs/
│  ├─ requisitos_tecnicos.md
│  └─ entregas.md
└─ README.md
```

O grupo pode adaptar a estrutura, desde que documente a escolha.

### 3. Modelo técnico do banco de dados

O grupo deve entregar a estrutura do banco pensada para responder às 5 perguntas de negócio.

O modelo deve conter, no mínimo:

- tabela de filiais;
- tabela de categorias;
- tabela de produtos;
- tabela de vendas;
- tabela de itens de venda;
- tabela de calendário ou campo de data suficiente para análises por período.

Para cada tabela, documentar:

- nome da tabela;
- finalidade técnica;
- campos;
- tipos de dados;
- chave primária;
- chaves estrangeiras;
- relacionamentos;
- observações importantes.

### 4. Código para criar o container e o SGBD

O grupo deve entregar os arquivos necessários para subir o banco em Docker.

Requisitos mínimos:

- uso de PostgreSQL com SGBD;
- arquivo `docker-compose.yml` ou comando Docker documentado `dockerfile`;
- nome do container;
- nome do banco;
- usuário;
- senha;
- porta exposta;
- instrução clara de execução.

### 5. Script SQL inicial

O grupo deve entregar um script SQL que crie a estrutura inicial do banco.

O script deve conter:

- criação das tabelas;
- definição de chaves primárias;
- definição de chaves estrangeiras;
- tipos de dados adequados;
- inserção de uma pequena massa de dados de teste;
- consultas simples para validar se as tabelas foram criadas corretamente.

Não é necessário ter todos os dados finais na semana 1, mas o banco deve estar tecnicamente preparado para evoluir.

## Critérios de avaliação

O professor avaliará se:

1. o repositório Git foi criado e compartilhado;
2. a entrega foi feita pelo repositório;
3. a estrutura de pastas está organizada;
4. o modelo do banco responde às 5 perguntas de negócio;
5. as tabelas possuem chaves e relacionamentos coerentes;
6. o Docker cria o container do SGBD;
7. o script SQL executa sem erro;
8. a documentação técnica explica como reproduzir o ambiente.

## O que não será aceito

- entrega fora do Git;
- repositório sem acesso para o professor;
- banco sem relacionamento entre tabelas;
- ausência de Docker ou instrução equivalente aprovada;
- script SQL que não executa;
- indicadores inventados pelo grupo;
- inclusão de temas fora do escopo comercial obrigatório;
- mudança do problema comercial definido;
- documentação técnica incompleta.

## Resumo da entrega

Na semana 1, o grupo deve entregar o repositório Git, a estrutura inicial do projeto, o modelo técnico do banco comercial, o Docker do SGBD e o script SQL inicial para criar a base.
