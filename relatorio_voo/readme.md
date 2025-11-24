# Relatório de Voos em ABAP (SCARR, SPFLI, SFLIGHT)

Este relatório exibe informações de voos com base nas tabelas SCARR, SPFLI e SFLIGHT.  
Os dados são combinados por meio de um SELECT com INNERJOIN e apresentados em uma tabela ALV.

---

## Funcionalidades

- Filtro por companhia aérea (CARRID)
- Filtro por número de conexão (CONNID)
- Combinação de tabelas (SCARR / SPFLI / SFLIGHT)
- Exibição final via ALV (CL_SALV_TABLE_)

---

## Objetivo

Demonstrar a montagem de um relatório de voos utilizando o INNER JOIN entre tabelas padrão do SAP e exibição via ALV com layout simples e funcional.
