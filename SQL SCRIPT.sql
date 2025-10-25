#Show tables and row counts
SHOW TABLES;
SELECT 'world_energy_investment' AS tbl, COUNT(*) FROM world_energy_investment
UNION ALL SELECT 'energy_data', COUNT(*) FROM energy_data
UNION ALL SELECT 'gdp', COUNT(*) FROM gdp
UNION ALL SELECT 'population', COUNT(*) FROM population
UNION ALL SELECT 'renewable_energy_consumption', COUNT(*) FROM renewable_energy_consumption;

# Create Indexes (to speed up joins & filtering)
ALTER TABLE gdp 
MODIFY COLUMN region_code VARCHAR(10);
DROP INDEX idx_gdp_region_year ON gdp;
CREATE INDEX idx_gdp_region_year ON gdp(region_code, year);

ALTER TABLE population 
MODIFY COLUMN region_code VARCHAR(10);
DROP INDEX idx_population_region_year ON population;
CREATE INDEX idx_population_region_year ON population(region_code, year);

ALTER TABLE energy_data 
MODIFY COLUMN region_code VARCHAR(10);
DROP INDEX idx_energy_region_year ON energy_data;
CREATE INDEX idx_energy_region_year ON energy_data(region_code, year);

ALTER TABLE renewable_energy_consumption
MODIFY COLUMN region_code VARCHAR(10);
CREATE INDEX idx_renewable_region_year ON renewable_energy_consumption(region_code, year);

ALTER TABLE world_energy_investment 
MODIFY COLUMN region_code VARCHAR(10);
CREATE INDEX idx_investment_region_year ON world_energy_investment(region_code, year);

# Change Column Name
ALTER TABLE energy_data
RENAME COLUMN ï»¿region TO region;

ALTER TABLE world_energy_investment
RENAME COLUMN Catergory TO Category;

# Create Aggregated Tables
DROP TABLE IF EXISTS agg_gdp;
CREATE TABLE agg_gdp AS
SELECT region_code, region, year, ROUND(SUM(GDP_current_US$) / 1000000000, 2) AS gdp_usd_billion
FROM gdp
GROUP BY region_code, region, year;

DROP TABLE IF EXISTS agg_population;
CREATE TABLE agg_population AS
SELECT region_code, region, year, 
ROUND(SUM(CAST(REPLACE(Population, ',', '') AS UNSIGNED)) / 1000000, 2) AS population_million
FROM population
GROUP BY region_code, region, year;
# Note:(REPLACE(Population, ',', '') → removes commas if they exist and CAST(... AS UNSIGNED) ensures it is treated as a number)

DROP TABLE IF EXISTS agg_renewable;
CREATE TABLE agg_renewable AS
SELECT region_code, region, year, ROUND(AVG(`Rene_eng_consp_%_of_total_eng_consp`), 2) AS renewable_pct
FROM renewable_energy_consumption
GROUP BY region_code, region, year;

