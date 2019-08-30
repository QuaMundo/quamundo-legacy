SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- Name: relation_role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.relation_role AS ENUM (
    'subject',
    'relative'
);


--
-- Name: fact_constituents_common_world(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fact_constituents_common_world() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    IF (SELECT ((i.world_id IS NULL)
          OR (f.world_id IS NULL)
          OR (f.world_id != i.world_id))
        FROM fact_constituents fc
        LEFT JOIN facts f ON f.id = fc.fact_id
        LEFT JOIN inventories i ON fc.constituable_id = i.inventory_id
                                AND fc.constituable_type = i.inventory_type
        WHERE fc.id = NEW.id)
    THEN
        RAISE EXCEPTION 'World mismatch: constituent % % does not belong to same world as his fact',
          NEW.constituable_type, NEW.constituable_id;
    ELSE
        RETURN NEW;
    END IF;
  END;
$$;


--
-- Name: freeze_fact_constituent_constituable(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.freeze_fact_constituent_constituable() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    IF (NEW.constituable_id != OLD.constituable_id
        OR NEW.constituable_type != OLD.constituable_type)
    THEN
      RAISE EXCEPTION 'Referenced inventory of fact constituent cannot be changed';
    END IF;
    RETURN NEW;
  END;
$$;


--
-- Name: freeze_relation_constituent_references(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.freeze_relation_constituent_references() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    IF (OLD.relation_id != NEW.relation_id
        OR OLD.fact_constituent_id != NEW.fact_constituent_id)
    THEN
      RAISE EXCEPTION 'References of a relation constituents may not be changed';
    ELSE
      RETURN NEW;
    END IF;
  END;
$$;


--
-- Name: freeze_relation_fact(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.freeze_relation_fact() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    IF (NEW.fact_id != OLD.fact_id)
    THEN
      RAISE EXCEPTION 'Referenced fact cannot be changed!';
    END IF;
    RETURN NEW;
  END;
$$;


--
-- Name: freeze_world_ref(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.freeze_world_ref() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    IF NEW.world_id != OLD.world_id THEN
      RAISE EXCEPTION 'Not allowed to change world reference of %',
      TG_TABLE_NAME;
    END IF;
    RETURN NEW;
  END;
$$;


--
-- Name: refresh_inventories(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.refresh_inventories() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    REFRESH MATERIALIZED VIEW inventories;
    RETURN NULL;
  END;
$$;


--
-- Name: refresh_subject_relative_relations(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.refresh_subject_relative_relations() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    REFRESH MATERIALIZED VIEW subject_relative_relations;
    RETURN NULL;
  END;
$$;


--
-- Name: relation_constituent_common_fact(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.relation_constituent_common_fact() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    IF (
      (SELECT fact_id FROM relations WHERE id = NEW.relation_id)
      !=
      (SELECT fact_id FROM fact_constituents WHERE id = NEW.fact_constituent_id)
    )
    THEN
      RAISE EXCEPTION 'Fact mismatch! All relation constituents must belong to the same fact';
    ELSE
      RETURN NEW;
    END IF;
  END;
$$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: concepts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.concepts (
    id bigint NOT NULL,
    name character varying NOT NULL,
    description text,
    world_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: concepts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.concepts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: concepts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.concepts_id_seq OWNED BY public.concepts.id;


--
-- Name: dossiers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dossiers (
    id bigint NOT NULL,
    name character varying NOT NULL,
    description text,
    content text,
    dossierable_type character varying,
    dossierable_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: dossiers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dossiers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dossiers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dossiers_id_seq OWNED BY public.dossiers.id;


--
-- Name: fact_constituents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fact_constituents (
    id bigint NOT NULL,
    roles character varying[] DEFAULT '{}'::character varying[] NOT NULL,
    constituable_type character varying NOT NULL,
    constituable_id integer NOT NULL,
    fact_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: fact_constituents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fact_constituents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fact_constituents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.fact_constituents_id_seq OWNED BY public.fact_constituents.id;


--
-- Name: facts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.facts (
    id bigint NOT NULL,
    name character varying NOT NULL,
    description text,
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    world_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    CONSTRAINT start_before_end_date CHECK (((start_date IS NULL) OR (end_date IS NULL) OR (start_date < end_date)))
);


--
-- Name: facts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.facts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: facts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.facts_id_seq OWNED BY public.facts.id;


--
-- Name: figures; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.figures (
    id bigint NOT NULL,
    name character varying NOT NULL,
    description text,
    world_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: figures_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.figures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: figures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.figures_id_seq OWNED BY public.figures.id;


--
-- Name: items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.items (
    id bigint NOT NULL,
    world_id bigint,
    name character varying NOT NULL,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.locations (
    id bigint NOT NULL,
    world_id bigint,
    name character varying NOT NULL,
    description text,
    lonlat public.geography(Point,4326),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: worlds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.worlds (
    id bigint NOT NULL,
    name character varying NOT NULL,
    description text,
    user_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    slug character varying NOT NULL
);


--
-- Name: inventories; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.inventories AS
 SELECT i.id AS inventory_id,
    'Item'::text AS inventory_type,
    i.name,
    i.description,
    i.updated_at,
    wi.id AS world_id,
    wi.user_id
   FROM (public.items i
     LEFT JOIN public.worlds wi ON ((wi.id = i.world_id)))
UNION
 SELECT f.id AS inventory_id,
    'Figure'::text AS inventory_type,
    f.name,
    f.description,
    f.updated_at,
    wf.id AS world_id,
    wf.user_id
   FROM (public.figures f
     LEFT JOIN public.worlds wf ON ((wf.id = f.world_id)))
UNION
 SELECT l.id AS inventory_id,
    'Location'::text AS inventory_type,
    l.name,
    l.description,
    l.updated_at,
    wl.id AS world_id,
    wl.user_id
   FROM (public.locations l
     LEFT JOIN public.worlds wl ON ((wl.id = l.world_id)))
UNION
 SELECT fa.id AS inventory_id,
    'Fact'::text AS inventory_type,
    fa.name,
    fa.description,
    fa.updated_at,
    wfa.id AS world_id,
    wfa.user_id
   FROM (public.facts fa
     LEFT JOIN public.worlds wfa ON ((wfa.id = fa.world_id)))
UNION
 SELECT c.id AS inventory_id,
    'Concept'::text AS inventory_type,
    c.name,
    c.description,
    c.updated_at,
    wc.id AS world_id,
    wc.user_id
   FROM (public.concepts c
     LEFT JOIN public.worlds wc ON ((wc.id = c.world_id)))
  ORDER BY 5 DESC
  WITH NO DATA;


--
-- Name: items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.items_id_seq OWNED BY public.items.id;


--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.locations_id_seq OWNED BY public.locations.id;


--
-- Name: notes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notes (
    id bigint NOT NULL,
    content text NOT NULL,
    noteable_type character varying,
    noteable_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: notes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notes_id_seq OWNED BY public.notes.id;


--
-- Name: relation_constituents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.relation_constituents (
    id bigint NOT NULL,
    fact_constituent_id bigint NOT NULL,
    relation_id bigint NOT NULL,
    role public.relation_role NOT NULL
);


--
-- Name: relation_constituents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.relation_constituents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: relation_constituents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.relation_constituents_id_seq OWNED BY public.relation_constituents.id;


--
-- Name: relations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.relations (
    id bigint NOT NULL,
    name character varying NOT NULL,
    reverse_name character varying,
    description text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    fact_id bigint NOT NULL
);


--
-- Name: relations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.relations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: relations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.relations_id_seq OWNED BY public.relations.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: subject_relative_relations; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.subject_relative_relations AS
 SELECT sc.relation_id,
    sc.id AS subject_id,
    r.name,
    rc.id AS relative_id
   FROM ((public.relation_constituents sc
     JOIN public.relation_constituents rc ON (((sc.relation_id = rc.relation_id) AND (sc.role <> rc.role))))
     JOIN public.relations r ON ((r.id = sc.relation_id)))
  WHERE (sc.role = 'subject'::public.relation_role)
UNION
 SELECT sc.relation_id,
    sc.id AS subject_id,
    r.reverse_name AS name,
    rc.id AS relative_id
   FROM ((public.relation_constituents sc
     JOIN public.relation_constituents rc ON (((sc.relation_id = rc.relation_id) AND (sc.role <> rc.role))))
     JOIN public.relations r ON ((r.id = sc.relation_id)))
  WHERE ((sc.role = 'relative'::public.relation_role) AND (r.reverse_name IS NOT NULL))
  WITH NO DATA;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tags (
    id bigint NOT NULL,
    tagset character varying[] DEFAULT '{}'::character varying[] NOT NULL,
    tagable_type character varying,
    tagable_id integer
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- Name: traits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.traits (
    id bigint NOT NULL,
    attributeset public.hstore DEFAULT ''::public.hstore NOT NULL,
    traitable_type character varying,
    traitable_id integer
);


--
-- Name: traits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.traits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: traits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.traits_id_seq OWNED BY public.traits.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    nick character varying NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: worlds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.worlds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: worlds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.worlds_id_seq OWNED BY public.worlds.id;


--
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);


--
-- Name: concepts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.concepts ALTER COLUMN id SET DEFAULT nextval('public.concepts_id_seq'::regclass);


--
-- Name: dossiers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dossiers ALTER COLUMN id SET DEFAULT nextval('public.dossiers_id_seq'::regclass);


--
-- Name: fact_constituents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fact_constituents ALTER COLUMN id SET DEFAULT nextval('public.fact_constituents_id_seq'::regclass);


--
-- Name: facts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facts ALTER COLUMN id SET DEFAULT nextval('public.facts_id_seq'::regclass);


--
-- Name: figures id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.figures ALTER COLUMN id SET DEFAULT nextval('public.figures_id_seq'::regclass);


--
-- Name: items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.items ALTER COLUMN id SET DEFAULT nextval('public.items_id_seq'::regclass);


--
-- Name: locations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations ALTER COLUMN id SET DEFAULT nextval('public.locations_id_seq'::regclass);


--
-- Name: notes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notes ALTER COLUMN id SET DEFAULT nextval('public.notes_id_seq'::regclass);


--
-- Name: relation_constituents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.relation_constituents ALTER COLUMN id SET DEFAULT nextval('public.relation_constituents_id_seq'::regclass);


--
-- Name: relations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.relations ALTER COLUMN id SET DEFAULT nextval('public.relations_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Name: traits id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.traits ALTER COLUMN id SET DEFAULT nextval('public.traits_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: worlds id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.worlds ALTER COLUMN id SET DEFAULT nextval('public.worlds_id_seq'::regclass);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: concepts concepts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.concepts
    ADD CONSTRAINT concepts_pkey PRIMARY KEY (id);


--
-- Name: dossiers dossiers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dossiers
    ADD CONSTRAINT dossiers_pkey PRIMARY KEY (id);


--
-- Name: fact_constituents fact_constituents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fact_constituents
    ADD CONSTRAINT fact_constituents_pkey PRIMARY KEY (id);


--
-- Name: facts facts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facts
    ADD CONSTRAINT facts_pkey PRIMARY KEY (id);


--
-- Name: figures figures_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.figures
    ADD CONSTRAINT figures_pkey PRIMARY KEY (id);


--
-- Name: items items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_pkey PRIMARY KEY (id);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: notes notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notes
    ADD CONSTRAINT notes_pkey PRIMARY KEY (id);


--
-- Name: relation_constituents relation_constituents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.relation_constituents
    ADD CONSTRAINT relation_constituents_pkey PRIMARY KEY (id);


--
-- Name: relations relations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.relations
    ADD CONSTRAINT relations_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: traits traits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.traits
    ADD CONSTRAINT traits_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: worlds worlds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.worlds
    ADD CONSTRAINT worlds_pkey PRIMARY KEY (id);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- Name: index_concepts_on_world_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_concepts_on_world_id ON public.concepts USING btree (world_id);


--
-- Name: index_dossiers_on_dossierable_type_and_dossierable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dossiers_on_dossierable_type_and_dossierable_id ON public.dossiers USING btree (dossierable_type, dossierable_id);


--
-- Name: index_fact_const_on_const_type_and_const_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fact_const_on_const_type_and_const_id ON public.fact_constituents USING btree (constituable_type, constituable_id);


--
-- Name: index_fact_const_on_const_type_and_const_id_and_fact_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_fact_const_on_const_type_and_const_id_and_fact_id ON public.fact_constituents USING btree (constituable_type, constituable_id, fact_id);


--
-- Name: index_fact_constituent_relation_role_unique_on_rel_constituents; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_fact_constituent_relation_role_unique_on_rel_constituents ON public.relation_constituents USING btree (fact_constituent_id, relation_id, role);


--
-- Name: index_fact_constituents_on_fact_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fact_constituents_on_fact_id ON public.fact_constituents USING btree (fact_id);


--
-- Name: index_fact_constituents_on_roles; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fact_constituents_on_roles ON public.fact_constituents USING gin (roles);


--
-- Name: index_facts_on_world_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_facts_on_world_id ON public.facts USING btree (world_id);


--
-- Name: index_figures_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_figures_on_name ON public.figures USING btree (name);


--
-- Name: index_figures_on_world_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_figures_on_world_id ON public.figures USING btree (world_id);


--
-- Name: index_inventories_on_inventory_id_and_inventory_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inventories_on_inventory_id_and_inventory_type ON public.inventories USING btree (inventory_id, inventory_type);


--
-- Name: index_items_on_world_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_world_id ON public.items USING btree (world_id);


--
-- Name: index_locations_on_lonlat; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_locations_on_lonlat ON public.locations USING gist (lonlat);


--
-- Name: index_locations_on_world_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_locations_on_world_id ON public.locations USING btree (world_id);


--
-- Name: index_notes_on_noteable_type_and_noteable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notes_on_noteable_type_and_noteable_id ON public.notes USING btree (noteable_type, noteable_id);


--
-- Name: index_rel_const_on_fact_const_and_role; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_rel_const_on_fact_const_and_role ON public.relation_constituents USING btree (fact_constituent_id, role);


--
-- Name: index_rel_const_on_relation_and_role; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_rel_const_on_relation_and_role ON public.relation_constituents USING btree (relation_id, role);


--
-- Name: index_relation_constituents_on_fact_constituent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_relation_constituents_on_fact_constituent_id ON public.relation_constituents USING btree (fact_constituent_id);


--
-- Name: index_relation_constituents_on_relation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_relation_constituents_on_relation_id ON public.relation_constituents USING btree (relation_id);


--
-- Name: index_relation_relative_on_sub_rel_relations; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_relation_relative_on_sub_rel_relations ON public.subject_relative_relations USING btree (relation_id, relative_id);


--
-- Name: index_relation_subject_on_sub_rel_relations; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_relation_subject_on_sub_rel_relations ON public.subject_relative_relations USING btree (relation_id, subject_id);


--
-- Name: index_relations_on_fact_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_relations_on_fact_id ON public.relations USING btree (fact_id);


--
-- Name: index_tags_on_tagable_type_and_tagable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_tags_on_tagable_type_and_tagable_id ON public.tags USING btree (tagable_type, tagable_id);


--
-- Name: index_tags_on_tagset; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tags_on_tagset ON public.tags USING gin (tagset);


--
-- Name: index_traits_on_attributeset; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_traits_on_attributeset ON public.traits USING gin (attributeset);


--
-- Name: index_traits_on_traitable_type_and_traitable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_traits_on_traitable_type_and_traitable_id ON public.traits USING btree (traitable_type, traitable_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_nick; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_nick ON public.users USING btree (nick);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_worlds_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_worlds_on_name ON public.worlds USING btree (name);


--
-- Name: index_worlds_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_worlds_on_slug ON public.worlds USING btree (slug);


--
-- Name: index_worlds_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_worlds_on_user_id ON public.worlds USING btree (user_id);


--
-- Name: concepts concept_world_change; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER concept_world_change BEFORE UPDATE OF world_id ON public.concepts FOR EACH ROW EXECUTE PROCEDURE public.freeze_world_ref();


--
-- Name: fact_constituents fact_constituent_change; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER fact_constituent_change BEFORE UPDATE OF constituable_id, constituable_type ON public.fact_constituents FOR EACH ROW EXECUTE PROCEDURE public.freeze_fact_constituent_constituable();


--
-- Name: facts fact_world_change; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER fact_world_change BEFORE UPDATE OF world_id ON public.facts FOR EACH ROW EXECUTE PROCEDURE public.freeze_world_ref();


--
-- Name: figures figure_world_change; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER figure_world_change BEFORE UPDATE OF world_id ON public.figures FOR EACH ROW EXECUTE PROCEDURE public.freeze_world_ref();


--
-- Name: fact_constituents foreign_fact_constituent; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER foreign_fact_constituent AFTER INSERT OR UPDATE OF constituable_id, constituable_type ON public.fact_constituents FOR EACH ROW EXECUTE PROCEDURE public.fact_constituents_common_world();


--
-- Name: relation_constituents foreign_relation_constituent; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER foreign_relation_constituent BEFORE INSERT ON public.relation_constituents FOR EACH ROW EXECUTE PROCEDURE public.relation_constituent_common_fact();


--
-- Name: items item_world_change; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER item_world_change BEFORE UPDATE OF world_id ON public.items FOR EACH ROW EXECUTE PROCEDURE public.freeze_world_ref();


--
-- Name: locations location_world_change; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER location_world_change BEFORE UPDATE OF world_id ON public.locations FOR EACH ROW EXECUTE PROCEDURE public.freeze_world_ref();


--
-- Name: concepts refresh_concept_inventories; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER refresh_concept_inventories AFTER INSERT OR DELETE OR UPDATE OR TRUNCATE ON public.concepts FOR EACH STATEMENT EXECUTE PROCEDURE public.refresh_inventories();


--
-- Name: relation_constituents refresh_constituent_on_subject_relative_relations; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER refresh_constituent_on_subject_relative_relations AFTER INSERT OR DELETE OR UPDATE OR TRUNCATE ON public.relation_constituents FOR EACH STATEMENT EXECUTE PROCEDURE public.refresh_subject_relative_relations();


--
-- Name: facts refresh_fact_inventories; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER refresh_fact_inventories AFTER INSERT OR DELETE OR UPDATE OR TRUNCATE ON public.facts FOR EACH STATEMENT EXECUTE PROCEDURE public.refresh_inventories();


--
-- Name: figures refresh_figure_inventories; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER refresh_figure_inventories AFTER INSERT OR DELETE OR UPDATE OR TRUNCATE ON public.figures FOR EACH STATEMENT EXECUTE PROCEDURE public.refresh_inventories();


--
-- Name: items refresh_item_inventories; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER refresh_item_inventories AFTER INSERT OR DELETE OR UPDATE OR TRUNCATE ON public.items FOR EACH STATEMENT EXECUTE PROCEDURE public.refresh_inventories();


--
-- Name: locations refresh_location_inventories; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER refresh_location_inventories AFTER INSERT OR DELETE OR UPDATE OR TRUNCATE ON public.locations FOR EACH STATEMENT EXECUTE PROCEDURE public.refresh_inventories();


--
-- Name: relations refresh_relation_on_subject_relative_relations; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER refresh_relation_on_subject_relative_relations AFTER INSERT OR DELETE OR UPDATE OR TRUNCATE ON public.relations FOR EACH STATEMENT EXECUTE PROCEDURE public.refresh_subject_relative_relations();


--
-- Name: relation_constituents relation_constituent_change; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER relation_constituent_change BEFORE UPDATE OF fact_constituent_id, relation_id ON public.relation_constituents FOR EACH ROW EXECUTE PROCEDURE public.freeze_relation_constituent_references();


--
-- Name: relations relation_fact_change; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER relation_fact_change BEFORE UPDATE OF fact_id ON public.relations FOR EACH ROW EXECUTE PROCEDURE public.freeze_relation_fact();


--
-- Name: facts fk_rails_0610f2844b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facts
    ADD CONSTRAINT fk_rails_0610f2844b FOREIGN KEY (world_id) REFERENCES public.worlds(id);


--
-- Name: figures fk_rails_124bcd8f21; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.figures
    ADD CONSTRAINT fk_rails_124bcd8f21 FOREIGN KEY (world_id) REFERENCES public.worlds(id);


--
-- Name: locations fk_rails_2892871a50; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT fk_rails_2892871a50 FOREIGN KEY (world_id) REFERENCES public.worlds(id);


--
-- Name: fact_constituents fk_rails_6ac65e0a48; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fact_constituents
    ADD CONSTRAINT fk_rails_6ac65e0a48 FOREIGN KEY (fact_id) REFERENCES public.facts(id);


--
-- Name: worlds fk_rails_7912bd990e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.worlds
    ADD CONSTRAINT fk_rails_7912bd990e FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: items fk_rails_b5ae10593b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT fk_rails_b5ae10593b FOREIGN KEY (world_id) REFERENCES public.worlds(id);


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: concepts fk_rails_d1ab849943; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.concepts
    ADD CONSTRAINT fk_rails_d1ab849943 FOREIGN KEY (world_id) REFERENCES public.worlds(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20181106163156'),
('20190222161807'),
('20190223073918'),
('20190225104426'),
('20190314225132'),
('20190315091854'),
('20190315093603'),
('20190315154615'),
('20190407101530'),
('20190407120223'),
('20190407144613'),
('20190410204103'),
('20190411071508'),
('20190412141828'),
('20190428142139'),
('20190506212919'),
('20190519214102'),
('20190601154637'),
('20190602174120'),
('20190604130121'),
('20190610173015'),
('20190617112044'),
('20190619154220'),
('20190619155033'),
('20190715165925'),
('20190715192434'),
('20190717165733'),
('20190721205302'),
('20190722161446'),
('20190726172358'),
('20190731140244'),
('20190805152237'),
('20190805163701'),
('20190814142500'),
('20190814152829'),
('20190825145758'),
('20190825151321'),
('20190828145207'),
('20190830105858'),
('20190923090443'),
('20190923124805'),
('20190923131312'),
('20190924112933'),
('20190924114909'),
('20190925152408'),
('20190927113355'),
('20190927150245'),
('20190927153349'),
('20190930151242'),
('20191001121919'),
('20191005215006');


