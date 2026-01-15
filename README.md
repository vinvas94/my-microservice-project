# CI/CD для Django у Kubernetes з Jenkins, Terraform та Argo CD

Цей проєкт демонструє повний цикл безперервної інтеграції та доставки (CI/CD) для Django-застосунку з використанням **Jenkins**, **Terraform**, **Helm** і **Argo CD**.  
Мета — забезпечити швидке, стабільне та передбачуване розгортання нових версій застосунку без ручних втручань.

---

## Архітектура

- **Terraform** — автоматизоване створення інфраструктури в AWS (VPC, EKS, ECR, S3, DynamoDB).  
- **Jenkins** — CI-сервер для збирання Docker-образів і оновлення Helm-чартів.  
- **Docker + Kaniko** — збірка контейнерів без Docker-демона.  
- **Helm** — управління Kubernetes-ресурсами.  
- **Argo CD** — GitOps-інструмент для безперервного розгортання.  

---

## Як розгорнути

### 1. Створити інфраструктуру
```bash
cd lesson-8-9
terraform init
terraform apply --auto-approve
```

### 2. Отримати доступ до кластеру EKS
```bash
aws eks --region <your-region> update-kubeconfig --name <cluster-name>
```

### 3. Jenkins та Argo CD
- URL Jenkins і Argo CD доступні у виводі `terraform output`.
- Отримати пароль адміністратора:
```bash
kubectl get secret -n jenkins jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode
```

---

## CI/CD-процес

1. **Jenkins**:
   - Клонує код із гілки `lesson-8-9`.
   - Збирає Docker-образ за допомогою Kaniko.
   - Публікує образ у ECR.
   - Оновлює тег образу у Helm-чарті та пушить зміни у Git.

2. **Argo CD**:
   - Автоматично відслідковує зміни у репозиторії.
   - Синхронізує стан кластера з Helm-чартом.
   - Розгортає нову версію застосунку.

---

## Видалення інфраструктури
Щоб уникнути зайвих витрат:
```bash
terraform destroy --auto-approve
```