# Значения для Задания 6*: целевые ВМ без внешнего IP (доступ через bastion),
# поднимается bastion, запускается ansible-playbook.
# Применение:  terraform apply -var-file=task6.tfvars
enable_nat     = false
enable_bastion = true
web_provision  = true
