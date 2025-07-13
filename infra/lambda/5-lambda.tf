module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "8.0.1"

  function_name  = "${random_pet.this.id}-lambda-with-docker-build-from-ecr"
  create_package = false

  image_uri    = module.docker_build_lambda.image_uri
  package_type = "Image"
  
}
