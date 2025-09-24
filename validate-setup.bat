@echo off
echo ==============================================
echo    Validador de Setup - Flask Hostname App
echo ==============================================
echo.

set "error_count=0"

echo [1/8] Verificando Docker...
docker --version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Docker instalado
    for /f "tokens=3" %%a in ('docker --version') do echo    Version: %%a
) else (
    echo ❌ Docker no instalado o no accesible
    set /a error_count+=1
)

echo.
echo [2/8] Verificando Docker Desktop...
docker info >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Docker Desktop ejecutándose
) else (
    echo ❌ Docker Desktop no está ejecutándose
    echo    💡 Inicia Docker Desktop antes de continuar
    set /a error_count+=1
)

echo.
echo [3/8] Verificando imagen flask-hostname-app...
docker images flask-hostname-app | findstr flask-hostname-app >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Imagen flask-hostname-app existe
) else (
    echo ⚠️  Imagen flask-hostname-app no encontrada
    echo    💡 Ejecuta: docker build -t flask-hostname-app .
    set /a error_count+=1
)

echo.
echo [4/8] Verificando archivos de configuración...
if exist "docker-compose-loadbalancer.yml" (
    echo ✅ docker-compose-loadbalancer.yml existe
) else (
    echo ❌ docker-compose-loadbalancer.yml no encontrado
    set /a error_count+=1
)

if exist "nginx.conf" (
    echo ✅ nginx.conf existe
) else (
    echo ❌ nginx.conf no encontrado
    set /a error_count+=1
)

echo.
echo [5/8] Verificando puertos disponibles...
netstat -an | findstr :8080 >nul 2>&1
if %errorlevel% equ 0 (
    echo ⚠️  Puerto 8080 está en uso
    echo    💡 Detén otros servicios o usa otro puerto
) else (
    echo ✅ Puerto 8080 disponible
)

echo.
echo [6/8] Verificando stack actual...
docker-compose -f docker-compose-loadbalancer.yml ps >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Stack configurado correctamente
    docker-compose -f docker-compose-loadbalancer.yml ps | findstr "Up" >nul 2>&1
    if %errorlevel% equ 0 (
        echo ✅ Stack ejecutándose
    ) else (
        echo ⚠️  Stack configurado pero no ejecutándose
    )
) else (
    echo ⚠️  Stack no inicializado
)

echo.
echo [7/8] Verificando conectividad (si stack está ejecutándose)...
curl -s http://localhost:8080/health >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Aplicación responde correctamente
    echo    🌐 Disponible en: http://localhost:8080
) else (
    echo ⚠️  Aplicación no responde o no está ejecutándose
)

echo.
echo [8/8] Verificando scripts de gestión...
if exist "manage-stack.bat" (
    echo ✅ manage-stack.bat disponible
) else (
    echo ⚠️  manage-stack.bat no encontrado
)

if exist "test-loadbalancer.bat" (
    echo ✅ test-loadbalancer.bat disponible
) else (
    echo ⚠️  test-loadbalancer.bat no encontrado
)

echo.
echo ==============================================
if %error_count% equ 0 (
    echo ✅ ¡VALIDACIÓN EXITOSA!
    echo    Todo está configurado correctamente.
    echo.
    echo 🚀 Para iniciar el stack:
    echo    docker-compose -f docker-compose-loadbalancer.yml up -d
    echo.
    echo 🎮 Para gestión interactiva:
    echo    manage-stack.bat
) else (
    echo ❌ VALIDACIÓN FALLIDA
    echo    Se encontraron %error_count% problemas.
    echo    Revisa los mensajes anteriores para solucionarlos.
)
echo ==============================================
pause