---------------------------------------------------
------------Siec sklepow elektronicznych-----------
---------------------------------------------------
--------------Mateusz Markowski 235605-------------
-----------------Piotr Lasek 235690----------------
---------------------------------------------------


---------------------------------------------------
--------------Usuwanie starej wersji---------------
---------------------------------------------------

DROP TABLE SZCZEGOLY_ZAMOWIENIA cascade constraints;
DROP TABLE ZAMOWIENIA cascade constraints;
DROP TABLE SZCZEGOLY_DOSTAWY cascade constraints;
DROP TABLE DOSTAWY cascade constraints;
DROP TABLE POJAZDY cascade constraints;
DROP TABLE PRACOWNICY cascade constraints;
DROP TABLE LOKALE cascade constraints;
DROP TABLE PRODUKTY cascade constraints;
DROP TABLE PRACOWNICY_LOG cascade constraints;
DROP TABLE ADRESY cascade constraints;
DROP VIEW WIDOK_WYSYLKA;

---------------------------------------------------
------------------Tworzenie tabel------------------
---------------------------------------------------

CREATE TABLE PRODUKTY
(
ID_Produktu NUMBER(6,0) PRIMARY KEY,
Nazwa_Produktu VARCHAR(20) NOT NULL,
Waga NUMBER(4,2) NOT NULL,
Cena NUMBER(6,2) NOT NULL,
Dostepnosc NUMBER(5,0) NOT NULL
);

CREATE TABLE ADRESY
(
ID_Adresu NUMBER(6,0) PRIMARY KEY,
Miasto VARCHAR(20) NOT NULL,
Kod_pocztowy NUMBER(5,0) NOT NULL,
Ulica VARCHAR(20) NOT NULL,
Numer_lokalu VARCHAR(7) NOT NULL
);

CREATE TABLE LOKALE
(
ID_Lokalu NUMBER(6,0) PRIMARY KEY,
ID_Kierownika NUMBER(6,0) NOT NULL,
ID_Adresu NUMBER(6,0) REFERENCES ADRESY(ID_Adresu)
);

CREATE TABLE PRACOWNICY
(
ID_Pracownika Number(6,0) PRIMARY KEY,
Imie VARCHAR(16) NOT NULL,
Nazwisko VARCHAR(20) NOT NULL,
Stanowisko VARCHAR(20) NOT NULL,
ID_Lokalu NUMBER(6,0) REFERENCES LOKALE(ID_Lokalu),
Pensja NUMBER(8,2) NOT NULL,
ID_Kierownika NUMBER(6,0)
);

CREATE TABLE POJAZDY
(
ID_Pojazdu NUMBER(6,0) PRIMARY KEY,
ID_Pracownika NUMBER(6,0) REFERENCES PRACOWNICY(ID_Pracownika),
Rejestracja VARCHAR(9) NOT NULL
);

CREATE TABLE DOSTAWY
(
Numer_Dostawy NUMBER(6,0) PRIMARY KEY,
ID_Lokalu NUMBER(6,0) REFERENCES LOKALE(ID_Lokalu),
Data_dostawy DATE NOT NULL,
ID_Pojazdu NUMBER(6,0) REFERENCES POJAZDY(ID_Pojazdu)
);

CREATE TABLE SZCZEGOLY_DOSTAWY
(
Numer_Dostawy NUMBER(6,0),
ID_Produktu NUMBER(6,0),
Ilosc_dost NUMBER(5,0) NOT NULL,
FOREIGN KEY (Numer_Dostawy)
      REFERENCES DOSTAWY(Numer_Dostawy),
FOREIGN KEY (ID_Produktu)
      REFERENCES PRODUKTY(ID_Produktu)
);

CREATE TABLE ZAMOWIENIA
(
Numer_Zamowienia NUMBER(6,0) PRIMARY KEY,
Data_zamowienia DATE NOT NULL,
Rodzaj_dostawy VARCHAR(20) NOT NULL,
ID_Adresu NUMBER(6,0) REFERENCES ADRESY(ID_Adresu)
);

