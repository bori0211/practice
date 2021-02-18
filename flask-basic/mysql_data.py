from mysql_connection import db, cursor

def add_product(status, title, price):
	sql = ("INSERT INTO pdt (status, title, price, regi_date, last_modi_date) VALUES (%s, %s, %s, SYSDATE(), SYSDATE())")
	cursor.execute(sql, (status, title, price))
	db.commit()
	product_id = cursor.lastrowid
	print("Added log {}".format(product_id))

def get_products():
	sql = ("SELECT id, status, title, price, regi_date FROM pdt ORDER BY id DESC")
	cursor.execute(sql)
	result = cursor.fetchall()
	
	for rows in result:
		#print(rows)
		print(rows[2])

def get_product(id):
	sql = ("SELECT id, status, title, price, regi_date FROM pdt WHERE id = %s")
	cursor.execute(sql, (id,))
	result = cursor.fetchone()
	
	for row in result:
		print(row)

def update_product(id, title):
	sql = ("UPDATE pdt SET title = %s WHERE id = %s")
	cursor.execute(sql, (title, id))
	db.commit()
	print("Updated {}".format(id))

def delete_product(id):
	sql = ("DELETE FROM pdt WHERE id = %s")
	cursor.execute(sql, (id,))
	db.commit()
	print("Deleted {}".format(id))

#add_product("대기중", "Python", "99.99")
#get_products()
#get_product(101)
#update_product(101, "수학공룡2")
delete_product(146)
