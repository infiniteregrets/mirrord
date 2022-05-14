const express = require('express');
const process = require('process');
const app = express();
const PORT = 80;

const TEXT = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

app.get('/', (req, res) => {
    console.log(req.headers);
    res.send('Request received'); //TODO: Test when outgoing hooks are implemented
});  

app.post('/', (req, res) => {
    console.log(req.headers);
    req.on('data', (data) => {
        data.toString().includes(TEXT) ? process.exit(0) : process.exit(1);
    });
    req.on('end', () => {
        console.log('Request ended');
    });
});

app.put('/', (req, res) => {
    console.log(req.headers);
    req.on('data', (data) => {
        data.toString().includes(TEXT) ? process.exit(0) : process.exit(1);
    });
});

app.delete('/', (req, res) => {
    console.log(req.headers);
    res.send('Request received'); //TODO: Test when outgoing hooks are implemented
});

app.listen(PORT, () => {
    console.log(`Server listening on port ${PORT}`);
});

