@echo off
echo ==============================================
echo    Script de Limpieza - Flask Hostname App
echo ==============================================
echo.

echo [1/3] Deteniendo el contenedor...
docker stop hostname-app 2>nul
if %errorlevel% equ 0 (
    echo ✅ Contenedor detenido
) else (
    echo ⚠️  El contenedor no estaba ejecutándose
)

echo.
echo [2/3] Eliminando el contenedor...
docker rm hostname-app 2>nul
if %errorlevel% equ 0 (
    echo ✅ Contenedor eliminado
) else (
    echo ⚠️  El contenedor no existía
)

echo.
echo [3/3] Eliminando la imagen...
docker rmi flask-hostname-app 2>nul
if %errorlevel% equ 0 (
    echo ✅ Imagen eliminada
) else (
    echo ⚠️  La imagen no existía
)

echo.
echo ==============================================
echo ✅ Limpieza completada
echo ==============================================
pause