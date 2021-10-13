create database firma;

--schema
create schema ksiegowosc;
--adding tables
create table ksiegowosc.pracownicy(id_pracownika int primary key, imie varchar(15) not null, nazwisko varchar(40) not null, adres varchar(55) not null, telefon varchar(15)not null);
--godziny
  create table ksiegowosc.godziny(id_godziny int primary key, data date not null, liczba_godzin int not null, id_pracownika int not null);

  --pensje

  create table ksiegowosc.pensje(id_pensji int primary key,stanowisko varchar(25), kwota decimal(7,2) not null);

  --premie

  create table ksiegowosc.premie(id_premii int primary key, rodzaj varchar(30), kwota int);
  
  create table ksiegowosc.wynagrodzenie(id_wynagrodzenia int primary key, data date not null, id_pracownika int not null, id_godziny int not null, id_pensji int not null, id_premii int not null);

   -- dodawanie kluczy obcych 

  alter table ksiegowosc.godziny 
  add foreign key(id_pracownika) references ksiegowosc.pracownicy(id_pracownika);

  alter table ksiegowosc.wynagrodzenie
  add foreign key(id_pracownika) references ksiegowosc.pracownicy(id_pracownika);

  alter table ksiegowosc.wynagrodzenie
  add foreign key(id_godziny) references ksiegowosc.godziny(id_godziny);

   alter table ksiegowosc.wynagrodzenie
  add foreign key(id_pensji) references ksiegowosc.pensje(id_pensji);

  alter table ksiegowosc.wynagrodzenie
  add foreign key(id_premii) references ksiegowosc.premie(id_premii);
  
  --komentarze
  comment on table ksiegowosc.pracownicy is 'tabela z podstawowymi infomacjami o pracownikach';
  comment on table ksiegowosc.godziny is 'tabela zawierajaca informacje o liczbie przepracowanych godzin przez poszczegolnych pracownikow';
  comment on table ksiegowosc.pensje is 'tabela zawierajaca infomacje o wysokosci pensji dla poszczegolnych stanowsik';
  comment on table ksiegowosc.premie is 'tabela zawierajaca informacje o wysokosci premii w zaleznosci od jej typu';
  comment on table ksiegowosc.wynagrodzenie is 'tabela zawierajaca id pracownika oraz przyznane mu wynagrodzenia wraz z data przyznania';

--pracownicy
  insert into ksiegowosc.pracownicy values(1, 'Agata', 'Majorowska', 'ul.Orzechowa 12, 30-663, Wieliczka', '+48 745 585 468');
  insert into ksiegowosc.pracownicy values(2, 'Karol','Dziuba','ul.Kącik 19, 32-720, Bochnia','+48 785 548 357');
  insert into ksiegowosc.pracownicy values(3,'Aleksander','Wróbel','ul.Piekarska 52b, 30-002, Kraków','+48 663 448 321');
  insert into ksiegowosc.pracownicy values(4,'Julia','Kisiel','ul.Ziołowa 13, 40-010, Katowice','+48 725 256 482');
  insert into ksiegowosc.pracownicy values(5,'Michał','Myśliwy','ul.Sadowa 16d, 34-100, Wadowice','+48 752 647 158');
  insert into ksiegowosc.pracownicy values(6,'Mikołaj','Markiewicz','ul.Podgórska 12/32, 30-016, Kraków','+48 725 486 286');
  insert into ksiegowosc.pracownicy values(7,'Karolina','Cieślak','ul.Bukowska 14c,32-050, Skawina','+48 584 259 478');
  insert into ksiegowosc.pracownicy values(8,'Dominika','Lesińska','ul.Wielicka 45a, 30-045, Kraków','+48 663 498 725');
  insert into ksiegowosc.pracownicy values(9,'Damian','Oleszak','ul.Sądecka 23, 32-700, Bochnia','+48 654 488 201');
  insert into ksiegowosc.pracownicy values(10,'Jakub','Kamiński','ul.Skawińska 11/14, 30-040, Kraków','+48 694 426 482');

--godziny
 insert into ksiegowosc.godziny values(1,'2020-04-02',8,2);
  insert into ksiegowosc.godziny values(2,'2021-04-02',8,5);
  insert into ksiegowosc.godziny values(3,'2021-04-02',8,6);
  insert into ksiegowosc.godziny values(4,'2021-04-02',9,1);
  insert into ksiegowosc.godziny values(5,'2021-04-02',8,7);
  insert into ksiegowosc.godziny values(6,'2021-04-02',8,3);
  insert into ksiegowosc.godziny values(7,'2021-04-02',9,4);
  insert into ksiegowosc.godziny values(8,'2021-04-02',9,10);
  insert into ksiegowosc.godziny values(9,'2021-04-02',8,9);
  insert into ksiegowosc.godziny values(10,'2021-04-02',8,8);

