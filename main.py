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
    cursor.execute('SELECT * FROM gruppetime WHERE aktivitetstype_navn =:aktivitet AND starttid =:starttid', 
                   {"aktivitet": aktivitet, "starttid": tidspunkt}
    )

    # Sjekker om gruppetimen finnes, sier ifra hvis ikke
    gruppetime = cursor.fetchone()
    if gruppetime is None:
        print('Treningen finnes ikke')
        return
    
    # Henter ut bruker fra databasen
    cursor.execute('SELECT id FROM bruker WHERE epost = :epost', 
                   {"epost": epost}
    )
    bruker = cursor.fetchone()

    # Sjekker om brukeren finnes, sier fra hvis ikke
    if bruker is None:
        print('Brukeren finnes ikke')
        return
    
    # Booker treningen hvis ingen av testene slo ut
    cursor.execute('INSERT INTO påmelding VALUES(:bruker_id, :gruppetime_id, NULL,)', 
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
    cursor.execute('SELECT id FROM bruker WHERE epost = :epost', 
                   {"epost": brukernavn})
    bruker = cursor.fetchone()
    
    # Sjekker om brukeren finnes, sier fra hvis ikke
    if bruker is None:
        print('Brukeren finnes ikke')
        return
    
    # Sjekker om påmelding finnes
    cursor.execute('SELECT * FROM påmelding WHERE bruker_id = :bruker_id AND gruppetime_id = :gruppetime_id', 
                   {"bruker_id": bruker[0], "gruppetime_id": aktivitet})
    påmelding = cursor.fetchone()
    
    if påmelding is None:
        print('Brukeren er ikke påmeldt denne treningen')
        return
    
    # Henter ut starttid for gruppetime
    cursor.execute('SELECT starttid FROM gruppetime WHERE id = :aktivitet', 
                   {"aktivitet": aktivitet})
    starttid = datetime.strptime(cursor.fetchone()[0], "%H:%M:%S")
    
    # Sjekker om oppmøte er innen fristen
    nå = datetime.now()
    if nå.time() > (starttid - timedelta(minutes=5)).time():
        print("For sent å registrere oppmøte, du får prikk")
        con.close()
        return
    
    # Registrerer oppmøte
    cursor.execute('UPDATE påmelding SET oppmøte_tidspunkt = :nå WHERE bruker_id = :bruker_id AND gruppetime_id = :gruppetime_id',
                   {"nå": nå.strftime("%H:%M:%S"), "bruker_id": bruker[0], "gruppetime_id": aktivitet})
    
    con.commit()
    con.close()
    print("Oppmøte registrert!")
    
