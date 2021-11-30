#!/bin/sh

if [ -z "$AWS_PROFILE" ]; then
  echo "ERRO: Faltando AWS_PROFILE" >&2
  exit 1
fi

export AWS_ACCESS_KEY_ID=$(aws configure get --profile "${AWS_PROFILE}" aws_access_key_id)
export AWS_SECRET_ACCESS_KEY=$(aws configure get --profile "${AWS_PROFILE}" aws_secret_access_key)
export AWS_SESSION_TOKEN=$(aws configure get --profile "${AWS_PROFILE}" aws_session_token)
export AWS_DEFAULT_REGION=$(aws configure get --profile "${AWS_PROFILE}" region)

if [ -z "$AWS_DEFAULT_REGION" ]; then
  AWS_DEFAULT_REGION="us-east-1"
  printf 'AVISO: Assumindo região padrão "%s".' "$AWS_DEFAULT_REGION" >&2
fi

if [ -z "$AWS_ACCESS_KEY_ID" ]; then
  printf 'ERRO: Faltando "aws_access_key_id" no profile "%s".\n' "$AWS_PROFILE" >&2
  exit 1
fi

if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
  printf 'ERRO: Faltando "aws_secret_access_key" no profile "%s".\n' "$AWS_PROFILE" >&2
  exit 1
fi

exec terraform "$@"
