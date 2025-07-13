resource "random_pet" "this" {
  length = 2
}

module "docker_build_ecr" {
  source  = "terraform-aws-modules/lambda/aws//modules/docker-build"
  version = "8.0.1"

  create_ecr_repo = true
  ecr_repo        = "${random_pet.this.id}-ecr"

  use_image_tag = true
  image_tag     = "0.1"

  source_path      = var.docker_source_path
  docker_file_path = var.docker_file_path

  platform = "linux/amd64"
}
