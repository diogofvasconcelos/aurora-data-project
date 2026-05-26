# Requisito 03 - Semana 3 - Aplicação e Visualizações

## Contexto

Na semana 2, o grupo preparou dados comerciais, consultas e acesso técnico ao banco.

Na semana 3, o grupo deve transformar esses dados em uma aplicação utilizável. A solução deve permitir que um usuário consulte indicadores, aplique filtros e visualize respostas para as 5 perguntas de negócio.

O foco continua sendo técnico. O grupo deve implementar a solução usando as regras comerciais e indicadores já definidos.

## Objetivo da semana

Ao final da semana, o grupo deve ter uma versão funcional parcial da aplicação, com:

- acesso ao banco;
- filtros funcionando;
- indicadores calculados;
- visualizações ou relatórios;
- documentação de execução.

## Entrega pelo Git

Todas as alterações devem ser feitas no repositório do projeto.

O professor avaliará a entrega a partir do estado do repositório na data combinada.

## Funcionalidades obrigatórias

A aplicação deve permitir:

1. abrir uma tela, página, dashboard, relatório ou interface principal;
2. carregar dados a partir do banco;
3. exibir indicadores obrigatórios;
4. aplicar filtros;
5. atualizar resultados após aplicação dos filtros;
6. apresentar visualizações compreensíveis;
7. lidar com ausência de dados ou erro de conexão de forma minimamente clara.

## Indicadores mínimos da semana

Nesta semana, a aplicação deve apresentar pelo menos 6 indicadores entre os obrigatórios:

- faturamento bruto;
- desconto total;
- receita líquida;
- custo total;
- margem bruta;
- margem bruta percentual;
- quantidade vendida;
- ticket médio.

Os cálculos devem seguir as fórmulas definidas no Requisito 01.

## Visualizações obrigatórias

A aplicação deve apresentar pelo menos 4 visualizações.

As visualizações podem ser gráficos, tabelas analíticas, rankings ou relatórios, desde que sejam úteis e atualizadas pelos filtros.

Visualizações mínimas esperadas:

### 1. Faturamento mensal

Deve mostrar a evolução do faturamento bruto ou da receita líquida ao longo dos meses.

### 2. Comparação por filial

Deve mostrar diferenças entre filiais, por exemplo receita líquida, faturamento bruto ou margem bruta.

### 3. Análise por categoria

Deve mostrar desempenho comercial por categoria de produto.

### 4. Produtos mais vendidos

Deve apresentar ranking de produtos por quantidade vendida ou receita líquida.

## Filtros obrigatórios na aplicação

A aplicação deve permitir filtrar, no mínimo, por:

- período;
- filial;
- categoria;
- produto.

Os filtros devem afetar os indicadores e as visualizações.

## O que se espera ver funcionando

Durante a avaliação, o professor deverá conseguir:

1. executar a aplicação seguindo o README;
2. abrir a interface principal;
3. visualizar os indicadores;
4. aplicar um filtro de período;
5. aplicar um filtro de filial;
6. aplicar um filtro de categoria;
7. aplicar um filtro de produto;
8. perceber alteração nos resultados;
9. identificar produtos, categorias e filiais com melhor desempenho comercial.

## Validação técnica obrigatória

O grupo deve entregar um arquivo Markdown com testes realizados.

Para cada teste, informar:

- objetivo do teste;
- passos executados;
- resultado esperado;
- resultado obtido;
- evidência, quando possível;
- problema encontrado, se houver.

Testes mínimos:

- execução do container;
- criação do banco;
- execução do script SQL;
- conexão da aplicação com o banco;
- cálculo de pelo menos 3 indicadores;
- aplicação de pelo menos 2 filtros;
- abertura da interface principal.

## Critérios de avaliação

O professor avaliará se:

1. a aplicação executa;
2. os dados vêm do banco;
3. os indicadores seguem as fórmulas obrigatórias;
4. os filtros alteram os resultados;
5. as visualizações respondem às 5 perguntas de negócio;
6. a aplicação possui organização técnica coerente;
7. os testes foram documentados;
8. a entrega está no Git.

## O que não será aceito

- tela estática sem conexão com banco;
- valores digitados manualmente na interface;
- indicadores calculados fora das fórmulas definidas;
- filtros apenas decorativos;
- inclusão de temas fora do escopo comercial obrigatório;
- ausência de instrução de execução;
- falta de evidência de testes;
- entrega fora do repositório.

## Resumo da entrega

Na semana 3, o grupo deve entregar uma versão funcional parcial da aplicação com indicadores comerciais, filtros, visualizações e validação técnica documentada.
