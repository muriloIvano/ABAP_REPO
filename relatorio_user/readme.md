# Resumo do Programa ABAP – Z02EST_REL_USER

Este relatório apresenta uma lista de usuários SAP com informações detalhadas, incluindo bloqueio, validade, data de criação e último logon.  
Também permite abrir diretamente a transação **SU01D** ao clicar no nome do usuário (hotspot).

---

## 🧩 Funcionalidades Principais

### 1. Seleção de Usuários
O programa permite filtrar usuários através do campo **BNAME** usando `SELECT-OPTIONS`.

---

### 2. Consulta de Dados
O relatório busca informações das seguintes tabelas:

- **USR02** – Dados gerais do usuário  
- **USR21** – Associação do usuário com número de pessoa  
- **ADRP** – Nome completo do usuário

Campos retornados no ALV:

- Código do usuário (BNAME)  
- Nome completo  
- Validade inicial/final (GLTGV / GLTGB)  
- Indicador de bloqueio (UFLAG)  
- Criado por  
- Data de criação  
- Último logon  

---

## 🎨 Regras de Destaque (Coloração)

O relatório aplica cores automaticamente conforme duas regras:

### 🔴 Usuário bloqueado  
A coluna **UFLAG** é destacada.

### 🔴 Validade expirada  
As colunas **GLTGV** e **GLTGB** são destacadas quando o usuário está fora do período válido.

---

## 📊 ALV Interativo (CL_SALV_TABLE)

O ALV possui:

- Ajuste automático de colunas  
- Funções padrões habilitadas  
- Linhas com padrão listrado  
- Coloração via campo **COLOR**  
- Coluna **BNAME** configurada como **hotspot**

### 🔗 Ação de clique (Hotspot)
Ao clicar sobre o usuário:

- O sistema define o parâmetro `XUS`  
- Abre automaticamente a transação **SU01D**

---

## 🧱 Fluxo do Programa

1. **QUERY**  
   Realiza o SELECT com JOINs nas tabelas USR02, USR21 e ADRP.

2. **BEFORE_OUTPUT**  
   Avalia bloqueio e validade, aplicando cores a cada linha.

3. **OUTPUT**  
   Constrói o ALV, ativa eventos e exibe o relatório.

---

## 🎯 Objetivo

Fornecer ao administrador uma visualização clara da situação atual dos usuários SAP, destacando bloqueios e contas expiradas, além de permitir acesso rápido ao SU01D.

