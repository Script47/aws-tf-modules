resource "aws_lambda_layer_version" "layer" {
  layer_name               = var.name
  description              = var.description
  compatible_architectures = var.architectures
  compatible_runtimes      = var.runtimes

  filename         = data.archive_file.layer.output_path
  source_code_hash = data.archive_file.layer.output_base64sha256
}