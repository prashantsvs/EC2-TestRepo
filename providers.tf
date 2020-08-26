provider "aws" {
	region = "us-east-1"
	profile = "prashant-credential"
}

provider "github" {
  token        = "a4b2344..."
  organization = "terraform-cg"
}