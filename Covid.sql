SELECT *                                             *
FROM [Portfolio Project]..['Covid Death$']
ORDER BY 3,4

--Select *
--From [Portfolio Project]..['Covid Vaccination$']
--order by 3,4

-- Select Data that we are going to be using
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM [Portfolio Project]..['Covid Death$']
ORDER BY 1,2
-- Looking at Total Cases Vs Total Deaths
-- Shows likelihood of dying if you contract covid in Australia
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM [Portfolio Project]..['Covid Death$']
WHERE location = 'Australia'
ORDER BY 1,2

-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid
SELECT Location, date, total_cases, population, (total_cases/population)*100 AS CasesPercentage
FROM [Portfolio Project]..['Covid Death$']
--Where location = 'Australia'
ORDER BY 1,2

-- Looking at Countries with Highest Infection Rate compared to Population
SELECT Location, Population, Max(total_cases) AS HighestInfectionCount, Max((total_cases/population))*100 AS CasesPercentage
FROM [Portfolio Project]..['Covid Death$']
GROUP BY location, population
ORDER BY CasesPercentage DESC

-- Showing Countries with Highest Death Count per Population
SELECT Location, Max(CAST(total_deaths AS int)) AS TotalDeathCount
FROM [Portfolio Project]..['Covid Death$']
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC

-- Let's break things down by continent
SELECT continent, MAX(CAST(total_deaths AS Int)) AS TotalDeathCount
FROM [Portfolio Project]..['Covid Death$']
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- Showing continents with highest death count in each continent
SELECT continent, MAX(CAST(total_deaths AS Int)) AS TotalDeathCount
FROM [Portfolio Project]..['Covid Death$']
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- Global Numbers
SELECT Sum(new_cases) AS total_cases, SUM(CAST(new_deaths AS Int)) AS total_deaths, SUM(CAST(new_deaths AS Int))/ Sum(new_cases)*100 AS DeathPercentage
FROM [Portfolio Project]..['Covid Death$']
WHERE continent is not null

SELECT *
FROM [Portfolio Project]..['Covid Vaccination$']

-- Looking at Total Population vs Total Tests

SELECT dea.continent, dea.location,dea.date, dea.population, vac.total_tests,
SUM(CAST(vac.total_tests AS bigint)) OVER (Partition BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleDead
FROM [Portfolio Project]..['Covid Death$'] dea
JOIN [Portfolio Project]..['Covid Vaccination$'] vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3

-- Create Table
DROP TABLE IF EXISTS PercentPopulationTested

CREATE TABLE PercentPopulationTested
(Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
total_tests numeric,
RollingPeopleTested numeric)


SELECT dea.continent, dea.location,dea.date, dea.population, vac.total_tests,
SUM(CAST(vac.total_tests AS bigint)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleTested
FROM [Portfolio Project]..['Covid Death$'] dea
JOIN [Portfolio Project]..['Covid Vaccination$'] vac
ON dea.location = vac.location
AND dea.date = vac.date



SELECT *, (RollingPeopleTested/Population)*100
FROM PercentPopulationTested

-- Creating View to store data for later Visualisation
CREATE VIEW PercentofPopulationTested AS
SELECT dea.continent, dea.location,dea.date, dea.population, vac.total_tests,
Sum(CAST(vac.total_tests AS bigint)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleTested
FROM [Portfolio Project]..['Covid Death$'] dea
JOIN [Portfolio Project]..['Covid Vaccination$'] vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not null

SELECT *
FROM PercentofPopulationTested
