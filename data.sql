-- Setter inn data om treningssenter
INSERT INTO sit_senter VALUES
    ('DMMH treningsrom', 'Thrond Nergaards veg 7', '91521539', 'Sit DMMH har et treningsrom på ca 150kvm, med kondisjonsapparater, frivekter og styrkeapparater, samt en stor gruppetimesal. Det er garderobefasiliteter tilknyttet treningsrommet som både studenter og ansatte kan benytte. Disse finner du til venstre i gangen for treningsrommet. Alle med aktivt treningskort hos Sit Trening har tilgang til treningsrommet i skolens åpningstider. Er du ikke student/ansatt ved DMMH, men ønsker å trene der før kl. 08.00, etter kl. 15.00, eller i helgene, kan du få lagt inn adgang til DMMH på ditt studentkort eller treningskort. Ta med deg legitimasjon, ditt studentkort/treningskort, og ta kontakt med ekspedisjonen i 2. etg innenfor skolens åpningstider (08-15).'),
    ('Dragvoll idrettssenter', 'Loholt allé 81', '90950246', 'På Dragvoll får du et meget variert treningstilbud: treningsstudio med frivekter og apparater, tre squashbaner, aerobicsal, gymsal og en stor flerbrukshall. Her finner du også garderober med badstue. Badstuene er åpne når senteret er bemannet. '),
    ('Gløshaugen idrettsbygg', 'Chr. Frederiks gate 20', '91521539', 'Ved Gløshaugen idrettsbygg finner du et allsidig treningstilbud - enten om du liker å trene alene i studio eller sammen med andre i gruppe. Vi har to gruppetreningssaler, en liten og en stor idrettshall, en stor apparatpark med egne områder dedikert til vektløftning og funksjonell trening, og eget løperom. Senteret har også freshe garderober med badstue.'),
    ('Moholt treningssenter', 'Moholt allmenning 12', NULL, 'Senteret består av tre rom med frivekter, styrke- og kondisjonsapparater, samt en basisavdeling - alt du trenger for en fullverdig treningsøkt. Det er ikke garderobe med dusjmuligheter, men omkledningsrom og toaletter. Ubemannet senter. For å få adgang må du ha aktivt medlemskap. Dette kan kjøpes på nett og aktiveres via mobilappen, eller du kan aktivere et fysisk kort i resepsjonen på Dragvoll, Portalen eller Gløshaugen.'),
    ('Øya treningssenter', 'Vangslundsgate 2', '91521539', 'Øya treningssenter ligger i Helgasetr-bygget på Øya, og er vårt nyeste treningssenter i Trondheim. Senteret inneholder blant annet 3 etasjer med styrke- og kondisjonsutstyr for egentrening, 4 gruppetreningssaler, functional fitness-boks, flerbrukshall, løpebane, og klatre- og buldrevegg. Senteret har også freshe garderober med badstue, disse finner du en etasje ned fra inngangsområdet. Øya treningssenter er ubemannet, og du må ha et gyldig medlemskap for komme deg inn. Ha med deg nøkkelkortet ditt eller Sit Trening-appen under treningsøkta for å få tilgang til de ulike delene av senteret. Ved behov for hjelp, så kan du kontakte resepsjonen ved Gløshaugen idrettsbygg.');

-- Fasiliteter på alle SIT-sentre
INSERT INTO fasilitet VALUES
    ('Gruppetrening'),
    ('Egentrening'),
    ('Utholdenhet'),
    ('Styrke'),
    ('Yoga'),
    ('Klatring'),
    ('Spinning'),
    ('Hall'),
    ('Garderober'),
    ('Badstue'),
    ('Dusj'),
    ('Ubemannet treningssenter'),
    ('Bemannet resepsjon'),
    ('Squash');

-- Øya treningssenter + Spinningsal på Dragvoll
INSERT INTO sal VALUES
    (2001, 'Dragvoll idrettssenter', 'Spinningsal', 20), --Må ha med Dragvoll som spinningsal, fordi noen spinningøkter er der
    (3001, 'Øya treningssenter', 'Flerbrukshall 1', 100),
    (3000, 'Øya treningssenter', 'Flerbrukshall 2', 100),
    (3002, 'Øya treningssenter', 'Møllesal', 30),
    (3003, 'Øya treningssenter', 'Sykkelsal', 38);

-- Tilfeldige navn inkludert Johnny
INSERT INTO bruker VALUES
    (1, 'Ola Nordmann', 'ola.nordmann@gmail.com', '94782911'),
    (2, 'Kari Bremnes', 'kari.bremnes@gmail.com', '456464767'),
    (3, 'Ludvig Smartnes', 'ludvig.smartnes@gmail.com', '98789878'),
    (4, 'Johnny Vassbakk', 'johnny@stud.ntnu.no', '99121345'),
    (5, 'Martin Lurvik', 'martin.lurvik@gmail.com', '43447823'),
    (6, 'Anne Borg', 'anne.borg@gmail.com', '45789923'),
    (7, 'Jonas Nøland', 'jonas.noeland@gmail.com', '44423312'),
    (8, 'Kent Ranum', 'kent.ranum@gmail.com', '99874533');

