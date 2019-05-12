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
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


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
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


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
    title character varying NOT NULL,
    description text,
    user_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    slug character varying NOT NULL
);


--
-- Name: dashboard_entries; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.dashboard_entries AS
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
  ORDER BY 5 DESC;


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
    noteable_id integer
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
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


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
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


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
-- Name: index_figures_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_figures_on_name ON public.figures USING btree (name);


--
-- Name: index_figures_on_world_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_figures_on_world_id ON public.figures USING btree (world_id);


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
-- Name: index_tags_on_tagable_type_and_tagable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_tags_on_tagable_type_and_tagable_id ON public.tags USING btree (tagable_type, tagable_id);


--
-- Name: index_tags_on_tagset; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tags_on_tagset ON public.tags USING gin (tagset);


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
-- Name: index_worlds_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_worlds_on_slug ON public.worlds USING btree (slug);


--
-- Name: index_worlds_on_title; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_worlds_on_title ON public.worlds USING btree (title);


--
-- Name: index_worlds_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_worlds_on_user_id ON public.worlds USING btree (user_id);


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
('20190604130121');


