/** 

/*
==========================================================================================================================================================
==========================================================================================================================================================
CREATE TABLE
==========================================================================================================================================================
==========================================================================================================================================================
*/

drop table if exists public.Online_Gambling_Sites;

create table if not exists public.Online_Gambling_Sites(
	
	Company_ID				int NOT NULL,
	Link					varchar(100),
	Languages				varchar(1500),
	Types					varchar(500),
	Crypto_Currencies		varchar(1500),
	Other_Payments			varchar(500),
	Community				varchar(100),
	AutoDice_speed_10_sec  	varchar(20),
	Global_Rank				int,
	March_2019				varchar(20),
	April_2019				varchar(20),
	May_19					varchar(20),
	June_2019				varchar(20),
	July_2019				varchar(20),
	August_2019				varchar(20),
	September_2019			varchar(20),
	October_2019			varchar(20),
	November_2019			varchar(20),
	December_2019			varchar(20),
	January_2020			varchar(20),
	February_2020			varchar(20),
	Month_change			varchar(10)
);
*/

/*
==========================================================================================================================================================
==========================================================================================================================================================
CLEANING DATA
==========================================================================================================================================================
==========================================================================================================================================================
*/

--I DON´T KNOW WHY, BUT THE SECOND REPLACE IS REPLACING THE ASCII 160 CHARACTER
UPDATE  public.online_gambling_sites
SET 	march_2019 		= REPLACE(REPLACE(REPLACE(march_2019,' ',''),' ',''),'-','0'),
		april_2019 		= REPLACE(REPLACE(REPLACE(april_2019,' ',''),' ',''),'-','0'),
		may_19 			= REPLACE(REPLACE(REPLACE(may_19,' ',''),' ',''),'-','0'),
		june_2019 		= REPLACE(REPLACE(REPLACE(june_2019,' ',''),' ',''),'-','0'),
		july_2019 		= REPLACE(REPLACE(REPLACE(july_2019,' ',''),' ',''),'-','0'),
		august_2019 	= REPLACE(REPLACE(REPLACE(august_2019,' ',''),' ',''),'-','0'),
		september_2019 	= REPLACE(REPLACE(REPLACE(september_2019,' ',''),' ',''),'-','0'),
		october_2019 	= REPLACE(REPLACE(REPLACE(october_2019,' ',''),' ',''),'-','0'),
		november_2019 	= REPLACE(REPLACE(REPLACE(november_2019,' ',''),' ',''),'-','0'),
		december_2019	= REPLACE(REPLACE(REPLACE(december_2019,' ',''),' ',''),'-','0'),
		january_2020 	= REPLACE(REPLACE(REPLACE(january_2020,' ',''),' ',''),'-','0'),
		february_2020 	= REPLACE(REPLACE(REPLACE(february_2020,' ',''),' ',''),'-','0');

ALTER TABLE public.online_gambling_sites ALTER COLUMN 		march_2019 		TYPE numeric	 USING march_2019::numeric	;
ALTER TABLE public.online_gambling_sites ALTER COLUMN 		april_2019 		 TYPE numeric	 USING april_2019::numeric	;
ALTER TABLE public.online_gambling_sites ALTER COLUMN 		may_19 			 TYPE numeric	 USING may_19::numeric	;
ALTER TABLE public.online_gambling_sites ALTER COLUMN 		june_2019 		 TYPE numeric	 USING june_2019::numeric	;
ALTER TABLE public.online_gambling_sites ALTER COLUMN 		july_2019 		 TYPE numeric	 USING july_2019::numeric	;
ALTER TABLE public.online_gambling_sites ALTER COLUMN 		august_2019 	 TYPE numeric	 USING august_2019::numeric	;
ALTER TABLE public.online_gambling_sites ALTER COLUMN 		september_2019 	 TYPE numeric	 USING september_2019::numeric	;
ALTER TABLE public.online_gambling_sites ALTER COLUMN 		october_2019 	 TYPE numeric	 USING october_2019::numeric	;
ALTER TABLE public.online_gambling_sites ALTER COLUMN 		november_2019 	 TYPE numeric	 USING november_2019::numeric	;
ALTER TABLE public.online_gambling_sites ALTER COLUMN 		december_2019	 TYPE numeric	 USING december_2019::numeric	;
ALTER TABLE public.online_gambling_sites ALTER COLUMN 		january_2020 	 TYPE numeric	 USING january_2020::numeric	;
ALTER TABLE public.online_gambling_sites ALTER COLUMN 		february_2020 	 TYPE numeric	 USING february_2020::numeric	;
		

