import git

from flask import Flask
from flask import request
app = Flask(__name__)


@app.route('/', methods=['GET'])
def index():
		git_dir = 'D:\gb_reading'
		
		g = git.cmd.Git(git_dir)
		g.pull()
		return 'OK'

@app.route('/webhook', methods=['POST'])
def tracking():
	if request.method == 'POST':
		git_dir = 'D:\gb_reading'
		
		g = git.cmd.Git(git_dir)
		g.pull()
		return 'OK'
	
if __name__ == '__main__':
	print('Webhook server online! Go to http://localhost:5000')
	app.run(host='0.0.0.0')

git_dir = 'D:\gb_reading'

g = git.cmd.Git(git_dir)
g.pull()
