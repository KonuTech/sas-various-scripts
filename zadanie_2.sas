proc sql;
	ALTER TABLE B_SZKODY DROP FOREIGN KEY B_SZKODY_ID_POLISY_fkey;
	DROP TABLE B_SZKODY;
	DROP TABLE B_POLISY;
;quit;
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
proc contents data=B_POLISY order=varnum;run;
proc contents data=B_SZKODY order=varnum;run;
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
