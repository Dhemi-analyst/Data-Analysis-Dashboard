--- Data cleaning


select *
FROM layoffs;

(--- steps in Data cleaning 
--1. Remove Duplicate 
--2. STandardize the Data
--3. null values or blank values 
--4. Remove any column );


Create Table layoffs_staging 
like layoffs;

Select *
from layoffs_staging;

INSERT layoffs_staging
select *
FROM layoffs;



Select *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, location, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
from layoffs_staging;


with duplicate_CTE AS
(Select *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, location, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
from layoffs_staging)
select *
from duplicate_CTE;

with duplicate_CTE AS
(Select *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, location, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
from layoffs_staging )

select *
from duplicate_CTE
where row_num > 1;


select*
from layoffs_staging
where company = 'Casper';


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;     

Select *
from layoffs_staging2;

insert layoffs_staging2
Select *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, location, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
from layoffs_staging;

DElETE
from layoffs_staging2
where row_num > 1;

-- standardization data

select company, Trim((company))
from layoffs_staging2;

Update layoffs_staging2
SET Company = Trim(company);

select Distinct(industry)
from layoffs_staging2
order by 1;

select *
from layoffs_staging2
where industry like 'Crypto%';

update layoffs_staging2
set industry = 'crypto'
where industry LIKE 'crypto%';

select DIstinct (country)
FROM Layoffs_staging2
order by 1;

Select Distinct(country)
from layoffs_staging2
where country like 'united state%';

Select Distinct(country), Trim(Trailing '.' from country)
from layoffs_staging2
order by 1;

update layoffs_staging2
set country = Trim(Trailing '.' from country) 
Where country like 'united states%'; 

select `date`
from layoffs_staging2
;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;



select * 
from layoffs_staging2 
where industry is NULL
 or industry = '';

select *
from layoffs_staging2
where company like 'Bally%';

select t1.industry, t2.industry
from layoffs_staging2 t1
join layoffs_staging2 t2
	 ON t1.company = t2.company 
     AND t1.location = t2.location
Where (T1.industry is Null) 
and t2.industry is not null;

update layoffs_staging2
set industry = null 
where industry ='';


update layoffs_staging2 t1
join layoffs_staging2 t2 
	ON t1.company =t2.company
    set t1.industry = t2.industry
    where (t1.industry is null)
    AND t2.industry is not null;
    
    
    
Select * 
from layoffs_staging2
where total_laid_off is Null AND percentage_laid_off is Null;

DELETE    
from layoffs_staging2
where total_laid_off is Null 
AND percentage_laid_off is Null;

select *
    from layoffs_staging2;
    
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;
