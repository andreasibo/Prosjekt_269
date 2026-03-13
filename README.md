# 🏋️ TreningDB — Gruppe 269

> Databaseprosjekt i TDT4145 Datamodellering og databasesystemer @ NTNU

![SQLite](https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![NTNU](https://img.shields.io/badge/NTNU-00509E?style=for-the-badge&logo=data:image/png;base64,&logoColor=white)
![Status](https://img.shields.io/badge/Status-Under%20utvikling-yellow?style=for-the-badge)

---

## 👥 Gruppemedlemmer

| Navn | NTNU-bruker |
|------|-------------|
| Andreas Bang-Olsen | - |
| Tørres Lutnæs | - |
| Mika Migliorini | - |

---

## 📋 Om prosjektet

TreningDB er et databasesystem for SiT Trening i Trondheim. Systemet håndterer booking av gruppetimer, registrering av oppmøte, svartelisting av brukere og statistikk over treningsaktivitet på tvers av flere treningssentre.

Databasen er implementert i **SQLite** og applikasjonslogikken er skrevet i **Python**.

---

## 📁 Prosjektstruktur

```
Prosjekt_269/
│
├── treningDB.db          # SQLite-databasefil (tom, klar for initialisering)
├── schema.sql            # DDL-script: oppretter alle tabeller
├── data.sql              # DML-script: setter inn testdata
├── main.py               # Hovedprogram med alle brukstilfeller
└── README.md             # Denne filen
```

---

## 🚀 Kom i gang

### Krav

- Python 3.x
- SQLite3 (følger med Python)

### Steg-for-steg

**1. Klon repoet**
```bash
git clone git@github.com:andreasibo/Prosjekt_269.git
cd Prosjekt_269
```

**2. Opprett og initialiser databasen**
```bash
sqlite3 treningDB.db < schema.sql
sqlite3 treningDB.db < data.sql
```

**3. Kjør programmet**
```bash
python main.py
```

---

## 📌 Brukstilfeller

Programmet tilbyr følgende brukstilfeller via en tekstbasert meny:

| # | Beskrivelse | Implementasjon |
|---|-------------|----------------|
| 1 | Legg inn treningssenter, saler, sykler, brukere, trenere og treninger | SQL |
| 2 | Booking av trening for en bruker | Python + SQL |
| 3 | Registrering av oppmøte | Python + SQL |
| 4 | Ukeplan for alle treninger i uke 12 (16.–23. mars) | Python + SQL |
| 5 | Personlig besøkshistorie for en bruker siden 1. januar 2026 | SQL |
| 6 | Svartelisting av bruker ved 3 prikker innen 30 dager | Python + SQL |
| 7 | Finn bruker(e) med flest gruppetimer en gitt måned | Python + SQL |
| 8 | Finn par av studenter som har trent flest ganger sammen | SQL |

---

## 🗄️ Datamodell

Databasen inneholder følgende hovedentiteter:

- **sit_senter** — Treningssentre med adresse, kontakt og beskrivelse
- **sal** — Saler tilknyttet hvert senter
- **sykkel / tredemølle** — Utstyr i salene
- **bruker** — Registrerte brukere
- **instruktør** — Instruktører for gruppetimer
- **gruppetime** — Planlagte gruppetimer
- **påmelding** — Brukeres påmeldinger til gruppetimer
- **prikk** — Prikker for manglende oppmøte
- **svartelista** — Utestengte brukere
- **reservasjon** — Idrettslagets salreservasjoner

Se `schema.sql` for fullstendig DDL og `ER.pdf` for ER-modellen.

---

## 🧪 Testdata

Testdata dekker en **3-dagers periode: 16.–18. mars 2025**, med fokus på:

- 🚴 Alle **spinning**-aktiviteter på **Øya** treningssenter
- 🚴 Alle **spinning**-aktiviteter på **Dragvoll** treningssenter
- Fasiliteter, saler og sykler for Øya treningssenter

---

## 🤖 Bruk av KI

Dette prosjektet har benyttet KI (Claude, Anthropic) som hjelpemiddel under utviklingen. Se egen KI-deklarasjon i innleveringsdokumentet for detaljer om hvilke deler som er generert, assistert eller egenprodusert.

---

## 📄 Lisens

Akademisk prosjekt — kun for intern bruk i TDT4145 ved NTNU.
