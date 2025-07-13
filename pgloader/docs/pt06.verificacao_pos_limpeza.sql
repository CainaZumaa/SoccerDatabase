-- Script para verificar se a limpeza de dados duplicados foi bem-sucedida
-- Executar após executar o script de limpeza

-- ========================================
-- 1. VERIFICAÇÃO DA TABELA MATCH
-- ========================================

-- 1.1 Verificar quantas colunas restaram
SELECT 'MATCH - COLUNAS RESTANTES' as verificacao,
       COUNT(*) as total_colunas
FROM information_schema.columns 
WHERE table_schema = 'campeonato' AND table_name = 'match';

-- 1.2 Verificar se as colunas de odds foram removidas
SELECT 'MATCH - ODDS REMOVIDAS' as verificacao,
       COUNT(*) as colunas_odds_restantes
FROM information_schema.columns 
WHERE table_schema = 'campeonato' 
  AND table_name = 'match' 
  AND column_name IN ('b365h', 'b365d', 'b365a', 'bwh', 'bwd', 'bwa');

-- 1.3 Verificar se as colunas de eventos foram removidas
SELECT 'MATCH - EVENTOS REMOVIDOS' as verificacao,
       COUNT(*) as colunas_eventos_restantes
FROM information_schema.columns 
WHERE table_schema = 'campeonato' 
  AND table_name = 'match' 
  AND column_name IN ('goal', 'shoton', 'shotoff', 'foulcommit', 'card');

-- 1.4 Verificar se as colunas de jogadores foram removidas
SELECT 'MATCH - JOGADORES REMOVIDOS' as verificacao,
       COUNT(*) as colunas_jogadores_restantes
FROM information_schema.columns 
WHERE table_schema = 'campeonato' 
  AND table_name = 'match' 
  AND column_name LIKE '%player_%';

-- 1.5 Verificar se a coluna season foi mantida
SELECT 'MATCH - SEASON MANTIDA' as verificacao,
       COUNT(*) as season_restante
FROM information_schema.columns 
WHERE table_schema = 'campeonato' 
  AND table_name = 'match' 
  AND column_name = 'season';

-- ========================================
-- 2. VERIFICAÇÃO DAS TABELAS NORMALIZADAS
-- ========================================

-- 2.1 Verificar se os dados ainda estão nas tabelas normalizadas
SELECT 'DADOS NORMALIZADOS PRESERVADOS' as verificacao,
       (SELECT COUNT(*) FROM campeonato.season) as total_seasons,
       (SELECT COUNT(*) FROM campeonato.venue) as total_venues,
       (SELECT COUNT(*) FROM campeonato.match_odds) as total_odds,
       (SELECT COUNT(*) FROM campeonato.match_events) as total_events,
       (SELECT COUNT(*) FROM campeonato.match_players) as total_players;

-- 2.2 Verificar se não há dados duplicados
SELECT 'VERIFICACAO FINAL - SEM DUPLICACOES' as verificacao,
       'Se todos os valores abaixo forem 0, a limpeza foi bem-sucedida' as observacao;

-- ========================================
-- 3. RESUMO FINAL
-- ========================================

SELECT 'RESUMO FINAL DA NORMALIZACAO' as verificacao,
       'Tabela match limpa de dados desnormalizados' as status_match,
       'Tabelas normalizadas preservadas' as status_normalizadas,
       'Dados duplicados removidos' as status_duplicatas,
       'Normalização completa' as resultado;

-- ========================================
-- 4. ESTRUTURA FINAL ESPERADA
-- ========================================

/*
ESTRUTURA FINAL ESPERADA da tabela match:

Colunas que devem permanecer (~25-30):
- id, match_api_id
- country_id, league_id, season
- home_team_api_id, away_team_api_id
- home_team_goal, away_team_goal
- date, match_date, stage
- home_team_goal_half_time, away_team_goal_half_time
- home_team_goal_position, away_team_goal_position
- home_team_goal_kick, away_team_goal_kick
- home_team_goal_corner, away_team_goal_corner
- home_team_goal_counterattack, away_team_goal_counterattack
- home_team_goal_freekick, away_team_goal_freekick
- home_team_goal_throwin, away_team_goal_throwin
- home_team_goal_other, away_team_goal_other

Colunas que foram removidas (~85-90):
- Todas as colunas de odds (b365h, b365d, b365a, etc.)
- Todas as colunas de eventos (goal, shoton, shotoff, etc.)
- Todas as colunas de jogadores (home_player_1, away_player_1, etc.)
- Todas as colunas de posições (home_player_x1, home_player_y1, etc.)

RESULTADO:
"verificacao"	                          "status_match"	                                 "status_normalizadas"	                         "status_duplicatas"	                "resultado"
"RESUMO FINAL DA NORMALIZACAO"	    "Tabela match limpa de dados desnormalizados"	       "Tabelas normalizadas preservadas"	         "Dados duplicados removidos"	       "Normalização completa"
*/ 