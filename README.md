# Final DevOps Project

Цей проєкт демонструє повний цикл побудови інфраструктури та CI/CD пайплайну для розгортання Django-додатку в AWS. Використані сервіси: AWS (VPC, EKS, RDS, ECR), інструменти автоматизації Terraform, Helm, Jenkins, Argo CD, а також система моніторингу Prometheus + Grafana.  

Проєкт включає:  
- Розгортання інфраструктури через Terraform.  
- CI/CD пайплайн з Jenkins (CI) та Argo CD (CD).  
- Розгортання додатку Django у кластері Kubernetes (EKS).  
- Моніторинг через Prometheus та Grafana.  
- Автоматичне масштабування (HPA).  

---

## Інфраструктура

Інфраструктура будується у AWS та включає такі компоненти:  
- **VPC**: приватні та публічні підмережі, Internet Gateway, NAT Gateway.  
- **EKS**: кластер Kubernetes з робочими нодами.  
- **RDS/Aurora**: база даних для Django-додатку.  
- **ECR**: реєстр контейнерних образів.  
- **S3 + DynamoDB**: бекенд для збереження Terraform стейту.  
- **Jenkins**: CI для збірки та публікації образів.  
- **Argo CD**: GitOps інструмент для автоматичного розгортання.  
- **Prometheus + Grafana**: моніторинг та візуалізація метрик.  

---

## Структура проєкту

```
Project/
│
├── main.tf           # Основний файл підключення модулів
├── backend.tf        # Бекенд для Terraform (S3 + DynamoDB)
├── outputs.tf        # Загальні вихідні змінні
│
├── modules/          # Модулі Terraform
│   ├── s3-backend/   # S3 + DynamoDB для стейтів
│   ├── vpc/          # VPC і підмережі
│   ├── ecr/          # Репозиторії ECR
│   ├── eks/          # Кластер EKS
│   ├── rds/          # RDS/Aurora база даних
│   ├── jenkins/      # Jenkins через Helm
│   └── argo_cd/      # Argo CD через Helm
│
├── charts/           # Helm-чарти для застосунків
│   └── django-app/   # Чарт для Django-додатку
│
└── Django/           # Код додатку Django
    ├── app/          # Код застосунку
    ├── Dockerfile    # Docker-образ
    ├── Jenkinsfile   # CI пайплайн
    └── docker-compose.yaml  # Локальний запуск
```

---

## Покрокова інструкція виконання

### 1. Підготовка середовища
1. Клонувати репозиторій:
   ```bash
   git clone <repo_url>
   cd Project
   ```
2. Ініціалізувати Terraform:
   ```bash
   terraform init
   ```
3. Перевірити всі необхідні змінні у `terraform.tfvars` та у файлах `variables.tf`.

### 2. Розгортання інфраструктури
Виконати команду:
```bash
terraform apply
```

Після завершення перевірити стан ресурсів:
```bash
kubectl get all -n jenkins
kubectl get all -n argocd
kubectl get all -n monitoring
```

### 3. Перевірка доступності сервісів

- **Jenkins**
  ```bash
  kubectl port-forward svc/jenkins 8080:8080 -n jenkins
  ```
  Доступ: [http://localhost:8080](http://localhost:8080)

- **Argo CD**
  ```bash
  kubectl port-forward svc/argocd-server 8081:443 -n argocd
  ```
  Доступ: [http://localhost:8081](http://localhost:8081)

- **Grafana**
  ```bash
  kubectl port-forward svc/grafana 3000:80 -n monitoring
  ```
  Доступ: [http://localhost:3000](http://localhost:3000)

### 4. Моніторинг та HPA

- Переглянути метрики у Grafana Dashboard.
- Перевірити стан HPA:
  ```bash
  kubectl get hpa -n <namespace>
  ```

---

## CI/CD пайплайн

1. **Jenkins (CI)**:
   - Збирає Docker-образ Django-додатку.
   - Завантажує образ у **ECR**.

2. **Argo CD (CD)**:
   - Відстежує GitHub-репозиторій.
   - Автоматично оновлює додаток у EKS після пушу змін.

---


