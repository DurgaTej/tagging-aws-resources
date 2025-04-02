https://docs.google.com/document/d/18anIrcTheBe4tfwCbu8kr91EpHfNgvpoJrwYFYYuwMQ/edit?usp=sharing

I checked your GitHub repository: tagging-aws-resources. Since you're using Terraform modules to manage CloudFormation StackSets, you need to structure your dependencies properly.

Steps to Ensure Proper StackSet Order
1️⃣ Modify main.tf to Enforce Dependencies
Your main.tf should follow this order:

IAM Role StackSet (creates the role ARN)
Lambda StackSet (references the IAM role ARN)
AWS Config StackSet (references the Lambda ARN)
Modify your main.tf to reflect this:

hcl
Copy
Edit
module "iam_role_stackset" {
  source        = "./modules/cloudformation"
  stackset_name = "iam-role-stackset"
  template_file = "stackset-templates/iam-role.yml"
}

module "lambda_stackset" {
  source        = "./modules/cloudformation"
  stackset_name = "lambda-stackset"
  template_file = "stackset-templates/lambda.yml"
  
  parameters = {
    ConfigLambdaRoleARN = module.iam_role_stackset.outputs["IAMRoleARN"]
  }

  depends_on = [module.iam_role_stackset]
}

module "aws_config_stackset" {
  source        = "./modules/cloudformation"
  stackset_name = "aws-config-stackset"
  template_file = "stackset-templates/aws-config.yml"
  
  parameters = {
    LambdaFunctionARN = module.lambda_stackset.outputs["LambdaFunctionARN"]
  }

  depends_on = [module.lambda_stackset]
}
2️⃣ Modify modules/cloudformation/main.tf to Output Required Values
In modules/cloudformation/main.tf, add outputs for the IAM Role ARN and Lambda ARN.

hcl
Copy
Edit
output "IAMRoleARN" {
  value = aws_cloudformation_stack_set.this.outputs["IAMRoleARN"]
}

output "LambdaFunctionARN" {
  value = aws_cloudformation_stack_set.this.outputs["LambdaFunctionARN"]
}
3️⃣ Ensure IAM Role StackSet Outputs the ARN
Modify your IAM Role StackSet YAML (stackset-templates/iam-role.yml) to output the ARN:

yaml
Copy
Edit
Outputs:
  IAMRoleARN:
    Description: "IAM Role ARN for Lambda Execution"
    Value: !GetAtt IAMRole.Arn
    Export:
      Name: !Sub "${AWS::StackName}-IAMRoleARN"
4️⃣ Ensure Lambda StackSet Outputs the ARN
Modify your Lambda StackSet YAML (stackset-templates/lambda.yml) to output the Lambda ARN:

yaml
Copy
Edit
Outputs:
  LambdaFunctionARN:
    Description: "ARN of the AWS Config validation Lambda function"
    Value: !GetAtt ConfigValidationLambda.Arn
    Export:
      Name: !Sub "${AWS::StackName}-LambdaFunctionARN"
Now, When You Run terraform apply
IAM Role StackSet deploys first.
Lambda StackSet waits for IAM Role ARN and then deploys.
AWS Config StackSet waits for Lambda ARN and then deploys.
This guarantees proper dependency resolution. 🚀

Let me know if you need further refinements! 🔥
