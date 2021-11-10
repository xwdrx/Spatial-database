create extension postgis;


--1.
select sum(trees.area_km2) as totalArea
from trees
where trees.vegdesc='Mixed Trees';

--3. spr
select Sum(ST_Length(railroads.geom)) from railroads, regions
where name_2='Matanuska-Susitna';

--4.
select round(avg(airports.elev),2) as avg_elev
from airports  
where use='Military';

select count(airports.name) as num_Of_mlitary
from airports 
where use='Military' and airports.elev < 1400;

--5.
select count(popp.gid) as num_of_buildings
from popp, regions
where ST_Contains(regions.geom,popp.geom) and (regions.name_2='Bristol Bay' and popp.f_codedesc='Building');

select count(popp.gid) as num_of_buildings
from popp, regions, rivers
where ST_Contains(regions.geom,popp.geom) and(regions.name_2='Bristol Bay' and popp.f_codedesc='Building') and ST_DWithin(popp.geom, rivers.geom, 100000);


--6.

select Sum(ST_nPoints(ST_Intersection(majrivers.geom,railroads.geom))) as int_Points
from majrivers,railroads 

--7.  
select sum(ST_Npoints(railroads.geom)) as ex_Nodes
from railroads

--8.
select ST_Intersection(ST_Difference(st_union(st_buffer(airports.geom,328083)),st_union(st_buffer(railroads.geom,164041 ))),
				   st_union(st_buffer(trails.geom,4921))) from airports, railroads, trails

--9. 
select sum(ST_Npoints(ST_Simplify(swamp.geom, 100))) as swamps_simp, sum(swamp.areakm2) as totalArea
from swamp

select  sum(ST_Npoints(swamp.geom)) as swamps, sum(swamp.areakm2) as totalArea
from swamp