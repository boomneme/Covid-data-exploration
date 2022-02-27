select *
from portfo..housing

--standard date

select saledate, convert(date, saledate)
from portfo..housing

alter table portfo..housing
add properdate date

update portfo..housing
set properdate = convert(date, saledate)

select properdate, convert(date, saledate)
from portfo..housing

--fillup Addresses
select ISNULL(A.PropertyAddress, B.PropertyAddress)
from portfo..housing A
join portfo..housing B
	on A.parcelid = B.parcelid
	and A.uniqueid <> B.uniqueid
where A.propertyaddress is null

Update A
set propertyaddress = ISNULL(A.propertyaddress, B.propertyaddress)
from portfo..housing A
join portfo..housing B
	on A.parcelid = B.parcelid
	and A.uniqueid <> B.uniqueid
where A.propertyaddress is null

--breaking up address into city and state
Select PropertyAddress
from portfo..housing

SELECT 
SUBSTRING(PropertyAddress, 1, Charindex(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, Charindex(',', PropertyAddress) + 1, len(PropertyAddress)) as Address

from portfo..housing

alter table portfo..housing
add properaddress nvarchar(255)

update portfo..housing
set properaddress = SUBSTRING(PropertyAddress, 1, Charindex(',', PropertyAddress)-1) 

alter table portfo..housing
add propercity nvarchar(255)

update portfo..housing
set propercity = SUBSTRING(PropertyAddress, Charindex(',', PropertyAddress) + 1, len(PropertyAddress)) 

select *
from portfo..housing



select owneraddress
from portfo..housing

select
PARSENAME(replace(owneraddress, ',', '.'), 3) 
,PARSENAME(replace(owneraddress, ',', '.'), 2)
,PARSENAME(replace(owneraddress, ',', '.'), 1)
from portfo..housing

select *
from portfo..housing


alter table portfo..housing
add streetadd nvarchar(255);

update portfo..housing
set streetadd = PARSENAME(replace(owneraddress, ',', '.'), 3) 

alter table portfo..housing
add city nvarchar(255)

update portfo..housing
set city = PARSENAME(replace(owneraddress, ',', '.'), 2) 

alter table portfo..housing
add state nvarchar(255)

update portfo..housing
set state = PARSENAME(replace(owneraddress, ',', '.'), 1) 


--Change string to same length/type

select SoldAsVacant,
  Case when SoldAsVacant = 'SoldVacant' then 'Yes'
		  End	
from portfo..housing

Update portfo..housing
set SoldasVacant = Case when SoldAsVacant = 'SoldVacant' then 'Yes'
		  End

--Removing duplicates

With rowCTE AS(
select *,
	Row_number() Over (
	Partition by ParcelID,
	             PropertyAddress,
				 SalePrice,
				 LegalReference
				 Order by UniqueID
				   ) row_num
from portfo..housing
--order by ParcelID
)
Select * 
from rowCTE
where row_num>1


--Delete unused columns

select *
from portfo..housing

Alter table portfo..housing
Drop Column OwnerAddress, TaxDistrict


 
