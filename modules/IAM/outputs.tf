output "NODE_GROUP_ROLE_ARN" {
    value = aws_iam_role.node_group.arn
  
}
output "EKS_CLUSTER_ROLE_ARN" {
    value = aws_iam_role.eks_role.arn
  
}


