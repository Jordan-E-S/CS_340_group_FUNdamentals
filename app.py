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
# ########## GAME GENRES

@app.route("/gamegenres", methods=["GET"])
def gamegenres():
    dbConnection = db.connectDB()
    genres = db.query(dbConnection, "SELECT * FROM GameGenres ORDER BY genre;").fetchall()
    dbConnection.close()
    return render_template("gamegenres.j2", genres=genres)


@app.route("/add_genre", methods=["POST"])
def add_genre():
    genre = request.form.get("genre")

    dbConnection = db.connectDB()
    db.query(dbConnection, "INSERT INTO GameGenres (genre) VALUES (%s);", (genre,))
    dbConnection.close()
    return redirect("/gamegenres")


@app.route("/delete_genre", methods=["POST"])
def delete_genre():
    gameGenreID = request.form.get("gameGenreID")

    dbConnection = db.connectDB()
    try:
        db.query(dbConnection, "DELETE FROM GameGenres WHERE gameGenreID = %s;", (gameGenreID,))
        dbConnection.close()
        return redirect("/gamegenres")
    except Exception:
        dbConnection.close()
        return redirect("/gamegenres?error=genre_in_use")


# #######################################
# ########## BOARD GAMES

@app.route("/boardgames", methods=["GET"])
def boardgames():
    dbConnection = db.connectDB()

    query = """
        SELECT bg.boardGameID, bg.title, bg.publisher,
               bg.minPlayers, bg.maxPlayers, bg.complexity,
               bg.GameGenres_gameGenreID,
               gg.genre
        FROM BoardGames bg
        INNER JOIN GameGenres gg
            ON bg.GameGenres_gameGenreID = gg.gameGenreID;
    """
    boardgames = db.query(dbConnection, query).fetchall()

    genre_query = "SELECT gameGenreID, genre FROM GameGenres ORDER BY genre;"
    genres = db.query(dbConnection, genre_query).fetchall()

    dbConnection.close()
    return render_template("boardgames.j2", boardgames=boardgames, genres=genres)


@app.route("/add_boardgame", methods=["POST"])
def add_boardgame():
    title = request.form.get("title")
    publisher = request.form.get("publisher")
    minPlayers = request.form.get("minPlayers")
    maxPlayers = request.form.get("maxPlayers")
    complexity = request.form.get("complexity")
    gameGenreID = request.form.get("gameGenreID")  # FK dropdown

    dbConnection = db.connectDB()
    query = """
        INSERT INTO BoardGames (title, publisher, minPlayers, maxPlayers, complexity, GameGenres_gameGenreID)
        VALUES (%s, %s, %s, %s, %s, %s);
    """
    db.query(dbConnection, query, (title, publisher, minPlayers, maxPlayers, complexity, gameGenreID))
    dbConnection.close()
    return redirect("/boardgames")


@app.route("/update_boardgame", methods=["POST"])
def update_boardgame():
    boardGameID = request.form.get("boardGameID")
    title = request.form.get("title")
    publisher = request.form.get("publisher")
    minPlayers = request.form.get("minPlayers")
    maxPlayers = request.form.get("maxPlayers")
    complexity = request.form.get("complexity")
    gameGenreID = request.form.get("gameGenreID")

    dbConnection = db.connectDB()
    query = """
        UPDATE BoardGames
        SET title=%s, publisher=%s, minPlayers=%s, maxPlayers=%s, complexity=%s, GameGenres_gameGenreID=%s
        WHERE boardGameID=%s;
    """
    db.query(dbConnection, query, (title, publisher, minPlayers, maxPlayers, complexity, gameGenreID, boardGameID))
    dbConnection.close()
    return redirect("/boardgames")


# #######################################
# ########## PATRONS

@app.route("/patrons", methods=["GET"])
def patrons():
    dbConnection = db.connectDB()

    query = "SELECT * FROM Patrons;"
    patrons = db.query(dbConnection, query).fetchall()

    dbConnection.close()
    return render_template("patrons.j2", patrons=patrons)


@app.route("/add_patron", methods=["POST"])
def add_patron():
    firstName = request.form.get("firstName")
    lastName = request.form.get("lastName")
    email = request.form.get("email")
    phoneNumber = request.form.get("phoneNumber")

    dbConnection = db.connectDB()
    query = """
        INSERT INTO Patrons (firstName, lastName, email, phoneNumber)
        VALUES (%s, %s, %s, %s);
    """
    db.query(dbConnection, query, (firstName, lastName, email, phoneNumber))
    dbConnection.close()
    return redirect("/patrons")


