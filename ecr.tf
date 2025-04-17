resource "aws_ecr_repository" "ecr_repo" {
  name = var.ECR_repository_name
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository_policy" "ecr_repo_policy" {
  repository = aws_ecr_repository.ecr_repo.name

  policy = jsonencode({
    Version = "2008-10-17",
    Statement = [{
      Sid       = "AllowPull"
      Effect    = "Allow"
      Principal = "*"
      Action    = "ecr:GetDownloadUrlForLayer"
    }]
  })
}

# Build Docker image
resource "null_resource" "docker_build" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "docker build -t ${aws_ecr_repository.ecr_repo.repository_url}:latest ."
  }
}

# Get Amazon ECR authorization token
data "aws_ecr_authorization_token" "current" {}

# Push Docker image to ECR
resource "null_resource" "docker_push" {
  depends_on = [null_resource.docker_build]

  provisioner "local-exec" {
    command = <<-EOT
      docker login -u AWS -p $(aws ecr get-login-password --region ${var.region}) ${aws_ecr_repository.ecr_repo.repository_url} && docker push ${aws_ecr_repository.ecr_repo.repository_url}:latest
    EOT
  }
}
