-- TABLE 1: Create the Hazardous_substances table (according to Directive 2002/95/EC.)

CREATE TABLE restricted_substances (
    id INT PRIMARY KEY,
    substance_name VARCHAR(100),
    cas_number VARCHAR(20),
    ec_number VARCHAR(20),
    rohs_limit DECIMAL(5,4),
    common_uses TEXT,
    hazard_classification VARCHAR(100),
    potential_alternatives TEXT
);

-- Insert data into restricted_substances
INSERT INTO restricted_substances (id, substance_name, cas_number, ec_number, rohs_limit, common_uses, hazard_classification, potential_alternatives)
VALUES
(1, 'Lead (Pb)', '7439-92-1', '231-100-4', 0.1000, 'Solder, batteries, cathode ray tubes', 'Reproductive toxicity', 'Lead-free solder (tin, silver, copper alloys)'),
(2, 'Mercury (Hg)', '7439-97-6', '231-106-7', 0.1000, 'Switches, relays, fluorescent lamps', 'Reproductive toxicity, environmental hazard', 'Optical switches, LED lamps'),
(3, 'Cadmium (Cd)', '7440-43-9', '231-152-8', 0.0100, 'Batteries, pigments, plating', 'Carcinogenic, mutagenic', 'Nickel-metal hydride batteries, zinc plating'),
(4, 'Hexavalent chromium (CrVI)', '18540-29-9', '240-440-2', 0.1000, 'Corrosion protection, pigments', 'Carcinogenic', 'Trivalent chromium, organic coatings'),
(5, 'PBB', '59536-65-1', '--', 0.1000, 'Flame retardants in plastics', 'Persistent organic pollutant', 'Phosphorus-based flame retardants'),
(6, 'PBDE', '1163-19-5', '214-604-9', 0.1000, 'Flame retardants in plastics and textiles', 'Persistent organic pollutant, potential endocrine disruptor', 'Halogen-free flame retardants'),
(7, 'DEHP', '117-81-7', '204-211-0', 0.1000, 'Plasticizer in PVC', 'Reproductive toxicity', 'Citrates, adipates, or other non-phthalate plasticizers'),
(8, 'BBP', '85-68-7', '201-622-7', 0.1000, 'Plasticizer in PVC, adhesives', 'Reproductive toxicity', 'Diisononyl cyclohexane-1,2-dicarboxylate (DINCH)'),
(9, 'DBP', '84-74-2', '201-557-4', 0.1000, 'Plasticizer in adhesives, printing inks', 'Reproductive toxicity', 'Di(2-ethylhexyl) terephthalate (DEHT)'),
(10, 'DIBP', '84-69-5', '201-553-2', 0.1000, 'Plasticizer in plastics, paints, adhesives', 'Reproductive toxicity', 'Acetyl tributyl citrate (ATBC)');

-- TABLE2: Create the Bill of Materials table for laptops and desktops (arbitary values)
CREATE TABLE components (
    id INT PRIMARY KEY IDENTITY(1,1),
    component_name VARCHAR(100),
    in_desktop BIT,
    in_laptop BIT,
    common_chemical_substances TEXT
);

-- Insert data into components
INSERT INTO components (component_name, in_desktop, in_laptop, common_chemical_substances) VALUES
('Motherboard', 1, 1, 'Lead (Pb), Mercury (Hg), Cadmium (Cd), Hexavalent Chromium (CrVI), PBB, PBDE, Beryllium, Copper, Silicon'),
('CPU', 1, 1, 'Silicon, Lead (Pb), Copper'),
('RAM', 1, 1, 'Silicon, Lead (Pb), Copper'),
('Hard Drive/SSD', 1, 1, 'Aluminum, Copper, Lead (Pb), Rare Earth Elements'),
('Power Supply Unit', 1, 0, 'Copper, Lead (Pb), PVC'),
('Optical Drive', 1, 0, 'Aluminum, Polycarbonate, Lead (Pb)'),
('Graphics Card', 1, 0, 'Lead (Pb), Copper, Silicon'),
('Cooling System', 1, 1, 'Aluminum, Copper'),
('Case/Chassis', 1, 1, 'Aluminum, Steel, Plastic, PBB, PBDE'),
('Keyboard', 1, 1, 'Plastic,PBB, PBDE, Rubber'),
('Touchpad', 0, 1, 'Plastic, Copper'),
('Battery', 0, 1, 'Lithium, Cobalt, Nickel, Cadmium'),
('Wireless Card', 1, 1, 'Copper, Lead (Pb)'),
('Webcam', 1, 1, 'Plastic, Silicon'),
('Speakers', 1, 1, 'Copper, Rare Earth Elements, Plastic'),
('Cables/Connectors', 1, 1, 'Copper, PVC, BBP');

