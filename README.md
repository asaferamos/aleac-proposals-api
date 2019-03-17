# ALEAC Matérias Legislativas - API
API que realiza o parsa do site da Assembleia Legislativa do Estado do Acre, utilizando Ruby on Rails

### Demo:
[![Deploy](https://img.shields.io/badge/demo--prod-heroku-430098.svg)](https://aleac-parser-api.herokuapp.com/)

### Developing
#### Com Docker:
```
sudo docker-compose up --build
sudo docker exec -it aleac_api rails db:migrate
```

Endereço: `http://localhost:3000`

#### Rodando sem docker:
```
bundle install
rails server -b 0.0.0.0
rails db:migrate
```

#### Testes

#### Endpoints:
|method|endpoint|request|response|
|--|--|--|--|
| POST | `/users` | `{name,email,password}`|`true` | `false`
| GET | `/auth/login/` |`{email,password}`|`{token,exp,name}`
| GET | `/proposal/:id` |`{id}`| json |
| POST | `/proposal/:id` |`{id}`|`true`
| DELETE | `/proposal/:id` |`{id}`|`true`


#### Retorno do endpoint de busca de proposição `GET /proposal/:id`

```
{
    "ext_id": "4059",
    "authors": [
        "Governo - Governador"
    ],
    "kind": "Projeto de Lei",
    "number": "201",
    "year": "2013",
    "status": "Aprovado",
    "description": "DISPÕE SOBRE A DOAÇÃO E A VENDA DE ÁREAS DE DOMÍNIO DA ADMINISTRAÇÃO PÚBLICA DIRETA E INDIRETA, PARA EFEITO DE REGULARIZAÇÃO FUNDIÁRIA DE INTERESSE SOCIAL.",
    "steps": [
        [
            "2013-12-19",
            "SAL",
            "Enviado para PE: Aprovado"
        ],
        [
            "2013-12-17",
            "SAL",
            "Enviado para SAL: Distribuição às Comissões Tematicas"
        ]
    ],
    "link": "https://sapl.al.ac.leg.br/media/sapl/public/materialegislativa/2013/4059/4059_texto_integral.pdf",
    "introduction_date": "2013-12-17",
    "saved": true
}
```

#### Testes
Com Docker: ```sudo docker exec -it aleac_api rspec spec/controllers/bills_controller_spec.rb```

Sem Docker: ```rspec spec/controllers/bills_controller_spec.rb```
