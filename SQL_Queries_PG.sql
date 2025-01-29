-- Create Tables

CREATE TABLE shipments ( shipment_id SERIAL PRIMARY KEY, shipment_date DATE NOT NULL, status VARCHAR(50), origin_id INTEGER REFERENCES locations(location_id), destination_id INTEGER REFERENCES locations(location_id), customer_id INTEGER REFERENCES customers(customer_id) );
CREATE TABLE shipment_items ( item_id SERIAL PRIMARY KEY, shipment_id INTEGER REFERENCES shipments(shipment_id), product_id INTEGER REFERENCES products(product_id), quantity INTEGER NOT NULL, weight NUMERIC(10, 2) );
CREATE TABLE locations ( location_id SERIAL PRIMARY KEY, city VARCHAR(100), state VARCHAR(100), country VARCHAR(100), zip_code VARCHAR(20) );
CREATE TABLE customers ( customer_id SERIAL PRIMARY KEY, name VARCHAR(150) NOT NULL, email VARCHAR(150), phone VARCHAR(50), address VARCHAR(250) );
CREATE TABLE products ( product_id SERIAL PRIMARY KEY, name VARCHAR(150) NOT NULL, description TEXT, price NUMERIC(10, 2), weight NUMERIC(10, 2) );
CREATE TABLE shipment_tracking ( tracking_id SERIAL PRIMARY KEY, shipment_id INTEGER REFERENCES shipments(shipment_id), status VARCHAR(50) NOT NULL, location_id INTEGER REFERENCES locations(location_id), timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP );

-- Add Data
INSERT INTO locations (city, state, country, zip_code) VALUES ('New York', 'NY', 'USA', '10001'), ('Los Angeles', 'CA', 'USA', '90001'), ('Chicago', 'IL', 'USA', '60601'), ('Houston', 'TX', 'USA', '77001');
INSERT INTO customers (name, email, phone, address) VALUES ('Alice Johnson', 'alice@example.com', '555-1234', '123 Maple St, New York, NY'), ('Bob Smith', 'bob@example.com', '555-5678', '456 Oak Ave, Los Angeles, CA'), ('Cathy Lee', 'cathy@example.com', '555-8765', '789 Pine Rd, Chicago, IL');
INSERT INTO products (name, description, price, weight) VALUES ('Laptop', '15-inch screen, 8GB RAM, 256GB SSD', 1200.00, 2.5), ('Smartphone', '128GB storage, 6GB RAM', 800.00, 0.4), ('Headphones', 'Noise-cancelling, wireless', 150.00, 0.3);
INSERT INTO shipments (shipment_date, status, origin_id, destination_id, customer_id) VALUES ('2024-11-10', 'In Transit', 1, 2, 1), ('2024-11-11', 'Delivered', 3, 4, 2), ('2024-11-12', 'In Transit', 2, 3, 3);
INSERT INTO shipment_items (shipment_id, product_id, quantity, weight) VALUES (1, 1, 2, 5.0), (1, 3, 1, 0.3), (2, 2, 1, 0.4), (3, 1, 1, 2.5), (3, 3, 2, 0.6);
INSERT INTO shipment_tracking (shipment_id, status, location_id, timestamp) VALUES (1, 'Departed Origin', 1, '2024-11-10 08:00:00'), (1, 'In Transit', 2, '2024-11-11 12:30:00'), (2, 'Departed Origin', 3, '2024-11-11 09:00:00'), (2, 'Delivered', 4, '2024-11-12 15:00:00'), (3, 'Departed Origin', 2, '2024-11-12 10:00:00'), (3, 'In Transit', 3, '2024-11-13 13:45:00'); 

-- Create Store Procedures add_customer and send_shipment

CREATE OR REPLACE PROCEDURE add_customer(
    p_name VARCHAR,
    p_email VARCHAR,
    p_phone VARCHAR,
    p_address VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO customers (name, email, phone, address)
    VALUES (p_name, p_email, p_phone, p_address);
END;
$$;

CREATE OR REPLACE PROCEDURE send_shipment(
    customer_id INTEGER,
    origin_id INTEGER,
    destination_id INTEGER,
    shipment_date DATE,
    items JSONB,  -- Assume JSONB format for items array
    status VARCHAR,
    tracking_status VARCHAR,
    location_id INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    shipment_id INTEGER;
    item JSONB;
BEGIN
    -- Insert into shipments table
    INSERT INTO shipments (customer_id, origin_id, destination_id, shipment_date, status)
    VALUES (customer_id, origin_id, destination_id, shipment_date, status)
    RETURNING shipments.shipment_id INTO shipment_id;
    
    -- Insert into shipment_items table
    FOR item IN SELECT * FROM jsonb_array_elements(items)
    LOOP
        INSERT INTO shipment_items (shipment_id, product_id, quantity)
        VALUES (
            shipment_id,
            (item->>'product_id')::INTEGER,
            (item->>'quantity')::INTEGER
        );
    END LOOP;
    
    -- Insert into shipment_tracking table
    INSERT INTO shipment_tracking (shipment_id, status, location_id, "timestamp")
    VALUES (shipment_id, tracking_status, location_id, NOW());
END;
$$;