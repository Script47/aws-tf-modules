locals {
  output_dir  = "${path.root}/build/lambda/functions"
  output_path = "${local.output_dir}/${var.name}"
}

resource "null_resource" "create_build_dir" {
  provisioner "local-exec" {
    command = "mkdir -p ${local.output_dir}"
  }
}

data "archive_file" "func" {
  type        = "zip"
  source_dir  = var.src
  output_path = local.output_path
  depends_on = [null_resource.create_build_dir]
}