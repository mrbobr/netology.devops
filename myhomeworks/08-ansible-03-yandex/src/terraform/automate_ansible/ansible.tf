# Ожидание после разворачивания узлов
resource "null_resource" "wait" {
  provisioner "local-exec" {
    command = "sleep 60"
  }

  depends_on = [
    local_file.inventory
  ]
}

# Установка clickhouse
resource "null_resource" "clickhouse" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../ansible/playbook/inventory/prod.yml ../ansible/playbook/clickhouse.yml"
  }

  depends_on = [
    null_resource.wait
  ]
}

# Установка vector
resource "null_resource" "vector" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../ansible/playbook/inventory/prod.yml ../ansible/playbook/vector.yml"
  }

  depends_on = [
    null_resource.clickhouse
  ]
}

# Установка lighthouse
resource "null_resource" "lighthouse" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../ansible/playbook/inventory/prod.yml ../ansible/playbook/lighthouse.yml"
  }

  depends_on = [
    null_resource.vector
  ]
}
