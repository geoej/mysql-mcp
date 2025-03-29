import { useState, useEffect } from 'react';
import {
  Box,
  Card,
  CardContent,
  Typography,
  List,
  ListItem,
  ListItemText,
  ListItemButton,
  Collapse,
  IconButton,
  CircularProgress,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Paper,
} from '@mui/material';
import ExpandLess from '@mui/icons-material/ExpandLess';
import ExpandMore from '@mui/icons-material/ExpandMore';
import axios from 'axios';

interface Database {
  name: string;
  tables: string[];
}

interface TableData {
  data: Record<string, any>[];
}

export default function DatabaseList() {
  const [databases, setDatabases] = useState<string[]>([]);
  const [expandedDatabase, setExpandedDatabase] = useState<string | null>(null);
  const [databaseDetails, setDatabaseDetails] = useState<Record<string, Database>>({});
  const [loading, setLoading] = useState(true);
  const [selectedTable, setSelectedTable] = useState<string | null>(null);
  const [tableData, setTableData] = useState<TableData | null>(null);
  const [selectedDatabase, setSelectedDatabase] = useState<string | null>(null);

  useEffect(() => {
    fetchDatabases();
  }, []);

  const fetchDatabases = async () => {
    try {
      const response = await axios.get('http://localhost:8000/databases');
      setDatabases(response.data);
      setLoading(false);
    } catch (error) {
      console.error('Error fetching databases:', error);
      setLoading(false);
    }
  };

  const handleDatabaseClick = async (databaseName: string) => {
    if (expandedDatabase === databaseName) {
      setExpandedDatabase(null);
      setSelectedDatabase(null);
      setSelectedTable(null);
      setTableData(null);
      return;
    }

    try {
      const response = await axios.get(`http://localhost:8000/database/${databaseName}`);
      setDatabaseDetails(prev => ({
        ...prev,
        [databaseName]: response.data
      }));
      setExpandedDatabase(databaseName);
      setSelectedDatabase(databaseName);
    } catch (error) {
      console.error('Error fetching database details:', error);
    }
  };

  const handleTableClick = async (tableName: string) => {
    if (!selectedDatabase) return;
    
    setSelectedTable(tableName);
    try {
      const response = await axios.get(`http://localhost:8000/table/${selectedDatabase}/${tableName}`);
      setTableData(response.data);
    } catch (error) {
      console.error('Error fetching table data:', error);
      setTableData(null);
    }
  };

  const renderTableData = () => {
    if (!tableData || !tableData.data || tableData.data.length === 0) return null;

    const columns = Object.keys(tableData.data[0]);

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
            {tableData.data.map((row, index) => (
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

  if (loading) {
    return (
      <Box display="flex" justifyContent="center" alignItems="center" minHeight="200px">
        <CircularProgress />
      </Box>
    );
  }

  return (
    <Box>
      <Typography variant="h4" gutterBottom>
        Databases
      </Typography>
      <Box display="flex" gap={2}>
        <Card sx={{ minWidth: 300 }}>
          <CardContent>
            <List>
              {databases.map((database) => (
                <Box key={database}>
                  <ListItem
                    secondaryAction={
                      <IconButton edge="end" onClick={() => handleDatabaseClick(database)}>
                        {expandedDatabase === database ? <ExpandLess /> : <ExpandMore />}
                      </IconButton>
                    }
                  >
                    <ListItemButton onClick={() => handleDatabaseClick(database)}>
                      <ListItemText primary={database} />
                    </ListItemButton>
                  </ListItem>
                  <Collapse in={expandedDatabase === database} timeout="auto" unmountOnExit>
                    <List component="div" disablePadding>
                      {databaseDetails[database]?.tables.map((table) => (
                        <ListItem key={table} sx={{ pl: 4 }}>
                          <ListItemButton onClick={() => handleTableClick(table)}>
                            <ListItemText 
                              primary={table} 
                              sx={{
                                color: selectedTable === table ? 'primary.main' : 'inherit',
                                fontWeight: selectedTable === table ? 'bold' : 'normal',
                              }}
                            />
                          </ListItemButton>
                        </ListItem>
                      ))}
                    </List>
                  </Collapse>
                </Box>
              ))}
            </List>
          </CardContent>
        </Card>
        <Box flexGrow={1}>
          {selectedTable && (
            <Card>
              <CardContent>
                <Typography variant="h6" gutterBottom>
                  {selectedTable}
                </Typography>
                {renderTableData()}
              </CardContent>
            </Card>
          )}
        </Box>
      </Box>
    </Box>
  );
} 