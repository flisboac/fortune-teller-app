# fortune-teller

## Deploy

```sh
export AWS_PROFILE=NOME_DO_SEU_PROFILE_AWS

./terraform.sh workspace new NOME_AMBIENTE_EXECUCAO
./terraform.sh init
./terraform.sh apply --auto-approve
```

`NOME_DO_SEU_PROFILE_AWS` é o nome de um profile AWS previamente configurado (i.e. `aws configure`).

`NOME_AMBIENTE_EXECUCAO` pode ser um de três valores:

- **`dev`** Ambiente de Desenvolvimento/Testes
- **`stg`** Ambiente de Homologação
- **`prd`** Ambiente de Produção

Não há nenhum recurso diferente, ou tratamento exclusivo por ambiente; o nome do ambiente de execução apenas ajuda a construir os nomes dos recursos.

A URL do app pode ser obtida via comando `terraform output`.

Caso seja necessário fazer SSH para as máquinas criadas, as chaves privadas estarão na pasta `local/NOME_AMBIENTE_EXECUCAO/keys/NOME_MAQUINA_EC2` (à partir da pasta-raíz do projeto).