--pensje
  insert into ksiegowosc.pensje values(1,'zastępca dyrektora',5400);
  insert into ksiegowosc.pensje values(2,'księgowa',3748);
  insert into ksiegowosc.pensje values(3,'inspektor',3800);
  insert into ksiegowosc.pensje values(4, 'serwisant',5200);
  insert into ksiegowosc.pensje values(5, 'specjalista ds. logistyki',4750);
  insert into ksiegowosc.pensje values(6,'specjalista ds. sprzedaży',5100);
  insert into ksiegowosc.pensje values(7,'technik',4800);
  insert into ksiegowosc.pensje values(8,'konstruktor',4500);
  insert into ksiegowosc.pensje values(9, 'programista',5800);
  insert into ksiegowosc.pensje values(10,'dyrektor',6500);
  
--premie
 insert into ksiegowosc.premie values(1,'świąteczna wielkanocna',200);
  insert into ksiegowosc.premie values(2,'świąteczna bozonarodzeniowa',200);
  insert into ksiegowosc.premie values(3,'jubileuszowa - 5 lat',500);
  insert into ksiegowosc.premie values(4,'-',0);
  insert into ksiegowosc.premie values(5,'motywacyjna',200);
  insert into ksiegowosc.premie values(6,'jubileuszowa - 10 lat',1000);
  insert into ksiegowosc.premie values(7,'-',0);
  insert into ksiegowosc.premie values(8,'jubileuszowa - 15 lat',1500);
  insert into ksiegowosc.premie values(9,'frekwencyjna',100);
  insert into ksiegowosc.premie values(10,'motywacyjna',100);
  
  --wynagrodzenie
   insert into ksiegowosc.wynagrodzenie values(1,'2021-04-24',10,9,9,4);
  insert into ksiegowosc.wynagrodzenie values(2,'2021-04-24',9,8,8,5);
  insert into ksiegowosc.wynagrodzenie values(3,'2021-04-24',8,10,1,7);
  insert into ksiegowosc.wynagrodzenie values(4,'2021-04-24',7,2,5,8);
  insert into ksiegowosc.wynagrodzenie values(5,'2021-04-24',8,1,6,9);
  insert into ksiegowosc.wynagrodzenie values(6,'2021-04-24',5,7,2,4);
  insert into ksiegowosc.wynagrodzenie values(7,'2021-04-24',4,6,7,10);
  insert into ksiegowosc.wynagrodzenie values(8,'2021-04-24',3,5,2,9);
  insert into ksiegowosc.wynagrodzenie values(9,'2021-04-24',2,4,4,6);
  insert into ksiegowosc.wynagrodzenie values(10,'2021-04-24',1,3,9,4);
  
  --ZAPYTANIA
  --a)
  select pracownicy.id_pracownika, pracownicy.nazwisko from ksiegowosc.pracownicy;
  --b)
  Select wynagrodzenie.id_pracownika, pensje.kwota
	from ksiegowosc.wynagrodzenie inner join ksiegowosc.pensje on ksiegowosc.wynagrodzenie.id_pensji = ksiegowosc.pensje.id_pensji
	where ksiegowosc.pensje.kwota>1000
	order by wynagrodzenie.id_pracownika;
  --c)
 select wynagrodzenie.id_pracownika, pensje.kwota, premie.rodzaj
 from ksiegowosc.wynagrodzenie 
 	inner join ksiegowosc.premie on ksiegowosc.premie.id_premii=ksiegowosc.wynagrodzenie.id_premii 
	inner join ksiegowosc.pensje on ksiegowosc.pensje.id_pensji=ksiegowosc.wynagrodzenie.id_pensji
 where pensje.kwota >2000 and premie.rodzaj like '-';
 --d)
 select pracownicy.id_pracownika, pracownicy.imie, pracownicy.nazwisko
 from ksiegowosc.pracownicy
 where imie like 'J%';
 --e)
 select pracownicy.id_pracownika, pracownicy.imie, pracownicy.nazwisko
 from ksiegowosc.pracownicy
 where pracownicy.imie like '%a' and pracownicy.nazwisko like '%n%';
 
 --f)
select pracownicy.imie, pracownicy.nazwisko,( ksiegowosc.godziny.liczba_godzin*21)-160 as nadgodziny
from ksiegowosc.wynagrodzenie 
	inner join ksiegowosc.pracownicy on ksiegowosc.wynagrodzenie.id_pracownika=ksiegowosc.pracownicy.id_pracownika
	inner join ksiegowosc.godziny on ksiegowosc.wynagrodzenie.id_godziny=ksiegowosc.godziny.id_godziny
