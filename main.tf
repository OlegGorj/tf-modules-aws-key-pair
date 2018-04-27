###############################################################################
# variables
###############################################################################

variable "namespace" {
  type        = "string"
  description = "Namespace"
}

variable "stage" {
  type        = "string"
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
}

variable "name" {
  type        = "string"
  description = "Application or solution name (e.g. `app`)"
}

variable "delimiter" {
  type        = "string"
  default     = "-"
  description = "Delimiter to be used between `namespace`, `stage`, `name` and `attributes`"
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

variable "ssh_public_key_path" {
  type        = "string"
  description = "Path to SSH public key directory (e.g. `/secrets`)"
}

variable "generate_ssh_key" {
  default     = "false"
  description = "If set to `true`, new SSH key pair will be created"
}

variable "ssh_key_algorithm" {
  type        = "string"
  default     = "RSA"
  description = "SSH key algorithm"
}

variable "private_key_extension" {
  type        = "string"
  default     = ""
  description = "Private key extension"
}

variable "public_key_extension" {
  type        = "string"
  default     = ".pub"
  description = "Public key extension"
}

variable "chmod_command" {
  type        = "string"
  default     = "chmod 600 %v"
  description = "Template of the command executed on the private key file"
}

###############################################################################
# RESOURCES
###############################################################################

locals {
  public_key_filename  = "${var.ssh_public_key_path}/${var.name}${var.public_key_extension}"
  private_key_filename = "${var.ssh_public_key_path}/${var.name}${var.private_key_extension}"
}

resource "aws_key_pair" "imported" {
  count      = "${var.generate_ssh_key == "false" ? 1 : 0}"
  key_name   = "${var.name}"
  public_key = "${file("${local.public_key_filename}")}"
}

resource "tls_private_key" "default" {
  count     = "${var.generate_ssh_key == "true" ? 1 : 0}"
  algorithm = "${var.ssh_key_algorithm}"
}

resource "aws_key_pair" "generated" {
  count      = "${var.generate_ssh_key == "true" ? 1 : 0}"
  depends_on = ["tls_private_key.default"]
  key_name   = "${var.name}"
  public_key = "${tls_private_key.default.public_key_openssh}"
}

resource "local_file" "public_key_openssh" {
  count      = "${var.generate_ssh_key == "true" ? 1 : 0}"
  depends_on = ["tls_private_key.default"]
  content    = "${tls_private_key.default.public_key_openssh}"
  filename   = "${local.public_key_filename}"
}

resource "local_file" "private_key_pem" {
  count      = "${var.generate_ssh_key == "true" ? 1 : 0}"
  depends_on = ["tls_private_key.default"]
  content    = "${tls_private_key.default.private_key_pem}"
  filename   = "${local.private_key_filename}"
}

resource "null_resource" "chmod" {
  count      = "${var.generate_ssh_key == "true" && var.chmod_command != "" ? 1 : 0}"
  depends_on = ["local_file.private_key_pem"]

  provisioner "local-exec" {
    command = "${format(var.chmod_command, local.private_key_filename)}"
  }
}


###############################################################################
# RESOURCES
###############################################################################


output "key_name" {
  value = "${element(compact(concat(aws_key_pair.imported.*.key_name, aws_key_pair.generated.*.key_name)), 0)}"
}

output "public_key" {
  value = "${join("", tls_private_key.default.*.public_key_openssh)}"
}
