SELECT *from CovidDeaths
select *from covidvaccinations

select location,date, total_cases,new_cases,total_deaths,population 
from coviddeaths
order by 1,2

--finding the death percentage out of total cases 
--Can find the death percentage of any location

select location,date,total_cases,total_deaths,population,(total_deaths/total_cases)*100
as Death_Percentage
from coviddeaths
where location like 'india'
order by 1,2

--finding total cases vs population
--shows the percentage of population got covid

select location ,date,total_cases,population,(total_cases/population)*100
as Cases_Percentage
from coviddeaths
where location like 'india'
order by 1,2

--find the countries with highest infection rate compared to population
--shows the percentage of population infected

select location,max(total_cases) Highest_InfectionCount,population,
max(total_cases/population)*100 as PercentPopulationInfected
from coviddeaths
group by location,population
Order by PercentPopulationInfected DESC

--showing highest death count in India

select *from coviddeaths

select location,max(cast(total_deaths as int)) as Total_Deaths,population
from CovidDeaths
where location like 'India'
group by location,population
order by 2 DESC

--showing continents with highest death count per population
--max(cast(total_deaths as int)) to convert coloumn Total_deaths from nvarchar to int

select continent,max(cast(total_deaths as int)) as Total_Death_Cont
from CovidDeaths
where continent is not NULL
group by continent
order by Total_Death_Cont DESC

--find the total deaths ,total newcases & death percentage (globaldata)

select  sum(cast(new_deaths as int)) Total_Death,sum(new_cases) Total_Cases, 
sum(cast(new_deaths as int))/sum(new_cases)*100  Death_Percent
from CovidDeaths
where continent is not NULL

--find the total amount of people vaccinated vs location

select*from CovidVaccinations

select cd.location,sum(cast(cv.people_fully_vaccinated as bigint)) as People_Vaccinated
from CovidDeaths cd
join CovidVaccinations cv
on cd.location=cv.location
and
   cd.date=cv.date
   where cd.continent is not NULL
   group by cd.location
   order by People_Vaccinated DESC

--USE CTE & JOINS to find data of new_vaccinations vs population
--find rolling count of people vaccinated
--find percentage of rolling count of vaccinations

select *from CovidDeaths
select *from CovidVaccinations

with Vac_Pop as
(
	select cd.date,cd.continent,cd.location,cd.population,cv.new_vaccinations,
	sum(cast(cv.new_vaccinations as int)) over (partition by cd.location order by cd.date ) as Rolling_Count
	from CovidDeaths cd
	join CovidVaccinations cv
	on cd.location=cv.location
	and
	cd.date=cv.date
	where cd.continent is not NULL 
)
	select *,
	(Rolling_Count/population) * 100 as Percent_Rolling_Count from Vac_Pop

--creating view to store data for later visualizations
--newvaccinations_population

Create view vaccination_population as

	select cd.date,cd.continent,cd.location,cd.population,cv.new_vaccinations,
	sum(cast(cv.new_vaccinations as int)) over (partition by cd.location order by cd.date ) as Rolling_Count
	from CovidDeaths cd
	join CovidVaccinations cv
	on cd.location=cv.location
	and
	cd.date=cv.date
	where cd.continent is not NULL 
