==================================================================================================
EL SIGUIENTE README.MD CONTIENE LAS INSTRUCCIONES PARA LA EJECUCIÓN DE LA PRÁCTICA "LOAD BALANCER"
PARA LA ASIGNATURA DE INGENIERÍA DE SOFTWARE III, IMPARTIDA EN LA UNIVERSIDAD DE SONORA.
==================================================================================================

# 🖥️ Flask Hostname App

Consiste en una aplicación que hace uso del framework Flask que muestra en pantalla el hostname
de la instancia donde se está ejecutando, con soporte para load balancing.


## 🚀 Setup Rápido

**¿Solo quieres ver la aplicación funcionando?**

```powershell
# 1. Clona el repositorio.
# 2. Ejecutar stack completo con load balancer
docker-compose -f docker-compose-loadbalancer.yml up -d

# 3. Abrir navegador en http://localhost:8080
```


---

## 📖 Setup Paso a Paso

### Opción 1: Ejecución Local

#### Paso 1: Preparar el entorno Python

```powershell
# Verificar que Python esté instalado y navegar al directorio del proyecto.
python --version

```

#### Paso 2: Crear entorno virtual

```powershell
# Crear entorno virtual
python -m venv .venv

# Activar entorno virtual
.venv\Scripts\activate

# Verificar que el entorno esté activo (verás (.venv) en el prompt)
```

#### Paso 3: Instalar dependencias

```powershell
# Instalar Flask
pip install flask

# O usar el archivo de requirements
pip install -r requirements.txt
```

#### Paso 4: Ejecutar la aplicación

```powershell
# Ejecutar la aplicación
python app.py
```

#### Paso 5: Verificar funcionamiento

```
✅ La aplicación estará disponible en:
   - http://localhost:5000
   - http://127.0.0.1:5000

✅ Para detener: Ctrl+C en la terminal
```

---

### Opción 2: Contenedor Docker

#### Prerequisitos

```powershell
# Verificar que Docker Desktop esté ejecutándose
docker --version
docker ps
```

#### Paso 1: Construir la imagen

```powershell

# Navegar al directorio del proyecto y construir la imagen Docker
docker build -t flask-hostname-app .
```

#### Paso 2: Ejecutar el contenedor

```powershell
# Ejecutar contenedor en segundo plano
docker run --detach --publish 5000:5000 --name hostname-app flask-hostname-app

# Verificar que esté ejecutándose
docker ps
```

#### Paso 3: Verificar funcionamiento

```
✅ La aplicación estará disponible en:
   - http://localhost:5000

✅ Comandos útiles:
   - Ver logs: docker logs hostname-app
   - Detener: docker stop hostname-app
   - Eliminar: docker rm hostname-app
```

---

### Opción 3: Load Balancer

#### Prerequisitos

```powershell
# Verificar Docker
docker --version
docker-compose --version
```

#### Paso 1: Preparar la imagen

```powershell
# Navegar al directorio del proyecto y construir la imagen (si no la tienes ya)
docker build -t flask-hostname-app .
```

#### Paso 2: Ejecutar stack completo

```powershell
# Iniciar stack con load balancer (3 réplicas + Nginx)
docker-compose -f docker-compose-loadbalancer.yml up -d
```

#### Paso 3: Verificar despliegue

```powershell
# Verificar que todos los contenedores estén ejecutándose
docker-compose -f docker-compose-loadbalancer.yml ps

# Deberías ver:
# - 3 contenedores app01 (healthy)
# - 1 contenedor nginx
```

#### Paso 4: Probar load balancing

```powershell
# Opción A: Usar script automático
test-loadbalancer.bat

# Opción B: Probar manualmente
curl http://localhost:8080/api/hostname
curl http://localhost:8080/api/hostname
curl http://localhost:8080/api/hostname
```

#### Paso 5: Verificar funcionamiento

```
✅ Aplicación disponible en:
   - http://localhost:8080 (a través del load balancer)

✅ Deberías ver diferentes hostnames en cada petición,
   demostrando que el load balancer distribuye las peticiones
   entre las 3 réplicas del servicio.
```

---

## 🔧 Gestión y Monitoreo

### Script de Gestión Interactivo

```powershell
# Usar el script de gestión completo
manage-stack.bat
```

**El script incluye opciones para:**
- ✅ Iniciar/detener stack
- ✅ Ver estado y logs
- ✅ Escalar servicios
- ✅ Probar load balancing
- ✅ Limpieza completa

### Comandos Manuales Avanzados

#### Escalado del servicio

```powershell
# Escalar a 5 réplicas
docker-compose -f docker-compose-loadbalancer.yml up -d --scale app01=5

# Escalar a 1 réplica
docker-compose -f docker-compose-loadbalancer.yml up -d --scale app01=1

# Verificar escalado
docker ps --filter "name=app01"
```

#### Monitoreo y logs

```powershell
# Ver estado del stack
docker-compose -f docker-compose-loadbalancer.yml ps

# Ver logs del load balancer
docker logs is-iii-nginx-1

# Ver logs de todas las réplicas de app01
docker-compose -f docker-compose-loadbalancer.yml logs app01

# Ver logs en tiempo real
docker-compose -f docker-compose-loadbalancer.yml logs -f app01
```

#### Limpieza y mantenimiento

```powershell
# Detener stack
docker-compose -f docker-compose-loadbalancer.yml down

# Detener y eliminar volúmenes
docker-compose -f docker-compose-loadbalancer.yml down -v

# Limpieza completa (contenedores, imágenes, redes)
docker-compose -f docker-compose-loadbalancer.yml down -v --remove-orphans
docker system prune -f
```

---

## 📁 Estructura del Proyecto

```
./
├── 📄 app.py                             # Aplicación Flask principal
├── 📄 requirements.txt                   # Dependencias Python
├── 🐳 Dockerfile                         # Configuración Docker
├── 🐳 docker-compose.yml                 # Compose simple
├── 🐳 docker-compose-loadbalancer.yml    # Compose con load balancer
├── ⚙️ nginx.conf                         # Configuración Nginx
├── 🚫 .dockerignore                      # Archivos ignorados por Docker
├── 🔧 deploy.bat                         # Script despliegue simple
├── 🔧 cleanup.bat                        # Script limpieza simple
├── 🔧 manage-stack.bat                   # Script gestión completa
├── 🔧 test-loadbalancer.bat              # Script prueba load balancer
├── 📁 .venv/                             # Entorno virtual Python
└── 📖 README.md                          # Esta documentación
```

---

## 🆘 Solución de Problemas

### ❌ "Docker no está ejecutándose"
```powershell
# Iniciar Docker Desktop desde el menú de Windows
# O verificar que esté instalado
docker --version
```

### ❌ "Puerto ya en uso"
```powershell
# Ver qué está usando el puerto
netstat -an | findstr :5000
netstat -an | findstr :8080

# Detener contenedores existentes
docker stop $(docker ps -q)
```

### ❌ "Imagen no encontrada"
```powershell
# Reconstruir la imagen
docker build -t flask-hostname-app .

# Verificar que la imagen existe
docker images | findstr flask-hostname-app
```

---