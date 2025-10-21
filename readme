# 🌐 Terraform AWS VPC + EC2 + Load Balancer Deployment

Este proyecto utiliza **Terraform** para aprovisionar una infraestructura completa en AWS. Incluye una VPC personalizada, subredes públicas y privadas, instancias EC2, grupos de seguridad, un balanceador de carga (ALB) y automatización de servicios con NGINX.

---

## 🚀 Descripción del Proyecto

La infraestructura provisionada incluye:

- VPC personalizada usando el módulo oficial `terraform-aws-modules/vpc`
- Subredes públicas y privadas distribuidas en hasta 3 zonas de disponibilidad
- Instancias EC2 públicas y privadas (autoescalables con `count`)
- Configuración de NGINX automática en instancias privadas
- Balanceador de carga (ALB) apuntando a instancias privadas
- Clave SSH generada automáticamente con `tls_private_key`
- Configuración de `LocalStack` para pruebas locales de servicios AWS

---

## 🧰 Tecnologías Utilizadas

- Terraform v1.x
- AWS (EC2, VPC, ALB, Security Groups, Key Pairs)
- LocalStack (para entornos locales)
- Ubuntu AMI oficial
- NGINX (mediante `user_data`)
- Módulos oficiales de Terraform

## ⚙️ Variables

Estas son las principales variables configurables:

| Variable            | Descripción                         | Valor por defecto |
|---------------------|--------------------------------------|-------------------|
| `tipo_de_instancia` | Tipo de instancia EC2               | `"t3.micro"`      |
| `include_ipv4`      | Asignar IP pública a instancias     | `true`            |
| `server_count`      | Número de instancias EC2 a lanzar   | `3`               |

Puedes sobrescribir estas variables con un archivo `terraform.tfvars`.

---

## 📦 Salidas (Outputs)

- `aws_region` – Región de despliegue  
- `aws_availability_zones` – Zonas de disponibilidad utilizadas  
- `cidir_vpc` – CIDR de la VPC creada  
- `ip_server` – IPs públicas de las instancias EC2  
- `dir_red` – IP pública de la primera instancia  
- `private_key` – Clave privada generada (marcada como `sensitive`)  
- `enpint` – DNS del Application Load Balancer  

---

## 🧪 LocalStack (Testing Local)

Este proyecto está configurado para funcionar también con **LocalStack** mediante endpoints personalizados en el bloque `provider`.

Puedes probar la infraestructura localmente sin usar recursos reales de AWS.

---

## 🔐 Acceso por SSH

Después de aplicar Terraform, puedes acceder a las instancias públicas vía SSH:

```bash
ssh -i key.pem ubuntu@<ip_publica>

## ⚠️ Clave SSH

Asegúrate de guardar el valor del output `private_key` como `key.pem` y otorgar permisos adecuados:

```bash
chmod 400 key.pem


## ✅ Requisitos

- Terraform ≥ v1.0  
- AWS CLI configurado (si no usas LocalStack)  
- Docker (si usas LocalStack)  
- Acceso a un perfil AWS válido o configuración de `test` en el `provider`

---

## 📌 Cómo desplegar

```bash
# Inicializa el proyecto
terraform init

# Previsualiza los cambios
terraform plan

# Aplica la infraestructura
terraform apply

# Cómo destruir la infraestructura
terraform destroy

## 🤝 Autor

**John Ocegueda**  
Cloud/DevOps Engineer  
[GitHub](https://github.com/jonh-OF)