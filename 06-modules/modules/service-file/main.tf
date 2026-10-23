resource "local_file" "this" {
  filename = "${path.root}/out/${var.name}.conf"
  content = <<EOT
name=${var.name}
port=${var.port}
public=${var.public}
EOT
}