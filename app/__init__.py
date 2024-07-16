from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate

app = Flask(__name__)
app.config.from_object("app.config.Config")

db = SQLAlchemy(app)
migrate = Migrate(app, db)

from . import routes, models

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
