from flask import Flask
import socket
import os
from datetime import datetime

app = Flask(__name__)

@app.route('/')
def show_hostname():
    # Obtener el hostname de la instancia
    hostname = socket.gethostname()
    
    # Obtener información adicional del sistema
    try:
        ip_address = socket.gethostbyname(hostname)
    except socket.gaierror:
        ip_address = "No disponible"
    
    # Obtener variables de entorno útiles
    user = os.environ.get('USERNAME', 'Desconocido')  # Windows usa USERNAME
    platform = os.environ.get('OS', 'Desconocido')
    
    # Crear respuesta HTML con información del sistema
    html_response = f"""
    <!DOCTYPE html>
    <html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Información de la Instancia</title>
        <style>
            body {{
                font-family: Arial, sans-serif;
                max-width: 800px;
                margin: 50px auto;
                padding: 20px;
                background-color: #f5f5f5;
            }}
            .container {{
                background-color: white;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }}
            h1 {{
                color: #333;
                text-align: center;
                margin-bottom: 30px;
            }}
            .info-item {{
                margin: 15px 0;
                padding: 10px;
                background-color: #f8f9fa;
                border-left: 4px solid #007bff;
                border-radius: 4px;
            }}
            .hostname {{
                font-size: 24px;
                font-weight: bold;
                color: #007bff;
            }}
            .timestamp {{
                text-align: center;
                color: #666;
                font-style: italic;
                margin-top: 20px;
            }}
        </style>
    </head>
    <body>
        <div class="container">
            <h1>🖥️ Información de la Instancia</h1>
            
            <div class="info-item">
                <strong>Hostname:</strong>
                <div class="hostname">{hostname}</div>
            </div>
            
            <div class="info-item">
                <strong>Dirección IP:</strong> {ip_address}
            </div>
            
            <div class="info-item">
                <strong>Usuario actual:</strong> {user}
            </div>
            
            <div class="info-item">
                <strong>Sistema operativo:</strong> {platform}
            </div>
            
            <div class="info-item">
                <strong>Proceso ID:</strong> {os.getpid()}
            </div>
            
            <div class="timestamp">
                Información generada el: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
            </div>
        </div>
    </body>
    </html>
    """
    
    return html_response

@app.route('/api/hostname')
def api_hostname():
    """Endpoint API que devuelve solo el hostname en formato JSON"""
    return {
        'hostname': socket.gethostname(),
        'timestamp': datetime.now().isoformat()
    }

@app.route('/health')
def health_check():
    """Endpoint para verificar el estado de la aplicación"""
    return {'status': 'healthy', 'hostname': socket.gethostname()}

if __name__ == '__main__':
    print(f"🚀 Iniciando aplicación Flask en hostname: {socket.gethostname()}")
    # En producción, debug=False para mejor rendimiento y seguridad
    debug_mode = os.environ.get('FLASK_DEBUG', 'False').lower() == 'true'
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=debug_mode)
