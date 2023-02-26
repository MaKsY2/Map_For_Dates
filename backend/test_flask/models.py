from flask_sqlalchemy import SQLAlchemy
from passlib.apps import custom_app_context as pwd_context

db = SQLAlchemy()


class Users(db.Model):
    __tablename__ = 'Users'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(20), nullable=False)
    phone = db.Column(db.String(100), nullable=False)
    password_hash = db.Column(db.String(1000), nullable=False)

    points = db.relationship('Placemarks', back_populates='user')

    def hash_password(self, password):
        self.password_hash = pwd_context.encrypt(password)

    def verify_password(self, password):
        return pwd_context.verify(password, self.password_hash)

    @property
    def json(self):
        return {
            "id": self.id,
            "name": self.name,
            "phone": self.phone,
        }

    def __repr__(self):
        return f'User<{self.id}>'


class Placemarks(db.Model):
    __tablename__ = 'Point_Posts'

    id = db.Column(db.Integer, primary_key=True)
    latitude = db.Column(db.Float, nullable=False)
    longitude = db.Column(db.Float, nullable=False)
    text = db.Column(db.String(100), nullable=False)
    quality = db.Column(db.Integer, nullable=False)
    date = db.Column(db.DateTime(timezone=True), nullable=False)
    pose_id = db.Column(db.Integer, nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey('Users.id'),  nullable=False)
    name = db.Column(db.String(50), nullable=False)

    user = db.relationship('Users', uselist=False, back_populates='points')

    @property
    def json(self):
        return {
            'id': self.id,
            'latitude': self.latitude,
            'longitude': self.longitude,
            'text': self.text,
            'quality': self.quality,
            'date': self.date,
            'pose_id': self.pose_id,
            'user_id': self.user_id,
            'name': self.name,
        }


class UserResponse:

    statusCode: int
    status: str
    user: Users

    def __init__(self, status, statusCode, user):
        self.status = status
        self.statusCode = statusCode
        self.user = user

    @property
    def json(self):
        return {
            "statusCode": self.statusCode,
            "status": self.status,
            "user": (self.user.json if self.user else None),
        }


class PlacemarkResponse:

    statusCode: int
    status: str
    placemark: Placemarks

    def __init__(self, status, statusCode, placemark):
        self.status = status
        self.statusCode = statusCode
        self.placemark = placemark

    @property
    def json(self):
        return {
            "statusCode": self.statusCode,
            "status": self.status,
            "user": (self.placemark.json if self.placemark else None),
        }
