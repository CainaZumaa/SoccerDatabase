-- Create schema
CREATE SCHEMA IF NOT EXISTS campeonato;

-- Create sequences
CREATE SEQUENCE IF NOT EXISTS campeonato.country_id_seq;
CREATE SEQUENCE IF NOT EXISTS campeonato.league_id_seq;
CREATE SEQUENCE IF NOT EXISTS campeonato.match_id_seq;
CREATE SEQUENCE IF NOT EXISTS campeonato.match_events_id_seq;
CREATE SEQUENCE IF NOT EXISTS campeonato.match_odds_id_seq;
CREATE SEQUENCE IF NOT EXISTS campeonato.match_players_id_seq;
CREATE SEQUENCE IF NOT EXISTS campeonato.player_id_seq;
CREATE SEQUENCE IF NOT EXISTS campeonato.player_audit_log_id_seq;
CREATE SEQUENCE IF NOT EXISTS campeonato.season_id_seq;
CREATE SEQUENCE IF NOT EXISTS campeonato.team_match_counters_id_seq;
CREATE SEQUENCE IF NOT EXISTS campeonato.venue_id_seq;

-- Table: campeonato.country
CREATE TABLE IF NOT EXISTS campeonato.country
(
    id bigint NOT NULL DEFAULT nextval('campeonato.country_id_seq'::regclass),
    name text COLLATE pg_catalog."default",
    CONSTRAINT country_pkey PRIMARY KEY (id)
);

