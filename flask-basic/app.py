from flask import Flask, render_template

import mysql.connector
import config

app = Flask(__name__)

@app.route("/")
def index():
	print("abc")
	
	return render_template("home.html", selectedContent="Index")

@app.route("/products")
def products():
	cnx = mysql.connector.connect(**config.MYSQL_CONFIG)
	cursor = cnx.cursor()
	sql = ("SELECT id, status, title, price, regi_date FROM pdt ORDER BY id DESC")
	cursor.execute(sql)
	result = cursor.fetchall()
	cursor.close()
	cnx.close()	
	
	return render_template("product_list.html", selectedContent="Product", products=result)

@app.route("/product/<string:id>")
def article(id):
	cnx = mysql.connector.connect(**config.MYSQL_CONFIG)
	cursor = cnx.cursor()
	sql = ("SELECT id, status, title, price, regi_date FROM pdt WHERE id = %s")
	cursor.execute(sql, (id,))
	result = cursor.fetchone()
	cursor.close()
	cnx.close()	
	
	return render_template("product_view.html", selectedContent="Product", product=result)

@app.route("/about")
def about():
	return render_template("about.html", selectedContent="About")

if __name__ == "__main__":
	app.run(host="0.0.0.0", port=3002, debug=True, threaded=True)
