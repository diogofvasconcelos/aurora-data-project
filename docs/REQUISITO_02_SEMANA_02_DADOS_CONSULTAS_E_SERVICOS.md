# Requisito 02 - Semana 2 - Dados, Consultas e Serviços

## Contexto

Na semana 1, o grupo criou o repositório, iniciou a infraestrutura e modelou o banco de dados comercial.

Na semana 2, o grupo deve evoluir a solução técnica para carregar dados mais completos, criar consultas que respondam às 5 perguntas definidas e iniciar a camada de acesso aos dados.

O grupo não deve alterar os objetivos de negócio. Os indicadores, perguntas e filtros obrigatórios já foram definidos no Requisito 01.

## Objetivo da semana

Ao final da semana, o grupo deve ter:

- banco executando em Docker;
- tabelas criadas;
- massa de dados suficiente para testes;
- consultas SQL para responder às perguntas de negócio;
- estrutura inicial da aplicação ou serviço que acessará os dados.

## Entrega pelo Git

Todas as alterações devem estar no repositório Git compartilhado com o professor.

O professor poderá verificar:

- histórico de commits;
- arquivos entregues;
- instruções de execução;
- evolução entre as semanas.

## Massa de dados obrigatória

O grupo deve ampliar os dados de teste para permitir análise realista.

A base deve conter, no mínimo:

- 5 filiais;
- 20 produtos;
- 5 categorias;
- vendas em pelo menos 6 meses diferentes;
- pelo menos 100 vendas;
- itens de venda vinculados às vendas;
- produtos com custos e preços diferentes;
- vendas com descontos;
- vendas em diferentes filiais;
- vendas em diferentes categorias.

Os dados podem ser fictícios, mas devem ser coerentes.

## Consultas obrigatórias

O grupo deve criar consultas SQL para responder às perguntas abaixo.

### 1. Faturamento total por mês

Deve retornar:

- mês;
- faturamento bruto;
- desconto total;
- receita líquida;
- quantidade vendida;
- quantidade de vendas.

### 2. Receita líquida por filial

Deve retornar:

- filial;
- faturamento bruto;
- desconto total;
- receita líquida;
- custo total;
- margem bruta;
- margem bruta percentual.

### 3. Receita líquida por categoria

Deve retornar:

- categoria;
- quantidade vendida;
- faturamento bruto;
- receita líquida;
- margem bruta;
- margem bruta percentual.

### 4. Produtos mais vendidos

Deve retornar:

- produto;
- categoria;
- quantidade vendida;
- faturamento bruto;
- receita líquida.

### 5. Margem bruta por mês, filial e categoria

Deve retornar:

- mês;
- filial;
- categoria;
- receita líquida;
- custo total;
- margem bruta;
- margem bruta percentual.

## Filtros técnicos obrigatórios

As consultas ou serviços devem permitir aplicação dos seguintes filtros:

- período inicial e período final;
- filial;
- produto;
- categoria.

Os filtros devem alterar os resultados. Não serão aceitos filtros apenas visuais ou sem impacto real nos dados.

## Camada técnica de acesso aos dados

O grupo deve iniciar a estrutura que permitirá a aplicação consultar o banco.

A tecnologia é livre, mas deve existir separação entre:

- configuração de conexão;
- execução de consultas;
- regras de preparação dos dados;
- interface ou ponto de uso.

Exemplos aceitáveis:

- backend web;
- API;
- aplicação desktop;
- script organizado em camadas;
- dashboard com camada de dados separada;
- outra solução justificada.

## Documentação técnica obrigatória

O grupo deve entregar Markdown explicando:

- como subir o banco;
- como executar o script SQL;
- quais tabelas existem;
- quais consultas foram criadas;
- quais indicadores cada consulta calcula;
- como aplicar filtros;
- como executar a primeira versão da aplicação ou serviço.

## Critérios de avaliação

O professor avaliará se:

1. o banco executa em Docker;
2. a massa de dados é suficiente para testar os indicadores;
3. as 5 consultas obrigatórias existem;
4. as fórmulas dos indicadores foram aplicadas corretamente;
5. os filtros funcionam nas consultas;
6. a estrutura técnica separa acesso a dados e uso da aplicação;
7. a documentação permite reproduzir a entrega;
8. a entrega está no Git.

## O que não será aceito

- consultas sem relação com os indicadores obrigatórios;
- dados insuficientes para validar os resultados;
- filtros que não alteram a consulta;
- cálculo incorreto dos indicadores definidos;
- inclusão de temas fora do escopo comercial obrigatório;
- acesso ao banco sem organização mínima;
- entrega fora do repositório;
- alteração das regras de negócio.

## Resumo da entrega

Na semana 2, o grupo deve entregar dados comerciais mais completos, 5 consultas SQL obrigatórias, filtros técnicos funcionando e a estrutura inicial de acesso aos dados da solução.
