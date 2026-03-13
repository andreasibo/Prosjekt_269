import sqlite3
from datetime import datetime, timedelta

# Funksjon for å koble til databasen
def koble_til():
    con = sqlite3.connect("trening.DB")
    cursor = con.cursor()
    return con, cursor

# Funksjon for brukstilfelle 2, booking av trening
def brukstilfelle_2(epost, aktivitet, tidspunkt):
    # Kobler til databasen
    con, cursor = koble_til()

    # Henter ut gruppetime fra databasen
    cursor.execute("""
                   SELECT * 
                   FROM gruppetime 
                   WHERE aktivitetstype_navn =:aktivitet AND starttid =:starttid
                   """, 
                   {"aktivitet": aktivitet, "starttid": tidspunkt}
    )

    # Sjekker om gruppetimen finnes, sier ifra hvis ikke
    gruppetime = cursor.fetchone()
    if gruppetime is None:
        con.close()
        print('Treningen finnes ikke')
        return
    
    # Henter ut bruker fra databasen
    cursor.execute("""
                   SELECT id 
                   FROM bruker 
                   WHERE epost = :epost
                   """, 
                   {"epost": epost}
    )
    bruker = cursor.fetchone()

    # Sjekker om brukeren finnes, sier fra hvis ikke
    if bruker is None:
        print('Brukeren finnes ikke')
        con.close()
        return
    
    # Sjekker om brukeren er svartelista
    cursor.execute("""
                    SELECT COUNT(*) FROM svartelista
                    WHERE bruker_id = :bruker_id
                    AND start_dato >= DATE('now', '-30 days')
                    """, 
                    {"bruker_id": bruker[0]})
    
    # Sier ifra hvis brukeren er svartelista
    if cursor.fetchone()[0] > 0:
        print("Brukeren er svartelistet og kan ikke booke trening.")
        con.close()
        return
    
    # Sjekker om brukeren allerede er påmeldt
    cursor.execute("""
                   SELECT * FROM påmelding 
                   WHERE bruker_id = :bruker_id AND gruppetime_id = :gruppetime_id
                   """, 
                   {"bruker_id": bruker[0], "gruppetime_id": gruppetime[0]})
    
    if cursor.fetchone() is not None:
        print("Brukeren er allerede påmeldt denne treningen.")
        con.close()
        return
    
        # Sjekker kapasitet i salen for gruppetimen
    cursor.execute("""
                   SELECT s.plasser, COUNT(p.bruker_id)
                   FROM gruppetime g
                   JOIN sal s ON g.sal_id = s.id
                   LEFT JOIN påmelding p ON p.gruppetime_id = g.id
                   WHERE g.id = :gruppetime_id
                   GROUP BY g.id, s.plasser
                   """,
                   {"gruppetime_id": gruppetime[0]})

    kapasitet = cursor.fetchone()

    if kapasitet is None:
        print("Kunne ikke hente kapasitet for treningen.")
        con.close()
        return

    maks_plasser = kapasitet[0]
    antall_påmeldte = kapasitet[1]

    if antall_påmeldte >= maks_plasser:
        print("Treningen er fullbooket.")
        con.close()
        return
    
    # Sjekker om brukeren allerede er påmeldt en overlappende gruppetime
    cursor.execute("""
                   SELECT g2.id, g2.aktivitetstype_navn, g2.dato, g2.starttid
                   FROM påmelding p
                   JOIN gruppetime g1 ON g1.id = :ny_gruppetime_id
                   JOIN gruppetime g2 ON g2.id = p.gruppetime_id
                   WHERE p.bruker_id = :bruker_id
                   AND g1.dato = g2.dato
                   AND time(g1.starttid) < time(g2.starttid, '+' || g2.varighet_minutter || ' minutes')
                   AND time(g2.starttid) < time(g1.starttid, '+' || g1.varighet_minutter || ' minutes')
                   """, {"bruker_id": bruker[0],"ny_gruppetime_id": gruppetime[0]})

    overlapp = cursor.fetchone()

    if overlapp is not None:
        print("Brukeren er allerede påmeldt en overlappende gruppetime.")
        con.close()
        return
    
    # Booker treningen hvis ingen av testene slo ut
    cursor.execute("""
                   INSERT INTO påmelding 
                   VALUES(:bruker_id, :gruppetime_id, NULL)
                   """, 
                   {"bruker_id": bruker[0], "gruppetime_id": gruppetime[0]}
    )

    # Stenger tilkoblingen
    con.commit()
    con.close()

    return

