# acm-arn
resource "aws_ssm_parameter" "acm_arn" {
    name = "/${var.project}/${var.environment}/acm_arn"
    type = "String"
    value = aws_acm_certificate.jsprajampeta.arn
}