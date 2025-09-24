@echo off
echo ==============================================
echo    Script de Despliegue - Flask Hostname App
echo ==============================================
echo.

echo [1/4] Verificando Docker...
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Error: Docker no está instalado
    pause
    exit /b 1
)
echo ✅ Docker está instalado

echo.
echo [2/4] Verificando que Docker Desktop esté ejecutándose...
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Error: Docker Desktop no está ejecutándose
    echo 💡 Por favor, inicia Docker Desktop antes de continuar
    echo.
    pause
    exit /b 1
)
echo ✅ Docker Desktop está ejecutándose

echo.
echo [3/4] Construyendo la imagen Docker...
docker build -t flask-hostname-app .
if %errorlevel% neq 0 (
    echo ❌ Error al construir la imagen
    pause
    exit /b 1
)
echo ✅ Imagen construida exitosamente

echo.
echo [4/4] Ejecutando el contenedor...
docker run -d -p 5000:5000 --name hostname-app flask-hostname-app
if %errorlevel% neq 0 (
    echo ❌ Error al ejecutar el contenedor
    pause
    exit /b 1
)
echo ✅ Contenedor ejecutándose

echo.
echo ==============================================
echo ✅ ¡Despliegue completado exitosamente!
echo.
echo 🌐 La aplicación está disponible en:
echo    - http://localhost:5000
echo    - http://127.0.0.1:5000
echo.
echo 📊 Para ver los logs: docker logs hostname-app
echo 🛑 Para detener: docker stop hostname-app
echo 🗑️  Para eliminar: docker rm hostname-app
echo ==============================================
pause