# Funksjon for brukstilfelle 3, registrering av oppmøte
def brukstilfelle_3(brukernavn, aktivitet):
    # Kobler til databasen
    con, cursor = koble_til()
    
    # Henter ut bruker fra databasen
    cursor.execute("""
                   SELECT id 
                   FROM bruker 
                   WHERE epost = :epost
                   """, 
                   {"epost": brukernavn})
    bruker = cursor.fetchone()
    
    # Sjekker om brukeren finnes, sier fra hvis ikke
    if bruker is None:
        print('Brukeren finnes ikke')
        con.close()
        return
    
    # Sjekker om påmelding finnes
    cursor.execute("""
                   SELECT * 
                   FROM påmelding 
                   WHERE bruker_id = :bruker_id AND gruppetime_id = :gruppetime_id
                   """, 
                   {"bruker_id": bruker[0], "gruppetime_id": aktivitet})
    påmelding = cursor.fetchone()
    
    if påmelding is None:
        print('Brukeren er ikke påmeldt denne treningen')
        con.close()
        return
    
    # Henter ut dato og starttid for gruppetime
    cursor.execute("""
                   SELECT dato, starttid
                   FROM gruppetime
                   WHERE id = :aktivitet
                   """, 
                   {"aktivitet": aktivitet})
    
    gruppetime_info = cursor.fetchone()

    if gruppetime_info is None:
        print("Treningen finnes ikke")
        con.close()
        return

    # Lager ett samlet datetime-objekt for treningsstart
    treningsstart = datetime.strptime(
        f"{gruppetime_info[0]} {gruppetime_info[1]}",
        "%Y-%m-%d %H:%M:%S"
    )
    
    # Sjekker om oppmøte er innen fristen
    nå = datetime.now()
    if nå > (treningsstart - timedelta(minutes=5)):
        print("For sent å registrere oppmøte, du får prikk")

        # Sjekker om bruker allerede har fått prikk for denne treningen
        cursor.execute("""
                       SELECT *
                       FROM prikk
                       WHERE bruker_id = :bruker_id AND gruppetime_id = :gruppetime_id
                       """,
                       {"bruker_id": bruker[0], "gruppetime_id": aktivitet})
        
        if cursor.fetchone() is None:
            cursor.execute("""
                           INSERT INTO prikk
                           VALUES(:bruker_id, :gruppetime_id, DATE('now'))
                           """, 
                           {"bruker_id": bruker[0], "gruppetime_id": aktivitet})

        con.commit()
        con.close()
        return
    
    # Registrerer oppmøte
    cursor.execute("""
                   UPDATE påmelding 
                   SET oppmøte_tidspunkt = :nå 
                   WHERE bruker_id = :bruker_id AND gruppetime_id = :gruppetime_id 
                   """,
                   {"nå": nå.strftime("%H:%M:%S"), "bruker_id": bruker[0], "gruppetime_id": aktivitet})
    
    con.commit()
    con.close()
    print("Oppmøte registrert!")
    