CREATE TABLE SZCZEGOLY_ZAMOWIENIA
(
Numer_Zamowienia NUMBER(6,0),
ID_Produktu NUMBER(6,0),
Ilosc_zam NUMBER(5,0) NOT NULL,
Cena_zamowienia NUMBER(6,2) NOT NULL,
FOREIGN KEY (Numer_Zamowienia)
      REFERENCES ZAMOWIENIA(Numer_Zamowienia),
FOREIGN KEY (ID_Produktu)
      REFERENCES PRODUKTY(ID_Produktu)
);

CREATE TABLE PRACOWNICY_LOG
(
id_pracownika Number(6,0) PRIMARY KEY,
stara_pensja number(8,2),
data_zmiany date,
akcja VARCHAR(20)
);

CREATE SEQUENCE seq_pracownicy_log
MINVALUE 1
MAXVALUE 9999
START WITH 1
INCREMENT BY 1
CACHE 20;


---------------------------------------------------
-----------------Tworzenie widoku------------------
---------------------------------------------------

CREATE OR REPLACE FORCE VIEW WIDOK_WYSYLKA (NUMER_ZAMOWIENIA, DATA_ZAMOWIENIA, RODZAJ_DOSTAWY, MIASTO, KOD_POCZTOWY, ULICA, NUMER_LOKALU) AS 
    SELECT DISTINCT
      zam.NUMER_ZAMOWIENIA,
      zam.DATA_ZAMOWIENIA,
      zam.RODZAJ_DOSTAWY,
      ad.MIASTO,
      ad.KOD_POCZTOWY,
      ad.ULICA,
      ad.NUMER_LOKALU
        FROM
           SZCZEGOLY_ZAMOWIENIA sz,
           ADRESY ad,
           ZAMOWIENIA zam
            WHERE
                zam.NUMER_ZAMOWIENIA = sz.NUMER_ZAMOWIENIA AND zam.ID_ADRESU = ad.ID_ADRESU
WITH READ ONLY;


---------------------------------------------------
--------------------Wypelnienia--------------------
---------------------------------------------------

----------------------Produkty---------------------
INSERT INTO PRODUKTY (ID_PRODUKTU, NAZWA_PRODUKTU, WAGA, CENA, DOSTEPNOSC) VALUES ('111111', 'Klawiatura Logitech', '0,45', '79,99', '23');
INSERT INTO PRODUKTY (ID_PRODUKTU, NAZWA_PRODUKTU, WAGA, CENA, DOSTEPNOSC) VALUES ('123456', 'Mysz Logitech', '0,15', '45,99', '76');
INSERT INTO PRODUKTY (ID_PRODUKTU, NAZWA_PRODUKTU, WAGA, CENA, DOSTEPNOSC) VALUES ('777777', 'Monitor ACER', '2,30', '469,99', '6');
INSERT INTO PRODUKTY (ID_PRODUKTU, NAZWA_PRODUKTU, WAGA, CENA, DOSTEPNOSC) VALUES ('654321', 'Sluchawki Panasonic', '0,20', '119,99', '13');
INSERT INTO PRODUKTY (ID_PRODUKTU, NAZWA_PRODUKTU, WAGA, CENA, DOSTEPNOSC) VALUES ('999999', 'Glosniki Creative', '0,75', '199,99', '16');

