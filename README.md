# Infrastructure as Code: Yandex Cloud + Ansible

Этот проект демонстрирует полный цикл автоматизации инфраструктуры (IaC):
от создания виртуальной машины в Yandex Cloud до настройки на ней веб-сервера.

## 🛠️ Стек технологий
*   **Terraform** (Provisioning: создание сети, ВМ, генерация инвентаря)
*   **Ansible** (Configuration Management: установка Nginx)
*   **Yandex Cloud** (Провайдер облака)
*   **Bash / Linux** (SSH, работа с ключами)

## 🚀 Как это работает
1. **Terraform** создает виртуальную машину с Ubuntu 22.04 в Yandex Cloud.
2. Terraform использует `local_file` для автоматической генерации `inventory.ini` с актуальным IP-адресом созданной ВМ.
3. **Ansible** читает `inventory.ini`, подключается к машине по SSH и устанавливает Nginx.

## 📁 Структура проекта
*   `main.tf` — конфигурация Terraform (провайдер, образ, ВМ, генерация inventory).
*   `variables.tf` — переменные (имя ВМ, зона).
*   `playbook-nginx.yml` — плейбук Ansible для установки Nginx.
*   `ansible.cfg` — конфигурация Ansible (отключение проверки ключей для новых хостов).

## ⚙️ Быстрый старт
1. Установите Terraform и Ansible.
2. Настройте доступ к Yandex Cloud (создайте сервисный аккаунт и `key.json`).
3. Выполните `terraform init` и `terraform apply`.
4. Запустите настройку: `ansible-playbook -i inventory.ini playbook-nginx.yml`.
5. После проверки удалите ресурсы: `terraform destroy` (чтобы не тратить грант).

## ⚠️ Безопасность
Файлы с секретами (`key.json`, `*.tfstate`) добавлены в `.gitignore` и не попадают в репозиторий.
