variable codepipeline_role {}
variable codebuild_role {}
variable cf_role {}
variable "artifact_bucket_name" {}
variable "codepipeline_bucket_name" {}
variable "codecommit_repo_name" {}
variable "codebuild_project_name" {}
variable "aws_codepipeline_name" {}
variable "template_path_name" {}



resource "aws_s3_bucket" "artifact_s3_bucket" {
    bucket = var.artifact_bucket_name
}

output "artifact_bucket_name" {
    value = aws_s3_bucket.artifact_s3_bucket.bucket
}

resource "aws_s3_bucket" "codepipeline_s3_bucket" {
    bucket = var.codepipeline_bucket_name
}

output "codepipeline_bucket_name" {
    value = aws_s3_bucket.codepipeline_s3_bucket.bucket
}

resource "aws_codecommit_repository" "codecommit_repo" {
    repository_name = var.codecommit_repo_name
    description = "This is the CodeCommit repository for lambda functions."
    default_branch = "master"
}

resource "aws_codebuild_project" "codebuild_project" {
    name = var.codebuild_project_name
    service_role = var.codebuild_role
    
    environment {
        compute_type = "BUILD_GENERAL1_SMALL"
        image = "aws/codebuild/standard:2.0"
        type = "LINUX_CONTAINER"
    }

    source {
        type = "CODEPIPELINE"
    }

    artifacts {
        type = "CODEPIPELINE"
    }
}

resource "aws_codepipeline" "codepipeline" {
    name = var.aws_codepipeline_name
    role_arn = var.codepipeline_role

    artifact_store {
        type = "S3"
        location = aws_s3_bucket.artifact_s3_bucket.id
    }

    stage {
        name = "Source"
        action {
            name = "Source"
            category = "Source"
            owner = "AWS"
            provider = "CodeCommit"
            version = "1"
            output_artifacts = ["source"]
            run_order = 1

            configuration = {
                RepositoryName = aws_codecommit_repository.codecommit_repo.repository_name
                BranchName = aws_codecommit_repository.codecommit_repo.default_branch
            }
        }
    }

    stage {
        name = "Build"
        action {
            name = "Build"
            category = "Build"
            owner = "AWS"
            provider = "CodeBuild"
            input_artifacts = ["source"]
            output_artifacts = ["build"]
            version = "1"
            run_order = 2

            configuration = {
                ProjectName = aws_codebuild_project.codebuild_project.name
            }
        }
    }

    stage {
        name = "Deploy"

        action {
            name = "CreateChangeSet"
            version = "1"
            category = "Deploy"
            owner = "AWS"
            provider = "CloudFormation"
            input_artifacts = ["build"]
            role_arn = var.cf_role
            run_order = 3

            configuration = {
                ActionMode = "CHANGE_SET_REPLACE"
                StackName = "lambda-stack"
                ChangeSetName = "lambda-changeset"
                Capabilities  = "CAPABILITY_IAM"
                RoleArn       = var.cf_role
                TemplatePath  = "build::${var.template_path_name}"
            }
        }

        action {
            name = "DeployChangeSet"
            version = "1"
            category = "Deploy"
            owner = "AWS"
            provider = "CloudFormation"
            output_artifacts = ["cf_artifacts"]
            run_order = 4

            configuration = {
                ActionMode = "CHANGE_SET_EXECUTE"
                StackName = "lambda-stack"
                ChangeSetName = "lambda-changeset"
            }
      }
    }
}

