# Import flask and template operators
from flask import Flask
from flask_cors import CORS, cross_origin

# Define the WSGI application object
app = Flask(__name__,
            static_url_path='',
            static_folder='static')
cors = CORS(app, resources={r"/cmd/*": {"origins": "*"}})

# Configurations
app.config.from_object('config')


# Import a module / component using its blueprint handler variable
from app.controller import mod_app as app_module


# Register blueprint(s)
app.register_blueprint(app_module)