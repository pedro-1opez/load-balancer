# Usar una imagen base de Python 3.11 slim
FROM python:3.11-slim

# Establecer el directorio de trabajo en el contenedor
WORKDIR /app

# Copiar el archivo de requirements primero para aprovechar el cache de Docker
COPY requirements.txt .

# Instalar las dependencias de Python
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el código de la aplicación
COPY app.py .

# Exponer el puerto 5000
EXPOSE 5000

# Crear un usuario no-root para ejecutar la aplicación (seguridad)
RUN useradd --create-home --shell /bin/bash flask && chown -R flask:flask /app
USER flask

# Comando para ejecutar la aplicación
CMD ["python", "app.py"]