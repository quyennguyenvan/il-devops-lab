#create the iam role for monitoring
resource "aws_iam_policy" "rds_enhance_policy" {
  name = "rds-enhanced-monitoring-policy"
  policy = file("./policies/policy_monitoring_rds.json")
}
resource "aws_iam_role" "iam_monitoring_interval_rds" {
  name = "enhanced-monitoring-rds-instance-role"
  path = "/"
  description = "Allow the monitoring enhance of rds instance"
  max_session_duration = 3600 #one hours
  assume_role_policy = file("./policies/trusted_rds_policy.json")
  tags = var.tags
}
resource "aws_iam_role_policy_attachment" "role_rds_monitoring_attachment_policy" {
  role = aws_iam_role.iam_monitoring_interval_rds.name
  policy_arn = aws_iam_policy.rds_enhance_policy.arn
}

#create the kms role
data "template_file" "kms_template_policy" {
  template = file("./policies/key_kms_grant.json")
  vars = {
        username = "quyennvcom-admin" #replace the current user by your user on your cloud account
  }
}
resource "aws_iam_policy" "ksm_policy_grant" {
    name = "kms-grant-policy"
    policy = data.template_file.kms_template_policy.rendered
}
resource "aws_iam_role" "iam_cks_kms_role" {
  name = "customer-managed-key-role"
  path = "/"
  description = "Allow the users can managed the cks"
  max_session_duration = 3600 #one hours
  assume_role_policy = file("./policies/trusted_kms.json")
  tags = var.tags
}
resource "aws_iam_role_policy_attachment" "role_kms_attachment_policy" {
  role = aws_iam_role.iam_cks_kms_role.name
  policy_arn = aws_iam_policy.ksm_policy_grant.arn
}
#create the kms key
resource "aws_kms_key" "kms_db_key" {
    description = "The kms key for rds perfomance insight"
    key_usage = "ENCRYPT_DECRYPT"
    customer_master_key_spec = "RSA_2048"
    is_enabled = true
    enable_key_rotation = false
    deletion_window_in_days = 7
    tags = var.tags
}
resource "aws_kms_alias" "kms_alias_name" {
    name = "alias/ksm_app_db"
    target_key_id = aws_kms_key.kms_db_key.id
}
resource "aws_kms_grant" "kms_grant_permission" {
  name = "user-admin-grant-for-managed"
  key_id = aws_kms_key.kms_db_key.key_id
  grantee_principal = aws_iam_role.iam_cks_kms_role.arn
  operations = [ "Encrypt", "Decrypt"]
}

#create the dev member
resource "aws_iam_policy" "dev_member_policy" {
  name = "dev-member-access-permission"
  policy = file("./policies/user/dev-policy.json")
}

resource "aws_iam_user" "dev_member" {
  name = "app-user-dev"
  path = "/"
}
resource "aws_iam_user_policy_attachment" "iam_user_dev_policy_attach" {
  user = aws_iam_user.dev_member.name
  policy_arn = aws_iam_policy.dev_member_policy.arn
}