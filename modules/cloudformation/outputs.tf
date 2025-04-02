output "stackset_arn" {
  value = aws_cloudformation_stack_set.this.arn
  description = "value of the stackset arn"
}

output "stackset_id" {
  value = aws_cloudformation_stack_set.this.stack_set_id
  description = "value of the stackset id" 
}