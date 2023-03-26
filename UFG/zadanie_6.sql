-- PostreSQL


DROP TABLE IF EXISTS LOGI_SYSTEMOWE;


CREATE TABLE IF NOT EXISTS LOGI_SYSTEMOWE (
    ID SERIAL PRIMARY KEY,
    RODZAJ TEXT,
    CZAS_AKTYWNOSCI TIMESTAMP,
    LOGIN TEXT
    )
;


-- Generuje 10.000 wierszy
INSERT INTO LOGI_SYSTEMOWE (RODZAJ, CZAS_AKTYWNOSCI, LOGIN)
SELECT
    -- Dostan wartosc losowa
    CASE FLOOR(random()*(4-0+1))+0
        WHEN 0 THEN 'LOGOWANIE'
        WHEN 1 THEN 'POBRANIE_PLIKU'
        WHEN 2 THEN 'WYSWIETLENIE_FORMULARZA'
        ELSE 'WYDRUK'
    END,
     -- Wygeneruj losowy CZAS_AKTYWNOSCI
    TIMESTAMP '2022-08-01 00:00:00' + (random() * (timestamp '2022-08-01 00:10:00' - timestamp '2022-08-01 00:00:00'))::interval,
    -- Wygeneruj losowy wartosc pola LOGIN
    'user_' || floor(random() * 1000)::text
FROM generate_series(1, 10000)
;


SELECT 
    LOGIN,
    RODZAJ,
    COUNT(*) AS LICZBA_AKTYWNOSCI
FROM 
    LOGI_SYSTEMOWE
GROUP BY 
    LOGIN,
    RODZAJ
HAVING 
    COUNT(*) > 100
;


SELECT 
    l1.ID,
    l1.RODZAJ,
    l1.CZAS_AKTYWNOSCI,
    l1.LOGIN,
    COUNT(l2.*) AS LICZBA_WYDARZEN_PRZED
FROM 
    LOGI_SYSTEMOWE l1
    LEFT JOIN LOGI_SYSTEMOWE l2 
        ON l2.LOGIN = l1.LOGIN 
        AND l2.CZAS_AKTYWNOSCI BETWEEN (l1.CZAS_AKTYWNOSCI - interval '5 minutes') AND l1.CZAS_AKTYWNOSCI
GROUP BY 
    l1.ID,
    l1.RODZAJ,
    l1.CZAS_AKTYWNOSCI,
    l1.LOGIN
ORDER BY 
    l1.login ASC,
    czas_aktywnosci ASC
;

