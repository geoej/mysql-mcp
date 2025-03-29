import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    MYSQL_USER = os.getenv("MYSQL_USER", "root")
    MYSQL_PASSWORD = os.getenv("MYSQL_PASSWORD", "")
    MYSQL_HOST = os.getenv("MYSQL_HOST", "localhost")
    MYSQL_PORT = os.getenv("MYSQL_PORT", "3306")
    CORS_ORIGINS = os.getenv("CORS_ORIGINS", "*").split(",")

class DevelopmentConfig(Config):
    DEBUG = True

class ProductionConfig(Config):
    DEBUG = False
    # In production, specify exact CORS origins
    CORS_ORIGINS = os.getenv("CORS_ORIGINS", "http://your-domain.com").split(",")

# Select config based on environment
config = ProductionConfig() if os.getenv("ENV") == "production" else DevelopmentConfig() 