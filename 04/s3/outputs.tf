output "bucket_name" {
  description = "Имя созданного S3-бакета"
  value       = module.s3.bucket_name
}

output "bucket_domain_name" {
  description = "Доменное имя бакета"
  value       = module.s3.bucket_domain_name
}
