output "lb_public_ip" {
  value = aws_instance.lb.public_ip
}

output "web1_public_ip" {
  value = aws_instance.web1.public_ip
}

output "web2_public_ip" {
  value = aws_instance.web2.public_ip
}

output "web1_private_ip" {
  value = aws_instance.web1.private_ip
}

output "web2_private_ip" {
  value = aws_instance.web2.private_ip
}

output "ansible_inventory_snippet" {
  value = <<EOT
[lb]
lb-01 ansible_host=${aws_instance.lb.public_ip}

[web]
web-01 ansible_host=${aws_instance.web1.public_ip} private_ip=${aws_instance.web1.private_ip}
web-02 ansible_host=${aws_instance.web2.public_ip} private_ip=${aws_instance.web2.private_ip}
EOT
}
