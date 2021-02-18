import git

from flask import Flask
from flask import request
app = Flask(__name__)

git_dir = 'D:\gb_reading'

g = git.cmd.Git(git_dir)
g.pull()
	
if __name__ == '__main__':
	print('Webhook server online! Go to http://localhost:5000')
	app.run(host='0.0.0.0')