# Funksjon for brukstilfelle 4, sortert ukeplan for alle treninger i uke x
def brukstilfelle_4(startdag, uke):
    # Kobler til databasen
    con, cursor = koble_til()

    # Definerer en ordbok for å konvertere ukedager til antall dager fra mandag
    dager = {
        "mandag": 0,
        "tirsdag": 1,
        "onsdag": 2,
        "torsdag": 3,
        "fredag": 4,
        "lørdag": 5,
        "søndag": 6
    }

    # Sjekker om uke og startdag er gyldige, sier fra hvis ikke
    if uke < 1 or uke > 52:
        print("Ugyldig uke, må være mellom 1 og 52")
        con.close()
        return      
    
    if startdag not in dager:
        print("Ugyldig startdag, må være en ukedag (mandag-søndag)")
        con.close()
        return

    # Bestemmer start- og sluttdato for uken
    mandag = datetime.fromisocalendar(2026, uke, 1)

    startdato = mandag + timedelta(days=dager[startdag])
    sluttdato = mandag + timedelta(days=6)

    # Henter datoer i sortert rekkefølge
    cursor.execute("""
        SELECT g.dato, g.starttid, g.aktivitetstype_navn, s.sit_senter_navn, s.navn, i.navn
        FROM gruppetime g
        JOIN sal s ON g.sal_id = s.id
        JOIN instruktør i ON g.instruktør_id = i.id
        WHERE g.dato BETWEEN :startdato AND :sluttdato
        ORDER BY g.dato, g.starttid
        """,
        {"startdato": startdato.strftime("%Y-%m-%d"), "sluttdato": sluttdato.strftime("%Y-%m-%d")})
    
    resultater = cursor.fetchall()
    
    # Sjekker om det finnes treninger i den valgte perioden, sier fra hvis ikke
    if not resultater:
        print("Ingen treninger funnet i valgt periode.")
    else:
        print(f"{'Dato':<12} {'Tid':<8} {'Aktivitet':<20} {'Senter':<15} {'Sal':<10} {'Instruktør'}")
        print("-" * 75)
        for rad in resultater:
            print(f"{rad[0]:<12} {rad[1]:<8} {rad[2]:<20} {rad[3]:<15} {rad[4]:<10} {rad[5]}")

    con.close()

# Funksjon for brukstilfelle 5, skriver ut besøkshistorie til bruker 
def brukstilfelle_5(epost):
    # Kobler til databasen
    con, cursor = koble_til()

    # Henter ut bruker fra databasen
    cursor.execute("""
                   SELECT id 
                   FROM bruker 
                   WHERE epost = :epost
                   """, 
                   {"epost": epost}
    )
    bruker = cursor.fetchone()

    # Sjekker om brukeren finnes, sier fra hvis ikke
    if bruker is None:
        print('Brukeren finnes ikke')
        con.close()
        return
    
    # Henter ut besøkshistorie for brukeren
    cursor.execute("""
                   SELECT DISTINCT g.dato, g.starttid, g.aktivitetstype_navn, s.sit_senter_navn
                    FROM påmelding p
                    JOIN gruppetime g ON p.gruppetime_id = g.id
                    JOIN sal s ON g.sal_id = s.id
                    JOIN bruker b ON p.bruker_id = b.id
                    WHERE b.epost = :epost
                    AND p.oppmøte_tidspunkt IS NOT NULL
                    AND g.dato >= '2026-01-01'
                    """,
                    {"epost": epost})
    
    resultater = cursor.fetchall()

    # Sjekker om det finnes besøkshistorie for brukeren, sier fra hvis ikke
    if not resultater:
        print("Ingen besøkshistorie funnet for denne brukeren.")
        con.close()
    else:
        print(f"{'Dato':<12} {'Tid':<8} {'Aktivitet':<20} {'Senter'}")
        print("-" * 60)
        for rad in resultater:
            print(f"{rad[0]:<12} {rad[1]:<8} {rad[2]:<20} {rad[3]}")

    con.close()

