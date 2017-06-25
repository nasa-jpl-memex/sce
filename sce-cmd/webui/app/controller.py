from flask import Blueprint
from app import crawler, seed

mod_app = Blueprint('application', __name__, url_prefix='/cmd')

# Define Controller(s)
@mod_app.route('/')
def index():
    return str("Crawler manager")


@mod_app.route('/crawler/exist/', methods=['POST'])
def crawler_exist():
    return crawler.exist()


@mod_app.route('/crawler/crawl/', methods=['POST'])
def crawler_crawl():
    return crawler.crawl()


@mod_app.route('/crawler/kill/', methods=['POST'])
def crawler_kill():
    return crawler.kill()


@mod_app.route('/crawler/int/', methods=['POST'])
def crawler_int():
    return crawler.int()


# POST Requests
@mod_app.route('/seed/upload/', methods=['POST'])
def upload_seed():
    return seed.upload()