----------------------Adresy-------------------
INSERT INTO ADRESY (ID_ADRESU, MIASTO, KOD_POCZTOWY, ULICA, NUMER_LOKALU) VALUES ('112', 'Wroclaw', '35555', 'Wyspianskiego', '16/3');
INSERT INTO ADRESY (ID_ADRESU, MIASTO, KOD_POCZTOWY, ULICA, NUMER_LOKALU) VALUES ('997', 'Warszawa', '06153', 'Pilsudskiego', '141/17');
INSERT INTO ADRESY (ID_ADRESU, MIASTO, KOD_POCZTOWY, ULICA, NUMER_LOKALU) VALUES ('41', 'Poznan', '72333', 'Swidnicka', '100/20');
INSERT INTO ADRESY (ID_ADRESU, MIASTO, KOD_POCZTOWY, ULICA, NUMER_LOKALU) VALUES ('605', 'Krakow', '31415', 'Pitagorasa', '3/14');
INSERT INTO ADRESY (ID_ADRESU, MIASTO, KOD_POCZTOWY, ULICA, NUMER_LOKALU) VALUES ('690', 'Gdansk', '27182', 'Eulera', '2/71');
INSERT INTO ADRESY (ID_ADRESU, MIASTO, KOD_POCZTOWY, ULICA, NUMER_LOKALU) VALUES ('222', 'Katowice', '44888', 'Prusa', '5/7');
INSERT INTO ADRESY (ID_ADRESU, MIASTO, KOD_POCZTOWY, ULICA, NUMER_LOKALU) VALUES ('333', 'Warszawa', '44222', 'Piastowska', '35/24');
INSERT INTO ADRESY (ID_ADRESU, MIASTO, KOD_POCZTOWY, ULICA, NUMER_LOKALU) VALUES ('444', 'Lublin', '11999', 'Rynek', '32/64');
INSERT INTO ADRESY (ID_ADRESU, MIASTO, KOD_POCZTOWY, ULICA, NUMER_LOKALU) VALUES ('256', 'Lodz', '16384', 'Binarna', '16/128');

----------------------Lokale-------------------
INSERT INTO LOKALE (ID_LOKALU, ID_KIEROWNIKA, ID_ADRESU) VALUES ('1', '565656', '222');
INSERT INTO LOKALE (ID_LOKALU, ID_KIEROWNIKA, ID_ADRESU) VALUES ('2', '121212', '997');
INSERT INTO LOKALE (ID_LOKALU, ID_KIEROWNIKA, ID_ADRESU) VALUES ('3', '878787', '333');
INSERT INTO LOKALE (ID_LOKALU, ID_KIEROWNIKA, ID_ADRESU) VALUES ('4', '131072', '444');
INSERT INTO LOKALE (ID_LOKALU, ID_KIEROWNIKA, ID_ADRESU) VALUES ('5', '262144', '256');

----------------------Pracownicy-------------------
INSERT INTO PRACOWNICY (ID_PRACOWNIKA, IMIE, NAZWISKO, STANOWISKO, ID_LOKALU, PENSJA, ID_KIEROWNIKA) VALUES ('11', 'Adrian', 'Wysocznik', 'Kierownik', '1', '11011,00', '565656');  
INSERT INTO PRACOWNICY (ID_PRACOWNIKA, IMIE, NAZWISKO, STANOWISKO, ID_LOKALU, PENSJA, ID_KIEROWNIKA) VALUES ('22', 'Pawel', 'Bialecki', 'Kierownik', '2', '11001,00', '121212');
INSERT INTO PRACOWNICY (ID_PRACOWNIKA, IMIE, NAZWISKO, STANOWISKO, ID_LOKALU, PENSJA, ID_KIEROWNIKA) VALUES ('33', 'Pawel', 'Danielko', 'Kierownik', '3', '10111,00', '878787');
INSERT INTO PRACOWNICY (ID_PRACOWNIKA, IMIE, NAZWISKO, STANOWISKO, ID_LOKALU, PENSJA, ID_KIEROWNIKA) VALUES ('44', 'Przemek', 'Ciotka', 'Kierownik', '4', '11000,00', '131072');
INSERT INTO PRACOWNICY (ID_PRACOWNIKA, IMIE, NAZWISKO, STANOWISKO, ID_LOKALU, PENSJA, ID_KIEROWNIKA) VALUES ('55', 'Gaaw', 'Hassan', 'Kierownik', '5', '10000,00', '262144');

