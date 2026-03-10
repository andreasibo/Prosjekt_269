-- Grunnleggende informasjon (Senter og fasiliter)
CREATE TABLE sit_senter (
    navn VARCHAR(20) PRIMARY KEY, --Distinkte navn på sit-sentre
    addresse VARCHAR(100),
    kontakt VARCHAR(15),
    beskrivelse VARCHAR(255)
);

CREATE TABLE fasilitet (
    navn VARCHAR(30) PRIMARY KEY
);

CREATE TABLE senter_fasilitet (
    sit_senter_navn VARCHAR(20) NOT NULL,
    fasilitet_navn VARCHAR(30) NOT NULL,
    PRIMARY KEY (sit_senter_navn, fasilitet_navn),
    FOREIGN KEY (sit_senter_navn) REFERENCES sit_senter(navn) ON DELETE CASCADE, -- Dersom et senter slettes fjernes også tilknyttede fasiliteter for å unngå foreldreløse rader
    FOREIGN KEY (fasilitet_navn) REFERENCES fasilitet(navn)ON DELETE CASCADE
);

CREATE TABLE åpningstid (
    sit_senter_navn VARCHAR(20) NOT NULL,
    ukedag VARCHAR(7),
    åpner TIME NOT NULL,
    stenger TIME NOT NULL,
    PRIMARY KEY(sit_senter_navn, ukedag),
    FOREIGN KEY(sit_senter_navn) REFERENCES sit_senter(navn) ON DELETE CASCADE,
    CHECK (stenger > åpner), -- Hindrer semantisk ugyldige tidsintervaller
    CHECK (ukedag IN ('mandag','tirsdag','onsdag','torsdag','fredag','lørdag','søndag')) -- SQLite støtter ikke CREATE DOMAIN, ellers hadde vi definert en egen domene
);

CREATE TABLE bemanning (
    sit_senter_navn VARCHAR(20) NOT NULL,
    ukedag VARCHAR(7),
    start_tidspunkt TIME,
    slutt_tidspunkt TIME NOT NULL,
    PRIMARY KEY(sit_senter_navn, ukedag, start_tidspunkt),
    FOREIGN KEY(sit_senter_navn) REFERENCES sit_senter(navn) ON DELETE CASCADE,
    CHECK (slutt_tidspunkt > start_tidspunkt),
    CHECK (ukedag IN ('mandag','tirsdag','onsdag','torsdag','fredag','lørdag','søndag'))
);

-- Saler og utstyr
CREATE TABLE sal (
    id INTEGER PRIMARY KEY, -- Ved bruk av INTEGER og INT tildeler SQLite en unik, stigende heltallsverdi hvis ID ikke blir spesifisert
    sit_senter_navn VARCHAR(20) NOT NULL,
    navn VARCHAR(30),
    plasser INT,
    FOREIGN KEY (sit_senter_navn) REFERENCES sit_senter(navn) ON DELETE CASCADE,
    CHECK (plasser > 0)
);

CREATE TABLE sykkel (
    sal_id INTEGER,
    sykkel_nr INTEGER,
    bluetooth BOOLEAN DEFAULT FALSE, -- Antar at det er rimelig å forvente at dette ikke er standard
    PRIMARY KEY(sal_id, sykkel_nr),
    FOREIGN KEY (sal_id) REFERENCES sal(id) ON DELETE CASCADE
);

CREATE TABLE tredemølle (
    sal_id INTEGER NOT NULL,
    mølle_nr INTEGER,
    produsent VARCHAR(30),
    maks_hastighet INT,
    maks_stigning INT,
    PRIMARY KEY (sal_id, mølle_nr),
    FOREIGN KEY (sal_id) REFERENCES sal(id) ON DELETE CASCADE,
    CHECK (maks_hastighet > 0),
    CHECK (maks_stigning >= 0)
);

-- Brukere og personell
CREATE TABLE instruktør (
    id INTEGER PRIMARY KEY,
    navn VARCHAR (30) NOT NULL
);

CREATE TABLE bruker (
    id INTEGER PRIMARY KEY, 
    navn VARCHAR(30) NOT NULL,
    epost VARCHAR(30) NOT NULL, 
    mobil VARCHAR(15) 
);  