DROP TABLE IF EXISTS agg_energy;
CREATE TABLE agg_energy AS
SELECT region_code, region, year,
ROUND(SUM(biofuel_consumption), 2) AS biofuel_consumption_twh,
ROUND(SUM(coal_consumption), 2) AS coal_consumption_twh,
ROUND(SUM(fossil_fuel_consumption), 2) AS fossil_consumption_twh,
ROUND(SUM(gas_consumption), 2) AS gas_consumption_twh,
ROUND(SUM(hydro_consumption), 2) AS hydro_consumption_twh,
ROUND(SUM(low_carbon_consumption), 2) AS low_carbon_consumption_twh,
ROUND(SUM(nuclear_consumption), 2) AS nuclear_consumption_twh,
ROUND(SUM(oil_consumption), 2) AS oil_consumption_twh,
ROUND(SUM(other_renewable_consumption), 2) AS other_renewable_consumption_twh,
ROUND(SUM(primary_energy_consumption), 2) AS total_primary_consumption_twh,
ROUND(SUM(renewables_consumption), 2) AS renewables_consumption_twh,
ROUND(SUM(solar_consumption), 2) AS solar_consumption_twh,
ROUND(SUM(wind_consumption), 2) AS wind_consumption_twh,
ROUND(SUM(biofuel_electricity), 2) AS biofuel_electricity_twh,
ROUND(SUM(coal_electricity), 2) AS coal_electricity_twh,
ROUND(SUM(fossil_electricity), 2) AS fossil_electricity_twh,
ROUND(SUM(gas_electricity), 2) AS gas_electricity_twh,
ROUND(SUM(low_carbon_electricity), 2) AS low_carbon_electricity_twh,
ROUND(SUM(nuclear_electricity), 2) AS nuclear_electricity_twh,
ROUND(SUM(oil_electricity), 2) AS oil_electricity_twh,
ROUND(SUM(other_renewable_electricity), 2) AS other_renewable_electricity_twh,
ROUND(SUM(renewables_electricity), 2) AS renewables_electricity_twh,
ROUND(SUM(solar_electricity), 2) AS solar_electricity_twh,
ROUND(SUM(wind_electricity), 2) AS wind_electricity_twh,
ROUND(SUM(coal_production), 2) AS coal_production_twh,
ROUND(SUM(gas_production), 2) AS gas_production_twh,
ROUND(SUM(oil_production), 2) AS oil_production_twh,
ROUND(SUM(electricity_demand), 2) AS electricity_demand_twh,
ROUND(SUM(electricity_generation), 2) AS electricity_generation_twh
FROM energy_data
GROUP BY region_code, region, year;

DROP TABLE IF EXISTS agg_investment;
CREATE TABLE agg_investment AS
SELECT region_code, region, year,
SUM(CASE WHEN Category = 'Total Energy Investment' THEN value_usdbillion ELSE 0 END) AS total_investment,
SUM(CASE WHEN Category = 'Total Clean Energy Investment' THEN value_usdbillion ELSE 0 END) AS clean_investment,
SUM(CASE WHEN Category LIKE '%Fossil%' THEN value_usdbillion ELSE 0 END) AS fossil_investment,
SUM(CASE WHEN Category = 'Renewables' THEN value_usdbillion ELSE 0 END) AS renewables_investment,
SUM(CASE WHEN Category = 'Nuclear' THEN value_usdbillion ELSE 0 END) AS nuclear_investment,
SUM(CASE WHEN Category = 'Energy efficiency' THEN value_usdbillion ELSE 0 END) AS efficiency_investment
FROM world_energy_investment
GROUP BY region_code, region, year;

# Joining Tables
DROP VIEW IF EXISTS energy_investment_combined;
CREATE VIEW energy_investment_combined AS
SELECT 
g.region_code,
g.region,
g.year,
g.gdp_usd_billion,
p.population_million,
r.renewable_pct,
e.biofuel_consumption_twh,
e.coal_consumption_twh,
e.fossil_consumption_twh,
e.gas_consumption_twh,
e.hydro_consumption_twh,
e.low_carbon_consumption_twh,
e.nuclear_consumption_twh,
e.oil_consumption_twh,
e.other_renewable_consumption_twh,
e.total_primary_consumption_twh,
e.renewables_consumption_twh,
e.solar_consumption_twh,
e.wind_consumption_twh,
e.biofuel_electricity_twh,
e.coal_electricity_twh,
e.fossil_electricity_twh,
e.gas_electricity_twh,
e.low_carbon_electricity_twh,
e.nuclear_electricity_twh,
e.oil_electricity_twh,
e.other_renewable_electricity_twh,
e.renewables_electricity_twh,
e.solar_electricity_twh,
e.wind_electricity_twh,
e.coal_production_twh,
e.gas_production_twh,
e.oil_production_twh,
e.electricity_demand_twh,
e.electricity_generation_twh,
i. total_investment,
i.clean_investment,
i.fossil_investment,
i.renewables_investment,
i.nuclear_investment,
i.efficiency_investment
FROM agg_gdp g
LEFT JOIN agg_population p ON g.region_code = p.region_code AND g.year = p.year
LEFT JOIN agg_renewable r ON g.region_code = r.region_code AND g.year = r.year
LEFT JOIN agg_energy e ON g.region_code = e.region_code AND g.year = e.year
LEFT JOIN agg_investment i ON g.region_code = i.region_code AND g.year = i.year;

select *
from energy_investment_combined;





