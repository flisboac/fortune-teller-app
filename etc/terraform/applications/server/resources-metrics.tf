# Lista de métricas: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/viewing_metrics_with_cloudwatch.html

resource "aws_cloudwatch_metric_alarm" "main_cpu" {
  alarm_name = "${module.environment.common_base_name}.ec2.cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "80"
  alarm_description = "Monitorar alto uso prolongado de CPU"
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "main_status" {
  alarm_name = "${module.environment.common_base_name}.ec2.status_failed"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "3"
  metric_name = "StatusCheckFailed"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "SampleCount"
  threshold = "2"
  alarm_description = "Monitorar health status da instancia"
  insufficient_data_actions = []
}

# Para monitorar memória, é necessário instalar um agente do CloudWatch dentro da VM.locals {
# Não tive tempo para realizar esta parte do desafio.
