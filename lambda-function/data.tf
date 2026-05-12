locals {
  output_dir  = "${path.root}/build/lambda/functions"
  output_path = "${local.output_dir}/${var.name}"
}

data "archive_file" "func" {
  type        = "zip"
  source_dir  = var.src
  output_path = local.output_path
}
