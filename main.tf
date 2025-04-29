data "aws_partition" "current" {}
data "aws_region" "current" {}
resource "aws_imagebuilder_image_recipe" "example" {

  component {
    component_arn = "arn:aws:imagebuilder:us-east-1:aws:component/docker-ce-linux/1.0.0/1"
  }

  name         = "example"
  parent_image = "arn:${data.aws_partition.current.partition}:imagebuilder:${data.aws_region.current.name}:aws:image/amazon-linux-2-x86/x.x.x"
  version      = "1.0.0"
}

resource "aws_imagebuilder_infrastructure_configuration" "example" {
  description                   = "example description"
  instance_profile_name         = aws_iam_instance_profile.example.name
  name                          = "example"
  terminate_instance_on_failure = true
}

resource "aws_imagebuilder_image_pipeline" "example" {
  image_recipe_arn                 = aws_imagebuilder_image_recipe.example.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.example.arn
  name                             = "example"

  schedule {
    schedule_expression = "cron(0 0 * * ? *)"
  }

  lifecycle {
    replace_triggered_by = [
      aws_imagebuilder_image_recipe.example
    ]
  }
}

resource "aws_s3_bucket" "this" {
  bucket = "empresa-setor-${var.name}"
  acl    = "private"

}