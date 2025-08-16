/*import 'package:http/http.dart';
import 'dart:convert';

const express = require('express');
const bodyParser = require('body-parser');
const axios = require('axios');
const app = express();
app.use(bodyParser.json());

app.post('/api/pedidos', async (req, res) => {
  const pedido = req.body;
  // Salve no banco de dados aqui 

  // Envie para o WhatsApp Business API
  const accessToken = 'SEU_ACCESS_TOKEN';
  const phoneNumberId = '047992680847_ID'; // Substitua pelo seu ID de número de telefone
  const recipientNumber = '55XXXXXXXXXXX';
  const message = `
Pedido de Ladrilho:
Imagem: ${pedido.image}
Largura: ${pedido.width_cm} cm
Altura: ${pedido.height_cm} cm
Observações: ${pedido.notes}
  `;
  await axios.post(
    `https://wa.me/message/TH6UCYQCCKX7D1${phoneNumberId}/messages`, //Link whatsapp 
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
*/