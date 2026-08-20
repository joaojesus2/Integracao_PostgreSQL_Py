CREATE TABLE public.customer (
    customer_id character varying(8) NOT NULL,
    customer_name character varying(40) NOT NULL,
    customer_segment integer NOT NULL
);

CREATE TABLE public.customer_segments (
    customer_segment_id integer NOT NULL,
    customer_segment character varying(20) NOT NULL
);

CREATE SEQUENCE public.customer_segments_customer_segment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.customer_segments_customer_segment_id_seq OWNED BY public.customer_segments.customer_segment_id;

CREATE TABLE public.orders (
    order_item_id integer NOT NULL,
    order_id character varying(14) NOT NULL,
    customer_id character varying(8) NOT NULL,
    product_id character varying(15) NOT NULL,
    order_date timestamp without time zone NOT NULL,
    ship_date timestamp without time zone NOT NULL,
    ship_mode integer NOT NULL,
    shipping_city character varying(20) NOT NULL,
    shipping_state character varying(20) NOT NULL,
    shipping_postal_code character varying(5) NOT NULL,
    shipping_region character varying(10) NOT NULL,
    shipping_country character varying(20) NOT NULL,
    sales numeric(10,2) NOT NULL,
    quantity integer NOT NULL,
    discount numeric(10,2) NOT NULL,
    profit numeric(10,2) NOT NULL
);

CREATE SEQUENCE public.orders_order_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.orders_order_item_id_seq OWNED BY public.orders.order_item_id;

CREATE TABLE public.product (
    product_id character varying(15) NOT NULL,
    product_category character varying(20) NOT NULL,
    product_subcategory character varying(20) NOT NULL,
    product_name character varying(150) NOT NULL
);

CREATE TABLE public.ship_modes (
    ship_mode_id integer NOT NULL,
    ship_mode character varying(20) NOT NULL
);

CREATE SEQUENCE public.ship_modes_ship_mode_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.ship_modes_ship_mode_id_seq OWNED BY public.ship_modes.ship_mode_id;

CREATE VIEW public.vw_global AS
 SELECT o.order_id,
    c.customer_name,
    sm.ship_mode,
    p.product_name,
    o.shipping_country,
    o.shipping_state,
    o.shipping_city,
    o.shipping_region,
    o.sales,
    o.quantity,
    o.discount,
    o.profit
   FROM (((public.orders o
     JOIN public.customer c ON (((o.customer_id)::text = (c.customer_id)::text)))
     JOIN public.product p ON (((o.product_id)::text = (p.product_id)::text)))
     JOIN public.ship_modes sm ON ((c.customer_segment = sm.ship_mode_id)));

ALTER TABLE ONLY public.customer_segments ALTER COLUMN customer_segment_id SET DEFAULT nextval('public.customer_segments_customer_segment_id_seq'::regclass);

ALTER TABLE ONLY public.orders ALTER COLUMN order_item_id SET DEFAULT nextval('public.orders_order_item_id_seq'::regclass);

ALTER TABLE ONLY public.ship_modes ALTER COLUMN ship_mode_id SET DEFAULT nextval('public.ship_modes_ship_mode_id_seq'::regclass);

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (customer_id);

ALTER TABLE ONLY public.customer_segments
    ADD CONSTRAINT customer_segments_customer_segment_key UNIQUE (customer_segment);

ALTER TABLE ONLY public.customer_segments
    ADD CONSTRAINT customer_segments_pkey PRIMARY KEY (customer_segment_id);

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_item_id);

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (product_id);

ALTER TABLE ONLY public.ship_modes
    ADD CONSTRAINT ship_modes_pkey PRIMARY KEY (ship_mode_id);

ALTER TABLE ONLY public.ship_modes
    ADD CONSTRAINT ship_modes_ship_mode_key UNIQUE (ship_mode);

CREATE INDEX idx_orders_order_id ON public.orders USING btree (order_id);

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_customer_segment_fkey FOREIGN KEY (customer_segment) REFERENCES public.customer_segments(customer_segment_id);

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id);

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(product_id);

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_ship_mode_fkey FOREIGN KEY (ship_mode) REFERENCES public.ship_modes(ship_mode_id);