-- TABLE 3: Create the component_substance_table to map the BOM with hazardous substance table
CREATE TABLE component_substance_map (
    id INT PRIMARY KEY IDENTITY(1,1),
    component_id INT,
    substance_id INT,
    FOREIGN KEY (component_id) REFERENCES components(id),
    FOREIGN KEY (substance_id) REFERENCES restricted_substances(id)
);

-- Populate the mapping table based on the common chemical substances
INSERT INTO component_substance_map (component_id, substance_id)
SELECT c.id, rs.id
FROM components c
CROSS JOIN restricted_substances rs
WHERE c.common_chemical_substances LIKE '%' + rs.substance_name + '%';

-- VIEW 1: Overall Table contains BOM and the hazardous substance it contains

CREATE VIEW BOM_RoHS AS
SELECT 
    c.id AS component_id,
    c.component_name,
    c.in_desktop,
    c.in_laptop,
    rs.substance_name,
    rs.rohs_limit,
    rs.hazard_classification,
	rs.potential_alternatives
FROM 
    components c
JOIN 
    component_substance_map csm ON c.id = csm.component_id
JOIN 
    restricted_substances rs ON csm.substance_id = rs.id;

select * from BOM_RoHS
-- TABLE 4:HP_DELL_ASUS_LENOVO - Contains EPEAT score out of 49 and EPEAT TIER
-- BRONZE - Products that meet all required criteria and achieve less than 50% of the optional points
-- SILVER - Products that meet all required criteria and achieve 50 - 74% of the optional points 
-- GOLD - Products that meet all required criteria and achieve 75 - 100% of the optional points 

-- BOM_ROHS table
select * from BOM_ROHS
--HP_DELL_ASUS_LENOVO table
select * from HP_DELL_ASUS_LENOVO


-- DATA CLEANING IN SQL 

--1 Get all the column name:

select column_name from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'HP_DELL_ASUS_LENOVO'

select column_name from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'BOM_RoHS'

--2 Drop Unwanted columns from the table:

alter table HP_DELL_ASUS_LENOVO
drop column archived_on, _07SYS10_FQ1G_00, _095205068153, AltaLink_C8145_120V_NA,Amazon_ASIN,European_Article_Number,Extended_name, Global_Trade_Item_Number, Horizon_D13560,
Manufacturer_Part_Number,RSL10_LSS5X4W1K1X0X0, universal_product_code, Serial_Number,Zebra_SKU,climate,product_category, status,exceptions

--3 Formatting date column

alter table HP_DELL_ASUS_LENOVO
alter column registered_on date

-- 4 Renaming and Formatting score column

EXEC sp_rename 'HP_DELL_ASUS_LENOVO.Score_out_of_49', 'EPEAT_Score_out_of_49', 'COLUMN';

update HP_DELL_ASUS_LENOVO
set EPEAT_Score_out_of_49 = SUBSTRING(EPEAT_Score_out_of_49,1,2)

-- 5. Changing the datatype of the score column

alter table HP_DELL_ASUS_LENOVO
alter column EPEAT_Score_out_of_49 int


-- EXPLORING DATA IN SQL:

-- 1 No of unique products from each manufacturer:

Select manufacturer,count(distinct(product_name)) No_of_products from HP_DELL_ASUS_LENOVO
group by manufacturer

-- 2. Total number of desktops and notebooks:

select product_type, count(distinct(id)) from HP_DELL_ASUS_LENOVO
group by product_type

-- 3 Comparing EPEAT Score of LAPTOP and DESKTOP 

select product_type, avg(EPEAT_Score_out_of_49)average_score from HP_DELL_ASUS_LENOVO
group by product_type

-- 4 Comparing EPEAT score of manufacturers

select manufacturer, avg(EPEAT_Score_out_of_49)average_score from HP_DELL_ASUS_LENOVO
group by manufacturer

-- 5 No of products by manufacturer having score more than 40

select manufacturer, count(distinct(product_name)) score_more_than_40 from HP_DELL_ASUS_LENOVO
where EPEAT_Score_out_of_49>40
group by manufacturer

-- 6. Details laptop and desktop having highest score

