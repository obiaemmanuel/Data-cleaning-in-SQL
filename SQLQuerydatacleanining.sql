select * 
from PortfolioProject.dbo.NasvileHousing

--standardize the data format
select SaleDateConverted, CONVERT (Date, SaleDate)
from PortfolioProject.dbo.NasvileHousing

Update PortfolioProject.dbo.NasvileHousing
SET SaleDate = CONVERT (Date, SaleDate)

ALTER TABLE PortfolioProject.dbo.NasvileHousing
add SaleDateConverted Date;

Update PortfolioProject.dbo.NasvileHousing
SET SaleDateConverted = CONVERT (Date, SaleDate)

--populate property address data 

select *
from PortfolioProject.dbo.NasvileHousing
--where PropertyAddress is null
order by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NasvileHousing a
JOIN PortfolioProject.dbo.NasvileHousing b
ON a.parcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null 


Update a

SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)

from PortfolioProject.dbo.NasvileHousing a
JOIN PortfolioProject.dbo.NasvileHousing b
ON a.parcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null 

--Breaking out address into individual columns (address, city, state)

select PropertyAddress
from PortfolioProject.dbo.NasvileHousing
--where PropertyAddress is null
--order by ParcelID

select 
SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as address
, SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress)) as address

from PortfolioProject.dbo.NasvileHousing

ALTER TABLE PortfolioProject.dbo.NasvileHousing
add PropertySplitAddress Nvarchar(255);

Update PortfolioProject.dbo.NasvileHousing
SET PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE PortfolioProject.dbo.NasvileHousing
add PropertySplitCity Nvarchar(255);

Update PortfolioProject.dbo.NasvileHousing
SET PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress))

select * 
from PortfolioProject.dbo.NasvileHousing


select OwnerAddress
from PortfolioProject.dbo.NasvileHousing

select PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
from PortfolioProject.dbo.NasvileHousing


ALTER TABLE PortfolioProject.dbo.NasvileHousing
add OwnerSplitAddress Nvarchar(255);

Update PortfolioProject.dbo.NasvileHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE PortfolioProject.dbo.NasvileHousing
add OwnerSplitCity Nvarchar(255);

Update PortfolioProject.dbo.NasvileHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE PortfolioProject.dbo.NasvileHousing
add OwnerSplitState  Nvarchar(255);

Update PortfolioProject.dbo.NasvileHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)



select * 
from PortfolioProject.dbo.NasvileHousing


--change Y and N to Yes and No in the sold vacant field

select DISTINCT(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject.dbo.NasvileHousing
group by SoldAsVacant
order by 2




select SoldAsVacant
, CASE when SoldAsVacant = 'Y' THEN 'Yes'
       when SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
from PortfolioProject.dbo.NasvileHousing


--Remove Duplicates

WITH RowNumCTE AS(
select *,
ROW_NUMBER() OVER (
PARTITION BY ParcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 ORDER BY 
			     UniqueID) row_num 
				 
from PortfolioProject.dbo.NasvileHousing
)
select *
from RowNumCTE  
where row_num > 1
order by PropertyAddress





update PortfolioProject.dbo.NasvileHousing
Set SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'Yes'
       when SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END




--Delete Unused column

select * 
from PortfolioProject.dbo.NasvileHousing

ALTER TABLE PortfolioProject.dbo.NasvileHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress  