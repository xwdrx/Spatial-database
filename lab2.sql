create database lab2;
create extension postgis;

create table buildings(id integer primary key not null, geometry geometry, name varchar(15));
create table roads(id integer primary key  not null, geometry geometry, name varchar(15));
create table poi(id integer primary key  not null, geometry geometry, name varchar(15));

--buildings
insert into buildings(id, geometry, name) values (1, ST_GeomFromText('POLYGON((8 4, 8 1.5, 10.5 1.5, 10.5 4, 8 4))',0), 'BuildingA');
insert into buildings(id, geometry, name) values (2, ST_GeomFromText('POLYGON((4 7, 6 7, 6 5, 4 5, 4 7))',0), 'BuildingB');
insert into buildings(id, geometry, name) values (3, ST_GeomFromText('POLYGON((3 6, 5 6, 5 8, 3 8, 3 6))',0), 'BuildingC');
insert into buildings(id, geometry, name) values (4, ST_GeomFromText('POLYGON((9 9, 10 9, 10 8, 9 8, 9 9))',0), 'BuildingD');
insert into buildings(id, geometry, name) values (5, ST_GeomFromText('POLYGON((1 2, 2 2, 2 1, 1 1, 1 2))',0), 'BuildingE');

--select * from buildings

--points 
insert into poi(id, geometry, name) values (1, ST_GeomFromText('POINT(1 3.5)',0), 'G');
insert into poi(id, geometry, name) values (2, ST_GeomFromText('POINT(5.5 1.5)',0), 'H');
insert into poi(id, geometry, name) values (3, ST_GeomFromText('POINT(9.5 6)',0), 'I');
insert into poi(id, geometry, name) values (4, ST_GeomFromText('POINT(6.5 6)',0), 'J');
insert into poi(id, geometry, name) values (5, ST_GeomFromText('POINT(6 9.5)',0), 'K');

--roads
insert into roads(id, geometry, name) values (1, ST_GeomFromText('LINESTRING(0 4.5, 12 4.5)',0), 'RoadX');
insert into roads(id, geometry, name) values (2, ST_GeomFromText('LINESTRING(7.5 10.5, 7.5 0)',0), 'RoadY');

--6A)
select Sum(st_length( ST_GeomFromText('LINESTRING(0 4.5, 12 4.5)',0)) + st_length(ST_GeomFromText('LINESTRING(7.5 10.5, 7.5 0)',0))) as total_length; 

--6B)
select ST_AsEWKT(buildings.geometry) as geometry, ST_Area(buildings.geometry) as Area, ST_Perimeter(buildings.geometry) as Perimeter
from buildings 
where buildings.name='BuildingA';

--6C) 
select buildings.name, ST_Area(buildings.geometry) as Area
from buildings
order by buildings.name;

--6D)
select buildings.name, ST_Perimeter(buildings.geometry) as Perimeter
from buildings
order by ST_Area(buildings.geometry) desc limit 2;

--6E)
select ST_Distance(buildings.geometry, poi.geometry) as distance
from buildings, poi
where buildings.name='BuildingC' and poi.name='G';

--6F) 
select ST_Area(ST_Difference((select buildings.geometry 
				  from buildings
				  where buildings.name='BuildingC'), ST_buffer((select buildings.geometry 
				  from buildings
				  where buildings.name='BuildingB'),0.5))) as Area;

--6G) 
select buildings.name
from buildings, roads
where ST_Y(ST_Centroid(buildings.geometry)) > ST_Y(ST_Centroid(roads.geometry)) and roads.name='RoadX';

--6H) 
select ST_Area(ST_Symdifference((select buildings.geometry 
				  from buildings
				  where buildings.name='BuildingC'),ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))',0))) as Area;
