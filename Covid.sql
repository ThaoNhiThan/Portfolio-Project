Select *
From [Portfolio Project]..['Covid Death$']
order by 3,4

--Select *
--From [Portfolio Project]..['Covid Vaccination$']
--order by 3,4

-- Select Data that we are going to be using
Select Location, date, total_cases, new_cases, total_deaths, population
From [Portfolio Project]..['Covid Death$']
order by 1,2
-- Looking at Total Cases Vs Total Deaths
-- Shows likelihood of dying if you contract covid in Australia
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [Portfolio Project]..['Covid Death$']
Where location = 'Australia'
order by 1,2

-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid
Select Location, date, total_cases, population, (total_cases/population)*100 as CasesPercentage
From [Portfolio Project]..['Covid Death$']
--Where location = 'Australia'
order by 1,2

-- Looking at Countries with Highest Infection Rate compared to Population
Select Location, Population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as CasesPercentage
From [Portfolio Project]..['Covid Death$']
Group by location, population
order by CasesPercentage Desc

-- Showing Countries with Highest Death Count per Population
Select Location, Max(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..['Covid Death$']
Where continent is not null
Group by location
order by TotalDeathCount Desc

-- Let's break things down by continent
Select continent, Max(cast(total_deaths as Int)) as TotalDeathCount
From [Portfolio Project]..['Covid Death$']
Where continent is not null
Group by continent
Order by TotalDeathCount Desc

-- Showing continents with highest death count in each continent
Select continent, Max(cast(total_deaths as Int)) as TotalDeathCount
From [Portfolio Project]..['Covid Death$']
Where continent is not null
Group by continent
order by TotalDeathCount Desc

-- Global Numbers
Select Sum(new_cases) as total_cases, Sum(cast(new_deaths as Int)) as total_deaths, Sum(cast(new_deaths as Int))/ Sum(new_cases)*100 as DeathPercentage
From [Portfolio Project]..['Covid Death$']
where continent is not null

Select *
From [Portfolio Project]..['Covid Vaccination$']

-- Looking at Total Population vs Total Tests

Select dea.continent, dea.location,dea.date, dea.population, vac.total_tests,
Sum(cast(vac.total_tests as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleDead
From [Portfolio Project]..['Covid Death$'] dea
Join [Portfolio Project]..['Covid Vaccination$'] vac
On dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
Order by 2,3

-- Create Table
Drop Table if exists PercentPopulationTested

Create Table PercentPopulationTested
(Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
total_tests numeric,
RollingPeopleTested numeric)


Select dea.continent, dea.location,dea.date, dea.population, vac.total_tests,
Sum(cast(vac.total_tests as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleTested
From [Portfolio Project]..['Covid Death$'] dea
Join [Portfolio Project]..['Covid Vaccination$'] vac
On dea.location = vac.location
and dea.date = vac.date



Select *, (RollingPeopleTested/Population)*100
From PercentPopulationTested

-- Creating View to store data for later Visualisation
Create View PercentofPopulationTested as
Select dea.continent, dea.location,dea.date, dea.population, vac.total_tests,
Sum(cast(vac.total_tests as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleTested
From [Portfolio Project]..['Covid Death$'] dea
Join [Portfolio Project]..['Covid Vaccination$'] vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

Select *
From PercentofPopulationTested
