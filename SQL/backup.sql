--
-- PostgreSQL database dump
--

-- Dumped from database version 10.14 (Ubuntu 10.14-1.pgdg16.04+1)
-- Dumped by pg_dump version 10.14 (Ubuntu 10.14-1.pgdg16.04+1)

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
-- Name: store; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA store;


ALTER SCHEMA store OWNER TO postgres;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: Customer; Type: TABLE; Schema: store; Owner: postgres
--

CREATE TABLE store."Customer" (
    "CustomerID" character(6) NOT NULL,
    "LastName" character varying(20),
    "FirstName" character varying(10),
    "Address" character varying(50),
    "City" character varying(20),
    "State" character(2),
    "Zip" character(5),
    "Phone" character varying(15)
);


ALTER TABLE store."Customer" OWNER TO postgres;

--
-- Name: Order; Type: TABLE; Schema: store; Owner: postgres
--

CREATE TABLE store."Order" (
    "ProductID" character(6) NOT NULL,
    "OrderID" character(6) NOT NULL,
    "CustomerID" character(6) NOT NULL,
    "PurchaseDate" date,
    "Quantity" integer,
    "TotalCost" money
);


ALTER TABLE store."Order" OWNER TO postgres;

--
-- Name: Product; Type: TABLE; Schema: store; Owner: postgres
--

CREATE TABLE store."Product" (
    "ProductID" character(6) NOT NULL,
    "ProductName" character varying(40),
    "Model" character varying(10),
    "Manufacturer" character varying(40),
    "UnitPrice" money,
    "Inventory" integer
);


ALTER TABLE store."Product" OWNER TO postgres;

--
-- Data for Name: Customer; Type: TABLE DATA; Schema: store; Owner: postgres
--

COPY store."Customer" ("CustomerID", "LastName", "FirstName", "Address", "City", "State", "Zip", "Phone") FROM stdin;
BLU003	Katie	AAAA	342 Pine	Hammond	IN	46200	555-9242
BLU005	Rich	Bbbbbbbb	123 Main St.	Chicago	IL	60633	555-1234
WIL001	Frank	Williams	456 Oak St.	Hammond	IN	46102	\N
BLU001	Jessica	Blum	229 State	Whiting	IN	46300	555-0921
BLU008	Blum8	Barbara	879 Oak	Gary	IN	46100	555-4321
\.


--
-- Data for Name: Order; Type: TABLE DATA; Schema: store; Owner: postgres
--

COPY store."Order" ("ProductID", "OrderID", "CustomerID", "PurchaseDate", "Quantity", "TotalCost") FROM stdin;
LAP001	ORD001	BLU001	2012-08-21	1	130₫
LAP002	ODR002	BLU003	2012-02-03	2	200₫
LAP001	ORD003	WIL001	2012-06-06	1	130₫
\.


--
-- Data for Name: Product; Type: TABLE DATA; Schema: store; Owner: postgres
--

COPY store."Product" ("ProductID", "ProductName", "Model", "Manufacturer", "UnitPrice", "Inventory") FROM stdin;
LAP001	Vaio CR31Z	CR	Sony Vaio	130₫	5
LAP002	HP AZE	HP	\N	100₫	18
LAP003	HP 34	HP	HP	100₫	200
\.


--
-- Name: Customer pk_customer; Type: CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store."Customer"
    ADD CONSTRAINT pk_customer PRIMARY KEY ("CustomerID");


--
-- Name: Order pk_order; Type: CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store."Order"
    ADD CONSTRAINT pk_order PRIMARY KEY ("OrderID");


--
-- Name: Product pk_product; Type: CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store."Product"
    ADD CONSTRAINT pk_product PRIMARY KEY ("ProductID");


--
-- Name: Order fk_order_customer; Type: FK CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store."Order"
    ADD CONSTRAINT fk_order_customer FOREIGN KEY ("CustomerID") REFERENCES store."Customer"("CustomerID");


--
-- Name: Order fk_order_product; Type: FK CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store."Order"
    ADD CONSTRAINT fk_order_product FOREIGN KEY ("ProductID") REFERENCES store."Product"("ProductID");


--
-- Name: SCHEMA store; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA store TO "Salesman";
GRANT USAGE ON SCHEMA store TO "Accountant";


--
-- Name: TABLE "Customer"; Type: ACL; Schema: store; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE store."Customer" TO "Salesman";
GRANT SELECT ON TABLE store."Customer" TO "Accountant";


--
-- Name: TABLE "Order"; Type: ACL; Schema: store; Owner: postgres
--

GRANT SELECT ON TABLE store."Order" TO "Accountant";


--
-- PostgreSQL database dump complete
--

