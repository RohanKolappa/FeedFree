import logging
import os
import re

import arrow
import datetime
import six
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_swagger_ui import get_swaggerui_blueprint


def db_health():
    """
    Classification cassandra health check function.
    :return: True if healthy, False if otherwise
    """
    try:
        connection.get_session(app.config['CLASSIFICATION_NAME']).execute('SELECT now() FROM system.local')
        return True
    except NoHostAvailable:
        app.logger.exception('Health check failed to access classification cluster.')
        return False



# initialize app
app = Flask(__name__)
app.url_map.strict_slashes = False
formatter = logging.Formatter(u'[%(asctime)s] %(levelname)s [%(module)s:%(lineno)s]  %(message)s')
log_level = getattr(logging, 'DEBUG')
app.logger.setLevel(log_level)
for handler in app.logger.handlers:
    handler.setFormatter(formatter)
    handler.setLevel(log_level)
api_endpoint = 'http://localhost:8080'
swagger_blueprint_v1 = get_swaggerui_blueprint(
    base_url='/v1.0',
    api_url=f'{api_endpoint}/static/docs/v1.0/swagger.yaml'
)
swagger_blueprint_v1.name = 'v1.0'
app.register_blueprint(swagger_blueprint_v1, url_prefix='/v1.0')
#version_route = VersionRoute(app)
#health_checker = HealthChecker(app)
#health_checker.add_check(db_health)

feedfree_db = 'feedfree'
feedfree_db_user = 'root'
feedfree_db_password = 'Lablix12'
feedfree_db_host = 'localhost'
feedfree_db_port = 3306

# FeedFree MySQL configuration
app.config['SQLALCHEMY_DATABASE_URI'] = ('mysql+pymysql://'
                                         f"{feedfree_db_user}:{feedfree_db_password}@"
                                         f"{feedfree_db_host}:{feedfree_db_port}"
                                         f"/{feedfree_db}?charset=utf8mb4")
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SQLALCHEMY_POOL_SIZE'] = 20
db = SQLAlchemy(app)

import feedfreeservice.feedfree_endpoints_v1_0