-- Table: campeonato.league
CREATE TABLE IF NOT EXISTS campeonato.league
(
    id bigint NOT NULL DEFAULT nextval('campeonato.league_id_seq'::regclass),
    country_id bigint,
    name text COLLATE pg_catalog."default",
    CONSTRAINT league_pkey PRIMARY KEY (id),
    CONSTRAINT league_country_id_fkey FOREIGN KEY (country_id)
        REFERENCES campeonato.country (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

-- Table: campeonato.season
CREATE TABLE IF NOT EXISTS campeonato.season
(
    id integer NOT NULL DEFAULT nextval('campeonato.season_id_seq'::regclass),
    season_name character varying(20) COLLATE pg_catalog."default" NOT NULL,
    year_start integer,
    year_end integer,
    CONSTRAINT season_pkey PRIMARY KEY (id),
    CONSTRAINT season_season_name_key UNIQUE (season_name)
);

-- Table: campeonato.team
CREATE TABLE IF NOT EXISTS campeonato.team
(
    id integer NOT NULL,
    team_api_id integer,
    team_fifa_api_id integer,
    team_long_name text COLLATE pg_catalog."default",
    team_short_name text COLLATE pg_catalog."default",
    CONSTRAINT team_pkey PRIMARY KEY (id)
);

-- Table: campeonato.player
CREATE TABLE IF NOT EXISTS campeonato.player
(
    id bigint NOT NULL DEFAULT nextval('campeonato.player_id_seq'::regclass),
    player_api_id bigint,
    player_name text COLLATE pg_catalog."default",
    player_fifa_api_id bigint,
    birthday text COLLATE pg_catalog."default",
    height real,
    weight bigint,
    CONSTRAINT player_pkey PRIMARY KEY (id)
);

-- Table: campeonato.match
CREATE TABLE IF NOT EXISTS campeonato.match
(
    id bigint NOT NULL DEFAULT nextval('campeonato.match_id_seq'::regclass),
    country_id bigint,
    league_id bigint,
    season text COLLATE pg_catalog."default",
    stage bigint,
    date text COLLATE pg_catalog."default",
    match_api_id bigint,
    home_team_api_id bigint,
    away_team_api_id bigint,
    home_team_goal bigint,
    away_team_goal bigint,
    CONSTRAINT match_pkey PRIMARY KEY (id),
    CONSTRAINT match_country_id_fkey FOREIGN KEY (country_id)
        REFERENCES campeonato.country (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT match_league_id_fkey FOREIGN KEY (league_id)
        REFERENCES campeonato.league (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

-- Table: campeonato.match_events
CREATE TABLE IF NOT EXISTS campeonato.match_events
(
    id integer NOT NULL DEFAULT nextval('campeonato.match_events_id_seq'::regclass),
    match_id bigint,
    event_type character varying(50) COLLATE pg_catalog."default" NOT NULL,
    minute integer,
    description text COLLATE pg_catalog."default",
    player_id bigint,
    team_id integer,
    CONSTRAINT match_events_pkey PRIMARY KEY (id),
    CONSTRAINT match_events_match_id_fkey FOREIGN KEY (match_id)
        REFERENCES campeonato.match (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT match_events_player_id_fkey FOREIGN KEY (player_id)
        REFERENCES campeonato.player (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT match_events_team_id_fkey FOREIGN KEY (team_id)
        REFERENCES campeonato.team (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

-- Table: campeonato.match_odds
CREATE TABLE IF NOT EXISTS campeonato.match_odds
(
    id integer NOT NULL DEFAULT nextval('campeonato.match_odds_id_seq'::regclass),
    match_id bigint,
    bookmaker character varying(10) COLLATE pg_catalog."default" NOT NULL,
    home_odds numeric(5,2),
    draw_odds numeric(5,2),
    away_odds numeric(5,2),
    CONSTRAINT match_odds_pkey PRIMARY KEY (id),
    CONSTRAINT match_odds_match_id_bookmaker_key UNIQUE (match_id, bookmaker),
    CONSTRAINT match_odds_match_id_fkey FOREIGN KEY (match_id)
        REFERENCES campeonato.match (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

-- Table: campeonato.match_players
CREATE TABLE IF NOT EXISTS campeonato.match_players
(
    id integer NOT NULL DEFAULT nextval('campeonato.match_players_id_seq'::regclass),
    match_id bigint,
    team_id integer,
    player_id bigint,
    position_x integer,
    position_y integer,
    player_number integer,
    is_home boolean NOT NULL,
    CONSTRAINT match_players_pkey PRIMARY KEY (id),
    CONSTRAINT match_players_match_id_player_id_key UNIQUE (match_id, player_id),
    CONSTRAINT match_players_match_id_fkey FOREIGN KEY (match_id)
        REFERENCES campeonato.match (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT match_players_player_id_fkey FOREIGN KEY (player_id)
        REFERENCES campeonato.player (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT match_players_team_id_fkey FOREIGN KEY (team_id)
        REFERENCES campeonato.team (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

-- Table: campeonato.player_attributes
CREATE TABLE IF NOT EXISTS campeonato.player_attributes
(
    id integer NOT NULL,
    player_fifa_api_id integer,
    player_api_id integer,
    date text COLLATE pg_catalog."default",
    overall_rating integer,
    potential integer,
    preferred_foot text COLLATE pg_catalog."default",
    attacking_work_rate text COLLATE pg_catalog."default",
    defensive_work_rate text COLLATE pg_catalog."default",
    crossing integer,
    finishing integer,
    heading_accuracy integer,
    short_passing integer,
    volleys integer,
    dribbling integer,
    curve integer,
    free_kick_accuracy integer,
    long_passing integer,
    ball_control integer,
    acceleration integer,
    sprint_speed integer,
    agility integer,
    reactions integer,
    balance integer,
    shot_power integer,
    jumping integer,
    stamina integer,
    strength integer,
    long_shots integer,
    aggression integer,
    interceptions integer,
    positioning integer,
    vision integer,
    penalties integer,
    marking integer,
    standing_tackle integer,
    sliding_tackle integer,
    gk_diving integer,
    gk_handling integer,
    gk_kicking integer,
    gk_positioning integer,
    gk_reflexes integer,
    CONSTRAINT player_attributes_pkey PRIMARY KEY (id)
);

-- Table: campeonato.player_audit_log
CREATE TABLE IF NOT EXISTS campeonato.player_audit_log
(
    id integer NOT NULL DEFAULT nextval('campeonato.player_audit_log_id_seq'::regclass),
    player_id bigint,
    player_name text COLLATE pg_catalog."default",
    operation_type character varying(10) COLLATE pg_catalog."default" NOT NULL,
    operation_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    user_name text COLLATE pg_catalog."default" DEFAULT CURRENT_USER,
    old_values jsonb,
    new_values jsonb,
    additional_info text COLLATE pg_catalog."default",
    CONSTRAINT player_audit_log_pkey PRIMARY KEY (id)
);

-- Table: campeonato.team_attributes
CREATE TABLE IF NOT EXISTS campeonato.team_attributes
(
    id integer NOT NULL,
    team_fifa_api_id integer,
    team_api_id integer,
    date text COLLATE pg_catalog."default",
    buildupplayspeed integer,
    buildupplayspeedclass text COLLATE pg_catalog."default",
    buildupplaydribbling integer,
    buildupplaydribblingclass text COLLATE pg_catalog."default",
    buildupplaypassing integer,
    buildupplaypassingclass text COLLATE pg_catalog."default",
    buildupplaypositioningclass text COLLATE pg_catalog."default",
    chancecreationpassing integer,
    chancecreationpassingclass text COLLATE pg_catalog."default",
    chancecreationcrossing integer,
    chancecreationcrossingclass text COLLATE pg_catalog."default",
    chancecreationshooting integer,
    chancecreationshootingclass text COLLATE pg_catalog."default",
    chancecreationpositioningclass text COLLATE pg_catalog."default",
    defencepressure integer,
    defencepressureclass text COLLATE pg_catalog."default",
    defenceaggression integer,
    defenceaggressionclass text COLLATE pg_catalog."default",
    defenceteamwidth integer,
    defenceteamwidthclass text COLLATE pg_catalog."default",
    defencedefenderlineclass text COLLATE pg_catalog."default",
    CONSTRAINT team_attributes_pkey PRIMARY KEY (id)
);

-- Table: campeonato.team_match_counters
CREATE TABLE IF NOT EXISTS campeonato.team_match_counters
(
    id integer NOT NULL DEFAULT nextval('campeonato.team_match_counters_id_seq'::regclass),
    team_id integer NOT NULL,
    season_name text COLLATE pg_catalog."default" NOT NULL,
    total_matches integer DEFAULT 0,
    home_matches integer DEFAULT 0,
    away_matches integer DEFAULT 0,
    last_updated timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT team_match_counters_pkey PRIMARY KEY (id),
    CONSTRAINT team_match_counters_team_id_season_name_key UNIQUE (team_id, season_name),
    CONSTRAINT team_match_counters_team_id_fkey FOREIGN KEY (team_id)
        REFERENCES campeonato.team (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

-- Table: campeonato.venue
CREATE TABLE IF NOT EXISTS campeonato.venue
(
    id integer NOT NULL DEFAULT nextval('campeonato.venue_id_seq'::regclass),
    venue_name character varying(200) COLLATE pg_catalog."default" NOT NULL,
    city character varying(100) COLLATE pg_catalog."default",
    country_id bigint,
    CONSTRAINT venue_pkey PRIMARY KEY (id),
    CONSTRAINT venue_country_id_fkey FOREIGN KEY (country_id)
        REFERENCES campeonato.country (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

-- Create indexes
CREATE UNIQUE INDEX IF NOT EXISTS idx_country_name ON campeonato.country (name);
CREATE UNIQUE INDEX IF NOT EXISTS idx_league_name ON campeonato.league (name);
CREATE UNIQUE INDEX IF NOT EXISTS idx_match_api_id ON campeonato.match (match_api_id);
CREATE UNIQUE INDEX IF NOT EXISTS idx_player_api_id ON campeonato.player (player_api_id);
CREATE UNIQUE INDEX IF NOT EXISTS idx_player_fifa_api_id ON campeonato.player (player_fifa_api_id);

CREATE INDEX IF NOT EXISTS idx_match_events_event_type ON campeonato.match_events (event_type);
CREATE INDEX IF NOT EXISTS idx_match_events_match_id ON campeonato.match_events (match_id);
CREATE INDEX IF NOT EXISTS idx_match_events_player_id ON campeonato.match_events (player_id);

CREATE INDEX IF NOT EXISTS idx_match_odds_bookmaker ON campeonato.match_odds (bookmaker);
CREATE INDEX IF NOT EXISTS idx_match_odds_match_id ON campeonato.match_odds (match_id);

CREATE INDEX IF NOT EXISTS idx_match_players_match_id ON campeonato.match_players (match_id);
CREATE INDEX IF NOT EXISTS idx_match_players_player_id ON campeonato.match_players (player_id);
CREATE INDEX IF NOT EXISTS idx_match_players_team_id ON campeonato.match_players (team_id);

CREATE INDEX IF NOT EXISTS idx_venue_country_id ON campeonato.venue (country_id);

-- Set ownership
ALTER TABLE campeonato.country OWNER TO postgres;
ALTER TABLE campeonato.league OWNER TO postgres;
ALTER TABLE campeonato.match OWNER TO postgres;
ALTER TABLE campeonato.match_events OWNER TO postgres;
ALTER TABLE campeonato.match_odds OWNER TO postgres;
ALTER TABLE campeonato.match_players OWNER TO postgres;
ALTER TABLE campeonato.player OWNER TO postgres;
ALTER TABLE campeonato.player_attributes OWNER TO postgres;
ALTER TABLE campeonato.player_audit_log OWNER TO postgres;
ALTER TABLE campeonato.season OWNER TO postgres;
ALTER TABLE campeonato.team OWNER TO postgres;
ALTER TABLE campeonato.team_attributes OWNER TO postgres;
ALTER TABLE campeonato.team_match_counters OWNER TO postgres;
ALTER TABLE campeonato.venue OWNER TO postgres;

-- Grant permissions
GRANT ALL PRIVILEGES ON SCHEMA campeonato TO postgres;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA campeonato TO postgres;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA campeonato TO postgres;

-- Add comments
COMMENT ON TABLE campeonato.player_audit_log IS 'Tabela de auditoria para registrar todas as mudanças na tabela player';
COMMENT ON TABLE campeonato.team_match_counters IS 'Tabela de contadores de partidas por time e temporada';

-- Log successful initialization
DO $$
BEGIN
    RAISE NOTICE 'Database schema campeonato initialized successfully';
END $$;