select * from HP_DELL_ASUS_LENOVO H
join (select product_type, max(EPEAT_Score_out_of_49) max_score from HP_DELL_ASUS_LENOVO
group by product_type) as M
on H.EPEAT_Score_out_of_49 = M.max_score and M.product_type = h.product_type

--7. Details of the laptop and desktop having least score

select * from HP_DELL_ASUS_LENOVO H
join (select product_type, min(EPEAT_Score_out_of_49) mini_score from HP_DELL_ASUS_LENOVO
group by product_type) as M
on H.EPEAT_Score_out_of_49 = M.mini_score and M.product_type = h.product_type


--8. How the registered date impacts the EPEAT Score:

select manufacturer, year(registered_on) Year, avg(EPEAT_Score_out_of_49) average_score from HP_DELL_ASUS_LENOVO
where manufacturer = 'HP'
group by manufacturer, year(registered_on)
order by manufacturer


--9. How the registered date impacts the EPEAT TIER:

select manufacturer, year(registered_on) Year, count(EPEAT_TIER) average_score from HP_DELL_ASUS_LENOVO
where EPEAT_TIER = 'Gold' and manufacturer in ('DELL','HP')
group by manufacturer, year(registered_on)
order by manufacturer

--10. No of Gold and silver TIER by laptops and desktops

select * from HP_DELL_ASUS_LENOVO

select product_type, EPEAT_TIER, count(EPEAT_TIER) from HP_DELL_ASUS_LENOVO
group by product_type, EPEAT_TIER
order by EPEAT_TIER

--11. what are the top 10 laptops based on the EPEAT_Score:

select top 10 product_name,EPEAT_Score_out_of_49 from HP_DELL_ASUS_LENOVO
order by EPEAT_Score_out_of_49 desc

--12. Get the 4th highest scored desktop for each manufacturer (if scores are level sort on date)

Select manufacturer,product_name,EPEAT_Score_out_of_49 from (select manufacturer, product_name, EPEAT_Score_out_of_49, 
Dense_rank() over(partition by manufacturer order by EPEAT_Score_out_of_49 desc, registered_on desc) as rnk
from HP_DELL_ASUS_LENOVO
where product_type ='%desktop%') as subquery
where rnk=5

--13. what are the laptops that scores above average EPEAT score for each manufacturer:

select P.manufacturer, product_name, average, EPEAT_Score_out_of_49 from HP_DELL_ASUS_LENOVO P
join 
(select manufacturer, avg(EPEAT_Score_out_of_49) average from HP_DELL_ASUS_LENOVO
group by manufacturer) A
on p.manufacturer = A.manufacturer and P.EPEAT_Score_out_of_49>A.average


--14. How many GOLD and SILVER TIER got by each manufacturer

select manufacturer, EPEAT_TIER, count(EPEAT_TIER) TIER  from HP_DELL_ASUS_LENOVO
where EPEAT_TIER <> 'Bronze'
group by manufacturer, EPEAT_TIER
order by manufacturer

--15. Percentage of gold, silver and bronze TIER got by each manufacturer

select T.manufacturer, EPEAT_TIER, TIER,Total, round((cast(TIER as float)/TOTAL)* 100,2) Percentage
from
(select manufacturer, count(EPEAT_TIER) Total from HP_DELL_ASUS_LENOVO
group by manufacturer)
T join 
(select manufacturer, EPEAT_TIER, count(EPEAT_TIER) TIER from HP_DELL_ASUS_LENOVO
group by manufacturer, EPEAT_TIER) 
C on T.manufacturer = C.manufacturer

--16. No of hazardous substance found in laptop vs desktop

select
sum(case when in_laptop = 1 then 1 else 0 end) as laptop,
sum(case when in_desktop = 1 then 1 else 0 end) as desktop
from BOM_rohs

--17. what can be the replacement product for lead,PBB and PDBE

select distinct(substance_name),potential_alternatives
from BOM_RoHS
where substance_name like '%Lead%' or substance_name like '%PDBE%' or substance_name like '%PBB%'

--18. which component/substance is potential endocrine disruptor

select component_name, substance_name, hazard_classification
from BOM_RoHS
where hazard_classification like '%potential endocrine disruptor%'

--19. which hazardous substance having rohs_limit of 0.0100(100 parts per million)?

select component_name, substance_name,rohs_limit
from BOM_RoHS
where rohs_limit = 0.0100

--20. which material/component having more no of hazardous substances

select TOP 1 substance_name, count(substance_name) No_of_hazardous_components
from BOM_RoHS
group by substance_name
order by No_of_hazardous_components desc



