from flask import Flask, jsonify
from flask import request, Response
from flask import make_response
from prometheus_flask_exporter import PrometheusMetrics
from sqlalchemy import URL
import jwt
import datetime as dt
from functools import wraps

from models import db, Users, UserResponse, Placemarks, PlacemarkResponse
from config import DATABASE, SECRET_KEY

app = Flask(__name__)
metrics = PrometheusMetrics(app, group_by='endpoint')
app.config['SECRET_KEY'] = SECRET_KEY
app.config['SQLALCHEMY_DATABASE_URI'] = URL.create(**DATABASE)
db.init_app(app)
with app.app_context():
    db.create_all()


def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = None
        if 'x-access-token' in request.headers:
            token = request.headers['x-access-token']
        if not token:
            return jsonify({'message': 'Token is missing !!'}), 401
        try:
            #verify
            data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=['HS256'])
            current_user = Users.query \
                .filter_by(id=data['user_id']) \
                .first()
        except:
            return jsonify({
                'message': 'Token is invalid !!'
            }), 401
        return f(current_user, *args, **kwargs)
    return decorated


@app.route('/')
def index():
    users = Users.query.all()
    return [user.json for user in users]


@app.route('/reg/', methods=["POST"])
def registration():
    if request.method == 'POST':
        phone = request.json.get("phone")
        password = request.json.get("password")
        name = request.json.get("name")
        if phone is None or not isinstance(phone, str) or phone == '':
            return UserResponse(statusCode=0, status='phone is bad', user=None).json, 400
        if password is None or not isinstance(password, str) or password == '':
            return UserResponse(statusCode=0, status='password is bad', user=None).json, 400
        if name is None or not isinstance(name, str) or name == '':
            return UserResponse(statusCode=0, status='name is bad', user=None).json, 400
        check_user = Users.query \
            .filter_by(phone=phone) \
            .first()
        if not check_user:
            user = Users(phone=phone, name=name)
            user.hash_password(password)
            db.session.add(user)
            db.session.commit()
            return UserResponse(statusCode=1, status='OK', user=user).json, 201
        return UserResponse(statusCode=0, status='password is incorrect', user=None).json, 400


@app.route('/placemarks/', methods=['GET'])
@token_required
def placemarks(current_user):
    uid = current_user.id
    if uid is None or not isinstance(uid, int):
        return \
            {'error': f'Invalid user'},\
            400, \
            {'WWW-Authenticate': 'Basic realm ="Login required !!"'}
    placemarks_ans = Placemarks.query\
        .filter_by(user_id=uid)
    return {"placemark": [places.json for places in placemarks_ans]}


@app.route('/placemarks/add/', methods=['POST'])
@token_required
def add_placemark(current_user):

    uid = current_user.id
    latitude = request.json.get("latitude")
    longitude = request.json.get("longitude")
    text = request.json.get("text")
    quality = request.json.get("quality")
    date = request.json.get("date")
    pose_id = request.json.get("pose_id")
    name = request.json.get("name")

    if (
        latitude is None or
        longitude is None or
        text is None or
        date is None or
        quality is None or
        pose_id is None or
        name is None
    ):
        return \
            {'error': f'Invalid data'}, \
            400, \
            {'WWW-Authenticate': 'Basic realm ="Login required !!"'}
    if uid is None or not isinstance(uid, int):
        return \
            {'error': f'Invalid user'},\
            400, \
            {'WWW-Authenticate': 'Basic realm ="Login required !!"'}
    placemark = Placemarks(
        latitude=latitude,
        longitude=longitude,
        text=text,
        quality=quality,
        date=date,
        pose_id=pose_id,
        user_id=uid,
        name=name
    )
    db.session.add(placemark)
    db.session.commit()
    return PlacemarkResponse(statusCode=1, status="OK", placemark=placemark).json, 201



@app.route('/login/', methods=['POST'])
def login():
    phone = request.json.get("phone")
    password = request.json.get("password")
    if phone is None or not isinstance(phone, str):
        return \
            {'error': f'Invalid data'},\
            400, \
            {'WWW-Authenticate': 'Basic realm ="Login required !!"'}
    if password is None or not isinstance(password, str):
        return \
            {'error': f'Invalid data'}, \
            400,  \
            {'WWW-Authenticate': 'Basic realm ="Login required !!"'}
    user = Users.query \
        .filter_by(phone=phone) \
        .first()
    if not user:
        return make_response(
            'Could not verify',
            401,
            {'WWW-Authenticate': 'Basic realm ="Login required !!"'}
        )
    if user.verify_password(request.json.get('password')):
        token = jwt.encode({
            'user_id': user.id,
            'exp': dt.datetime.utcnow() + dt.timedelta(days=1)
        }, app.config['SECRET_KEY'])
        return make_response({'token': token}, 201)

    return make_response(
        'Wrong password',
        403,
        {'WWW-Authenticate': 'Basic realm ="Wrong Password !!"'}
    )


@app.route('/user/delete/', methods=['DELETE'])
def delete():
    phone = request.json.get("phone")
    password = request.json.get("password")


@app.route('/metrics')
def metric():
    return Response(status=200)


if __name__ == '__main__':
    app.run(host='127.0.0.1', port=8084, debug=True)

