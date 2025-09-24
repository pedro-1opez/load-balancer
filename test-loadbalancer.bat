@echo off
echo ==============================================
echo    Probando Load Balancer - Flask App
echo ==============================================
echo.

echo Haciendo 10 peticiones al load balancer para ver la distribucion:
echo.

for /L %%i in (1,1,10) do (
    echo [Peticion %%i]
    curl -s http://localhost:8080/api/hostname | findstr hostname
    timeout /t 1 /nobreak >nul
)

echo.
echo ==============================================
echo Prueba completada. Deberas ver diferentes hostnames
echo indicando que las peticiones se distribuyen entre
echo las diferentes instancias del servicio app01
echo ==============================================
pause