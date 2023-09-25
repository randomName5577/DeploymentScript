const express = require('express');
const crypto = require('crypto');
const { exec } = require('child_process');
require('dotenv').config();

const app = express();
const port = 4000;

const secret = process.env.WEBHOOK_SECRET;

app.use(express.json({
    verify: (req, res, buf) => {
        req.githubSignature = req.get('X-Hub-Signature-256');
        req.payloadBuffer = buf;
    }
}));

app.post('/webhook', (req, res) => {
    const hmac = crypto.createHmac('sha256', secret);
    const digest = 'sha256=' + hmac.update(req.payloadBuffer).digest('hex');

    if (digest === req.githubSignature) {
        exec('./deploy.sh', (error, stdout, stderr) => {
            if (error) {
                console.error(`Exec error: ${error}`);
                return res.status(500).send('Internal Server Error');
            }
            console.log(`stdout: ${stdout}`);
            console.error(`stderr: ${stderr}`);
            res.status(200).send('OK');
        });
    } else {
        console.error('Received an unauthorized request.');
        res.status(403).send('Forbidden');
    }
});

app.listen(port, () => {
    console.log(`Webhook listener running at http://localhost:${port}`);
});

