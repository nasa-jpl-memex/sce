import flask
import os
from flask import request, flash

def upload():
    print 'importing'
    filename = 'seed_imported.txt'

    if 'seed' not in request.files:
        print 'seed not in'
        flash('No seed part')
        return '-1'
    seed = request.files['seed']
    if seed.filename == '':
        flash('No selected seed')
        return '-1'
    if seed:
        seed.save(os.path.join(flask.current_app.root_path, flask.current_app.config['UPLOAD_FOLDER'], seed.filename))
        setattr(flask.current_app, 'seed', seed.filename)
    else:
        flash('An error occurred while uploading the seed file')
        return '-1'

    return str(0)