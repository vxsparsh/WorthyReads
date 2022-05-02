from flask import Flask
from flask_restful import Api, Resource, reqparse
import json

app = Flask(__name__)
api = Api(app)


class Books(Resource):
    def get(self):
        f = open('records.json')
        data = json.load(f)
        return data




api.add_resource(Books, '/books')

if __name__ == '__main__':
    app.run()