where ( ksiegowosc.godziny.liczba_godzin*21)-160>0

--g)
select pracownicy.imie, pracownicy.nazwisko
from ksiegowosc.wynagrodzenie inner join ksiegowosc.pensje on ksiegowosc.wynagrodzenie.id_pensji=ksiegowosc.pensje.id_pensji
inner join ksiegowosc.pracownicy on ksiegowosc.wynagrodzenie.id_pracownika=ksiegowosc.pracownicy.id_pracownika
where kwota between 1500 and 3000;
--h)
select pracownicy.imie, pracownicy.nazwisko
from ksiegowosc.wynagrodzenie left join ksiegowosc.godziny on ksiegowosc.wynagrodzenie.id_godziny=ksiegowosc.godziny.id_godziny
left join ksiegowosc.pracownicy on ksiegowosc.wynagrodzenie.id_pracownika=ksiegowosc.pracownicy.id_pracownika
left join ksiegowosc.premie on ksiegowosc.wynagrodzenie.id_premii=ksiegowosc.premie.id_premii
where (ksiegowosc.godziny.liczba_godzin*21)-160>0 and ksiegowosc.premie.rodzaj like '-'
order by imie;
--i)
select pracownicy.imie, pracownicy.nazwisko, pensje.kwota
from ksiegowosc.wynagrodzenie left join ksiegowosc.pracownicy on ksiegowosc.wynagrodzenie.id_pracownika=ksiegowosc.pracownicy.id_pracownika
left join ksiegowosc.pensje on ksiegowosc.wynagrodzenie.id_pensji=ksiegowosc.pensje.id_pensji
order by ksiegowosc.pensje.kwota;

--j)
select pracownicy.imie, pracownicy.nazwisko, pensje.kwota, premie.kwota
from ksiegowosc.wynagrodzenie 
	inner join ksiegowosc.pracownicy on ksiegowosc.wynagrodzenie.id_pracownika=ksiegowosc.pracownicy.id_pracownika
	inner join ksiegowosc.pensje on ksiegowosc.wynagrodzenie.id_pensji=ksiegowosc.pensje.id_pensji
	inner join ksiegowosc.premie on ksiegowosc.wynagrodzenie.id_premii=ksiegowosc.premie.id_premii
order by ksiegowosc.pensje.kwota desc, ksiegowosc.premie.kwota desc;
--k)
select pensje.stanowisko, count(pensje.stanowisko) as liczba_stanowisk
from ksiegowosc.wynagrodzenie 
	inner join ksiegowosc.pracownicy on ksiegowosc.wynagrodzenie.id_pracownika=ksiegowosc.pracownicy.id_pracownika
	inner join ksiegowosc.pensje on ksiegowosc.wynagrodzenie.id_pensji=ksiegowosc.pensje.id_pensji
group by pensje.stanowisko;
--l)
select pensje.stanowisko,AVG(pensje.kwota) as Kwota_Srednia, Min(pensje.kwota) as Kwota_minimalna,MAX(pensje.kwota) as Kwota_Maksymalna
from ksiegowosc.pensje
where pensje.stanowisko like '%księgowa%'
group by pensje.stanowisko;
--m)
select Sum(pensje.kwota + premie.kwota) as wszystkie_wynagrodzenia, Sum(pensje.kwota) as wszystkie_pensje,Sum(premie.kwota) as wszystkie_premie
from ksiegowosc.wynagrodzenie 
	inner join ksiegowosc.pensje on ksiegowosc.wynagrodzenie.id_pensji=ksiegowosc.pensje.id_pensji
	inner join ksiegowosc.premie on ksiegowosc.wynagrodzenie.id_premii=ksiegowosc.premie.id_premii;
	
--n)
select pensje.stanowisko, Sum(pensje.kwota) as suma_wynagrodzen
from ksiegowosc.wynagrodzenie 
	inner join ksiegowosc.pensje on ksiegowosc.wynagrodzenie.id_pensji=ksiegowosc.pensje.id_pensji
group by pensje.stanowisko;

--o)
select pensje.stanowisko, count(premie.kwota) as liczba_premii
from ksiegowosc.wynagrodzenie 
	inner join ksiegowosc.pensje on ksiegowosc.wynagrodzenie.id_pensji=ksiegowosc.pensje.id_pensji
	inner join ksiegowosc.premie on ksiegowosc.wynagrodzenie.id_premii=ksiegowosc.premie.id_premii
Group by pensje.stanowisko;