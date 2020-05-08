module "pipeline-roles" {
	source = "./modules/roles-policies-resources"
    aws_codepipeline_name = var.codepipeline_name
}

output "cf_role" {
    value = module.pipeline-roles.cf_role
}

output "codepipeline_role" {
    value = module.pipeline-roles.codepipeline_role
}

output "codebuild_role" {
    value = module.pipeline-roles.codebuild_role
}

module "pipeline" {
	source = "./modules/aws-services-resources"
	cf_role = module.pipeline-roles.cf_role
	codepipeline_role = module.pipeline-roles.codepipeline_role
	codebuild_role = module.pipeline-roles.codebuild_role
    aws_codepipeline_name = var.codepipeline_name
    artifact_bucket_name = var.artifact_bucket
    codepipeline_bucket_name = var.codepipeline_bucket
    codecommit_repo_name = var.codecommit_repo
    codebuild_project_name = var.codebuild_project
    template_path_name = var.template_path
}
