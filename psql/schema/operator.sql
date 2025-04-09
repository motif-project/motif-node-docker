--
-- PostgreSQL database dump
--

-- Dumped from database version 14.5 (Ubuntu 14.5-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.7 (Ubuntu 14.7-0ubuntu0.22.04.1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: deposit_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.deposit_requests (
    pod_address character varying(42) NOT NULL,
    operator_address character varying(42) NOT NULL,
    transaction_id character varying(64) NOT NULL,
    amount character varying NOT NULL,
    archived boolean NOT NULL
);


CREATE TABLE public.withdraw_requests (
    podaddress character varying(42) NOT NULL,
    operatoraddress character varying(42) NOT NULL,
    transactionid character varying(64) NOT NULL,
    withdrawaddr bytea NOT NULL,
    archived boolean NOT NULL
);

--
-- Name: multi_sig_address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.multi_sig_address (
    address character varying(255) NOT NULL,
    script text NOT NULL,
    podaddress character varying(255),
    signed boolean NOT NULL,
    archived boolean NOT NULL
);

CREATE TABLE public.presign_tx (
    pod_address text NOT NULL,
    tx text NOT NULL,
    archived boolean DEFAULT false NOT NULL
);

ALTER TABLE ONLY public.presign_tx
    ADD CONSTRAINT presign_tx_pkey PRIMARY KEY (pod_address, tx);
