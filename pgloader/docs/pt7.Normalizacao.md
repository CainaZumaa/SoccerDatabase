# Normalização da Base de Dados de Futebol

## Visão Geral

Este documento descreve o processo de normalização realizado na base de dados de futebol, transformando de 7 tabelas originais para 12 tabelas normalizadas.

## Estrutura Original (7 Tabelas)

1. **country** - Países
2. **league** - Ligas  
3. **team** - Times
4. **player** - Jogadores
5. **player_attributes** - Atributos dos jogadores
6. **team_attributes** - Atributos dos times
7. **match** - Partidas (tabela principal com dados desnormalizados)

## Estrutura Normalizada (12 Tabelas)

### Tabelas Mantidas (7)
1. **country** - Países
2. **league** - Ligas
3. **team** - Times
4. **player** - Jogadores
5. **player_attributes** - Atributos dos jogadores
6. **team_attributes** - Atributos dos times
7. **match** - Partidas (mantida para compatibilidade)

### Novas Tabelas Normalizadas (5)
8. **season** - Normalização de temporadas
9. **venue** - Normalização de estádios/localidades
10. **match_players** - Normalização de jogadores por partida (1NF)
11. **match_events** - Normalização de eventos da partida (1NF)
12. **match_odds** - Normalização de odds de apostas (1NF)

## Processo de Normalização

### Passo 1: Análise da Base Original
- Identificação de dados desnormalizados na tabela `match`
- Análise de relacionamentos e dependências
- Mapeamento de chaves primárias e estrangeiras

### Passo 2: Criação das Novas Tabelas
```sql
-- 8. SEASON - Normalizar temporadas
CREATE TABLE campeonato.season (
    id SERIAL PRIMARY KEY,
    season_name VARCHAR(20) NOT NULL UNIQUE,
    year_start INTEGER,
    year_end INTEGER
);

-- 9. VENUE - Normalizar estádios/localidades
CREATE TABLE campeonato.venue (
    id SERIAL PRIMARY KEY,
    venue_name VARCHAR(200) NOT NULL,
    city VARCHAR(100),
    country_id INTEGER REFERENCES country(id)
);

-- 10. MATCH_PLAYERS - Normalizar jogadores por partida (1NF)
CREATE TABLE campeonato.match_players (
    id SERIAL PRIMARY KEY,
    match_id INTEGER REFERENCES match(id),
    team_id INTEGER REFERENCES team(id),
    player_id INTEGER REFERENCES player(id),
    position_x INTEGER,
    position_y INTEGER,
    player_number INTEGER,
    is_home BOOLEAN NOT NULL,
    UNIQUE(match_id, player_id)
);

-- 11. MATCH_EVENTS - Normalizar eventos da partida (1NF)
CREATE TABLE campeonato.match_events (
    id SERIAL PRIMARY KEY,
    match_id INTEGER REFERENCES match(id),
    event_type VARCHAR(50) NOT NULL,
    minute INTEGER,
    description TEXT,
    player_id INTEGER REFERENCES player(id),
    team_id INTEGER REFERENCES team(id)
);

-- 12. MATCH_ODDS - Normalizar odds de apostas (1NF)
CREATE TABLE campeonato.match_odds (
    id SERIAL PRIMARY KEY,
    match_id INTEGER REFERENCES match(id),
    bookmaker VARCHAR(10) NOT NULL,
    home_odds NUMERIC(5,2),
    draw_odds NUMERIC(5,2),
    away_odds NUMERIC(5,2),
    UNIQUE(match_id, bookmaker)
);
```

### Passo 3: Migração de Dados

#### 3.1 População da Tabela SEASON
```sql
INSERT INTO campeonato.season (season_name, year_start, year_end)
SELECT DISTINCT 
    season,
    CAST(SUBSTRING(season, 1, 4) AS INTEGER) AS year_start,
    CAST(SUBSTRING(season, 6, 4) AS INTEGER) AS year_end
FROM campeonato.match 
WHERE season IS NOT NULL
ORDER BY season;
```

#### 3.2 População da Tabela VENUE
```sql
INSERT INTO campeonato.venue (venue_name, city, country_id)
SELECT DISTINCT 
    'Estádio ' || t.team_long_name as venue_name,
    'Cidade ' || t.team_long_name as city,
    l.country_id
FROM campeonato.team t
JOIN campeonato.match m ON m.home_team_api_id = t.team_api_id
JOIN campeonato.league l ON l.id = m.league_id
WHERE t.team_long_name IS NOT NULL;
```

#### 3.3 População da Tabela MATCH_PLAYERS
```sql
-- Jogadores do time da casa
INSERT INTO campeonato.match_players (match_id, team_id, player_id, position_x, position_y, player_number, is_home)
SELECT DISTINCT
    m.id AS match_id,
    ht.id AS team_id,
    p.id AS player_id,
    m.home_player_x1 AS position_x,
    m.home_player_y1 AS position_y,
    1 AS player_number,
    TRUE AS is_home
FROM campeonato.match m
JOIN campeonato.team ht ON ht.team_api_id = m.home_team_api_id
JOIN campeonato.player p ON p.player_api_id = m.home_player_1
WHERE m.home_player_1 IS NOT NULL
-- Repetir para jogadores 2-11...
```

#### 3.4 População da Tabela MATCH_ODDS
```sql
INSERT INTO campeonato.match_odds (match_id, bookmaker, home_odds, draw_odds, away_odds)
SELECT id, 'B365', b365h, b365d, b365a FROM campeonato.match WHERE b365h IS NOT NULL
UNION ALL
SELECT id, 'BW', bwh, bwd, bwa FROM campeonato.match WHERE bwh IS NOT NULL
-- Repetir para outros bookmakers...
```

### Passo 4: Criação de Índices
```sql
-- Índices para foreign keys
CREATE INDEX idx_league_country_id ON campeonato.league(country_id);
CREATE INDEX idx_match_country_id ON campeonato.match(country_id);
-- ... outros índices para performance
```

## Benefícios da Normalização

### 1. Eliminação de Redundância
- Dados de temporadas não são mais repetidos
- Informações de estádios centralizadas
- Odds organizadas por bookmaker

### 2. Integridade Referencial
- Foreign keys garantem consistência
- Constraints evitam dados inválidos
- Relacionamentos bem definidos

### 3. Flexibilidade para Consultas
- Consultas mais eficientes
- Agregações simplificadas
- Análises temporais facilitadas

### 4. Manutenibilidade
- Estrutura mais clara
- Modificações isoladas
- Menor acoplamento entre tabelas

## Estrutura Final

```
campeonato/
├── country (1)
├── league (2) → country
├── team (3)
├── player (4)
├── player_attributes (5) → player
├── team_attributes (6) → team
├── season (7)
├── venue (8) → country
├── match (9) → country, league
├── match_players (10) → match, team, player
├── match_events (11) → match, player, team
└── match_odds (12) → match
```

## Scripts Disponíveis

- `maquina1/relacional.sql` - DDL completo das 12 tabelas
- Scripts de migração de dados (executados manualmente)
- Índices para otimização de performance

## Próximos Passos

1. **Limpeza de Dados**: Remover colunas desnormalizadas da tabela `match`
2. **Views**: Criar views para consultas complexas
3. **Procedures**: Desenvolver procedures para operações comuns
4. **Triggers**: Implementar triggers para manutenção automática
5. **Documentação**: Atualizar documentação de API e consultas 