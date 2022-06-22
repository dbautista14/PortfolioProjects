select * from PortfolioProject..CovidDeaths
where continent is not null 
order by 3, 4

--select * from PortfolioProject..CovidVaccinations
--order by 3, 4

-- select data that we are going to be using


select Location, date, total_cases, new_cases, total_deaths, population from PortfolioProject..CovidDeaths where continent is not null order by 1,2

-- Looking at total cases vs total deaths
-- shows likelihood of dying if you contract covid in your country

select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage from PortfolioProject..CovidDeaths where Location like '%states%' and where continent is not null order by 1,2

-- looking at total case vs population
--shows what percentage of population got covid

select Location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected from PortfolioProject..CovidDeaths where Location like '%states%' and where continent is not null order by 1,2

-- looking at countries with highest infection rate compared to population

select Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected from PortfolioProject..CovidDeaths 
--where Location like '%states%' 
where continent is not null
group by Location, population order by PercentPopulationInfected desc

--showing countries with highest death count per population

select Location, MAX(cast(total_deaths as int)) as TotalDeathCount from PortfolioProject..CovidDeaths 
--where Location like '%states%' 
where continent is not null
group by Location 
order by TotalDeathCount desc

-- break down TotalDeathCount by continent

-- showing continents with highest death count per population

select continent, MAX(cast(total_deaths as int)) as TotalDeathCount from PortfolioProject..CovidDeaths 
--where Location like '%states%' 
where continent is not null
group by continent
order by TotalDeathCount desc 


-- global numbers

select date, SUM(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage 
from PortfolioProject..CovidDeaths 
--where Location like '%states%' 
where continent is not null 
group by date
order by 1,2


select SUM(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage 
from PortfolioProject..CovidDeaths 
--where Location like '%states%' 
where continent is not null 
--group by date
order by 1,2


-- looking at total population vs vaccinations
select * 
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVax vac
on dea.location = vac.location
and dea.date = vac.date


-- Use CTE

with PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location order by dea.location, dea.date)
as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/Population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVax vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
-- order by 2,3
)

select *, (RollingPeopleVaccinated/Population)*100
from PopvsVac


-- temp table
Drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric, 
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location, dea.date)
as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/Population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVax vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
-- order by 2,3

select *, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated


--creating view to store data for later visualizations

create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location, dea.date)
as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/Population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVax vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3



select *
from PercentPopulationVaccinated