-- Instruktørnavn hentet fra siden til SIT for spinningtimer i uke 12
INSERT INTO instruktør VALUES
    (1, 'Eirin H.'),
    (2, 'Siri M. L.'),
    (3, 'Jorunn B. B.'),
    (4, 'Ramona L. S.'),
    (5, 'Trine R.'),
    (6, 'Nora D.'),
    (7, 'Håkon W.'),
    (8, 'Hanne H.'),
    (9, 'Ada J.R.'),
    (10, 'Sindre K. S.'),
    (11, 'Kaja S.'),
    (12, 'Amalie M. H.'),
    (13, 'Natalie D. H.'),
    (14, 'Rikke S.W');

-- Ulike spinningaktiviteter
INSERT INTO aktivitets_type VALUES 
    ('Spin 4x4', 'Spinning', 'En forutsigbar intervalltime: 4 stående intervaller på 4 minutter hver, med ca 2 minutter aktiv pause mellom hvert drag. God oppvarming og nedsykling inkludert.'),
    ('Spin 8x3', 'Spinning', 'En forutsigbar intervalltime med 8 intervaller på 3 minutter hver, der du sitter og står annethvert drag. 90-120 sek pause mellom hvert intervall. God oppvarming og nedsykling inkludert.'),
    ('Spin45', 'Spinning', 'En variert spinningtime med 2-3 arbeidsperioder som passer for alle. Perfekt for deg som er ny på spinning! Du styrer intensiteten selv, og vi bruker takta til å tråkke oss gjennom timen.'),
    ('Spin60', 'Spinning', 'En variert spinningtime som er noe mer utfordrende enn Spin45 med lengre varighet og tidvis høyere tempo. Du styrer likevel intensiteten selv, og timen passer alle som liker å tråkke i takt! Timen inneholder 2-4 arbeidsperioder med variert løype.');

-- Har tatt med alle spinningtimer i uke 12
INSERT INTO gruppetime VALUES 
    (1101, 3003, 1, 'Spin 4x4', '2026-03-16', '07:00:00', '45'),
    (1102, 2001, 2, 'Spin 4x4', '2026-03-16', '16:30:00', '45'),
    (1103, 3003, 3, 'Spin45', '2026-03-16', '16:30:00', '45'),
    (1104, 3003, 4, 'Spin 8x3', '2026-03-16', '17:40:00', '55'),
    (1105, 3003, 5, 'Spin60', '2026-03-16', '19:00:00', '60'),
    (1106, 3003, 6, 'Spin 8x3', '2026-03-17', '07:00:00', '55'),
    (1107, 3003, 7, 'Spin60', '2026-03-17', '18:30:00', '60'),
    (1108, 3003, 8, 'Spin 4x4', '2026-03-17', '19:45:00', '45'),
    (1109, 3003, 6, 'Spin60', '2026-03-18', '16:15:00', '60'),
    (1110, 2001, 9, 'Spin45', '2026-03-18', '16:30:00', '45'),
    (1111, 3003, 10, 'Spin 4x4', '2026-03-18', '17:30:00', '45'),
    (1112, 3003, 11, 'Spin45', '2026-03-18', '18:30:00', '45'),
    (1113, 3003, 12, 'Spin 8x3', '2026-03-18', '19:30:00', '55'),
    (1114, 3003, 2, 'Spin 8x3', '2026-03-19', '07:30:00', '55'),
    (1115, 3003, 3, 'Spin45', '2026-03-19', '16:45:00', '45'),
    (1116, 3003, 13, 'Spin60', '2026-03-19', '17:45:00', '60'),
    (1117, 3003, 11, 'Spin45', '2026-03-20', '06:30:00', '45'),
    (1118, 3003, 14, 'Spin 8x3', '2026-03-20', '16:30:00', '55'),
    (1119, 3003, 2, 'Spin60', '2026-03-21', '10:00:00', '60'),
    (1120, 3003, 10, 'Spin 8x3', '2026-03-21', '12:00:00', '55'),
    (1121, 3003, 3, 'Spin45', '2026-03-22', '12:15:00', '45');

