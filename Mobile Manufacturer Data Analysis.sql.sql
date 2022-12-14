--SQL Advance Case Study


--Q1--BEGIN 
	
select  State,year(date)[Year] from FACT_TRANSACTIONS ft inner join DIM_LOCATION dl on ft.IDLocation = dl.IDLocation
inner join DIM_MODEL dm on ft.IDModel = dm.IDModel
where year(Date) between '2005' and GETDATE()




--Q1--END

--Q2--BEGIN
	
select top 1 State from DIM_LOCATION dm inner join FACT_TRANSACTIONS ft on dm.IDLocation = ft.IDLocation 
inner join DIM_MODEL dm2 on ft.IDModel = dm2.IDModel
inner join DIM_MANUFACTURER dma on dma.IDManufacturer = dm2.IDManufacturer
where Manufacturer_Name ='Samsung'
group by State
order by sum(Quantity) desc








--Q2--END

--Q3--BEGIN      
	
select Model_Name,ZipCode, State, count(IDCUSTOMER) [Number of Transaction] from DIM_LOCATION dl
inner join FACT_TRANSACTIONS ft on dl.IDLocation = ft.IDLocation 
inner join  DIM_MODEL dm on ft.IDModel = dm.IDModel
group by Model_Name , ZipCode,State









--Q3--END

--Q4--BEGIN  

select top 1  IDModel, TotalPrice   from FACT_TRANSACTIONS
order by TotalPrice





--Q4--END

--Q5--BEGIN

select Model_Name,avg(Unit_price)[AveragePrice] from DIM_MODEL dm inner join DIM_MANUFACTURER dma on dma.IDManufacturer = dm.IDManufacturer
where Manufacturer_Name in 

( select top 5 Manufacturer_Name from FACT_TRANSACTIONS ft inner join DIM_MODEL dm on ft.IDModel = dm.IDModel 
inner join DIM_MANUFACTURER dma1 on dma1.IDManufacturer = dm.IDManufacturer
group by Manufacturer_Name
order by sum(Quantity) )

group by Model_Name 
order by avg(Unit_price) desc





--Q5--END

--Q6--BEGIN

select Customer_Name,avg(totalprice) AverageSpent from DIM_CUSTOMER dm
inner join FACT_TRANSACTIONS ft on dm.IDCustomer = ft.IDCustomer
where year(Date) =2009
group by Customer_Name
having avg(TotalPrice)>500









--Q6--END
	
--Q7--BEGIN  
	
select IDModel from 
(select idmodel,ROW_NUMBER() over(partition by year([date])
order by quantity desc) m
from
FACT_TRANSACTIONS
where year([date]) in (2008,2009,2010))l
where m<=5
group by IDModel
having count(*)=3













--Q7--END	
--Q8--BEGIN
select top 1 * from (select top 2  Manufacturer_Name ,sum(totalprice) [Sales in Year 2009] from FACT_TRANSACTIONS ft
left join DIM_MODEL dm on ft.IDModel =dm.IDModel
left join DIM_MANUFACTURER dma on dm.IDManufacturer = dma.IDManufacturer
where DATEPART(year,date)='2009'
group by Manufacturer_Name, Quantity
order by sum(TotalPrice)desc) as A,
(select top 2  Manufacturer_Name ,sum(totalprice) [Sales in Year 2010]from FACT_TRANSACTIONS ft
left join DIM_MODEL dm on ft.IDModel =dm.IDModel
left join DIM_MANUFACTURER dma on dm.IDManufacturer = dma.IDManufacturer
where DATEPART(year,date)='2010'
group by Manufacturer_Name, Quantity
order by sum(TotalPrice)desc) as B

















--Q8--END
--Q9--BEGIN
	
select Manufacturer_Name ,year(date)[Year] from DIM_MANUFACTURER dma

inner join DIM_MODEL dm on dma.IDManufacturer =dm.IDManufacturer
inner join  FACT_TRANSACTIONS ft on dm.IDModel = ft.IDModel
where year (date) =2010

except

select Manufacturer_Name,year(date)[Year]from DIM_MANUFACTURER dma
inner join DIM_MODEL dm on dma.IDManufacturer =dm.IDManufacturer
inner join  FACT_TRANSACTIONS ft on dm.IDModel = ft.IDModel
where year (date) =2009
















--Q9--END

--Q10--BEGIN

select top 100 t1.customer_name,T1.Year,t1.Average_Price,t1.Average_Quantity,
case when t2.year is not null
then  format(convert (decimal(8,2), (t1.Average_Price-t2.Average_Price)) / convert(decimal (8,2), t2.Average_Price),'p') else null
end as 'Yearly % Change' from

(select t2.customer_name, year (t1.date) as Year , avg(t1.totalprice) as Average_Price ,avg(t1.quantity) as Average_Quantity from FACT_TRANSACTIONS as t1
left join  DIM_CUSTOMER as t2  on  t1.IDCustomer = t2.IDCustomer
where  t1.IDCustomer in (select top 10 idcustomer from FACT_TRANSACTIONS group by IDCustomer order by sum (totalprice) desc)
group by t2.Customer_Name , year(t1.date)
)
t1 left join
(select t2.customer_name , year(t1.date) as Year , avg(t1.totalprice)  as Average_Price ,avg(t1.quantity) as Average_Quantity from FACT_TRANSACTIONS as t1
left join  DIM_CUSTOMER as t2 on t1.IDCustomer = t2.IDCustomer
where t1.IDCustomer in(select top 10  idcustomer from  FACT_TRANSACTIONS group by IDCustomer order by sum(totalprice) desc)
group by  t2.Customer_Name, year(t1.date))

t2 on t1.Customer_Name = t2.Customer_Name and t2.year = t1.year-1

















--Q10--END
	