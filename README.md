<p align="center">
  <a href="https://github.com/Azure-Samples/MultiAgent_Azure_PostgreSQL_AutoGen0.4.git" target="_blank">
    <img src="https://img.shields.io/badge/⚠️%20Latest%20PostgreSQL%20with%20AutoGen%20Demo-CLICK%20TO%20VIEW-orange?style=for-the-badge" alt="Multi-Agent PostgreSQL Demo">
  </a>
</p>

# **Multi-Agent AI System with LangChain, AutoGen, Azure OpenAI GPT-4, and Azure PostgreSQL**

<div align="center">
  <img src="https://github.com/user-attachments/assets/26489916-3af8-4371-a035-9cbdb4db0c61" alt="Architecture">
</div>

This repository demonstrates how to build a **multi-agent AI system** using:
- **LangChain** for natural language to SQL translation.
- **AutoGen** for coordinating AI agents in collaborative workflows.
- **Azure OpenAI GPT-4** for intelligent language understanding and generation of SQL queries in PostgreSQL.
- **Azure Database for PostgreSQL** for data storage and querying.

The application showcases a shipping company where agents manage shipments, customers and product informations. The main goal of this repository is to illustrate how easy it is to have agents not just reading data but also acting on them. It extends the "Chat With Your Data" to "Chat and Act on Your Data". ** We welcome contributions to help make those agents more reliable and under guardrails. Feel free to contribute to more agents as well! **

## **Features**

- 🌐 **Gradio UI**: User-friendly interface for natural language interactions.
- 🤖 **AutoGen Multi-Agent System**: Agents collaborate to handle specific tasks:
  - **SchemaAgent**: Manages database schema retrieval and sharing.
  - **ShipmentAgent**: Handles shipment-related queries and updates. It can use the stored procedure *send_shipment* to create shipments.
  - **CRMAgent**: Manages customer and product-related data. It can use the stored procedure *add_customer* to create new customers.
- 🧠 **Azure OpenAI GPT-4**: Generates SQL queries and natural language responses.
- 🛢️ **Azure PostgreSQL**: Stores shipment, customer, and product data.

## **Getting Started**

### **1. Prerequisites**

- Python 3.9+ and <3.13
- An Azure account with:
  - **Azure OpenAI Service** (GPT-4 deployed). **Note: I am looking to see how we can use other GPT models but they keep adding ``` sql  which returns an error**
  - **Azure Database for PostgreSQL** (configured with necessary tables).
- Environment setup:
  - `python-dotenv` for environment variables.
  - PostgreSQL client library (`psycopg2` or similar).
     
---

### **2. Setup Instructions**

#### **Clone the Repository**

```bash
git clone https://github.com/Azure-Samples/azure-postgresql-openai-langchain-autogen-demo.git
```
```bash
cd azure-postgresql-openai-langchain-autogen-demo
```

#### **Create Tables, Add Data and Create Stored Procedures**
- Use the file **SQL_Queries.sql** to set your database.

#### **Configure .env File**

Create a **.env** file in the root directory to store sensitive credentials. Use the following template:

```ini
# Azure OpenAI
AZURE_OPENAI_KEY=your_openai_api_key
AZURE_OPENAI_ENDPOINT=https://your-openai-endpoint
AZURE_OPENAI_DEPLOYMENT=gpt-4

# PostgreSQL Database
POSTGRES_USER=your_username
POSTGRES_PASSWORD=your_password
POSTGRES_HOST=your_postgresql_host
POSTGRES_PORT=5432
POSTGRES_DB=your_database_name
```

Replace the placeholder values with your actual credentials. The Jupyter Notebook is configured with .env been located in the same root folder in my machine. 

If you use Google Collab and you want to upload .env file, you will have to add the following code:

```python
from google.colab import files
files.upload()  # Upload your .env file
```

#### Install libraries
- I recommend using Jupyter Notebook in VS Code
- You should create a virtual environment to avoid any library conflicts:
  1. Go to your root folder where you have cloned the files
  2. Create a virtual environment named `.venv` in your current directory:
     ```python
     python3 -m venv .venv
     ```
  3. Activate:

     a. **On Windows:**
        ```bash
        .venv\Scripts\activate
        ```

     b. **On Mac/Linux:**
        ```bash
        source .venv/bin/activate
        ```
  4. Install the Requirement File:
     ```python
     pip install -r requirements.txt
     ```

#### **Usage - example of questions that you can ask:**

##### **Chat with your Data Examples**:
- Which products with names are currently tracking in transit?
- Is Alice Johnson a Customer?

##### **Multi-agents to help develop on the database example question**:
- I would like to create a stored Procedure to delete customers. What would be the best way to do this?

##### **Act on Your Data example**:
- Can you add Marc with email address marcr@contoso.com, phone number +1 123 456 7890 and address in 1 Main Street, Redmond?
- Can you add Marc with email address marcre@contoso.com, phone number +1 123 456 7890? **Note: the information is incomplete and the agents should not perfom an operation**
- Can you create a new shipment of 1 Laptop and 1 Smartphone to Marc and ensure shipment is updated to Departed Origin from the location in New York and towards Los Angeles date is today?
