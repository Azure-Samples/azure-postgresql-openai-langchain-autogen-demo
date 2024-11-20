# **Multi-Agent AI System with LangChain, AutoGen, Azure OpenAI GPT-4, and Azure PostgreSQL**

<div align="center">
  <img src="https://github.com/user-attachments/assets/26489916-3af8-4371-a035-9cbdb4db0c61" alt="Architecture">
</div>

This repository demonstrates how to build a **multi-agent AI system** using:
- **LangChain** for natural language to SQL translation.
- **AutoGen** for coordinating AI agents in collaborative workflows.
- **Azure OpenAI GPT-4** for intelligent language understanding and generation of SQL queries in PostgreSQL.
- **Azure Database for PostgreSQL** for data storage and querying.

The application showcases a use case of a shipping company where agents manage shipment, customer and product informations. 

## **Features**

- 🌐 **Gradio UI**: User-friendly interface for natural language interactions.
- 🤖 **AutoGen Multi-Agent System**: Agents collaborate to handle specific tasks:
  - **SchemaAgent**: Manages database schema retrieval and sharing.
  - **ShipmentAgent**: Handles shipment-related queries and updates.
  - **CRMAgent**: Manages customer and product-related data.
- 🧠 **Azure OpenAI GPT-4**: Generates SQL queries and natural language responses.
- 🛢️ **Azure PostgreSQL**: Stores shipment, customer, and product data.

## **Getting Started**

### **1. Prerequisites**

- Python 3.7+
- An Azure account with:
  - **Azure OpenAI Service** (GPT-4 deployed).
  - **Azure Database for PostgreSQL** (configured with necessary tables).
- Environment setup:
  - `python-dotenv` for environment variables.
  - PostgreSQL client library (`psycopg2` or similar).

---

### **2. Setup Instructions**

#### **Clone the Repository**

```bash
git clone https://github.com/arno756/multi-ai-agents-with-postgresql.git
cd multi-ai-agents-with-postgresql
```

#### **Configure .env File**

Create a .env file in the root directory to store sensitive credentials. Use the following template:

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

#### **Usage - example of questions that you can ask:**

- How many customers do we have?
- What products are currently in transit?
- Can you add Marc with email address marc@contoso.com, phone number +1 123 456 7890 and address in 1 Main Street, Seattle?
- Can you create a new shipment of 1 Laptop and 1 Smartphone to Marc and ensure shipment is updated to Departed Origin from the location in New York and towards Los Angeles date is today?
