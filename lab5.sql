create extension postgis;


Create table Object(id int primary key, geom geometry, name varchar(15));

insert into Object(id, geom, name) values(1, St_GeomFromEWKT('SRID=0;MULTICURVE(LINESTRING(0 1, 1 1), 
CIRCULARSTRING(1 1,2 0, 3 1), CIRCULARSTRING(3 1, 4 2, 5 1),LINESTRING(5 1, 6 1))'),'object1');

insert into Object(id, geom, name) values(2,ST_GeomFromEWKT('SRID=0;CURVEPOLYGON(COMPOUNDCURVE(LINESTRING(10 6, 14 6), CIRCULARSTRING(14 6, 16 4, 14 2), 
							  CIRCULARSTRING(14 2, 12 0, 10 2), LINESTRING(10 2, 10 6)), CIRCULARSTRING(11 2, 13 2, 11 2))'),'object2');

insert into Object(id, geom, name) values(3,ST_GeomFromEWKT('SRID=0;POLYGON((7 15, 10 17, 12 13, 7 15))'),'object3');

insert into Object(id, geom, name) values(4,ST_GeomFromEWKT('SRID=0;MULTILINESTRING((20 20, 25 25), (25 25, 27 24), (27 24, 25 22), 
							  (25 22, 26 21), (26 21, 22 19), (22 19, 20.5 19.5))'),'object4');

insert into Object(id, geom, name) values(5,ST_GeomFromEWKT('SRID=0;MULTIPOINTM((30 30 59),(38 32 234))'),'object5');

insert into Object(id, geom, name) values(6,ST_GeomFromEWKT('SRID=0;GEOMETRYCOLLECTION(LINESTRING(1 1, 3 2),POINT(4 2))'),'object6');


select Object.id, ST_CurveToLine(Object.geom), Object.name from Object;

--1.

select ST_Area(ST_Buffer(ST_ShortestLine(o3.geom, o4.geom), 5)) as Area
from Object as o3, Object as o4 
where o3.name = 'object3' and o4.name = 'object4'; 

--2.

update Object set geom =ST_MakePolygon(ST_LineMerge(ST_CollectionHomogenize(ST_Collect(geom, 'LINESTRING(20.5 19.5, 20 20)'))))
where Object.name = 'object4';

--3.
insert into Object values(7, (select ST_Collect(o3.geom, o4.geom) 
						   from Object as o3, Object as o4 
						   where o3.name = 'object3' and o4.name = 'object4'), 'object7');

--4.
--select Obj.name, ST_Area(ST_Buffer(Obj.geom, 5)) 
Select Sum(ST_Area(ST_Buffer(Object.geom, 5))) as totalArea
from Object 
where ST_HasArc(Object.geom)=false;

