resource "shoreline_notebook" "low_disk_space_on_rabbitmq" {
  name       = "low_disk_space_on_rabbitmq"
  data       = file("${path.module}/data/low_disk_space_on_rabbitmq.json")
  depends_on = [shoreline_action.invoke_rabbitmq_queue_cleanup]
}

resource "shoreline_file" "rabbitmq_queue_cleanup" {
  name             = "rabbitmq_queue_cleanup"
  input_file       = "${path.module}/data/rabbitmq_queue_cleanup.sh"
  md5              = filemd5("${path.module}/data/rabbitmq_queue_cleanup.sh")
  description      = "Identify any messages or persistent messages that are being mismanaged and take action to resolve the issue (e.g., delete unnecessary messages, optimize message storage)."
  destination_path = "/agent/scripts/rabbitmq_queue_cleanup.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_rabbitmq_queue_cleanup" {
  name        = "invoke_rabbitmq_queue_cleanup"
  description = "Identify any messages or persistent messages that are being mismanaged and take action to resolve the issue (e.g., delete unnecessary messages, optimize message storage)."
  command     = "`chmod +x /agent/scripts/rabbitmq_queue_cleanup.sh && /agent/scripts/rabbitmq_queue_cleanup.sh`"
  params      = ["RABBITMQ_PASSWORD","RABBITMQ_PORT","RABBITMQ_HOST","RABBITMQ_USER"]
  file_deps   = ["rabbitmq_queue_cleanup"]
  enabled     = true
  depends_on  = [shoreline_file.rabbitmq_queue_cleanup]
}