/*
==========================================================================================================================================================================================================================================
==========================================================================================================================================================================================================================================
LANGUAGE SP
==========================================================================================================================================================================================================================================
==========================================================================================================================================================================================================================================
*/

DROP TABLE IF EXISTS Languages_base;

	CREATE TEMP TABLE IF NOT EXISTS Languages_base

	as(

		SELECT distinct DENSE_RANK() OVER (order by LANGUAGES) id,  REPLACE(REPLACE(LANGUAGES,' ',''),' ','') LANGUAGES
		FROM public.online_gambling_sites

	);


create or replace procedure SP_Create_Languages()

language plpgsql

as $$

declare		
	i int := 1;
	j int := 1;	
begin
	
	drop table if exists languages;

	create table if not exists languages(
		id integer NOT NULL GENERATED ALWAYS AS IDENTITY,	
		LANGUAGEs varchar(5)
	);
	
	create temp table if not exists l (
		LANGUAGEs varchar(5)
	);
	
	while  i <= (select max(id) from Languages_base) loop
			
				while j <= (select LENGTH(LANGUAGES) from Languages_base where id = i) loop

					insert into l(LANGUAGEs)

					select substring(LANGUAGES,j,2)
					from Languages_base
					where id = i;

					j := j + 3;

				end loop;
			 
			 i := i + 1;
			 j := 1;
			 
	end loop;
	
	insert into languages(LANGUAGEs)
	select distinct LANGUAGEs
	from l;

end; $$


call  SP_Create_Languages();


select *
from public.languages
order by languages;



/*
==========================================================================================================================================================================================================================================
==========================================================================================================================================================================================================================================
types SP
==========================================================================================================================================================================================================================================
==========================================================================================================================================================================================================================================
*/

DROP TABLE IF EXISTS typess_base;

	CREATE TEMP TABLE IF NOT EXISTS typess_base

	as(

		SELECT distinct DENSE_RANK() OVER (order by types) id,  REPLACE(REPLACE(REPLACE(types,' ',''),' ',''),'.',',') typesS
		FROM public.online_gambling_sites

	);


create or replace procedure SP_Create_typess()

language plpgsql

as $$

declare		
	i int := 1;
	word varchar(500) := '';
begin
	
	drop table if exists typess;

	create table if not exists typess(
		id integer NOT NULL GENERATED ALWAYS AS IDENTITY,	
		typess varchar(500)
	);
	
	create temp table if not exists t (
		typess varchar(500)
	);
	
	while  i <= (select max(id) from typess_base) loop
			
				word := (select typesS from typess_base where id = i);
								
				while (select LENGTH(word)) > 1 loop
					
					insert into t(typess)
					select substring(word,1,(case when strpos(word,',') > 0 then strpos(word,',')-1 else LENGTH(word) end));
									
					word := substring(word,
									  case when strpos(word,',') > 0 then strpos(word,',')+1 else 0 end,
									  case when strpos(word,',') > 0 then length(word) else 0 end);
												
				end loop;
			 
			 i := i + 1;
			 
	end loop;
	
	insert into typess(typess)
	select distinct typess
	from t;

end; $$


call  SP_Create_typess();


select *
from public.typess
order by typess;

select *
from online_gambling_sites

select *,strpos(typess,',')

--,substring(typess,1,strpos(typess,',')-1),
--				substring(substring(typess,strpos(typess,',')+1,length(typess))
--				,1,strpos(substring(typess,strpos(typess,',')+1,length(typess)),',')-1)
from typess_base
order by id
where id = 30
