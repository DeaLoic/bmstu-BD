import psycopg2
conn = psycopg2.connect(
    dbname='postgres',
    user='postgres',
    password='postgres',
    host='localhost'
)
cursor = conn.cursor()

# 1. Выполнить скалярный запрос
# select player_name, team, player_country from players where players.id = 100;
def f1():
    request = 'select * from employes'
    cursor.execute(request)
    return cursor.fetchall()

print(f1())
cursor.close()
conn.close()