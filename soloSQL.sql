
CREATE DATABASE IF NOT EXISTS SoloLevelingDB;
USE SoloLevelingDB;

CREATE TABLE IF NOT EXISTS Guildas (
    id_guilda INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    fundos_totais DECIMAL(15, 2) NOT NULL,
    nivel ENUM('S', 'A', 'B', 'C', 'D', 'E') NOT NULL,
    data_fundacao DATE,
    sede VARCHAR(100),
    INDEX idx_guilda_nivel (nivel)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Dungeons (
    id_dungeon INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    nivel ENUM('S', 'A', 'B', 'C', 'D', 'E') NOT NULL,
    tipo ENUM('Portal', 'Dungeon', 'Raide', 'Gate') NOT NULL,
    descricao TEXT,
    INDEX idx_dungeon_nivel (nivel)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Portais (
    id_portal INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    localizacao VARCHAR(255) NOT NULL,
    nivel ENUM('S', 'A', 'B', 'C', 'D', 'E') NOT NULL,
    fk_idGuilda INT NOT NULL,
    fk_idDungeon INT,
    data_abertura DATETIME NOT NULL,
    data_fechamento DATETIME,
    FOREIGN KEY(fk_idGuilda) REFERENCES Guildas(id_guilda),
    FOREIGN KEY(fk_idDungeon) REFERENCES Dungeons(id_dungeon),
    INDEX idx_portal_localizacao (localizacao),
    INDEX idx_portal_nivel (nivel)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Cacadores (
    id_cacador INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    cpf VARCHAR(11) UNIQUE NOT NULL,
    nome VARCHAR(30) NOT NULL, 
    endereco VARCHAR(255) NOT NULL,
    cidade VARCHAR(255) NOT NULL,
    nivel ENUM('S', 'A', 'B', 'C', 'D', 'E') NOT NULL,
    tipo ENUM('Atacante', 'Healer', 'Tank', 'Suporte', 'Arqueiro', 'Lutador') NOT NULL,
    data_registro DATE NOT NULL,
    status ENUM('Ativo', 'Inativo', 'Falecido', 'Desaparecido') NOT NULL DEFAULT 'Ativo',
    INDEX idx_cacador_nivel (nivel),
    INDEX idx_cacador_tipo (tipo)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Administradores (
    id_admin INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    cpf VARCHAR(11) UNIQUE NOT NULL,
    nome VARCHAR(30) NOT NULL,
    telefone VARCHAR(15) NOT NULL,
    data_contratacao DATE NOT NULL,
    cargo ENUM('Diretor', 'Gerente', 'Supervisor', 'Assistente') NOT NULL,
    fk_idSupervisor INT,
    status ENUM('Ativo', 'Inativo', 'Licenca') NOT NULL DEFAULT 'Ativo',
    FOREIGN KEY(fk_idSupervisor) REFERENCES Administradores(id_admin),
    INDEX idx_admin_cargo (cargo)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Dependentes (
    id_dependente INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    parentesco ENUM('Filho(a)', 'Conjuge', 'Pai', 'Mae', 'Outro') NOT NULL,
    data_nascimento DATE,
    fk_idAdmin INT NOT NULL,
    FOREIGN KEY (fk_idAdmin) REFERENCES Administradores(id_admin)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Habilidades (
    id_habilidade INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    descricao TEXT,
    tipo ENUM('Ataque', 'Defesa', 'Suporte', 'Passiva', 'Cura', 'Buff', 'Debuff') NOT NULL,
    nivel_minimo ENUM('S', 'A', 'B', 'C', 'D', 'E') NOT NULL,
    INDEX idx_habilidade_tipo (tipo)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Monstros (
    id_monstro INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    nivel ENUM('S', 'A', 'B', 'C', 'D', 'E') NOT NULL,
    tipo ENUM('Demon', 'Beast', 'Undead', 'Elemental', 'Humanoid', 'Boss') NOT NULL,
    pontos_experiencia INT NOT NULL,
    descricao TEXT,
    INDEX idx_monstro_nivel (nivel),
    INDEX idx_monstro_tipo (tipo)
) ENGINE=InnoDB;

-- =============================================
-- TABELAS DE RELACIONAMENTO
-- =============================================

-- Tabela de Registros de Caçador
CREATE TABLE IF NOT EXISTS RegistrosCacador (
    id_registro INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    numero_registro VARCHAR(45) UNIQUE NOT NULL,
    pontos_poder DECIMAL(15, 2) NOT NULL,
    ultima_atualizacao DATE NOT NULL,
    taxa_crescimento DECIMAL(5,2),
    limite_equipamento DECIMAL(15, 2),
    tipo ENUM('Ofensivo', 'Defensivo', 'Misto') NOT NULL,
    fk_idCacador INT NOT NULL,
    fk_idPortal INT NOT NULL,
    FOREIGN KEY (fk_idPortal) REFERENCES Portais(id_portal),
    FOREIGN KEY(fk_idCacador) REFERENCES Cacadores(id_cacador),
    INDEX idx_registro_poder (pontos_poder)
) ENGINE=InnoDB;

-- Tabela de Caçador-Habilidades
CREATE TABLE IF NOT EXISTS CacadorHabilidades (
    fk_idCacador INT NOT NULL,
    fk_idHabilidade INT NOT NULL,
    nivel_habilidade INT NOT NULL DEFAULT 1,
    data_aquisicao DATE NOT NULL,
    PRIMARY KEY (fk_idCacador, fk_idHabilidade),
    FOREIGN KEY(fk_idCacador) REFERENCES Cacadores(id_cacador),
    FOREIGN KEY(fk_idHabilidade) REFERENCES Habilidades(id_habilidade)
) ENGINE=InnoDB;

-- Tabela de Missões
CREATE TABLE IF NOT EXISTS Missoes (
    id_missao INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    titulo VARCHAR(100) NOT NULL,
    descricao TEXT,
    recompensa_total DECIMAL(15, 2) NOT NULL,
    duracao_dias INT NOT NULL,
    nivel ENUM('S', 'A', 'B', 'C', 'D', 'E') NOT NULL,
    status ENUM('Ativa', 'Concluída', 'Falha', 'Cancelada') NOT NULL DEFAULT 'Ativa',
    data_inicio DATE NOT NULL,
    data_conclusao DATE,
    fk_idPortal INT NOT NULL,
    FOREIGN KEY (fk_idPortal) REFERENCES Portais(id_portal),
    INDEX idx_missao_status (status),
    INDEX idx_missao_nivel (nivel)
) ENGINE=InnoDB;

-- Tabela de Missão-Monstros
CREATE TABLE IF NOT EXISTS MissaoMonstros (
    fk_idMissao INT NOT NULL,
    fk_idMonstro INT NOT NULL,
    quantidade INT NOT NULL DEFAULT 1,
    PRIMARY KEY (fk_idMissao, fk_idMonstro),
    FOREIGN KEY(fk_idMissao) REFERENCES Missoes(id_missao),
    FOREIGN KEY(fk_idMonstro) REFERENCES Monstros(id_monstro)
) ENGINE=InnoDB;

-- Tabela de Recompensas
CREATE TABLE IF NOT EXISTS Recompensas (
    id_recompensa INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    valor DECIMAL(15, 2) NOT NULL,
    data_pagamento DATE NOT NULL,
    status ENUM('Pendente', 'Pago', 'Cancelado') NOT NULL DEFAULT 'Pendente',
    metodo_pagamento ENUM('Dinheiro', 'Transferência', 'Item') NOT NULL,
    fk_idMissao INT NOT NULL,
    fk_idCacador INT NOT NULL,
    FOREIGN KEY(fk_idMissao) REFERENCES Missoes(id_missao),
    FOREIGN KEY(fk_idCacador) REFERENCES Cacadores(id_cacador),
    INDEX idx_recompensa_status (status)
) ENGINE=InnoDB;

-- Tabela de Caçador-Administrador
CREATE TABLE IF NOT EXISTS CacadorAdmin (
    fk_idAdmin INT NOT NULL,
    fk_idCacador INT NOT NULL,
    data_associacao DATE NOT NULL,
    tipo_associacao ENUM('Recrutamento', 'Controle', 'Treinamento') NOT NULL,
    PRIMARY KEY (fk_idAdmin, fk_idCacador),
    FOREIGN KEY(fk_idAdmin) REFERENCES Administradores(id_admin),
    FOREIGN KEY(fk_idCacador) REFERENCES Cacadores(id_cacador)
) ENGINE=InnoDB;

INSERT INTO Guildas (nome, fundos_totais, nivel, data_fundacao, sede) VALUES 
('White Tiger Guild', 1000000000.00, 'S', '2005-03-15', 'Seul'),
('Knights Guild', 750000000.00, 'A', '2008-07-22', 'Busan'),
('Scavenger Guild', 500000000.00, 'S', '2003-11-30', 'Incheon'),
('Hunters Guild', 300000000.00, 'B', '2010-05-18', 'Daegu');

INSERT INTO Dungeons (nome, nivel, tipo, descricao) VALUES 
('Dungeon of the Demon King', 'S', 'Dungeon', 'A masmorra mais perigosa já registrada'),
('Red Gate', 'A', 'Gate', 'Portal que apareceu durante o incidente de Jeju'),
('Tower of Trials', 'B', 'Raide', 'Torre com desafios progressivos'),
('Cemetery of the Undead', 'C', 'Dungeon', 'Masmorra repleta de mortos-vivos');

INSERT INTO Portais (nome, localizacao, nivel, fk_idGuilda, fk_idDungeon, data_abertura) VALUES 
('Jeju Island Gate', 'Jeju Island', 'S', 1, 1, '2023-01-15 08:00:00'),
('Seoul Red Gate', 'Gangnam, Seoul', 'A', 2, 2, '2023-02-20 14:30:00'),
('Training Portal', 'Hunter Training Center', 'B', 3, 3, '2023-03-10 09:15:00'),
('Cemetery Portal', 'Busan Outskirts', 'C', 4, 4, '2023-04-05 11:00:00');

INSERT INTO Cacadores (cpf, nome, endereco, cidade, nivel, tipo, data_registro, status) VALUES 
('12345678901', 'Sung Jin-Woo', '123 Hero Street', 'Seul', 'S', 'Atacante', '2018-05-10', 'Ativo'),
('23456789012', 'Cha Hae-In', '456 Sword Avenue', 'Busan', 'S', 'Atacante', '2017-08-15', 'Ativo'),
('34567890123', 'Yoo Jinho', '789 Shield Road', 'Incheon', 'C', 'Suporte', '2020-02-20', 'Ativo'),
('45678901234', 'Choi Jong-In', '321 Fire Lane', 'Daegu', 'A', 'Atacante', '2016-11-05', 'Ativo'),
('56789012345', 'Baek Yoonho', '654 Beast Street', 'Seul', 'A', 'Tank', '2019-04-30', 'Ativo');

INSERT INTO Administradores (cpf, nome, telefone, data_contratacao, cargo, fk_idSupervisor, status) VALUES 
('67890123456', 'Go Gunhee', '11987654321', '2010-05-15', 'Diretor', NULL, 'Ativo'),
('78901234567', 'Woo Jinchul', '11976543210', '2015-08-20', 'Gerente', 1, 'Ativo'),
('89012345678', 'Park Heejin', '11965432109', '2018-03-12', 'Supervisor', 2, 'Ativo');

INSERT INTO Dependentes (nome, parentesco, data_nascimento, fk_idAdmin) VALUES 
('Go Minji', 'Filho(a)', '2005-07-22', 1),
('Woo Seungri', 'Conjuge', '1985-11-30', 2),
('Park Jisoo', 'Filho(a)', '2010-04-15', 3);

INSERT INTO Habilidades (nome, descricao, tipo, nivel_minimo) VALUES 
('Shadow Extraction', 'Extrai sombras de inimigos derrotados', 'Ataque', 'S'),
('Ruler\'s Authority', 'Controle absoluto sobre as sombras', 'Buff', 'S'),
('Bloodlust', 'Aumento de dano em combate prolongado', 'Passiva', 'A'),
('Healing Light', 'Cura ferimentos de aliados', 'Cura', 'B'),
('Steel Defense', 'Aumenta defesa por 30 segundos', 'Defesa', 'C');

INSERT INTO Monstros (nome, nivel, tipo, pontos_experiencia, descricao) VALUES 
('Igris', 'S', 'Undead', 10000, 'General das sombras'),
('Iron', 'A', 'Demon', 5000, 'Demônio de ferro'),
('Cerberus', 'A', 'Beast', 6000, 'Cão de três cabeças'),
('Skeleton Soldier', 'C', 'Undead', 500, 'Soldado esqueleto comum');

INSERT INTO RegistrosCacador (numero_registro, pontos_poder, ultima_atualizacao, taxa_crescimento, limite_equipamento, tipo, fk_idCacador, fk_idPortal) VALUES 
('SL-001', 999999.99, '2023-10-01', 50.00, 1000000.00, 'Ofensivo', 1, 1),
('SL-002', 85000.00, '2023-09-28', 15.00, 200000.00, 'Ofensivo', 2, 2),
('SL-003', 15000.00, '2023-09-30', 5.00, 50000.00, 'Defensivo', 3, 3),
('SL-004', 45000.00, '2023-09-25', 10.00, 150000.00, 'Misto', 4, 4),
('SL-005', 35000.00, '2023-09-29', 8.00, 120000.00, 'Defensivo', 5, 1);

INSERT INTO CacadorHabilidades (fk_idCacador, fk_idHabilidade, nivel_habilidade, data_aquisicao) VALUES 
(1, 1, 5, '2023-01-15'),
(1, 2, 5, '2023-02-20'),
(2, 3, 4, '2022-11-10'),
(3, 4, 3, '2023-03-05'),
(4, 3, 3, '2023-04-12'),
(5, 5, 4, '2023-05-18');

INSERT INTO Missoes (titulo, descricao, recompensa_total, duracao_dias, nivel, status, data_inicio, fk_idPortal) VALUES 
('Jeju Island Cleanup', 'Eliminar todas as criaturas S-Rank na ilha', 3000000.00, 7, 'S', 'Concluída', '2023-06-01', 1),
('Red Gate Investigation', 'Investigar o portal vermelho em Seoul', 250000.00, 3, 'A', 'Concluída', '2023-07-15', 2),
('Training Session', 'Sessão de treino para caçadores C-Rank', 100000.00, 1, 'B', 'Ativa', '2023-10-01', 3),
('Undead Extermination', 'Eliminar mortos-vivos no cemitério', 150000.00, 2, 'C', 'Ativa', '2023-10-05', 4);

-- Inserção de Missão-Monstros
INSERT INTO MissaoMonstros (fk_idMissao, fk_idMonstro, quantidade) VALUES 
(1, 1, 1),
(1, 2, 5),
(2, 2, 3),
(3, 4, 20),
(4, 4, 30);

INSERT INTO Recompensas (valor, data_pagamento, status, metodo_pagamento, fk_idMissao, fk_idCacador) VALUES 
(1000000.00, '2023-06-08', 'Pago', 'Transferência', 1, 1),
(500000.00, '2023-06-08', 'Pago', 'Transferência', 1, 2),
(250000.00, '2023-07-18', 'Pago', 'Transferência', 2, 3),
(50000.00, '2023-10-02', 'Pendente', 'Dinheiro', 3, 4),
(75000.00, '2023-10-07', 'Pendente', 'Dinheiro', 4, 5);

-- Inserção de Caçador-Administrador
INSERT INTO CacadorAdmin (fk_idAdmin, fk_idCacador, data_associacao, tipo_associacao) VALUES 
(1, 1, '2023-01-10', 'Recrutamento'),
(2, 2, '2023-02-15', 'Controle'),
(3, 3, '2023-03-20', 'Treinamento'),
(2, 4, '2023-04-25', 'Controle'),
(3, 5, '2023-05-30', 'Treinamento');

-- =============================================
-- CONSULTAS EXEMPLO
-- =============================================

-- Top 5 Caçadores por Poder
SELECT c.nome, c.nivel, rc.pontos_poder
FROM Cacadores c
JOIN RegistrosCacador rc ON c.id_cacador = rc.fk_idCacador
ORDER BY rc.pontos_poder DESC
LIMIT 5;

-- Missões por Guildas
SELECT g.nome AS guilda, COUNT(m.id_missao) AS total_missoes
FROM Guildas g
LEFT JOIN Portais p ON g.id_guilda = p.fk_idGuilda
LEFT JOIN Missoes m ON p.id_portal = m.fk_idPortal
GROUP BY g.nome
ORDER BY total_missoes DESC;

-- Progressão de Caçadores
SELECT 
    c.nome,
    c.nivel,
    rc.pontos_poder,
    rc.ultima_atualizacao,
    ROUND(rc.pontos_poder * rc.taxa_crescimento/100, 2) AS progresso_diario_estimado
FROM Cacadores c
JOIN RegistrosCacador rc ON c.id_cacador = rc.fk_idCacador
WHERE rc.ultima_atualizacao >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
ORDER BY progresso_diario_estimado DESC;

-- Habilidades por Caçador
SELECT 
    c.nome AS cacador,
    h.nome AS habilidade,
    ch.nivel_habilidade,
    h.tipo
FROM Cacadores c
JOIN CacadorHabilidades ch ON c.id_cacador = ch.fk_idCacador
JOIN Habilidades h ON ch.fk_idHabilidade = h.id_habilidade
ORDER BY c.nome, ch.nivel_habilidade DESC;

-- Monstros por Missão
SELECT 
    m.titulo AS missao,
    mo.nome AS monstro,
    mo.nivel AS nivel_monstro,
    mm.quantidade
FROM Missoes m
JOIN MissaoMonstros mm ON m.id_missao = mm.fk_idMissao
JOIN Monstros mo ON mm.fk_idMonstro = mo.id_monstro
ORDER BY m.titulo, mo.nivel DESC;

select * from administradores;