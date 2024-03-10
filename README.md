# Rinha de Backend Q1 2024 - Ada

Projeto criado para participar da rinha de backend do Q1 2024.

## Tecnologias

- Ada
- Alire
- GNAT
- Nginx
- PostgreSQL

## Requisitos

- Docker

## Como rodar

```bash
docker-compose up
```

Como o comando acima pode demorar um pouco devido a compilação, é melhor rodar o comando abaixo:

```bash
docker-compose -f docker-compose.dev.yml up
```

A aplicação estará disponível para requisições na URL http://localhost:9999 com os seguintes endpoints:

```
GET /clientes/:id/extrato
```

```
POST /clientes/:id/transacoes

{
    "valor": 100000,
    "tipo" : "c",
    "descricao" : "descricao"
}
```
