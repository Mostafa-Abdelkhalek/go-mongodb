resource "aws_ecr_repository" "ecr_repo" {
  name = "go-app-repo"
  image_scanning_configuration {
    scan_on_push = true
  }
}