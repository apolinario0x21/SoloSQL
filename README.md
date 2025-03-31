# SoloSQL Database Project

Um banco de dados relacional completo inspirado no universo de Solo Leveling, desenvolvido para fins educacionais de aprendizado de SQL e modelagem de dados.

## 📌 Aviso Legal
Este projeto é um banco de dados fictício criado para fins educacionais, inspirado no universo de Solo Leveling. Não possui afiliação oficial com os criadores de Solo Leveling ou detentores dos direitos autorais.

## 🗃️ Estrutura do Banco de Dados

### Diagrama ER
[arquivo pdf](https://github.com/apolinario0x21/SoloSQL/blob/main/soloSQL.pdf)

### Principais Tabelas

| Tabela               | Descrição                                  |
|----------------------|-------------------------------------------|
| `Guildas`            | Registro das guildas de caçadores         |
| `Cacadores`          | Cadastro de todos os caçadores            |
| `Portais`            | Locais de dungeons e gates                |
| `Missoes`            | Missões atribuídas aos caçadores          |
| `Habilidades`        | Habilidades especiais dos caçadores       |
| `Monstros`           | Catálogo de monstros e criaturas          |
| `Administradores`    | Equipe da Associação de Caçadores         |

### Relacionamentos Chave
- Um caçador possui um registro de poder (`RegistrosCacador`)
- Uma guilda controla vários portais (`Portais`)
- Missões são associadas a portais e monstros específicos
- Caçadores podem ter múltiplas habilidades (`CacadorHabilidades`)

## 🛠️ Configuração

1. Clone o repositório:
   ```bash
   git clone git@github.com:apolinario0x21/SoloSQL.git
    ```
2. Execute o script SQL no MySQL:
   ```bash
   mysql -u user -p < arquivo.sql
   ```

## 📊 Exemplos de Consultas
Veja [CONSULTAS.md](https://github.com/apolinario0x21/SoloSQL/blob/main/CONSULTAS.md) para exemplos práticos de consultas SQL.

