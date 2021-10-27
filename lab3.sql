create extension postgis;
 --4.

select count(popp.f_codedesc) as buildings 
 into tableB
 from popp, majrivers
 where ST_DWithin(popp.geom, majrivers.geom, 1000.0) and f_codedesc='Building';
 
 select * from tableB
 --5.
select airports.name, airports.geom,airports.elev
into table airportsNew
from airports

select * from airportsNew
--5a)

	Select (Select airportsNew.name
	from airportsNew
	order by st_YMin(geom) limit 1) as East_airport,
	(Select airportsNew.name
	 from airportsNew
	order by st_YMin(geom) desc limit 1) as West_airport
	
	 
	-- Select West.name as West_airport, East.name as East_airport
	-- from airportsNew as West, airportsNew as East
	--where 
	--(Select max(ST_Y(airportsNew.geom))from airportsNew)=St_Y(West.geom) and 
	--(Select min(st_y((airportsNew.geom))) from airportsNew)=st_y(East.geom) limit 1;

	--5b
		
	insert into airportsNew values('airportB',(select ST_Centroid(ST_ShortestLine((select max(airportsNew.geom)from airportsNew),
																	(select min(airportsNew.geom)from airportsNew)))), 55.000);
	 
select * from airportsNew

--6
Select ST_area(St_buffer(st_ShortestLine(airports.geom, lakes.geom), 1000)) as area
from airports, lakes
where lakes.names='Iliamna Lake' and airports.name='AMBLER';

--7
Select vegdesc as description, Sum(ST_Area(trees.geom)) as total_area
from trees,swamp,tundra
where ST_Contains(tundra.geom, trees.geom) or ST_Contains(swamp.geom, trees.geom)
group by vegdesc;
