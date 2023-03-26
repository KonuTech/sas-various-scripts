/* proc sql; */
/* 	ALTER TABLE B_SZKODY DROP FOREIGN KEY B_SZKODY_ID_POLISY_fkey; */
/* 	DROP TABLE B_SZKODY; */
/* 	DROP TABLE B_POLISY; */
/* ;quit; */
proc sql;

	CREATE TABLE B_POLISY (
		ID INT,
		RODZAJ VARCHAR(2),
		OCHRONA_OD DATE FORMAT=yymmdd10.,
		OCHRONA_DO DATE FORMAT=yymmdd10.,
		CONSTRAINT B_POLISY_pkey PRIMARY KEY (ID)
)
;quit;
proc sql;

	CREATE TABLE B_SZKODY (
		ID INT,
		ID_POLISY INT,
		TYP_SZKODY VARCHAR(1),
		DATA_ZDARZENIA DATE FORMAT=yymmdd10.,
		CONSTRAINT B_SZKODY_pkey PRIMARY KEY (ID)
)
;quit;
proc sql;
	ALTER TABLE B_SZKODY
	ADD CONSTRAINT B_SZKODY_ID_POLISY_fkey FOREIGN KEY (ID_POLISY) REFERENCES B_POLISY (ID);
quit;
proc sql;
	insert into B_POLISY values (1, 'OC', 21185, 21549);
	insert into B_POLISY values (2, 'OC', 21258, 21622);
	insert into B_POLISY values (3, 'AC', 21217, 21581);
	insert into B_POLISY values (4, 'AC', 21279, 21643);
	insert into B_SZKODY values (1, 1, 'P', 21294);
	insert into B_SZKODY values (2, 1, 'O', 21452);
	insert into B_SZKODY values (3, 2, 'P', 21305);
	insert into B_SZKODY values (4, 3, 'P', 21380);
quit;


/* SQL example*/
proc sql;
	CREATE TABLE sql_example AS
	SELECT
		B_POLISY.ID AS ID_POLISY,
		B_POLISY.RODZAJ AS RODZAJ_POLISY,
		B_POLISY.OCHRONA_OD,
		B_POLISY.OCHRONA_DO,
		B_SZKODY.ID AS ID_SZKODY,
		B_SZKODY.TYP_SZKODY,
		B_SZKODY.DATA_ZDARZENIA,
		CASE WHEN B_SZKODY.DATA_ZDARZENIA BETWEEN B_POLISY.OCHRONA_OD AND B_POLISY.OCHRONA_DO THEN 1 ELSE 0 END AS CZY_ZDARZENIE_OBCIAZA_POLISE
	FROM B_POLISY
	LEFT JOIN B_SZKODY
	ON B_POLISY.ID = B_SZKODY.ID_POLISY
;quit;


/* MERGE example */
data merge_example;
	merge B_POLISY (rename=(ID=ID_POLISY RODZAJ=RODZAJ_POLISY)) B_SZKODY (rename=(ID=ID_SZKODY));
	by ID_POLISY;
	if OCHRONA_OD < DATA_ZDARZENIA < OCHRONA_DO then do;
	 CZY_ZDARZENIE_OBCIAZA_POLISE = 1;
	end;
	else do;
	 CZY_ZDARZENIE_OBCIAZA_POLISE = 0;
	end;
run;


/* HASH TABLE */
data hash_example;

	set  B_POLISY;

    if _n_=1 then do;
        
		declare hash h_polisy(dataset:"B_POLISY", multidata: "Y");
	    h_polisy.defineKey("ID");
	    h_polisy.defineData(all: "Y");
	    h_polisy.defineDone();
	end;
	
	set B_SZKODY;
	rc = h_polisy.find(key:ID_POLISY);
run;


proc contents data=B_POLISY order=varnum;run;
proc contents data=B_SZKODY order=varnum;run;
proc print data=sql_example;run;
proc print data=merge_example;run;
proc print data=hash_example;run;