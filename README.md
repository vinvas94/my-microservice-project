# Terraform-модуль RDS/Aurora

Модуль створює **RDS** або **Aurora** залежно від прапора `use_aurora`.  
Автоматично піднімає Subnet Group, Security Group і Parameter Group.

---

## Приклад використання

```hcl
module "rds" {
  source = "./modules/rds"

  name                  = "myapp-db"
  use_aurora            = true
  aurora_instance_count = 2

  engine_cluster            = "aurora-postgresql"
  engine_version_cluster    = "15.3"
  parameter_group_family_aurora = "aurora-postgresql15"

  instance_class        = "db.t3.medium"
  db_name               = "mydb"
  username              = "admin"
  password              = "securepassword123"

  vpc_id                = "vpc-123456"
  subnet_private_ids    = ["subnet-aaa111", "subnet-bbb222"]

  publicly_accessible   = false
  multi_az              = true
}


## Змінні

| Змінна                                      | Опис                    | Default       |
| ------------------------------------------- | ----------------------- | ------------- |
| `use_aurora`                                | Aurora чи RDS           | false         |
| `name`                                      | Назва інстансу/кластера | ""            |
| `db_name`                                   | Назва бази              | ""            |
| `username` / `password`                     | Доступ до БД            | ""            |
| `instance_class`                            | Клас інстансу           | db.t3.micro   |
| `engine` / `engine_version`                 | Тип і версія для RDS    | postgres / "" |
| `engine_cluster` / `engine_version_cluster` | Тип і версія для Aurora | ""            |
| `vpc_id`                                    | ID VPC                  | ""            |
| `subnet_private_ids`                        | Приватні сабнети        | []            |
| `publicly_accessible`                       | Доступ з інтернету      | false         |
| `multi_az`                                  | Multi-AZ                | false         |

---

## Outputs

- `rds_endpoint` — кінцева точка БД  
- `rds_arn` — ARN ресурсу  
- `security_group_id` — SG БД  

---

## Як змінити тип БД

- **Aurora ↔ RDS:** змініть `use_aurora`  
- **Тип БД:**  
  - RDS → `engine` + `engine_version`  
  - Aurora → `engine_cluster` + `engine_version_cluster`  
- **Multi-AZ:** `multi_az = true`  
- **Клас інстансу:** змінити `instance_class`  
