-- Create Tables

CREATE SCHEMA [aiagent] AUTHORIZATION dbo;
GO

DROP TABLE IF EXISTS [aiagent].[shipment_tracking];
DROP TABLE IF EXISTS [aiagent].[shipment_items];
DROP TABLE IF EXISTS [aiagent].[shipments];
DROP TABLE IF EXISTS [aiagent].[products];
DROP TABLE IF EXISTS [aiagent].[customers];
DROP TABLE IF EXISTS [aiagent].[locations];
GO

CREATE TABLE [aiagent].[locations] 
( 
    [location_id] INT IDENTITY PRIMARY KEY, 
    [city] VARCHAR(100), 
    [state] VARCHAR(100), 
    [country] VARCHAR(100), 
    [zip_code] VARCHAR(20) 
);

CREATE TABLE [aiagent].[customers] 
( 
    [customer_id] INT IDENTITY PRIMARY KEY, 
    [name] VARCHAR(150) NOT NULL, 
    [email] VARCHAR(150), 
    [phone] VARCHAR(50), 
    [address] VARCHAR(250) 
);

CREATE TABLE [aiagent].[products] 
( 
    [product_id] INT IDENTITY PRIMARY KEY, 
    [name] VARCHAR(150) NOT NULL, 
    [description] NVARCHAR(MAX), 
    [price] NUMERIC(10, 2), 
    [weight] NUMERIC(10, 2) 
);

CREATE TABLE [aiagent].[shipments]
( 
    [shipment_id] INT IDENTITY PRIMARY KEY, 
    [shipment_date] DATE NOT NULL, 
    [status] VARCHAR(50), 
    [origin_id] INTEGER REFERENCES [aiagent].[locations] (location_id), 
    [destination_id] INTEGER REFERENCES [aiagent].[locations] (location_id), 
    [customer_id] INTEGER REFERENCES [aiagent].[customers] (customer_id) 
);

CREATE TABLE [aiagent].[shipment_items] 
( 
    [item_id] INT IDENTITY PRIMARY KEY, 
    [shipment_id] INTEGER REFERENCES [aiagent].[shipments] (shipment_id), 
    [product_id] INTEGER REFERENCES [aiagent].[products] (product_id), 
    [quantity] INTEGER NOT NULL, 
    [weight] NUMERIC(10, 2) 
);

CREATE TABLE [aiagent].[shipment_tracking] 
( 
    [tracking_id] INT IDENTITY PRIMARY KEY, 
    [shipment_id] INTEGER REFERENCES [aiagent].[shipments] (shipment_id), 
    [status] VARCHAR(50) NOT NULL, 
    [location_id] INTEGER REFERENCES [aiagent].[locations] (location_id), 
    [timestamp] DATETIME2(7) DEFAULT (CURRENT_TIMESTAMP)
);

-- Add Data
INSERT INTO [aiagent].[locations] ([city], [state], [country], [zip_code]) VALUES 
('New York', 'NY', 'USA', '10001'), 
('Los Angeles', 'CA', 'USA', '90001'), 
('Chicago', 'IL', 'USA', '60601'), 
('Houston', 'TX', 'USA', '77001');
GO

INSERT INTO [aiagent].[customers] ([name], [email], [phone], [address]) VALUES 
('Alice Johnson', 'alice@example.com', '555-1234', '123 Maple St, New York, NY'), 
('Bob Smith', 'bob@example.com', '555-5678', '456 Oak Ave, Los Angeles, CA'), 
('Cathy Lee', 'cathy@example.com', '555-8765', '789 Pine Rd, Chicago, IL');
GO

INSERT INTO [aiagent].[products] ([name], [description], [price], [weight]) VALUES 
('Laptop', '15-inch screen, 8GB RAM, 256GB SSD', 1200.00, 2.5), 
('Smartphone', '128GB storage, 6GB RAM', 800.00, 0.4), 
('Headphones', 'Noise-cancelling, wireless', 150.00, 0.3);
GO

INSERT INTO [aiagent].[shipments] ([shipment_date], [status], [origin_id], [destination_id], [customer_id]) VALUES 
('2024-11-10', 'In Transit', 1, 2, 1), 
('2024-11-11', 'Delivered', 3, 4, 2), 
('2024-11-12', 'In Transit', 2, 3, 3);
GO

INSERT INTO [aiagent].[shipment_items] ([shipment_id], [product_id], [quantity], [weight]) VALUES 
(1, 1, 2, 5.0), 
(1, 3, 1, 0.3), 
(2, 2, 1, 0.4), 
(3, 1, 1, 2.5), 
(3, 3, 2, 0.6);
GO

INSERT INTO [aiagent].[shipment_tracking] ([shipment_id], [status], [location_id], [timestamp]) VALUES 
(1, 'Departed Origin', 1, '2024-11-10 08:00:00'), 
(1, 'In Transit', 2, '2024-11-11 12:30:00'), 
(2, 'Departed Origin', 3, '2024-11-11 09:00:00'), 
(2, 'Delivered', 4, '2024-11-12 15:00:00'), 
(3, 'Departed Origin', 2, '2024-11-12 10:00:00'), 
(3, 'In Transit', 3, '2024-11-13 13:45:00'); 
GO

-- Create Store Procedures add_customer and send_shipment
CREATE OR ALTER PROCEDURE aiagent.add_customer
@name VARCHAR,
@email VARCHAR,
@phone VARCHAR,
@address VARCHAR
AS
INSERT INTO aiagent.customers ([name], [email], [phone], [address])
VALUES (@name, @email, @phone, @address);
GO

CREATE OR ALTER PROCEDURE aiagent.send_shipment
@customer_id INTEGER,
@origin_id INTEGER,
@destination_id INTEGER,
@shipment_date DATE,
@items JSON,
@status VARCHAR,
@tracking_status VARCHAR,
@location_id INTEGER
AS
SET XACT_ABORT ON;
BEGIN TRAN;
DECLARE @t TABLE (shipment_id INT);

-- Insert into shipments table
INSERT INTO aiagent.shipments (customer_id, origin_id, destination_id, shipment_date, status)
OUTPUT INSERTED.shipment_id INTO @t
VALUES (@customer_id, @origin_id, @destination_id, @shipment_date, @status)    

-- Insert into shipment_items table
DECLARE @shipment_id INT = (SELECT TOP(1) shipment_id FROM @t);
INSERT INTO shipment_items (shipment_id, product_id, quantity)
SELECT @shipment_id, * FROM OPENJSON(CAST(@items AS NVARCHAR(MAX))) WITH (
    product_id INTEGER,
    quantity INTEGER
);    

-- Insert into shipment_tracking table
INSERT INTO shipment_tracking (shipment_id, status, location_id, [timestamp])
VALUES (@shipment_id, @tracking_status, @location_id, CURRENT_TIMESTAMP);

COMMIT TRAN;