-- Johnny sine spinningtimer fra 1.januar 
INSERT INTO gruppetime VALUES
    (901, 3003, 7, 'Spin60', '2026-01-13', '18:30:00', '60'),
    (902, 3003, 7, 'Spin60', '2026-01-20', '18:30:00', '60'),
    (903, 3003, 7, 'Spin60', '2026-01-27', '18:30:00', '60'),
    (904, 3003, 6, 'Spin60', '2026-02-04', '16:15:00', '60'),
    (905, 3003, 12, 'Spin 8x3', '2026-02-11', '19:30:00', '55'),
    (906, 3003, 7, 'Spin60', '2026-02-17', '18:30:00', '60'),
    (907, 3003, 7, 'Spin60', '2026-02-24', '18:30:00', '60'),
    (908, 3003, 10, 'Spin 4x4', '2026-03-04', '17:30:00', '45');

-- Påmelding til de gitte spinningtimene fra 1.januar
INSERT INTO påmelding VALUES
    (4, 901, '18:22:12'),
    (4, 902, '18:23:45'),
    (4, 903, '18:18:49'), 
    (4, 904, '18:21:08'), 
    (4, 905, '18:24:37'), 
    (4, 906, '18:20:04'),
    (4, 907, '18:24:09'),
    (4, 908, '18:22:09'),
    (4, 1107, '18:19:48'); --Johnny sin spinning 17.mars

--Senterbesøk hvor Anne og Jonas trente sammen
INSERT INTO senterbesøk VALUES
    ('Gløshaugen idrettsbygg', 6, '2026-02-19 19:28:02'),
    ('Gløshaugen idrettsbygg', 7, '2026-02-19 19:28:07'),
    ('Gløshaugen idrettsbygg', 6, '2026-02-23 18:01:11'),
    ('Gløshaugen idrettsbygg', 7, '2026-02-23 18:01:32'),
    ('Øya treningssenter', 6, '2026-03-08 20:09:01'),
    ('Øya treningssenter', 7, '2026-03-08 20:08:48');

-- Fasiliteter for Øya treningssenter
INSERT INTO senter_fasilitet VALUES
    ('Øya treningssenter', 'Gruppetrening'),
    ('Øya treningssenter', 'Egentrening'),
    ('Øya treningssenter', 'Utholdenhet'),
    ('Øya treningssenter', 'Styrke'),
    ('Øya treningssenter', 'Yoga'),
    ('Øya treningssenter', 'Klatring'),
    ('Øya treningssenter', 'Spinning'),
    ('Øya treningssenter', 'Hall'),
    ('Øya treningssenter', 'Garderober'),
    ('Øya treningssenter', 'Badstue'),
    ('Øya treningssenter', 'Dusj'),
    ('Øya treningssenter', 'Ubemannet treningssenter');

-- Sykler i sykkelsalen på Øya (sal_id 3004), alle med bluetooth
INSERT INTO sykkel VALUES
    (3003, 1, TRUE),
    (3003, 2, TRUE),
    (3003, 3, TRUE),
    (3003, 4, TRUE),
    (3003, 5, TRUE),
    (3003, 6, TRUE),
    (3003, 7, TRUE),
    (3003, 8, TRUE),
    (3003, 9, TRUE),
    (3003, 10, TRUE),
    (3003, 11, TRUE),
    (3003, 12, TRUE),
    (3003, 13, TRUE),
    (3003, 14, TRUE),
    (3003, 15, TRUE),
    (3003, 16, TRUE),
    (3003, 17, TRUE),
    (3003, 18, TRUE),
    (3003, 19, TRUE),
    (3003, 20, TRUE),
    (3003, 21, TRUE),
    (3003, 22, TRUE),
    (3003, 23, TRUE),
    (3003, 24, TRUE),
    (3003, 25, TRUE),
    (3003, 26, TRUE),
    (3003, 27, TRUE),
    (3003, 28, TRUE),
    (3003, 29, TRUE),
    (3003, 30, TRUE),
    (3003, 31, TRUE),
    (3003, 32, TRUE),
    (3003, 33, TRUE),
    (3003, 34, TRUE),
    (3003, 35, TRUE),
    (3003, 36, TRUE),
    (3003, 37, TRUE),
    (3003, 38, TRUE);
    
-- Ettersom brukstilfelle 2 vil feile ved prikk på Johnny, lager vi en egen Petter Prikk for å teste brukstilfelle 7
INSERT INTO bruker VALUES 
    (9, 'Petter Prikk', 'petter@stud.ntnu.no', '12345678');

-- Melder Petter Prikk på noen timer så han kan få prikker
INSERT INTO påmelding VALUES
    (9, 901, NULL),
    (9, 902, NULL),
    (9, 903, NULL);

-- Prikker på Petter prikk
INSERT INTO prikk VALUES
    (9, 901, '2026-03-01'),
    (9, 902, '2026-03-05'),
    (9, 903, '2026-03-10');

-- Setter inn data for brukstilfelle 7, de som har trent mest
INSERT INTO påmelding VALUES
    (1, 1107, '18:25:00'),
    (1, 1109, '16:10:00'),
    (1, 1112, '18:25:00'),
    (2, 1107, '18:26:00'),
    (2, 1109, '16:11:00');