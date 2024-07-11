# RoHS - Hazardous Substances in Electronics and EPEAT Analysis

## Project Overview

This project analyzes hazardous substances in electronic components, particularly in laptops and desktops, according to Directive 2002/95/EC. It also includes an analysis of EPEAT (Electronic Product Environmental Assessment Tool) scores for products from major manufacturers like HP, Dell, ASUS, and Lenovo.

## Key Findings

- Desktop computers tend to have more components containing hazardous substances compared to laptops.
- Laptops have a higher average EPEAT score compared to desktops.

## Data Sources

1. Hazardous substances data according to Directive 2002/95/EC
2. General component data for laptops and desktops
3. EPEAT scores and ratings for various electronic products

## Database Structure

The project uses several SQL tables:

1. `restricted_substances`: Contains information about hazardous substances.
2. `components`: Lists common components in laptops and desktops.
3. `component_substance_map`: Maps components to the hazardous substances they may contain.
4. 'BOM_RoHS': A View which joins the hazardous substance and electronic materials.
5. `HP_DELL_ASUS_LENOVO`: Contains EPEAT scores and other details for products from these manufacturers.

## Data Dictionary

### BOM_RoHS View

| Column Name | Description | Data Type |
|-------------|-------------|-----------|
| component_id | Unique identifier for the component | INT |
| component_name | Name of the component | VARCHAR(100) |
| in_desktop | Indicates if the component is used in desktops | BIT |
| in_laptop | Indicates if the component is used in laptops | BIT |
| substance_name | Name of the RoHS restricted substance | VARCHAR(100) |
| rohs_limit | EU RoHS limit for the substance | DECIMAL(5,4) |
| hazard_classification | Classification of the hazard | VARCHAR(100) |
| potential_alternatives | Potential alternatives for the substance | TEXT |

### HP_DELL_ASUS_LENOVO Table

| Column Name | Description | Data Type |
|-------------|-------------|-----------|
| id | Unique identifier for the product | INT |
| manufacturer | Name of the manufacturer | VARCHAR(50) |
| product_name | Name of the product | VARCHAR(100) |
| product_type | Type of product (e.g., laptop, desktop) | VARCHAR(50) |
| EPEAT_Score_out_of_49 | EPEAT score out of 49 points | INT |
| EPEAT_TIER | EPEAT tier (Bronze, Silver, Gold) | VARCHAR(10) |
| registered_on | Date of registration | DATE |

## SQL Queries

## Methodology

1. **Data Cleaning and Preprocessing:**
   - Removed unnecessary columns from the HP_DELL_ASUS_LENOVO table
   - Formatted date columns
   - Renamed and formatted the EPEAT score column
   - Changed data types for consistency

2. **RoHS Compliance Analysis:**
   - Identified components containing restricted substances
   - Analyzed the distribution of hazardous substances across components
   - Investigated potential alternatives for restricted substances

3. **EPEAT Performance Analysis:**
   - Analyzed product distribution across manufacturers
   - Compared EPEAT scores between product types and manufacturers
   - Investigated EPEAT tier distribution
   - Examined the impact of registration date on EPEAT scores

4. **Analysing the RoHS and electronic components**
   - Comparing the number of hazardous substances in laptops vs desktops
   - No of hazardous substance in various components
   - Analysing rohs limit for each component

## Tools Used

- SQL for data analysis and manipulation
- Excel for initial cleaning

## Conclusion

This project report outlines the comprehensive analysis of hazardous substances in electronic components and the EPEAT scores of products from major manufacturers using SQL. The findings provide valuable insights into the distribution of hazardous materials in laptops and desktops, the availability of safer alternatives, and the environmental performance of electronic products. These insights can guide manufacturers in improving product safety and compliance with regulations, as well as enhance their environmental sustainability efforts.

## Future Work

- Expand the analysis to include more manufacturers
- Investigate correlations between specific hazardous substances and EPEAT scores
- Develop visualizations using Power BI