@app.route("/delete_patron", methods=["POST"])
def delete_patron():
    patronID = request.form.get("patronID")

    dbConnection = db.connectDB()
    try:
        db.query(dbConnection, "DELETE FROM Patrons WHERE patronID = %s;", (patronID,))
        dbConnection.close()
        return redirect("/patrons")
    except Exception as e:
        dbConnection.close()
        # If FK blocks deletion, you can show a message via querystring
        return redirect("/patrons?error=patron_has_checkouts")


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
        SELECT c.checkoutID, c.checkoutDate, c.dueDate, c.returnDate,
               c.Patrons_patronID, c.Staff_staffID,
               p.firstName AS patronFirstName,
               p.lastName  AS patronLastName,
               s.firstName AS staffFirstName,
               s.lastName  AS staffLastName
        FROM Checkouts c
        INNER JOIN Patrons p ON c.Patrons_patronID = p.patronID
        INNER JOIN Staff s   ON c.Staff_staffID = s.staffID;
    """
    checkouts = db.query(dbConnection, query).fetchall()

    patrons = db.query(
        dbConnection,
        "SELECT patronID, firstName, lastName FROM Patrons ORDER BY lastName, firstName;"
    ).fetchall()

    staffMembers = db.query(
        dbConnection,
        "SELECT staffID, firstName, lastName FROM Staff ORDER BY lastName, firstName;"
    ).fetchall()

    dbConnection.close()
    return render_template("checkouts.j2", checkouts=checkouts, patrons=patrons, staffMembers=staffMembers)


# #######################################
# ########## CHECKOUT ITEMS

@app.route("/checkoutitems", methods=["GET"])
def checkoutitems():
    dbConnection = db.connectDB()

    query = """
        SELECT ci.checkoutItemID,
               ci.Checkouts_checkoutID,
               ci.BoardGames_boardGameID,
               bg.title AS gameTitle,
               CONCAT(p.firstName, ' ', p.lastName) AS patronName
        FROM CheckoutItems ci
        INNER JOIN BoardGames bg ON ci.BoardGames_boardGameID = bg.boardGameID
        INNER JOIN Checkouts c   ON ci.Checkouts_checkoutID = c.checkoutID
        INNER JOIN Patrons p     ON c.Patrons_patronID = p.patronID
        ORDER BY ci.checkoutItemID;
    """
    checkoutitems = db.query(dbConnection, query).fetchall()

    boardgames = db.query(
        dbConnection,
        "SELECT boardGameID, title FROM BoardGames ORDER BY title;"
    ).fetchall()

    checkouts = db.query(
        dbConnection,
        """
        SELECT c.checkoutID,
               CONCAT(p.firstName, ' ', p.lastName) AS patronName
        FROM Checkouts c
        INNER JOIN Patrons p ON c.Patrons_patronID = p.patronID
        ORDER BY c.checkoutID;
        """
    ).fetchall()

    dbConnection.close()
    return render_template("checkoutitems.j2", checkoutitems=checkoutitems, boardgames=boardgames, checkouts=checkouts)


@app.route("/add_checkoutitem", methods=["POST"])
def add_checkoutitem():
    boardGameID = request.form.get("boardGameID")
    checkoutID = request.form.get("checkoutID")

    dbConnection = db.connectDB()
    query = """
        INSERT INTO CheckoutItems (BoardGames_boardGameID, Checkouts_checkoutID)
        VALUES (%s, %s);
    """
    db.query(dbConnection, query, (boardGameID, checkoutID))
    dbConnection.close()
    return redirect("/checkoutitems")


@app.route("/update_checkoutitem", methods=["POST"])
def update_checkoutitem():
    checkoutItemID = request.form.get("checkoutItemID")
    boardGameID = request.form.get("boardGameID")
    checkoutID = request.form.get("checkoutID")

    dbConnection = db.connectDB()
    query = """
        UPDATE CheckoutItems
        SET BoardGames_boardGameID=%s, Checkouts_checkoutID=%s
        WHERE checkoutItemID=%s;
    """
    db.query(dbConnection, query, (boardGameID, checkoutID, checkoutItemID))
    dbConnection.close()
    return redirect("/checkoutitems")


@app.route("/delete_checkoutitem", methods=["POST"])
def delete_checkoutitem():
    checkoutItemID = request.form.get("checkoutItemID")

    dbConnection = db.connectDB()
    db.query(dbConnection, "DELETE FROM CheckoutItems WHERE checkoutItemID=%s;", (checkoutItemID,))
    dbConnection.close()
    return redirect("/checkoutitems")


# ########################################
# ########## LISTENER

if __name__ == "__main__":
    app.run(
        port=PORT, debug=True
    )  # debug is an optional parameter. Behaves like nodemon in Node.