# aws-codepipeline
AWS CodePipeline to publish and deploy lambda function.

Creates an AWS CodePipeline using CodeCommit, CodeBuild, and CloudFormation that automates the deployment of serverless applications.

It has 3 stages:
    Source(CodeCommit)
    Build(CodeBuild)
    Deploy(CloudFormation)

After creating the pipeline successfully, any git push to the CodeCommit branch connected to this pipeline is going to trigger a deployment.

Steps to create a pipeline by executing the terraform scripts.
1. Download the zip file of the code. Extract it to your local directory.
2. On command-line, go to the directory in which terraform files reside.
3. Run the "terraform init" command.
4. Put the valid values in "terraform.tfvars" file.
5. Run "terraform plan" on the command-line.
6. Review new or updated resources.
7. If everything is okay in the plan, then run "terraform apply."
8. You should see Apply Complete message with arn of roles created along with pipeline.