# 🏋️ TreningDB — Gruppe 269

> Databaseprosjekt i TDT4145 Datamodellering og databasesystemer @ NTNU

![SQLite](https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![NTNU](https://img.shields.io/badge/NTNU-00509E?style=for-the-badge&logoColor=white)
![Status](https://img.shields.io/badge/Status-Ferdig-green?style=for-the-badge)

---

## 👥 Gruppemedlemmer

| Navn |
|------|
| Andreas Bang-Olsen |
| Tørres Lutnæs |
| Mika Migliorini |

---

## 📁 Prosjektstruktur

```
Prosjekt_269/
│
├── treningDB.db           # SQLite-databasefil (tom, klar for initialisering)
├── schema.sql             # DDL-script: oppretter alle tabeller
├── data.sql               # DML-script: setter inn testdata
├── ER.pdf                 # ER-diagram fra del 1
├── Kommentarer til ER.pdf # Kommentarer fra del 1
├── main.py                # Hovedprogram med alle brukstilfeller|
└── README.md              # Denne filen
```

---

## 🚀 Kom i gang

### Krav

- Python 3.x (ingen eksterne biblioteker nødvendig)
- SQLite3 (følger med Python)

### Steg 1 — Initialiser databasen

Kjør følgende kommandoer i terminalen fra prosjektmappen:

```bash
sqlite3 treningDB.db < schema.sql
sqlite3 treningDB.db < data.sql
```

### Steg 2 — Kjør programmet

```bash
python main.py
```

Du vil da se en meny med alle brukstilfeller.

---

## 📌 Brukstilfeller og eksempelinput

### 1 — Book trening
```
Velg brukstilfelle: 1
Epost: johnny@stud.ntnu.no
Aktivitet: Spin60
Tidspunkt (HH:MM:SS): 18:30:00
```

### 2 — Registrer oppmøte
```
Velg brukstilfelle: 2
Epost: johnny@stud.ntnu.no
Gruppetime-id: 1107
```

### 3 — Ukeplan
```
Velg brukstilfelle: 3
Startdag (mandag-søndag): mandag
Ukenummer: 12
```

### 4 — Besøkshistorie
```
Velg brukstilfelle: 4
Epost: johnny@stud.ntnu.no
```

### 5 — Svartelisting
```
Velg brukstilfelle: 5
Epost: petter@stud.ntnu.no
```
> Petter Prikk har 3 prikker i systemet og vil bli svartelistet.
> For å teste at svartelisting blokkerer booking, kjør brukstilfelle 1 med petter@stud.ntnu.no etterpå.

### 6 — Flest gruppetimer
```
Velg brukstilfelle: 6
Måned: mars
```

### 7 — Trener sammen
```
Velg brukstilfelle: 7
```
> Anne Borg og Jonas Nøland har besøkt treningssenter innen 30 sekunder av hverandre 3 ganger.

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

Testdata dekker en **3-dagers periode: 16.–18. mars 2026**, med fokus på:

- 🚴 Alle **spinning**-aktiviteter på **Øya** treningssenter
- 🚴 Alle **spinning**-aktiviteter på **Dragvoll** treningssenter
- Fasiliteter, saler og sykler for Øya treningssenter

---
