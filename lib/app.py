from flask import Flask, request, jsonify
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import generate_password_hash, check_password_hash


app = Flask(__name__)
CORS(app)

# Configure the database
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///chatusers.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SECRET_KEY'] = 'your_secret_key'  # Change this to a strong secret key
db = SQLAlchemy(app)

# User model
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password = db.Column(db.String(128), nullable=False)

# Create the database
with app.app_context():
    db.create_all()
@app.route('/')
def home():
    return 'Server is running!', 200

@app.route('/register', methods=['POST'])
def register():
    try:
        data = request.json
        email = data.get('email')
        password = data.get('password')
        if not email or not password:
            return jsonify({"message": "Email and password are required"}), 400
        if User.query.filter_by(email=email).first():
            return jsonify({"message": "User  already exists"}), 400

        # Hash the password
        
        new_user = User(email=email, password=password)

        # Add the new user to the database
        db.session.add(new_user)
        db.session.commit()

        return jsonify({"message": "User  registered successfully"}), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/login', methods=['POST'])
def login():
    data = request.json
    email = data.get('email')
    password = data.get('password')

    # Find the user by email
    user = User.query.filter_by(email=email).first()

    # Check if the user exists and the password matches
    if user and user.password == password:
        return jsonify({"message": "Login successful"}), 200

    # If credentials are invalid
    return jsonify({"message": "Invalid credentials"}), 401



if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)