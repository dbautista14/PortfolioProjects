/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [PortfolioProject].[dbo].[NashvilleHousing]
  --

 --Cleaning data in sql queries

  select * 
  from PortfolioProject.dbo.NashvilleHousing

  -- Standardize Date Format

  select SaleDateConverted, convert(Date, SaleDate)
  from PortfolioProject.dbo.NashvilleHousing

  update NashvilleHousing
  set SaleDate = convert(Date, SaleDate)

  alter table NashvilleHousing
  Add SaleDateConverted Date;

   update NashvilleHousing
  set SaleDateConverted = convert(Date, SaleDate)

 

 -- Populate Property Address Data

 select PropertyAddress 
  from PortfolioProject.dbo.NashvilleHousing
where PropertyAddress is null

select * 
  from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID



select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-- using ISNULL to populate null addresses

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null
-- updating null Property Address

update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-- checking if no null on property addresses

select PropertyAddress 
from PortfolioProject.dbo.NashvilleHousing



-- breaking out address into individual columns (address, city, state) using substring and charindex


select PropertyAddress 
from PortfolioProject.dbo.NashvilleHousing

select 
substring (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, substring (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress)) as Address

from PortfolioProject.dbo.NashvilleHousing


alter table NashvilleHousing
Add PropertySplitAddress nvarchar(255)

update NashvilleHousing
set PropertySplitAddress = substring (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

alter table NashvilleHousing
Add PropertySplitCity nvarchar(255)

update NashvilleHousing
set PropertySplitCity = substring (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress))

-- seeing if new columns worked; makes data more usable and easier to use

select PropertySplitAddress, PropertySplitCity
from PortfolioProject.dbo.NashvilleHousing




-- cleaning up owner addresses using parsename

select OwnerAddress
from PortfolioProject.dbo.NashvilleHousing

select 
parsename (replace(OwnerAddress, ',', '.'), 3),
parsename (replace(OwnerAddress, ',', '.'), 2),
parsename (replace(OwnerAddress, ',', '.'), 1)
from PortfolioProject.dbo.NashvilleHousing



alter table NashvilleHousing
Add OwnerSplitAddress nvarchar(255)

update NashvilleHousing
set OwnerSplitAddress = parsename (replace(OwnerAddress, ',', '.'), 3)

alter table NashvilleHousing
Add OwnerSplitCity nvarchar(255)

update NashvilleHousing
set OwnerSplitCity = parsename (replace(OwnerAddress, ',', '.'), 2)

alter table NashvilleHousing
Add OwnerSplitState nvarchar(255)

update NashvilleHousing
set OwnerSplitState = parsename (replace(OwnerAddress, ',', '.'), 1)

-- seeing if new columns worked

select *
from PortfolioProject.dbo.NashvilleHousing






-- change Y and N to Yes and No in 'Sold as Vacant' field using CASE statement

select distinct(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant,
case
when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end
from PortfolioProject.dbo.NashvilleHousing


update NashvilleHousing
set SoldAsVacant = case
when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end




-- Remove Dupiclates


with RowNumCTE as(
select *, 
ROW_NUMBER() over (
PARTITION BY ParcelID, 
PropertyAddress, 
SalePrice, 
SaleDate, 
LegalReference
order  by UniqueID
) row_num
from PortfolioProject.dbo.NashvilleHousing
)


Select *
from RowNumCTE
where row_num > 1





-- Delete Unused Columns

select * 
from PortfolioProject.dbo.NashvilleHousing

alter table PortfolioProject.dbo.NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress

alter table PortfolioProject.dbo.NashvilleHousing
drop column SaleDate














