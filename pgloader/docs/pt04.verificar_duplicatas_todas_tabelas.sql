-- Script para verificar duplicações em TODAS as tabelas originais vs normalizadas
-- Executar no pgAdmin

-- ========================================
-- RESUMO GERAL - TODAS AS TABELAS
-- ========================================

SELECT 'RESUMO GERAL' as verificacao,
       (SELECT COUNT(*) FROM campeonato.country) as country,
       (SELECT COUNT(*) FROM campeonato.league) as league,
       (SELECT COUNT(*) FROM campeonato.team) as team,
       (SELECT COUNT(*) FROM campeonato.player) as player,
       (SELECT COUNT(*) FROM campeonato.player_attributes) as player_attributes,
       (SELECT COUNT(*) FROM campeonato.team_attributes) as team_attributes,
       (SELECT COUNT(*) FROM campeonato.match) as match;

-- ========================================
-- 1. VERIFICAÇÃO DA TABELA MATCH (PRINCIPAL)
-- ========================================

-- 1.1 Dados de season na tabela match
SELECT 'MATCH - SEASON' as verificacao, 
       COUNT(DISTINCT season) as seasons_na_match,
       (SELECT COUNT(*) FROM campeonato.season) as seasons_normalizadas
FROM campeonato.match 
WHERE season IS NOT NULL;

-- 1.2 Dados de odds na tabela match
SELECT 'MATCH - ODDS' as verificacao,
       COUNT(*) as matches_com_odds_na_match,
       (SELECT COUNT(DISTINCT match_id) FROM campeonato.match_odds) as matches_com_odds_normalizadas
FROM campeonato.match 
WHERE b365h IS NOT NULL OR bwh IS NOT NULL OR iwh IS NOT NULL;

-- 1.3 Dados de eventos na tabela match
SELECT 'MATCH - EVENTOS' as verificacao,
       COUNT(*) as matches_com_eventos_na_match,
       (SELECT COUNT(DISTINCT match_id) FROM campeonato.match_events) as matches_com_eventos_normalizadas
FROM campeonato.match 
WHERE goal IS NOT NULL OR shoton IS NOT NULL OR shotoff IS NOT NULL;

-- 1.4 Dados de jogadores na tabela match
SELECT 'MATCH - JOGADORES' as verificacao,
       COUNT(*) as matches_com_jogadores_na_match,
       (SELECT COUNT(DISTINCT match_id) FROM campeonato.match_players) as matches_com_jogadores_normalizadas
FROM campeonato.match 
WHERE home_player_1 IS NOT NULL OR away_player_1 IS NOT NULL;

-- ========================================
-- 2. VERIFICAÇÃO DA TABELA TEAM
-- ========================================

-- 2.1 Dados de venue/estádio na tabela team
SELECT 'TEAM - VENUE' as verificacao,
       COUNT(*) as total_teams,
       (SELECT COUNT(*) FROM campeonato.venue) as total_venues,
       'Verificar se team_long_name foi usado para criar venues' as observacao;

-- ========================================
-- 3. VERIFICAÇÃO DAS TABELAS DE ATRIBUTOS
-- ========================================

-- 3.1 Player attributes - verificar se há dados de season
SELECT 'PLAYER_ATTRIBUTES - SEASON' as verificacao,
       COUNT(*) as total_player_attributes,
       'Verificar se há coluna season ou data que pode ser normalizada' as observacao
FROM campeonato.player_attributes;

-- 3.2 Team attributes - verificar se há dados de season
SELECT 'TEAM_ATTRIBUTES - SEASON' as verificacao,
       COUNT(*) as total_team_attributes,
       'Verificar se há coluna season ou data que pode ser normalizada' as observacao
FROM campeonato.team_attributes;

-- ========================================
-- 4. VERIFICAÇÃO DAS TABELAS NORMALIZADAS
-- ========================================

-- 4.1 Season
SELECT 'SEASON normalizada' as verificacao,
       COUNT(*) as total_seasons,
       STRING_AGG(season_name, ', ' ORDER BY season_name) as seasons
FROM campeonato.season;

-- 4.2 Venue
SELECT 'VENUE normalizada' as verificacao,
       COUNT(*) as total_venues,
       COUNT(DISTINCT country_id) as paises_diferentes
FROM campeonato.venue;

-- 4.3 Match players
SELECT 'MATCH_PLAYERS normalizada' as verificacao,
       COUNT(*) as total_players,
       COUNT(DISTINCT match_id) as matches_com_jogadores,
       COUNT(DISTINCT player_id) as jogadores_unicos,
       COUNT(DISTINCT team_id) as times_unicos
FROM campeonato.match_players;

-- 4.4 Match events
SELECT 'MATCH_EVENTS normalizada' as verificacao,
       COUNT(*) as total_events,
       COUNT(DISTINCT match_id) as matches_com_eventos,
       COUNT(DISTINCT event_type) as tipos_eventos
FROM campeonato.match_events;

-- 4.5 Match odds
SELECT 'MATCH_ODDS normalizada' as verificacao,
       COUNT(*) as total_odds,
       COUNT(DISTINCT match_id) as matches_com_odds,
       COUNT(DISTINCT bookmaker) as total_bookmakers,
       STRING_AGG(DISTINCT bookmaker, ', ' ORDER BY bookmaker) as bookmakers
FROM campeonato.match_odds;

-- ========================================
-- 5. ANÁLISE DE DUPLICAÇÕES ESPECÍFICAS
-- ========================================

-- 5.1 Verificar se team_long_name foi usado para criar venues
SELECT 'TEAM vs VENUE' as verificacao,
       COUNT(DISTINCT t.team_long_name) as teams_unicos,
       COUNT(DISTINCT v.venue_name) as venues_unicos,
       'Se venues foram criadas baseadas em team_long_name, pode haver duplicação' as observacao
FROM campeonato.team t
LEFT JOIN campeonato.venue v ON v.venue_name LIKE '%' || t.team_long_name || '%';

-- 5.2 Verificar se há dados de season em outras tabelas
SELECT 'SEASON em outras tabelas' as verificacao,
       'Verificar se player_attributes ou team_attributes têm dados de season que podem ser normalizados' as observacao;

-- ========================================
-- 6. RESUMO FINAL DE DUPLICAÇÕES
-- ========================================

SELECT 'DUPLICAÇÕES CONFIRMADAS' as tipo,
       'MATCH: season, odds, eventos, jogadores' as duplicacoes_match,
       'TEAM: possivelmente venue (estádios)' as duplicacoes_team,
       'PLAYER_ATTRIBUTES: possivelmente season' as duplicacoes_player_attr,
       'TEAM_ATTRIBUTES: possivelmente season' as duplicacoes_team_attr; 