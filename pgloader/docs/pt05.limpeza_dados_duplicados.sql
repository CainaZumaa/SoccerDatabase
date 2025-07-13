-- Script para limpar dados duplicados das tabelas originais após normalização
-- Remove dados que foram extraídos para as tabelas normalizadas

-- ========================================
-- 1. LIMPEZA DA TABELA MATCH (PRINCIPAL)
-- ========================================

-- 1.1 Remover colunas de odds (já estão em match_odds)
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS b365h;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS b365d;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS b365a;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS bwh;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS bwd;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS bwa;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS iwh;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS iwd;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS iwa;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS lbh;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS lbd;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS lba;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS psh;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS psd;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS psa;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS whh;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS whd;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS wha;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS sjh;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS sjd;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS sja;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS vch;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS vcd;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS vca;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS gbh;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS gbd;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS gba;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS bsh;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS bsd;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS bsa;

-- 1.2 Remover colunas de eventos (já estão em match_events)
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS goal;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS shoton;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS shotoff;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS foulcommit;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS card;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS "cross";
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS corner;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS possession;

-- 1.3 Remover colunas de jogadores (já estão em match_players)
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS home_player_1;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS home_player_2;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS home_player_3;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS home_player_4;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS home_player_5;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS home_player_6;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS home_player_7;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS home_player_8;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS home_player_9;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS home_player_10;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS home_player_11;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS away_player_1;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS away_player_2;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS away_player_3;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS away_player_4;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS away_player_5;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS away_player_6;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS away_player_7;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS away_player_8;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS away_player_9;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS away_player_10;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS away_player_11;

-- 1.4 Remover colunas de posições X dos jogadores (já estão em match_players)
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS home_player_x1;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS home_player_x2;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS home_player_x3;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS home_player_x4;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS home_player_x5;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS home_player_x6;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS home_player_x7;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS home_player_x8;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS home_player_x9;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS home_player_x10;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS home_player_x11;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS away_player_x1;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS away_player_x2;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS away_player_x3;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS away_player_x4;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS away_player_x5;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS away_player_x6;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS away_player_x7;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS away_player_x8;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS away_player_x9;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS away_player_x10;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS away_player_x11;

-- 1.5 Remover colunas de posições Y dos jogadores (já estão em match_players)
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS home_player_y1;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS home_player_y2;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS home_player_y3;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS home_player_y4;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS home_player_y5;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS home_player_y6;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS home_player_y7;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS home_player_y8;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS home_player_y9;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS home_player_y10;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS home_player_y11;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS away_player_y1;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS away_player_y2;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS away_player_y3;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS away_player_y4;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS away_player_y5;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS away_player_y6;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS away_player_y7;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS away_player_y8;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS away_player_y9;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS away_player_y10;
ALTER TABLE campeonato.match DROP COLUMN IF EXISTS away_player_y11;

-- ========================================
-- 2. VERIFICAÇÃO PÓS-LIMPEZA
-- ========================================

-- 2.1 Verificar quantas colunas restaram na tabela match
SELECT 'COLUNAS RESTANTES na MATCH' as verificacao,
       COUNT(*) as total_colunas
FROM information_schema.columns 
WHERE table_schema = 'campeonato' AND table_name = 'match';

-- 2.2 Verificar se os dados ainda estão nas tabelas normalizadas
SELECT 'DADOS NORMALIZADOS' as verificacao,
       (SELECT COUNT(*) FROM campeonato.season) as total_seasons,
       (SELECT COUNT(*) FROM campeonato.venue) as total_venues,
       (SELECT COUNT(*) FROM campeonato.match_odds) as total_odds,
       (SELECT COUNT(*) FROM campeonato.match_events) as total_events,
       (SELECT COUNT(*) FROM campeonato.match_players) as total_players;

-- ========================================
-- 3. OBSERVAÇÕES IMPORTANTES
-- ========================================

/*
OBSERVAÇÕES:

1. A coluna 'season' da tabela match foi MANTIDA para compatibilidade
   - Pode ser usada como referência para a tabela season normalizada
   - Não foi removida para evitar quebrar consultas existentes

2. Tabelas player_attributes e team_attributes:
   - Contêm dados de datas que podem ser relacionados com seasons
   - Não foram modificadas pois não há duplicação direta
   - Podem ser normalizadas futuramente se necessário

3. Tabela team:
   - Não foi modificada pois não há duplicação direta com venue
   - Os dados de venue foram criados baseados em team_long_name
   - Não há colunas duplicadas para remover

4. Tabelas country, league, player:
   - Não foram modificadas pois não há duplicação
   - São tabelas de referência mantidas intactas

RESULTADO:
"verificacao"	       "total_seasons"	"total_venues"	   "total_odds"	 "total_events"	 "total_players"
"DADOS NORMALIZADOS"	           8	         282	         166793	          41149         	468813
*/  