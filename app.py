from flask import Flask, render_template, request, redirect, url_for
import mysql.connector

app = Flask(__name__)

# Database connection
db = mysql.connector.connect(
    host="localhost",
    user="your_username",
    password="your_password",
    database="cs340_smitjor8"
)

cursor = db.cursor(dictionary=True)


# ==========================
# HOME
# ==========================
@app.route("/")
def home():
    return render_template("home.j2")


# ==========================
# GAME GENRES
# ==========================
@app.route("/gamegenres")
def gamegenres():
    cursor.execute("SELECT * FROM GameGenres")
    genres = cursor.fetchall()
    return render_template("gamegenres.j2", genres=genres)


@app.route("/add_genre", methods=["POST"])
def add_genre():
    genre = request.form["genre"]
    cursor.execute("INSERT INTO GameGenres (genre) VALUES (%s)", (genre,))
    db.commit()
    return redirect("/gamegenres")


@app.route("/delete_genre", methods=["POST"])
def delete_genre():
    try:
        genre_id = request.form["gameGenreID"]
        cursor.execute("DELETE FROM GameGenres WHERE gameGenreID = %s", (genre_id,))
        db.commit()
        return redirect("/gamegenres")
    except:
        return redirect("/gamegenres?error=genre_in_use")


# ==========================
# BOARD GAMES
# ==========================
@app.route("/boardgames")
def boardgames():
    cursor.execute("""
        SELECT bg.*, g.genre
        FROM BoardGames bg
        JOIN GameGenres g
        ON bg.GameGenres_gameGenreID = g.gameGenreID
    """)
    boardgames = cursor.fetchall()

    cursor.execute("SELECT * FROM GameGenres")
    genres = cursor.fetchall()

    return render_template("boardgames.j2", boardgames=boardgames, genres=genres)


@app.route("/add_boardgame", methods=["POST"])
def add_boardgame():
    data = (
        request.form["title"],
        request.form["publisher"],
        request.form["minPlayers"],
        request.form["maxPlayers"],
        request.form["complexity"],
        request.form["gameGenreID"]
    )
    cursor.execute("""
        INSERT INTO BoardGames
        (title, publisher, minPlayers, maxPlayers, complexity, GameGenres_gameGenreID)
        VALUES (%s, %s, %s, %s, %s, %s)
    """, data)
    db.commit()
    return redirect("/boardgames")


@app.route("/update_boardgame", methods=["POST"])
def update_boardgame():
    data = (
        request.form["title"],
        request.form["publisher"],
        request.form["minPlayers"],
        request.form["maxPlayers"],
        request.form["complexity"],
        request.form["gameGenreID"],
        request.form["boardGameID"]
    )
    cursor.execute("""
        UPDATE BoardGames
        SET title=%s, publisher=%s, minPlayers=%s,
            maxPlayers=%s, complexity=%s,
            GameGenres_gameGenreID=%s
        WHERE boardGameID=%s
    """, data)
    db.commit()
    return redirect("/boardgames")


# ==========================
# PATRONS
# ==========================
@app.route("/patrons")
def patrons():
    cursor.execute("SELECT * FROM Patrons")
    patrons = cursor.fetchall()
    return render_template("patrons.j2", patrons=patrons)


@app.route("/add_patron", methods=["POST"])
def add_patron():
    data = (
        request.form["firstName"],
        request.form["lastName"],
        request.form["email"],
        request.form["phoneNumber"]
    )
    cursor.execute("""
        INSERT INTO Patrons (firstName, lastName, email, phoneNumber)
        VALUES (%s, %s, %s, %s)
    """, data)
    db.commit()
    return redirect("/patrons")


@app.route("/delete_patron", methods=["POST"])
def delete_patron():
    try:
        patron_id = request.form["patronID"]
        cursor.execute("DELETE FROM Patrons WHERE patronID=%s", (patron_id,))
        db.commit()
        return redirect("/patrons")
    except:
        return redirect("/patrons?error=patron_has_checkouts")


# ==========================
# STAFF
# ==========================
@app.route("/staff")
def staff():
    cursor.execute("SELECT * FROM Staff")
    staff = cursor.fetchall()
    return render_template("staff.j2", staff=staff)


# ==========================
# CHECKOUTS
# ==========================
@app.route("/checkouts")
def checkouts():
    cursor.execute("""
        SELECT c.*, 
               p.firstName AS patronFirstName,
               p.lastName AS patronLastName,
               s.firstName AS staffFirstName,
               s.lastName AS staffLastName
        FROM Checkouts c
        JOIN Patrons p ON c.Patrons_patronID = p.patronID
        JOIN Staff s ON c.Staff_staffID = s.staffID
    """)
    checkouts = cursor.fetchall()
    return render_template("checkouts.j2", checkouts=checkouts)


# ==========================
# CHECKOUT ITEMS (M:M)
# ==========================
@app.route("/checkoutitems")
def checkoutitems():
    cursor.execute("""
        SELECT ci.*, bg.title,
               c.checkoutID,
               p.firstName AS patronName
        FROM CheckoutItems ci
        JOIN BoardGames bg ON ci.BoardGames_boardGameID = bg.boardGameID
        JOIN Checkouts c ON ci.Checkouts_checkoutID = c.checkoutID
        JOIN Patrons p ON c.Patrons_patronID = p.patronID
    """)
    checkoutitems = cursor.fetchall()

    cursor.execute("SELECT * FROM BoardGames")
    boardgames = cursor.fetchall()

    cursor.execute("""
        SELECT c.checkoutID, p.firstName AS patronName
        FROM Checkouts c
        JOIN Patrons p ON c.Patrons_patronID = p.patronID
    """)
    checkouts = cursor.fetchall()

    return render_template("checkoutitems.j2",
                           checkoutitems=checkoutitems,
                           boardgames=boardgames,
                           checkouts=checkouts)


@app.route("/add_checkoutitem", methods=["POST"])
def add_checkoutitem():
    data = (
        request.form["boardGameID"],
        request.form["checkoutID"]
    )
    cursor.execute("""
        INSERT INTO CheckoutItems
        (BoardGames_boardGameID, Checkouts_checkoutID)
        VALUES (%s, %s)
    """, data)
    db.commit()
    return redirect("/checkoutitems")


@app.route("/delete_checkoutitem", methods=["POST"])
def delete_checkoutitem():
    checkoutItemID = request.form["checkoutItemID"]
    cursor.execute("DELETE FROM CheckoutItems WHERE checkoutItemID=%s",
                   (checkoutItemID,))
    db.commit()
    return redirect("/checkoutitems")


if __name__ == "__main__":
    app.run(debug=True)
