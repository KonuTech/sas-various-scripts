proc sql;
/* 	ALTER TABLE MART_SZK DROP FOREIGN KEY MART_SZK_ID_REKORDU_fkey; */
	DROP TABLE MART_SZK;
	DROP TABLE MART_UB;
;quit;
proc sql;

	CREATE TABLE MART_UB (
		ID_REKORDU INT,
		ID_OSOBY INT,
		ID_POLISY VARCHAR(5),
		RODZAJ_POLISY VARCHAR(2),
		CONSTRAINT MART_UB_pkey PRIMARY KEY (ID_REKORDU)
)
;quit;
proc sql;

	CREATE TABLE MART_SZK (
		ID_REKORDU INT,
		ID_OSOBY INT,
		ID_SZKODY VARCHAR(5),
		ID_POLISY VARCHAR(5),
		ROLA VARCHAR(1),
		CONSTRAINT MART_UB_pkey PRIMARY KEY (ID_REKORDU)
)
;quit;
proc sql;
	insert into MART_UB values (1, 1, 'POL_1', 'OC');
	insert into MART_UB values (2, 1, 'POL_2', 'AC');
	insert into MART_UB values (3, 2, 'POL_3', 'OC');
	insert into MART_UB values (4, 3, 'POL_3', 'OC');
	insert into MART_UB values (5, 4, 'POL_4', 'OC');
	insert into MART_UB values (6, 5, 'POL_5', 'AC');
	insert into MART_SZK values (1, 1, 'SZK_1', 'POL_1', 'U');
	insert into MART_SZK values (2, 1, 'SZK_1', 'POL_1', 'S');
	insert into MART_SZK values (3, 6, 'SZK_1', 'POL_1', 'P');
	insert into MART_SZK values (4, 2, 'SZK_2', 'POL_3', 'U');
	insert into MART_SZK values (5, 3, 'SZK_2', 'POL_3', 'U');
	insert into MART_SZK values (6, 3, 'SZK_2', 'POL_3', 'S');
	insert into MART_SZK values (7, 5, 'SZK_3', 'POL_5', 'K');
	insert into MART_SZK values (8, 5, 'SZK_3', 'POL_5', 'P');
	insert into MART_SZK values (9, 1, 'SZK_4', 'POL_1', 'S');
	insert into MART_SZK values (10, 1, 'SZK_4', 'POL_1', 'U');
quit;
proc contents data=MART_UB order=varnum;run;
proc contents data=MART_SZK order=varnum;run;
proc format;
value $role
'U'='ubezpieczony'
'S'='sprawca'
'P'='poszkodowany'
'K'='kierujacy'
other='INCORRECT CODE';
run;
proc print data=MART_SZK;
format ROLA $role.;
run;
proc print data=MART_UB;
run;
/* SQL */
proc sql;
	SELECT
		MART_UB.*,
		"zero zdarzen" AS profil_osoby 
	FROM MART_UB
	WHERE MART_UB.ID_OSOBY NOT IN (SELECT MART_SZK.ID_OSOBY FROM MART_SZK)
	
	UNION
	
	SELECT
		MART_UB.*,
		"sprawca przynajmniej dwa razy" AS profil_osoby
	FROM MART_UB
	WHERE MART_UB.ID_OSOBY IN (
		SELECT DISTINCT ID_OSOBY FROM (
				SELECT
					MART_SZK.ID_OSOBY,
					MART_SZK.ROLA,
					COUNT(MART_SZK.ID_OSOBY) AS ID_OSOBY_COUNT
				FROM MART_SZK
				WHERE ROLA='S'
				GROUP BY
				MART_SZK.ROLA,
				MART_SZK.ID_OSOBY
				HAVING ID_OSOBY_COUNT >= 2
		)
	)
	
;quit;
