#Import the python driver for PostgreSQL
import psycopg2


#Create a connection credentials to the PostgreSQL database
try:
    connection = psycopg2.connect(
        user = "skie",
        password = "skie",
        host = "localhost",
        port = "5432",
        database = "postgres"
    )

    #Create a cursor connection object to a PostgreSQL instance and print the connection properties.
    cursor = connection.cursor()
    pg_create = """ create table book(id serial, author text, isbn text, title text, date_published text) """
    cursor.execute(pg_create)
	
	
    #Get the column name of a table inside the database and put some values
    pg_insert = """ INSERT INTO book (id, author, isbn, title, date_published)
                VALUES (%s,%s,%s,%s,%s)"""
   
    inserted_values = (1, 'Layla Nowiztki', '789-1-46-268414-1', 'How to become a professional programmer', 'January 25 2011')

    cursor.execute(pg_insert, inserted_values)


    #Commit transaction and prints the result successfully
    connection.commit()
    count = cursor.rowcount
    print (count, "Successfully inserted")

#Error handling for psycopg2
except(Exception, psycopg2.Error) as error:
    print("Error connecting to PostgreSQL database", error)
    connection = None

#Close the database connection
finally:
    if(connection != None):
        cursor.close()
        connection.close()
        print("PostgreSQL connection is now closed")