INSERT INTO PRACOWNICY (ID_PRACOWNIKA, IMIE, NAZWISKO, STANOWISKO, ID_LOKALU, PENSJA) VALUES ('66', 'Stanislaw', 'Tarnowski', 'Kierowca', '1', '2500,00');
INSERT INTO PRACOWNICY (ID_PRACOWNIKA, IMIE, NAZWISKO, STANOWISKO, ID_LOKALU, PENSJA) VALUES ('77', 'Stefan', 'Wiesolowski', 'Kierowca', '2', '2450,00');
INSERT INTO PRACOWNICY (ID_PRACOWNIKA, IMIE, NAZWISKO, STANOWISKO, ID_LOKALU, PENSJA) VALUES ('88', 'Emilian', 'Kaktus', 'Kierowca', '3', '2700,00');
INSERT INTO PRACOWNICY (ID_PRACOWNIKA, IMIE, NAZWISKO, STANOWISKO, ID_LOKALU, PENSJA) VALUES ('99', 'Mateusz', 'Waligora', 'Kierowca', '4', '2850,00');
INSERT INTO PRACOWNICY (ID_PRACOWNIKA, IMIE, NAZWISKO, STANOWISKO, ID_LOKALU, PENSJA) VALUES ('110', 'Kazimierz', 'Kogut', 'Kierowca', '5', '2600,00');

----------------------Pojazdy-------------------
INSERT INTO POJAZDY (ID_POJAZDU, ID_PRACOWNIKA, REJESTRACJA) VALUES ('1111', '66', 'ABC123456');
INSERT INTO POJAZDY (ID_POJAZDU, ID_PRACOWNIKA, REJESTRACJA) VALUES ('1112', '77', 'DEF789123');
INSERT INTO POJAZDY (ID_POJAZDU, ID_PRACOWNIKA, REJESTRACJA) VALUES ('1113', '88', 'GHI456789');
INSERT INTO POJAZDY (ID_POJAZDU, ID_PRACOWNIKA, REJESTRACJA) VALUES ('1114', '99', 'JKL987654');
INSERT INTO POJAZDY (ID_POJAZDU, ID_PRACOWNIKA, REJESTRACJA) VALUES ('1115', '110', 'MNO321987');

----------------------Dostawy-------------------
INSERT INTO DOSTAWY (NUMER_DOSTAWY, ID_LOKALU, DATA_DOSTAWY, ID_POJAZDU) VALUES ('128', '1', to_date('24/04/18','DD/MM/RR'), '1115');
INSERT INTO DOSTAWY (NUMER_DOSTAWY, ID_LOKALU, DATA_DOSTAWY, ID_POJAZDU) VALUES ('256', '2', to_date('15/03/18','DD/MM/RR'), '1112');
INSERT INTO DOSTAWY (NUMER_DOSTAWY, ID_LOKALU, DATA_DOSTAWY, ID_POJAZDU) VALUES ('512', '2', to_date('30/09/18','DD/MM/RR'), '1115');
INSERT INTO DOSTAWY (NUMER_DOSTAWY, ID_LOKALU, DATA_DOSTAWY, ID_POJAZDU) VALUES ('1024', '4', to_date('12/12/18','DD/MM/RR'), '1113');
INSERT INTO DOSTAWY (NUMER_DOSTAWY, ID_LOKALU, DATA_DOSTAWY, ID_POJAZDU) VALUES ('2048', '5', to_date('21/11/18','DD/MM/RR'), '1114');

