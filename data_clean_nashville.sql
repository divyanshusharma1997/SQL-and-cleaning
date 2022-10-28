--day 1

select cast(SaleDate as date) as date_only
from PortfolioProject1..Nashvillehousing

--this is add column syntex will add all the future required columns here

alter table PortfolioProject1..Nashvillehousing
--drop column house_number;
add date_only Date,

--add house_number nvarchar(20),
--drop column street;

street nvarchar(50),
city varchar(20)

update PortfolioProject1..Nashvillehousing
set date_only= cast(SaleDate as date)

select *
from PortfolioProject1..Nashvillehousing

--find nulls in propertyadress
select UniqueID, PropertyAddress
from PortfolioProject1..Nashvillehousing	
where PropertyAddress is null

--updating null address value with same parcel id data table updating table b considering nashville as a and same as b to update values


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(b.PropertyAddress, a.PropertyAddress)
from PortfolioProject1..Nashvillehousing a
join PortfolioProject1..Nashvillehousing b
on a.ParcelID= b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where b.PropertyAddress is null

update b
set PropertyAddress =ISNULL(b.PropertyAddress, a.PropertyAddress)
from PortfolioProject1..Nashvillehousing a
join PortfolioProject1..Nashvillehousing b
on a.ParcelID= b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where b.PropertyAddress is null

select *
from PortfolioProject1..Nashvillehousing

--now splitting address to home, street, city with help of substring function

select 
SUBSTRING(PropertyAddress, 1,4) as house_number,
SUBSTRING(PropertyAddress, 5,  CHARINDEX(',', PropertyAddress) -1 ) as Street,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress)) as city


from PortfolioProject1..Nashvillehousing

update PortfolioProject1..Nashvillehousing
set house_number =  cast(SUBSTRING(PropertyAddress, 1,4)as nvarchar),
street = cast(SUBSTRING(PropertyAddress, 5,  CHARINDEX(',', PropertyAddress) -1 ) as nvarchar),
city= cast(SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress)) as nvarchar)

-- removed extra spaces in street column

update PortfolioProject1..Nashvillehousing
set street= trim(street)
--now we will split owner address in address, city ,state with the help of parsename function as this function splits with respect to .

--so first we have to change , to .
Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3) 
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject1..Nashvillehousing
where PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1) is not null

alter table PortfolioProject1..Nashvillehousing
add owner_splitaddress nvarchar(50),
owner_splitcity nvarchar(50),
owner_splitstate nvarchar(50)

update PortfolioProject1..Nashvillehousing
set owner_splitaddress =  PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3),
owner_splitcity= PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2),
owner_splitstate =PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
-- now we should change soldas vacant column either yes or no

select soldasvacant 
from PortfolioProject1..Nashvillehousing
where soldasvacant = 'N'

update PortfolioProject1..Nashvillehousing
set SoldAsVacant= 'No'
where SoldAsVacant in (select soldasvacant 
from PortfolioProject1..Nashvillehousing
where soldasvacant = 'Noi')

update PortfolioProject1..Nashvillehousing
set SoldAsVacant= 'Yes'
where SoldAsVacant in (select soldasvacant 
from PortfolioProject1..Nashvillehousing
where soldasvacant = 'Y')\
--also we can use case method to ammend 
--another way to update

/*Select SoldAsVacant
, CASE When SoldAsVacant = 'Yes' THEN 'YES'
	   When SoldAsVacant = 'No' THEN 'NO'
	   ELSE SoldAsVacant
	   END
From PortfolioProject1..NashvilleHousing
*/
select soldasvacant,count(soldasvacant)
from PortfolioProject1..Nashvillehousing
group by SoldAsVacant

--day 2
--now we are going to remove duplicates with with cte statement 
select *
from Nashvillehousing
 
with newtabCTE as(
select *, ROW_NUMBER() over (partition by parcelid,
				date_only,
				saleprice,
				legalreference order by uniqueid) as rownum
from PortfolioProject1..Nashvillehousing

)

select *
from newtabCTE
where rownum >1


select *
from Nashvillehousing
--we have deleted all the duplicate rows in the table now we will drop unwanted columns

alter table portfolioproject1..nashvillehousing
drop column Propertyaddress, saledate, owneraddress

select * 
from Nashvillehousing
order by ParcelID

