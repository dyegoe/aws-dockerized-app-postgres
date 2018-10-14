from notejam import app
from notejam.config import ProductionConfig
from notejam import db

app.config.from_object(ProductionConfig)

if __name__ == '__main__':
    db.create_all()
    app.run(host='0.0.0.0')