CREATE TABLE gruppe (
    id INTEGER PRIMARY KEY,
    navn VARCHAR(30)
);

CREATE TABLE medlemskap (
    bruker_id INTEGER NOT NULL,
    gruppe_id INTEGER NOT NULL,
    PRIMARY KEY (bruker_id, gruppe_id), 
    FOREIGN KEY (bruker_id) REFERENCES bruker (id) ON DELETE CASCADE,
    FOREIGN KEY (gruppe_id) REFERENCES gruppe (id) ON DELETE CASCADE
);

-- Aktiviteter og booking
CREATE TABLE aktivitets_type (
    navn VARCHAR(30) PRIMARY KEY,
    fasilitet_navn VARCHAR(30) NOT NULL,
    beskrivelse VARCHAR(255),
    FOREIGN KEY (fasilitet_navn) REFERENCES fasilitet(navn) ON DELETE CASCADE -- Slettes hvis fasiliteten fjernes
);

CREATE TABLE gruppetime (
    id INTEGER PRIMARY KEY,
    sal_id INTEGER NOT NULL,
    instruktør_id INTEGER NOT NULL,
    aktivitetstype_navn VARCHAR(30) NOT NULL,
    dato DATE NOT NULL, -- Dato og starttid separeres for å forenkle ukentlige analyser og tidsbaserte spørringer
    starttid TIME NOT NULL, 
    varighet_minutter INT, -- Sikrer at varighet representerer et reelt tidsintervall
    FOREIGN KEY (sal_id) REFERENCES sal (id),
    FOREIGN KEY (instruktør_id) REFERENCES instruktør(id),
    FOREIGN KEY (aktivitetstype_navn) REFERENCES aktivitets_type(navn) ON DELETE CASCADE, -- Kan ikke gjennomføres hvis aktivitettypen ikke eksister på et senter fjernes
    CHECK (varighet_minutter > 0)
);

CREATE TABLE reservasjon (
    id INTEGER PRIMARY KEY,
    sal_id INTEGER NOT NULL,
    gruppe_id INTEGER NOT NULL,
    starttid TIME NOT NULL,
    varighet_minutter INT,
    ukedag VARCHAR(7) NOT NULL,
    FOREIGN KEY (sal_id) REFERENCES sal(id),
    FOREIGN KEY (gruppe_id) REFERENCES gruppe(id),
    CHECK (varighet_minutter > 0),
    CHECK (ukedag IN ('mandag','tirsdag','onsdag','torsdag','fredag','lørdag','søndag'))
);

-- Påmelding, besøk og svartelisting
CREATE TABLE påmelding (
    bruker_id INTEGER NOT NULL,
    gruppetime_id INTEGER NOT NULL,
    oppmøte_tidspunkt TIME DEFAULT NULL, -- NULL representerer manglende oppmøte, ikke ukjent verdi
    PRIMARY KEY (bruker_id, gruppetime_id),
    FOREIGN KEY (bruker_id) REFERENCES bruker (id),
    FOREIGN KEY (gruppetime_id) REFERENCES gruppetime (id)
);

CREATE TABLE prikk (
    bruker_id INTEGER NOT NULL,
    gruppetime_id INTEGER NOT NULL,
    dato_registrert DATE NOT NULL, 
    PRIMARY KEY (bruker_id, gruppetime_id),
    FOREIGN KEY (bruker_id, gruppetime_id) REFERENCES påmelding(bruker_id, gruppetime_id) ON DELETE CASCADE
);

CREATE TABLE svartelista (
    bruker_id INTEGER NOT NULL,
    start_dato DATE NOT NULL, -- Sluttdato lagres ikke eksplisitt, beregnes dynamisk som start_dato + 30 dager
    PRIMARY KEY(bruker_id, start_dato),
    FOREIGN KEY (bruker_id) REFERENCES bruker(id) ON DELETE CASCADE
);

CREATE TABLE senterbesøk (
    sit_senter_navn VARCHAR(20) NOT NULL,
    bruker_id INTEGER NOT NULL,
    ankomst TIMESTAMP,
    PRIMARY KEY (bruker_id, sit_senter_navn, ankomst),
    FOREIGN KEY (bruker_id) REFERENCES bruker(id),
    FOREIGN KEY (sit_senter_navn) REFERENCES sit_senter(navn) 
);

