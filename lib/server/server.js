import 'package:http/http.dart';
import 'dart:convert';

const express = require('express');
const bodyParser = require('body-parser');
const axios = require('axios');
const app = express();
app.use(bodyParser.json());

app.post('/api/pedidos', async (req, res) => {
  const pedido = req.body;
  // Salve no banco de dados aqui (SQLite, etc)

  // Envie para o WhatsApp Business API
  const accessToken = 'SEU_ACCESS_TOKEN';
  const phoneNumberId = 'SEU_PHONE_NUMBER_ID';
  const recipientNumber = '55XXXXXXXXXXX';
  const message = `
Pedido de Ladrilho:
Imagem: ${pedido.image}
Largura: ${pedido.width_cm} cm
Altura: ${pedido.height_cm} cm
Observações: ${pedido.notes}
  `;
  await axios.post(
    `https://graph.facebook.com/v19.0/${phoneNumberId}/messages`,
    {
      messaging_product: "whatsapp",
      to: recipientNumber,
      type: "text",
      text: { body: message }
    },
    { headers: { Authorization: `Bearer ${accessToken}` } }
  );

  res.json({ status: 'ok' });
});

app.listen(3000, () => console.log('API rodando na porta 3000'));