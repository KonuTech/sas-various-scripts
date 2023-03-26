option mprint mlogic symbolgen;

data B_POLISY;
	input ID :best. RODZAJ :$2. DATA_ZAWARCIA :best. OCHRONA_OD :best. OCHRONA_DO :best.;
	format DATA_ZAWARCIA yymmdd10. OCHRONA_OD yymmdd10. OCHRONA_DO yymmdd10.;
	datalines;
1 OC 21153 21185 21549
2 OC 21257 21258 21622
3 AC 21216 21217 21581
4 AC 21275 21279 21643
;
run;


%LET _RODZAJ = AC;
%LET _DATA_START = '1JAN2018'd;
%put ### RODZAJ ###       : &_rodzaj.;
%put ### DATA_START ###   : &_data_start.;


%MACRO aktywnosc_umow(_rodzaj=, _data_start=);

	data AKTYWNOSC_UMOW;
		set B_POLISY;
		
		length KWARTAL_ZAWARCIA $6. CZY_AKTYWNA_Q1 - CZY_AKTYWNA_Q4 8. ;

		KWARTAL_ZAWARCIA = put(DATA_ZAWARCIA, yyq6.);
		KWARTAL_OD = put(OCHRONA_OD, yyq6.);
		KWARTAL_DO = put(OCHRONA_DO, yyq6.);
		
		%DO i = 1 %to 6;
			%let _nastepny_kwartal = %sysfunc(INTNX(quarter, &_DATA_START., &i.), yyq6.);
			%put ### NASTEPNY_KWARTAL ###   : &_nastepny_kwartal.;
			CZY_AKTYWNA_Q&i = ifn((KWARTAL_OD < "&_nastepny_kwartal." <= KWARTAL_DO), 1, 0);
			
		%END;
		
		where RODZAJ = symget("_rodzaj");
		
		keep ID RODZAJ KWARTAL_ZAWARCIA CZY_AKTYWNA_Q1 - CZY_AKTYWNA_Q6;
	run;

%mend aktywnosc_umow;

%aktywnosc_umow(_rodzaj=&_RODZAJ., _data_start=&_DATA_START.);


proc contents data=B_POLISY order=varnum;run;
proc contents data=AKTYWNOSC_UMOW order=varnum;run;
proc print data=AKTYWNOSC_UMOW;run;
