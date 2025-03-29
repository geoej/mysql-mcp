from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import create_engine, text
from sqlalchemy.exc import SQLAlchemyError
from typing import List, Dict, Any
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

app = FastAPI(title="MySQL MCP API")

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, replace with specific origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Database connection configuration
DB_CONFIG = {
    "user": os.getenv("MYSQL_USER", "root"),
    "password": os.getenv("MYSQL_PASSWORD", ""),
    "host": os.getenv("MYSQL_HOST", "localhost"),
    "port": os.getenv("MYSQL_PORT", "3306"),
}

def get_db_connection(database: str = None):
    try:
        connection_string = f"mysql://{DB_CONFIG['user']}:{DB_CONFIG['password']}@{DB_CONFIG['host']}:{DB_CONFIG['port']}"
        if database:
            connection_string += f"/{database}"
        return create_engine(connection_string)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database connection error: {str(e)}")

@app.get("/")
async def root():
    return {"message": "Welcome to MySQL MCP API"}

@app.get("/databases", response_model=List[str])
async def get_databases():
    try:
        engine = get_db_connection()
        with engine.connect() as connection:
            result = connection.execute(text("SHOW DATABASES"))
            return [row[0] for row in result]
    except SQLAlchemyError as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/database/{database_name}")
async def get_database_info(database_name: str):
    try:
        engine = get_db_connection(database_name)
        with engine.connect() as connection:
            result = connection.execute(text("SHOW TABLES"))
            tables = [row[0] for row in result]
            return {"name": database_name, "tables": tables}
    except SQLAlchemyError as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/table/{database_name}/{table_name}")
async def get_table_data(database_name: str, table_name: str):
    try:
        engine = get_db_connection(database_name)
        with engine.connect() as connection:
            # Get table data
            result = connection.execute(text(f"SELECT * FROM {table_name} LIMIT 1000"))
            rows = [dict(row._mapping) for row in result]
            return {"data": rows}
    except SQLAlchemyError as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/execute")
async def execute_query(query: Dict[str, str]):
    try:
        engine = get_db_connection()
        with engine.connect() as connection:
            if query.get("database"):
                connection.execute(text(f"USE {query['database']}"))
            result = connection.execute(text(query["query"]))
            if result.returns_rows:
                return {"results": [dict(row._mapping) for row in result]}
            return {"results": []}
    except SQLAlchemyError as e:
        raise HTTPException(status_code=500, detail=str(e)) 