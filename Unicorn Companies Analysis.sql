create database  unicorn;
use unicorn;

create table industries (
	company_id int,
    industry varchar(50)
);

create table funding (
	company_id int,
    valuation int,
    funding int,
    select_investors varchar(50)
);

create table dates (
	company_id int,
    date_joined date,
    year_founded date
);

create table companies (
	company_id int,
    company varchar(50),
    city varchar(50),
    country varchar(50),
    continent varchar(50)
);

LOAD DATA LOCAL INFILE 'C:/Users/Dell/Downloads/Unicorn Analysis/industries.csv'
INTO TABLE industries 
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/Users/Dell/Downloads/Unicorn Analysis/funding.csv'
INTO TABLE funding 
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/Users/Dell/Downloads/Unicorn Analysis/dates.csv'
INTO TABLE dates
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/Users/Dell/Downloads/Unicorn Analysis/companies.csv'
INTO TABLE companies
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

show tables;
select * from industries;
select * from funding;
select * from dates;
select * from companies;

alter table dates
modify date_joined varchar(100), 
modify year_founded varchar(100);

alter table funding
modify valuation bigint, 
modify funding bigint;

ALTER TABLE dates ADD COLUMN date_joined_temp DATE;

UPDATE dates 
SET date_joined_temp = STR_TO_DATE(date_joined, '%d-%m-%Y');
SELECT date_joined, date_joined_temp FROM dates LIMIT 10;

ALTER TABLE dates DROP COLUMN date_joined;

ALTER TABLE dates CHANGE date_joined_temp date_joined DATE;
SET GLOBAL LOCAL_INFILE=ON;

select count(*) from industries
where
	company_id is null 
    or industry is null;
    
select * from funding
where
	company_id is null 
    or valuation is null
    or funding is null
    or select_investors is null;
    
select count(*) from dates
where
	company_id is null 
    or date_joined is null
    or year_founded is null;
    
select count(*) from companies
where
	company_id is null 
    or company is null
    or city is null
    or country is null
    or continent is null;
    
-- Total Unicorn Companies
select count(distinct company_id) as Total_Companies
from companies;

-- 1. Top 5 Most Valuable Companies
select f.company_id, c.company, sum(f.valuation) as Valuation
from funding as f
join companies as c 
on f. company_id = c.company_id
group by c.company_id, c.company
order by c.company_id, Valuation desc
limit 5;

-- 2. Number of Unicorns per Continent
select continent, count(company_id) as no_of_companies
from companies
group by continent
order by no_of_companies desc;

-- 3. Find Companies Founded Before 2000 That Became Unicorns After 2015
select c.company, d.year_founded, d.date_joined from companies as c
join dates as d 
on c.company_id = d.company_id
where d.year_founded <=2000
and d.date_joined >='2015-01-01';

-- 4. Find the Average Valuation of Companies by Industry
select i.industry, avg(f.valuation) as avg_valuation_of_industry
from industries as i
join funding as f
on i.company_id = f.company_id
group by i.industry
order by avg_valuation_of_industry desc;

-- 5. Find Companies with the Most Selective Investors
SELECT c.company, LENGTH(f.select_investors) - LENGTH(REPLACE(f.select_investors, ',', '')) + 1 AS investor_count
FROM funding f
JOIN companies c ON f.company_id = c.company_id
ORDER BY investor_count DESC
LIMIT 15;

-- 6. Top 5 companies by valuation - to - funding ratio
SELECT 
  c.company,
  ROUND(SUM(f.valuation) / NULLIF(SUM(f.funding), 0), 2) AS valuation_to_funding_ratio
FROM companies AS c
JOIN funding AS f 
  ON c.company_id = f.company_id
GROUP BY c.company
ORDER BY valuation_to_funding_ratio DESC
limit 5;

-- 7️. Find the Most Common Industry by Continent
select c.continent, i.industry, count(*) as industries
from companies as c
join industries as i
on c.company_id = i.company_id
group by 1,2
order by 3 desc;

-- 8️. Find Top 20 Companies That Raised More Than Industry Average
select c.company, f.funding, i.industry
from funding f
join industries i on f.company_id = i.company_id
join companies c on f.company_id = c.company_id
where f.funding > (
    select avg(f2.funding) 
    from funding f2 
    join industries i2 on f2.company_id = i2.company_id 
    where i2.industry = i.industry
)
order by f.funding desc
limit 20;

-- 9️. Find the Fastest-Growing Unicorns (Shortest Time from Founding to Unicorn Status)
select c.company, d.year_founded, year(d.date_joined) as date_joined, (year(d.date_joined) - year_founded) as years_to_unicorn
from companies c
join dates d on c.company_id = d.company_id
where (year(d.date_joined) - year_founded) > 0
order by days_to_unicorn ASC
limit 10;

-- 10. Find the Oldest Unicorns (Companies Founded the Longest Ago but Still Unicorns)
select c.company, d.year_founded
from companies c
join dates d on c.company_id = d.company_id
order by d.year_founded
limit 10;

-- 11. Average Time (in Years) from Founding to Unicorn Status by Continent
select c.continent, avg(year(d.date_joined) - year_founded) as avg_year
from companies c
join dates d on c.company_id = d.company_id
group by 1;

-- 12. Most Common Founding Years Among Unicorns
select year_founded, count(*) as company_count
from dates
group by year_founded
order by company_count desc;

-- 13. Companies Founded Before 2010 but Valued Over $10 Billion
select c.company, d.year_founded, f.valuation
from companies c
join dates d on c.company_id = d.company_id
JOIN funding f on c.company_id = f.company_id
where d.year_founded < 2010 and f.valuation > 10000000000
order by f.valuation desc;

-- 14. Continent with the Highest Total Unicorn Valuation
SELECT c.continent, SUM(f.valuation) AS total_valuation
FROM companies c
JOIN funding f ON c.company_id = f.company_id
GROUP BY c.continent
ORDER BY total_valuation DESC
LIMIT 1;

-- 15. Top 3 Industries with the Highest Average Funding
SELECT i.industry, ROUND(AVG(f.funding), 2) AS avg_funding
FROM industries i
JOIN funding f ON i.company_id = f.company_id
GROUP BY i.industry
ORDER BY avg_funding DESC
LIMIT 3;

-- 16. Industry Diversity: Number of Different Industries Per Country
SELECT c.country, COUNT(DISTINCT i.industry) AS industry_count
FROM companies c
JOIN industries i ON c.company_id = i.company_id
GROUP BY c.country
ORDER BY industry_count DESC;

-- 17. Countries with the Highest Number of Unicorns Founded After 2022
SELECT c.country, COUNT(*) AS unicorn_count
FROM companies c
JOIN dates d ON c.company_id = d.company_id
WHERE d.date_joined >= '2022-01-01'
GROUP BY c.country
ORDER BY unicorn_count DESC;