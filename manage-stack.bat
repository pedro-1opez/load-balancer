@echo off
echo ==============================================
echo    Gestion del Stack con Load Balancer
echo ==============================================
echo.
echo Selecciona una opcion:
echo [1] Iniciar stack completo
echo [2] Detener stack
echo [3] Ver estado de contenedores
echo [4] Ver logs del load balancer
echo [5] Ver logs de app01
echo [6] Escalar servicio app01
echo [7] Probar load balancing
echo [8] Limpiar todo
echo [0] Salir
echo.
set /p choice="Ingresa tu opcion: "

if "%choice%"=="1" goto start
if "%choice%"=="2" goto stop
if "%choice%"=="3" goto status
if "%choice%"=="4" goto logs_nginx
if "%choice%"=="5" goto logs_app
if "%choice%"=="6" goto scale
if "%choice%"=="7" goto test
if "%choice%"=="8" goto cleanup
if "%choice%"=="0" goto exit
goto menu

:start
echo.
echo [INFO] Iniciando stack completo...
docker-compose -f docker-compose-loadbalancer.yml up -d
echo.
echo ✅ Stack iniciado. Disponible en http://localhost:8080
goto menu

:stop
echo.
echo [INFO] Deteniendo stack...
docker-compose -f docker-compose-loadbalancer.yml down
echo ✅ Stack detenido
goto menu

:status
echo.
echo [INFO] Estado de contenedores:
docker ps --filter "name=is-iii"
goto menu

:logs_nginx
echo.
echo [INFO] Logs del load balancer Nginx:
docker logs is-iii-nginx-1 --tail 20
goto menu

:logs_app
echo.
echo [INFO] Logs del servicio app01:
docker-compose -f docker-compose-loadbalancer.yml logs app01 --tail 20
goto menu

:scale
echo.
set /p replicas="Ingresa el numero de replicas para app01: "
echo [INFO] Escalando app01 a %replicas% replicas...
docker-compose -f docker-compose-loadbalancer.yml up -d --scale app01=%replicas%
echo ✅ Servicio escalado
goto menu

:test
echo.
echo [INFO] Probando load balancing...
call test-loadbalancer.bat
goto menu

:cleanup
echo.
echo [WARNING] Esto eliminara todos los contenedores y recursos del stack
set /p confirm="¿Estas seguro? (y/N): "
if /i "%confirm%"=="y" (
    docker-compose -f docker-compose-loadbalancer.yml down -v --remove-orphans
    echo ✅ Limpieza completada
) else (
    echo Operacion cancelada
)
goto menu

:exit
echo.
echo ¡Hasta luego!
exit /b 0

:menu
echo.
pause
cls
goto start