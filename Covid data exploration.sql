--deth=table of covid deaths
--vacc=table of covid vaccinations
select * 
from portfo..deth
where continent is not null
order by 3,4

--select * 
--from portfo..vacc
--order by 3,4

select location, date, total_cases, new_cases, total_deaths, population 
from portfo..deth
order by 1,2

--total cases vs total deaths
--dethper=likelihood of death in canada if infected
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as dethper 
from portfo..deth
where location like '%anad%' 
order by 1


--total cases to population
--infecper=percent of canadians that got covid 

select location, date, total_cases, population, (total_cases/population)*100 as infecper 
from portfo..deth
where location like '%anad%' 
order by 1

--View infecper=CanInfec
Create view CanInfec as
select location, date, total_cases, population, (total_cases/population)*100 as infecper 
from portfo..deth
where location like '%anad%' 
--order by 1

--highest infection ratio by country

select location, max(total_cases) as infeccount, population, max((total_cases/population))*100 as infecper 
from portfo..deth
--where location like '%anad%' 
group by location, population
order by infecper desc

--death count and percent

select location, max(cast(total_deaths as int)) as deathcount, population, max((total_deaths/population))*100 as deathper 
from portfo..deth
--where location like '%anad%'
where continent is not null
group by location, population
order by deathcount desc


--by continent/region

select location, max(cast(total_deaths as int)) as deathcount
from portfo..deth
where location like '%anad%'
--where continent is null
group by location
order by deathcount desc


select continent, max(cast(total_deaths as int)) as deathcount
from portfo..deth
--where location like '%anad%'
where continent is not null
group by continent
order by deathcount desc


--continents highest death count per population

select continent, max(cast(total_deaths as int)) as deathcount
from portfo..deth
--where location like '%anad%'
where continent is not null
group by continent
order by deathcount desc

--View

Create View Contideath as
select continent, max(cast(total_deaths as int)) as deathcount
from portfo..deth
--where location like '%anad%'
where continent is not null
group by continent
--order by deathcount desc



-- global numbers

select sum(new_cases) as newcases, sum(cast(new_deaths as int)) as newdeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as newdeathpercent 
from portfo..deth
where location like '%anad%' 
--where continent is not null
--group by date
order by 1


--vaccination trend by country 
select D.continent, D.location, D.date, D.population, V.new_vaccinations,
sum(cast(V.new_vaccinations as int)) over (partition by D.location order by D.location, D.date)
as dailyincrease
from portfo..deth D
join portfo..vacc V
	on D.location = V.location
	and D.date=V.date
where D.continent is not null
--where D.location like '%anad%'
order by 2,3


--CTE use
--dailyincrease=rolling total infections

with trend (continent, location, date, population, new_vaccinations, dailyincrease)
as 
(
select D.continent, D.location, D.date, D.population, V.new_vaccinations,
sum(cast(V.new_vaccinations as numeric)) over (partition by D.location order by D.location, D.date)
as dailyincrease
from portfo..deth D
join portfo..vacc V
	on D.location = V.location
	and D.date = V.date
where D.continent is not null
--where D.location like '%anad%'
--order by 2,3
)
select *, (dailyincrease/population)*100
from trend
order by location, date


--TEMP
Drop Table if exists #percentvaccin
create Table #percentvaccin
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
dailyincrease numeric
)

Insert into #percentvaccin
select D.continent, D.location, D.date, D.population, V.new_vaccinations,
sum(convert(numeric, V.new_vaccinations)) over (partition by D.location order by D.location, D.date)
as dailyincrease
from portfo..deth D
join portfo..vacc V
	on D.location = V.location
	and D.date = V.date
where D.continent is not null
--where D.location like '%anad%'
--order by 2,3

select *, (dailyincrease/population)*100
from #percentvaccin



--View

Create view percentvaccin as
select D.continent, D.location, D.date, D.population, V.new_vaccinations,
sum(convert(numeric, V.new_vaccinations)) over (partition by D.location order by D.location, D.date)
as dailyincrease
from portfo..deth D
join portfo..vacc V
	on D.location = V.location
	and D.date = V.date
where D.continent is not null
--where D.location like '%anad%'
--order by 2,3

