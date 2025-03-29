import { useState } from 'react';
import {
  Box,
  Card,
  CardContent,
  Typography,
  TextField,
  Button,
  Paper,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  CircularProgress,
  Alert,
} from '@mui/material';
import PlayArrowIcon from '@mui/icons-material/PlayArrow';
import axios from 'axios';

interface QueryResult {
  results: any[];
}

export default function QueryEditor() {
  const [query, setQuery] = useState('');
  const [results, setResults] = useState<any[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);

  const handleExecuteQuery = async () => {
    if (!query.trim()) return;

    setLoading(true);
    setError(null);
    setSuccess(null);

    try {
      const response = await axios.post<QueryResult>('http://localhost:8000/execute', {
        query: query.trim(),
      });
      setResults(response.data.results);
      if (response.data.results.length === 0) {
        setSuccess('Query executed successfully');
      }
    } catch (error: any) {
      setError(error.response?.data?.detail || 'Error executing query');
      setResults([]);
    } finally {
      setLoading(false);
    }
  };

  const renderResults = () => {
    if (results.length === 0) return null;

    const columns = Object.keys(results[0]);

    return (
      <TableContainer component={Paper} sx={{ mt: 2 }}>
        <Table size="small">
          <TableHead>
            <TableRow>
              {columns.map((column) => (
                <TableCell key={column} sx={{ fontWeight: 'bold' }}>
                  {column}
                </TableCell>
              ))}
            </TableRow>
          </TableHead>
          <TableBody>
            {results.map((row, index) => (
              <TableRow key={index}>
                {columns.map((column) => (
                  <TableCell key={column}>
                    {row[column] !== null ? String(row[column]) : 'NULL'}
                  </TableCell>
                ))}
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>
    );
  };

  return (
    <Box>
      <Typography variant="h4" gutterBottom>
        Query Editor
      </Typography>
      <Card>
        <CardContent>
          <Box sx={{ display: 'flex', flexDirection: 'column', gap: 2 }}>
            <TextField
              fullWidth
              multiline
              rows={6}
              variant="outlined"
              placeholder="Enter your SQL query..."
              value={query}
              onChange={(e) => setQuery(e.target.value)}
              sx={{
                fontFamily: 'monospace',
                '& .MuiOutlinedInput-root': {
                  fontFamily: 'monospace',
                },
              }}
            />
            <Box sx={{ display: 'flex', justifyContent: 'flex-end' }}>
              <Button
                variant="contained"
                color="primary"
                onClick={handleExecuteQuery}
                disabled={loading || !query.trim()}
                startIcon={loading ? <CircularProgress size={20} /> : <PlayArrowIcon />}
              >
                Execute Query
              </Button>
            </Box>
            {error && (
              <Alert severity="error" sx={{ mt: 2 }}>
                {error}
              </Alert>
            )}
            {success && (
              <Alert severity="success" sx={{ mt: 2 }}>
                {success}
              </Alert>
            )}
          </Box>
        </CardContent>
      </Card>
      {renderResults()}
    </Box>
  );
} 