----------------------Szczegoly_dostawy-------------------
INSERT INTO SZCZEGOLY_DOSTAWY (NUMER_DOSTAWY, ID_PRODUKTU, ILOSC_DOST) VALUES ('128', '777777', '50');
INSERT INTO SZCZEGOLY_DOSTAWY (NUMER_DOSTAWY, ID_PRODUKTU, ILOSC_DOST) VALUES ('128', '111111', '25');
INSERT INTO SZCZEGOLY_DOSTAWY (NUMER_DOSTAWY, ID_PRODUKTU, ILOSC_DOST) VALUES ('512', '999999', '100');
INSERT INTO SZCZEGOLY_DOSTAWY (NUMER_DOSTAWY, ID_PRODUKTU, ILOSC_DOST) VALUES ('2048', '654321', '200');
INSERT INTO SZCZEGOLY_DOSTAWY (NUMER_DOSTAWY, ID_PRODUKTU, ILOSC_DOST) VALUES ('1024', '777777', '30');

----------------------Zamowienia-------------------
INSERT INTO ZAMOWIENIA (NUMER_ZAMOWIENIA, DATA_ZAMOWIENIA, RODZAJ_DOSTAWY, ID_ADRESU) VALUES ('000123', to_date('05/05/18','DD/MM/RR'), 'Paczkomat', '112');
INSERT INTO ZAMOWIENIA (NUMER_ZAMOWIENIA, DATA_ZAMOWIENIA, RODZAJ_DOSTAWY, ID_ADRESU) VALUES ('000001', to_date('01/01/18','DD/MM/RR'), 'Polecony', '41');
INSERT INTO ZAMOWIENIA (NUMER_ZAMOWIENIA, DATA_ZAMOWIENIA, RODZAJ_DOSTAWY, ID_ADRESU) VALUES ('235605', to_date('17/10/18','DD/MM/RR'), 'Kurier', '605');
INSERT INTO ZAMOWIENIA (NUMER_ZAMOWIENIA, DATA_ZAMOWIENIA, RODZAJ_DOSTAWY, ID_ADRESU) VALUES ('235690', to_date('28/02/18','DD/MM/RR'), 'Polecony', '690');
INSERT INTO ZAMOWIENIA (NUMER_ZAMOWIENIA, DATA_ZAMOWIENIA, RODZAJ_DOSTAWY, ID_ADRESU) VALUES ('961017', to_date('07/07/17','DD/MM/RR'), 'Pocztex', '41');

----------------------Szczegoly_zamowienia-------------------
INSERT INTO SZCZEGOLY_ZAMOWIENIA (NUMER_ZAMOWIENIA, ID_PRODUKTU, ILOSC_ZAM, CENA_ZAMOWIENIA) VALUES ('000123', '123456', '2', '91,98');
INSERT INTO SZCZEGOLY_ZAMOWIENIA (NUMER_ZAMOWIENIA, ID_PRODUKTU, ILOSC_ZAM, CENA_ZAMOWIENIA) VALUES ('000001', '777777', '1', '469,99');
INSERT INTO SZCZEGOLY_ZAMOWIENIA (NUMER_ZAMOWIENIA, ID_PRODUKTU, ILOSC_ZAM, CENA_ZAMOWIENIA) VALUES ('235605', '999999', '10', '1999,90');
INSERT INTO SZCZEGOLY_ZAMOWIENIA (NUMER_ZAMOWIENIA, ID_PRODUKTU, ILOSC_ZAM, CENA_ZAMOWIENIA) VALUES ('235690', '654321', '5', '599,95');
INSERT INTO SZCZEGOLY_ZAMOWIENIA (NUMER_ZAMOWIENIA, ID_PRODUKTU, ILOSC_ZAM, CENA_ZAMOWIENIA) VALUES ('000123', '111111', '1', '79,99');

------------------TRIGGER PRZY USUWANIU ZAMOWIENIA-----------------

create or replace trigger trig_pracownicy
after update on pracownicy
for each row
when(new.pensja>0)
 
begin
  insert into pracownicy_log(id_pracownika,stara_pensja,data_zmiany,akcja) values(seq_pracownicy_log.nextval,:old.pensja,sysdate,'zmiana wyplaty');
end;

