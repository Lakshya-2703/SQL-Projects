--This data has been downloaded through Kagggle(https://www.kaggle.com/datasets/kuralamuthan300/glassdoor-data-science-jobs/data)
--Glassdoor Data science Jobs - 2024
--The Glassdoor Job Postings Dataset is a comprehensive collection of data science job listings sourced from the popular employment and company review platform, Glassdoor. 
--This dataset aims to provide valuable insights into the job market, industry trends, and employer characteristics.
--I have break down the data in 2 table 
-- 1) With data related to to job titles,description,company size and related data
-- 2) With data related to the ratings 

-- Viewing full Companies Table 
Select * from Companies

-- Viewing full Job Reviews table
Select * from Ratings

-- Checking for highest rating companies
Select company, job_title, location, company_size, company_rating 
from Companies
Order by 5 desc

-- We'll see no. of companie's employment type
select employment_type, count(employment_type) as No_of_companies
from Companies
group by employment_type
order by 2 desc

-- While viewing the companies data we could see that the salary_avg_estimate was needed to be clean to process.
-- From that we will use Trim and Try_Parse
-- Trim - removes the space character OR other specified characters from the start or end of a string.
-- Try_Parse - for converting from string to date/time and number types

Select company, job_title, location, 
parse(trim( leading 'â,¹‚¹'from salary_avg_estimate)as numeric (10,2) ) as AvgSalary
from Companies
Order by 4 desc

--To reuse the AvgSalary column we will introduce temp table
-- Temp Table - used to store data temporarily. 
----------------They are useful for storing the immediate result sets that are accessed multiple times.
drop table if exists #Salaries
go
SELECT company, job_title, location, 
try_parse(trim( leading 'â,¹‚¹'from salary_avg_estimate)as numeric (10,2) ) as AvgSalary 
INTO #Salaries FROM Companies

Select * from #Salaries
order by 4 desc

-- Now we will look for highest paying jobtitle at microsoft
select company, job_title, AvgSalary 
from #Salaries
where company = 'Microsoft' and AvgSalary is not null
order by 3 desc

-- We'll be looking for companies with hight work life balance rate
select com.company,com.job_title, location, company_size,work_life_balance_rating
from Companies as com join Ratings rate
on com.company = rate.company 
and com.job_title = rate.job_title
where work_life_balance_rating is not null
order by 5 desc

--now we'll join 3 tables
select com.company,rate.job_title, com.location, company_size,work_life_balance_rating,AvgSalary
from Companies as com 
join Ratings rate
on com.company = rate.company 
and com.job_title = rate.job_title
join #Salaries
on com.company = rate.company 
and com.job_title = rate.job_title
where work_life_balance_rating is not null and AvgSalary is not null
order by 6 desc

-- We'll look into text operator - highest paying job in noida
select com.company,com.job_title,com.location,sal.AvgSalary,job_description
from Companies com join #Salaries sal
on com.company = sal.company 
and com.job_title = sal.job_title
where com.location like '%Noida%'
and AvgSalary is not null
order by 4 desc

-- Companys job opening at location which ends with 'a'
select com.company,com.job_title,com.location,sal.AvgSalary,job_description
from Companies com join #Salaries sal
on com.company = sal.company 
and com.job_title = sal.job_title
where com.location like '%a'
and AvgSalary is not null
order by 3,4

--Number of openings in a company
Select company,count(job_title) from Companies as no_of_openings
Where company is not null and company_size is not null
group by company
order by 2 desc