# Funksjon for brukstilfelle 6, svartelisting av bruker
def brukstilfelle_6(epost):
    # Kobler til databasen
    con, cursor = koble_til()

    # Henter ut bruker fra databasen
    cursor.execute("""
                   SELECT id 
                   FROM bruker 
                   WHERE epost = :epost
                   """, 
                   {"epost": epost}
    )
    bruker = cursor.fetchone()

    # Sjekker om brukeren finnes, sier fra hvis ikke
    if bruker is None:
        print('Brukeren finnes ikke')
        con.close()
        return
    
    cursor.execute("""
                   SELECT COUNT(*)
                   FROM prikk
                   WHERE bruker_id =:bruker_id
                   AND dato_registrert >= DATE('now', '-30 days')
                   """,
                   {"bruker_id": bruker[0]})
    
    antall_prikker = cursor.fetchone()[0]
    
    if antall_prikker < 3: 
        print(f"Brukeren har kun {antall_prikker} prikker siste 30 dager, svartelisting krever 3.")
        con.close()
        return
    
    # Sjekker om brukeren allerede er aktivt svartelistet
    cursor.execute("""
                   SELECT COUNT(*)
                   FROM svartelista
                   WHERE bruker_id = :bruker_id
                   AND start_dato >= DATE('now', '-30 days')
                   """,
                   {"bruker_id": bruker[0]})
    
    if cursor.fetchone()[0] > 0:
        print(f"Brukeren {epost} er allerede svartelistet.")
        con.close()
        return
    
    # Svartelister brukeren
    cursor.execute("""
                   INSERT INTO svartelista VALUES(:bruker_id, DATE('now'))
                   """,
                   {"bruker_id": bruker[0]})
    
    con.commit()
    con.close()
    print(f"Brukeren {epost} er nå svartelistet i 30 dager.")

# Funksjon for brukstilfelle 7, henter personer som har trent flest fellestrenniger
def brukstilfelle_7(maned):
    # Kobler til databasen
    con, cursor = koble_til()

    # Definerer en ordbok for å konvertere måneder til deres respektive tallverdi
    maneder = {
        "januar": "01",
        "februar": "02",
        "mars": "03",
        "april": "04",
        "mai": "05",
        "juni": "06",
        "juli": "07",
        "august": "08",
        "september": "09",
        "oktober": "10",
        "november": "11",
        "desember": "12"
    }

    # Sjekker at måned er en lovlig paramter
    if maned.lower() not in maneder:
        print("Dette er ikke en gyldig måned")
        con.close()
        return
    
    ar = str(datetime.now().year)
    
    cursor.execute("""
                    SELECT b.navn, b.epost, COUNT(*) AS antall
                    FROM påmelding p
                    JOIN bruker b ON p.bruker_id = b.id
                    JOIN gruppetime g ON p.gruppetime_id = g.id
                    WHERE p.oppmøte_tidspunkt IS NOT NULL
                    AND strftime('%m', g.dato) = :maned
                    AND strftime('%Y', g.dato) = :ar
                    GROUP BY p.bruker_id
                    ORDER BY antall DESC
                   """, 
                   {"maned": maneder[maned.lower()], "ar": ar})

    resultater = cursor.fetchall()
    
    if not resultater:
        print(f"Ingen treninger funnet for {maned} {ar}.")
        con.close()
        return
    
    maks = resultater[0][2]
    vinnere = [rad for rad in resultater if rad[2] == maks]

    print(f"\nPersoner med flest gruppetimer i {maned} {ar} ({maks} treninger):")
    print("-" * 50)
    for rad in vinnere:
        print(f"{rad[0]:<20} {rad[1]}")
    
    con.close()


# Funksjon for brukstilfelle 8, henter personer som trener sammen
def brukstilfelle_8():
    # Kobler til databasen
    con, cursor = koble_til()

    cursor.execute("""
                   SELECT b1.epost, b2.epost, COUNT(*) AS treninger_sammen
                   FROM senterbesøk s1
                   JOIN senterbesøk s2 ON s1.sit_senter_navn = s2.sit_senter_navn
                   JOIN bruker b1 ON s1.bruker_id = b1.id
                   JOIN bruker b2 ON s2.bruker_id = b2.id
                   WHERE s1.bruker_id < s2.bruker_id
                   AND ABS(strftime('%s', s1.ankomst) - strftime('%s', s2.ankomst)) <= 30
                   GROUP BY s1.bruker_id, s2.bruker_id
                   HAVING COUNT(*) >= 2
                   """)
    
    resultater = cursor.fetchall()

    if not resultater:
        print("Ingen par funnet som har trent sammen.")
        con.close()
        return
    
    print(f"\n{'Bruker 1':<25} {'Bruker 2':<25} {'Treninger sammen'}")
    print("-" * 65)
    for rad in resultater:
        print(f"{rad[0]:<25} {rad[1]:<25} {rad[2]}")
    
    con.close()

    





