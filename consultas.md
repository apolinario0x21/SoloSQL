
# CONSULTAS.md (Documentação das Principais Consultas)

## Exemplos de Consultas Básicas
1. Top 5 Caçadores por Poder
    ```sql
    SELECT c.nome, c.nivel, rc.pontos_poder
    FROM Cacadores c
    JOIN RegistrosCacador rc ON c.id_cacador = rc.fk_idCacador
    ORDER BY rc.pontos_poder DESC
    LIMIT 5;
    ```

2. Missões por Guildas e Status
   ```sql
   SELECT 
       g.nome AS Guilda,
       m.nivel AS Rank_Missao,
       m.titulo AS Missao,
       m.status,
       COUNT(mm.fk_idMonstro) AS Qtd_Monstros
    FROM Guildas g
    JOIN Portais p ON g.id_guilda = p.fk_idGuilda
    JOIN Missoes m ON p.id_portal = m.fk_idPortal
    LEFT JOIN MissaoMonstros mm ON m.id_missao = mm.fk_idMissao
    GROUP BY g.nome, m.titulo, m.nivel, m.status
    ORDER BY g.nome, m.nivel;
    ```

## Exemplos de Consultas Avançadas
3. Progressão de Caçadores (com crescimento estimado)

    ```sql
    SELECT 
        c.nome,
        c.nivel,
        rc.pontos_poder,
        rc.ultima_atualizacao,
        ROUND(rc.pontos_poder * rc.taxa_crescimento/100, 2) AS progresso_diario_estimado,
        CASE
            WHEN rc.taxa_crescimento > 20 THEN 'Crescimento Rápido'
            WHEN rc.taxa_crescimento BETWEEN 10 AND 20 THEN 'Crescimento Moderado'
            ELSE 'Crescimento Lento'
        END AS taxa_crescimento_categoria
    FROM Cacadores c
    JOIN RegistrosCacador rc ON c.id_cacador = rc.fk_idCacador
    ORDER BY progresso_diario_estimado DESC;
    ```

4. Análise de Recompensas por Guilda
   ```sql
   SELECT 
       g.nome AS Guilda,
       COUNT(DISTINCT m.id_missao) AS Total_Missoes,
       SUM(r.valor) AS Total_Recompensas,
       AVG(r.valor) AS Media_Recompensa,
       MAX(r.valor) AS Maior_Recompensa,
       MIN(r.valor) AS Menor_Recompensa
    FROM Guildas g
    JOIN Portais p ON g.id_guilda = p.fk_idGuilda
    JOIN Missoes m ON p.id_portal = m.fk_idPortal
    JOIN Recompensas r ON m.id_missao = r.fk_idMissao
    GROUP BY g.nome
    ORDER BY Total_Recompensas DESC;
    ```

## Exemplo de Consultas para Relatórios
5. Relatório Completo de Caçadores
    ```sql
    SELECT 
        c.nome,
        c.nivel AS Rank,
        c.tipo AS Classe,
        rc.pontos_poder,
        COUNT(DISTINCT ch.fk_idHabilidade) AS Qtd_Habilidades,
        COUNT(DISTINCT r.id_recompensa) AS Missoes_Concluidas,
        SUM(r.valor) AS Total_Ganho
    FROM Cacadores c
    JOIN RegistrosCacador rc ON c.id_cacador = rc.fk_idCacador
    LEFT JOIN CacadorHabilidades ch ON c.id_cacador = ch.fk_idCacador
    LEFT JOIN Recompensas r ON c.id_cacador = r.fk_idCacador AND r.status = 'Pago'
    GROUP BY c.id_cacador, c.nome, c.nivel, c.tipo, rc.pontos_poder
    ORDER BY rc.pontos_poder DESC;
    ```

6. Análise de Monstros por Tipo e Rank

    ```sql
    SELECT 
        tipo AS Tipo_Monstro,
        nivel AS Rank,
        COUNT(*) AS Quantidade,
        AVG(pontos_experiencia) AS XP_Medio,
        SUM(pontos_experiencia) AS XP_Total
    FROM Monstros
    GROUP BY tipo, nivel
    ORDER BY nivel, tipo;
    ```

## Views Úteis
7. View: Caçadores com Habilidades

    ```sql
    CREATE VIEW vw_cacadores_habilidades AS
    SELECT 
        c.nome AS Caçador,
        c.nivel AS Rank,
        GROUP_CONCAT(h.nome SEPARATOR ', ') AS Habilidades,
        COUNT(h.id_habilidade) AS Qtd_Habilidades
    FROM Cacadores c
    LEFT JOIN CacadorHabilidades ch ON c.id_cacador = ch.fk_idCacador
    LEFT JOIN Habilidades h ON ch.fk_idHabilidade = h.id_habilidade
    GROUP BY c.id_cacador, c.nome, c.nivel;
    ```

8. View: Missões Pendentes
    
   ```sql
    CREATE VIEW vw_missoes_pendentes AS
    SELECT 
        m.titulo AS Missao,
        m.nivel AS Rank,
        g.nome AS Guilda,
        p.nome AS Portal,
        m.recompensa_total AS Recompensa,
        DATEDIFF(m.data_conclusao, CURDATE()) AS Dias_Restantes
    FROM Missoes m
    JOIN Portais p ON m.fk_idPortal = p.id_portal
    JOIN Guildas g ON p.fk_idGuilda = g.id_guilda
    WHERE m.status = 'Ativa'
    ORDER BY m.nivel, Dias_Restantes;
    ```