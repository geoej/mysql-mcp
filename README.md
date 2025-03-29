# MySQL MCP (Management Control Panel)

A modern web-based MySQL database management tool that allows you to interact with your local MySQL databases.

## Features

- Connect to local MySQL databases
- View and manage database schemas
- Execute SQL queries
- Browse and edit table data
- User-friendly interface

## Prerequisites

- Python 3.8+
- MySQL Server installed locally
- Node.js 16+ (for frontend development)

## Setup

1. Create a virtual environment and activate it:
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

2. Install Python dependencies:
```bash
pip install -r requirements.txt
```

3. Create a `.env` file in the root directory with your MySQL credentials:
```
MYSQL_USER=your_username
MYSQL_PASSWORD=your_password
MYSQL_HOST=localhost
MYSQL_PORT=3306
```

4. Start the backend server:
```bash
uvicorn app.main:app --reload
```

5. Start the frontend development server:
```bash
cd frontend
npm install
npm run dev
```

The application will be available at:
- Backend API: http://localhost:8000
- Frontend: http://localhost:5173

## API Documentation

Once the server is running, you can access the API documentation at:
- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc 