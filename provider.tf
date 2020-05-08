provider "aws" {
	region = var.region
	shared_credentials_file = var.shared-file-path
	profile = var.profile
}