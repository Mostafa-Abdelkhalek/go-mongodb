resource "aws_eks_cluster" "demo" {
  name     = "demo"
  role_arn = aws_iam_role.eks-role.arn

  vpc_config {
    subnet_ids = [aws_subnet.private.id,aws_subnet.public.id]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.role1-policy-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.role2-policy-AmazonEKSVPCResourceController,
  ]
}

output "endpoint" {
  value = aws_eks_cluster.demo.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.demo.certificate_authority[0].data
}
resource "aws_eks_node_group" "demo-node" {
  cluster_name    = aws_eks_cluster.demo.name
  node_group_name = "demo-node"
  node_role_arn   = aws_iam_role.node-role.arn
  subnet_ids      = [ aws_subnet.private.id , aws_subnet.public.id ]
  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.small"]
  

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.role3-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.role4-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.role5-AmazonEC2ContainerRegistryReadOnly,
  ]
}