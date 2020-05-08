variable "shared-file-path" {
    type = string
    description = "Path of your AWS Credentials file"
}

variable "profile" {
    type = string
    description = "Name of the profile"
}

variable "region" {
    type = string
    description = "Region in which resources should be launched"
}

variable "artifact_bucket" {
    type = string
    description = "S3 bucket to store artifacts of codepipeline"
}

variable "codepipeline_bucket" {
    type = string
    description = "S3 bucket store codepipeline"
}

variable "codecommit_repo" {
    type = string
    description = "Name of the CodeCommit repository"
}

variable "codebuild_project" {
    type = string
    description = "Name of the CodeBuild project."
}

variable "codepipeline_name" {
    type = string
    description = "Name of the CodePipeline."
}

variable "template_path" {
    type = string
    description = "Name of the template file to deploy lambda function."
}









