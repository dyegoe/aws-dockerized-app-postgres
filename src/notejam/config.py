import os
basedir = os.path.abspath(os.path.dirname(__file__))

class Config(object):
    DEBUG = False
    TESTING = False
    SECRET_KEY = os.environ.get('NOTEJAM_SECRET_KEY')
    CSRF_ENABLED = True
    CSRF_SESSION_KEY = os.environ.get('NOTEJAM_SECRET_KEY')
    SQLALCHEMY_DATABASE_URI = 'postgresql://{db_user}:{db_password}@{db_host}:5432/{db_name}'.format(
        db_user=os.environ.get('DB_USER'),
        db_password=os.environ.get('DB_PASSWORD'),
        db_host=os.environ.get('DB_HOST'),
        db_name=os.environ.get('DB_NAME')
    )


class ProductionConfig(Config):
    DEBUG = False


class DevelopmentConfig(Config):
    DEVELOPMENT = True
    DEBUG = True


class TestingConfig(Config):
    TESTING = True
    SECRET_KEY = "RHIJ4ODJeleexpaczpa4LHEdvipYAKNm"
