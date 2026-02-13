# Based on the flask template provided from the cs340 course with original modifications by Jordan Smith. 
# Further modified by chatgpt for bug eliminnation and code cleanup.
# The above applies to all code related to this project step 3, including the database connector and the html templates.
# ########################################
# ########## SETUP

from flask import Flask, render_template, request, redirect
import database.db_connector as db

PORT = 25194

app = Flask(__name__)

# #######################################
# ########## ROUTE HANDLERS

# READ ROUTES
@app.route("/", methods=["GET"])
def home():
    try:
        return render_template("home.j2")

    except Exception as e:
        print(f"Error rendering page: {e}")
        return "An error occurred while rendering the page.", 500


# #######################################
# ########## BOARD GAMES

@app.route("/boardgames", methods=["GET"])
def boardgames():
    dbConnection = db.connectDB()

    query = """
        SELECT bg.boardGameID, bg.title, bg.publisher,
               bg.minPlayers, bg.maxPlayers, bg.complexity,
               gg.genre
        FROM BoardGames bg
        INNER JOIN GameGenres gg
            ON bg.GameGenres_gameGenreID = gg.gameGenreID;
    """

    boardgames = db.query(dbConnection, query).fetchall()
    dbConnection.close()

    return render_template("boardgames.j2", boardgames=boardgames)


# #######################################
# ########## PATRONS

@app.route("/patrons", methods=["GET"])
def patrons():
    dbConnection = db.connectDB()

    query = "SELECT * FROM Patrons;"
    patrons = db.query(dbConnection, query).fetchall()

    dbConnection.close()
    return render_template("patrons.j2", patrons=patrons)


# #######################################
# ########## STAFF

@app.route("/staff", methods=["GET"])
def staff():
    dbConnection = db.connectDB()

    query = "SELECT * FROM Staff;"
    staff = db.query(dbConnection, query).fetchall()

    dbConnection.close()
    return render_template("staff.j2", staff=staff)


# #######################################
# ########## CHECKOUTS

@app.route("/checkouts", methods=["GET"])
def checkouts():
    dbConnection = db.connectDB()

    query = """
        SELECT c.checkoutID, c.checkoutDate, c.dueDate,
               c.returnDate,
               p.firstName AS patronFirstName,
               s.firstName AS staffFirstName
        FROM Checkouts c
        INNER JOIN Patrons p
            ON c.Patrons_patronID = p.patronID
        INNER JOIN Staff s
            ON c.Staff_staffID = s.staffID;
    """

    checkouts = db.query(dbConnection, query).fetchall()
    dbConnection.close()

    return render_template("checkouts.j2", checkouts=checkouts)


# #######################################
# ########## CHECKOUT ITEMS

@app.route("/checkoutitems", methods=["GET"])
def checkoutitems():
    dbConnection = db.connectDB()

    query = """
        SELECT ci.checkoutItemID,
               ci.Checkouts_checkoutID,
               bg.title
        FROM CheckoutItems ci
        INNER JOIN BoardGames bg
            ON ci.BoardGames_boardGameID = bg.boardGameID;
    """

    checkoutitems = db.query(dbConnection, query).fetchall()
    dbConnection.close()

    return render_template("checkoutitems.j2", checkoutitems=checkoutitems)




# ########################################
# ########## LISTENER

if __name__ == "__main__":
    app.run(
        port=PORT, debug=True
    )  # debug is an optional parameter. Behaves like nodemon in Node.