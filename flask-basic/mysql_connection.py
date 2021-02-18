import mysql.connector

import config

ctx = mysql.connector.connect(**config.MYSQL_CONFIG)
cursor = ctx.cursor()
