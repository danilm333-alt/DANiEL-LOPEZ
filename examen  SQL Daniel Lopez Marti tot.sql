use olympics;
#1. Mostra la quantitat d'esdeveniments que té cada esport (0,5p)
SELECT sport.sport_name, COUNT(*)
FROM event
JOIN sport ON sport.id=event.sport_id
GROUP BY sport.sport_name;
#2Mostra el nom de la ciutat i la quantitat de joc olímpics que han
#organitzat, de les ciutats que han organitzat més d'un joc olímpic 
SELECT city.city_name, COUNT(games_city.city_id) as total_jocs
FROM  city
JOIN games_city ON city.id=games_city.city_id
JOIN games ON games_city.games_id=games.id
GROUP BY city.city_name
HAVING total_jocs > 1;
#3Mostra el nom de totes les esportistes (gènere femení) espanyoles
#que van participar en els jocs de Barcelona 92 i que es diuen Cristina
#(pots fer la consulta tenint en compte que l'id dels jocs de Barcelona92 és l'1) (1,25p
 SELECT person.full_name
 FROM person
 JOIN games_competitor ON person.id=games_competitor.person_id
 JOIN person_region ON person.id=person_region.person_id
 JOIN noc_region ON person_region.region_id=noc_region.id
 WHERE games_competitor.games_id= 1 AND person.gender= 'F' AND person.full_name  LIKE 'Cristina%' AND noc_region.region_name ='Spain';
 
 #4Mostra el nom de la persona esportista que va guanyar més
#medalles a Rio de Janeiro (és preferible que no, però pots utilitzar el fet que els jocs de Rio tenen l'id 21) (1,5p)
SELECT person.full_name, COUNT(*) total_medallas
FROM medal
JOIN competitor_event ON medal.id=competitor_event.medal_id
JOIN  games_competitor ON competitor_event.competitor_id= games_competitor.id
JOIN person ON games_competitor.person_id=person.id
JOIN games ON games_competitor.games_id=games.id
JOIN games_city ON games.id=games_city.games_id
JOIN city ON games_city.city_id=city.id
WHERE city.city_name= 'Rio de Janeiro' AND medal.id < 4
GROUP BY person.full_name
ORDER BY total_medallas DESC
LIMIT 1 ; #amb un limit el resultat es correcte ja que son jocs ja acabats i no empata amb la segona posicio.alter
 
 #5Qui va guanyar més medalles d'or en atletisme masculí en els jocs
#de Barcelona 92, Espanya o USA? (És preferible que no, però pots
#utilitzar el fet que els jocs de Barcelona tenen l'id 1 i l'atletisme com a
#esport té l'id 6) (1,5p)
SELECT noc_region.region_name, COUNT(*) as Total_medallas_or_atletisme
FROM medal
JOIN competitor_event ON medal.id=competitor_event.medal_id
JOIN  games_competitor ON competitor_event.competitor_id= games_competitor.id
JOIN person ON games_competitor.person_id=person.id
JOIN person_region ON person.id=person_region.person_id
JOIN noc_region ON person_region.region_id=noc_region.id
JOIN games ON games_competitor.games_id=games.id
JOIN games_city ON games.id=games_city.games_id
JOIN city ON games_city.city_id=city.id
JOIN event ON competitor_event.event_id=event.id
JOIN sport ON sport.id=event.sport_id
WHERE city.city_name ='Barcelona' AND person.gender='M' AND medal.medal_name ='Gold' AND sport.sport_name ='Athletics' AND (noc_region.region_name= 'Spain' OR noc_region.region_name='USA') 
GROUP BY noc_region.region_name
ORDER BY Total_medallas_or_atletisme DESC
LIMIT 1;
#6 Mostra el nom de la persona esportista que té el major pes d’entre
#tots i totes. No ports utilitzar ni ORDER BY ni LIMIT, és a dir la
#consulta a de ser dinàmica i si haguessin dues o més persones amb el pes màxim, hauries de mostrar-les totes. (1,25p)
SELECT*
FROM person
WHERE weight=(
	SELECT MAX(weight)
    FROM person);
    
#7Mostra el nom de la persona esportista que ha guanyat més medalles d’or de cada país, tenint en compte tots els jocs olímpics
#(també pots mostrar la quantitat de medalles que ha guanyat i dequin país és). Aquest càlcul ha de tenir en compte, només aquelles
#persones esportistes que han guanyat com a mínim, dues medalles d’or i si hi ha “empat” entre persones esportistes d’un mateix país, les has de mostrar totes. (1.5p)
SELECT person.full_name, noc_region.region_name,taula_medallas_oro.medallas_oro
FROM medal
JOIN competitor_event ON medal.id = competitor_event.medal_id
JOIN games_competitor ON competitor_event.competitor_id = games_competitor.id
JOIN person ON games_competitor.person_id = person.id
JOIN person_region ON person.id = person_region.person_id
JOIN noc_region ON person_region.region_id = noc_region.id
JOIN (
	  SELECT person.id, COUNT(*)  as medallas_oro
	  FROM medal
	  JOIN competitor_event ON medal.id = competitor_event.medal_id
      JOIN games_competitor ON competitor_event.competitor_id = games_competitor.id
      JOIN person ON games_competitor.person_id = person.id
      JOIN person_region ON person.id = person_region.person_id
      JOIN noc_region ON person_region.region_id = noc_region.id
      WHERE medal.medal_name = 'Gold'
      GROUP BY person.id
      HAVING medallas_oro >1) taula_medallas_oro ON person.id=taula_medallas_oro.id
JOIN(
	 SELECT person.id, MAX(taula_oro.medallas_oro) as maximo
     FROM medal
	 JOIN competitor_event ON medal.id = competitor_event.medal_id
	 JOIN games_competitor ON competitor_event.competitor_id = games_competitor.id
	 JOIN person ON games_competitor.person_id = person.id
	 JOIN person_region ON person.id = person_region.person_id
	 JOIN noc_region ON person_region.region_id = noc_region.id
     JOIN(
     
		SELECT person.id, COUNT(*)  as medallas_oro
		FROM medal
		JOIN competitor_event ON medal.id = competitor_event.medal_id
		JOIN games_competitor ON competitor_event.competitor_id = games_competitor.id
		JOIN person ON games_competitor.person_id = person.id
		JOIN person_region ON person.id = person_region.person_id
		JOIN noc_region ON person_region.region_id = noc_region.id
		WHERE medal.medal_name = 'Gold'
		GROUP BY person.id
		HAVING medallas_oro >1) taula_oro ON person.id=taula_oro.id
      GROUP BY person.id) as taula_maximo ON person.id=taula_maximo.id
WHERE taula_medallas_oro.medallas_oro=taula_maximo.maximo
GROUP BY  person.full_name, noc_region.region_name, taula_medallas_oro.medallas_oro;

#Mostra els noms dels països que compleixin la següent situació:
#l’alçada mínima de qualsevol dels seus esportistes masculins és
#major a l’alçada mitja de tots els esportistes masculins. No has
#d’incloure en aquests càlculs tots aquells esportistes dels quals no
#tenim la seva alçada. (1,5p)
SELECT DISTINCT noc_region.region_name
FROM person
JOIN person_region ON person.id=person_region.person_id
JOIN noc_region ON person_region.region_id=noc_region.id
WHERE person.gender='M' AND person.height >(
	SELECT ROUND(AVG(person.height),2) AS mitja_altu
    FROM person
	WHERE person.gender='M' AND person.height != 0)
GROUP BY noc_region.region_name;