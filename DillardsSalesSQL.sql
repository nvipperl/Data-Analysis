/*Customer behavior */
select count(transact.TRANSACTION_ID) as items,transact.cust_id, TRAN_DATE,store.STORE,TRAN_TYPE, DEPT_DESC, DEPTDEC_DESC, DEPTCENT_DESC,COLOR, sum(ORIG_PRICE) as orig_price , sum(TRAN_AMT) as sale_price , sum(TRAN_AMT)-sum(ORIG_PRICE) as discount,TENDER_TYPE
from TRANSACT inner join sku on transact.sku = sku.SKU
inner join DEPARTMENT on sku.dept =department.dept
inner join CUSTOMER on customer.CUST_ID = transact.CUST_ID
inner join store on store.store = transact.store
where store.state = 'TX' and ORIG_PRICE>0
group by transact.cust_id,TRAN_DATE,store.STORE,TRAN_TYPE, DEPT_DESC, DEPTDEC_DESC, DEPTCENT_DESC,COLOR,TENDER_TYPE
having count(transact.TRANSACTION_ID)>4
order by count(transact.TRANSACTION_ID) desc

/* Sales analysis on Dillards stores */
select st.store,st.city,t.tran_date,sum(t.tran_amt)
from store st inner join transact t
on st.store=t.store
where st.state='TX' and year(t.tran_date) in (2014,2015)
group by st.store,st.city,t.tran_date

select *
from customer c inner join store st
on c.preferred_store=st.store
where c.zip_code in ('77060','77082')

select st.store,count(1) as "Total Items Sold",count(distinct cust_id) as "Total Customers",
count(distinct s.sku) as 'Distinct Items',count(distinct d.dept_desc) as 'Total Brands',
count(distinct d.deptdec_desc) as 'Total Sub-categories', count(distinct d.deptcent_desc) as 'Total Categories'
from store st inner join transact t
on st.store=t.store
inner join sku s 
on t.sku=s.sku
inner join department d
on s.dept=d.dept
inner join sku_store ss 
on s.sku=ss.sku
where st.city='Houston' and year(t.tran_date) in (2014,2015)
group by st.store
order by st.store

/* Analysis on Dillard's profits */

/*Most successful department category in Texas? ( gross margin)*/

select sum(t.sale_price) as "Total Revenue",SUM(ss.retail) as "Total Cost of Units sold",d.DEPTCENT_DESC from transact t 
inner join sku_store ss on t.sku=ss.sku 
inner join sku s on s.sku=t.sku
inner join DEPARTMENT d on d.dept=s.dept
inner join store st on ss.store=st.store
where st.state='TX' and t.ORIG_PRICE>0
group by d.DEPTCENT_DESC


select sum(t.sale_price) as "Total Revenue",SUM(ss.retail) as "Total Cost of Units sold",d.DEPTCENT_DESC from transact t 
inner join sku_store ss on t.sku=ss.sku 
inner join sku s on s.sku=t.sku
inner join DEPARTMENT d on d.dept=s.dept
inner join store st on ss.store=st.store
where st.state='TX' and t.ORIG_PRICE>0 AND YEAR(convert(date,t.TRAN_DATE))=2014
group by d.DEPTCENT_DESC


select sum(t.sale_price) as "Total Revenue",SUM(ss.retail) as "Total Cost of Units sold",d.DEPTCENT_DESC from transact t 
inner join sku_store ss on t.sku=ss.sku 
inner join sku s on s.sku=t.sku
inner join DEPARTMENT d on d.dept=s.dept
inner join store st on ss.store=st.store
where st.state='TX' and t.ORIG_PRICE>0 AND YEAR(convert(date,t.TRAN_DATE))=2015
group by d.DEPTCENT_DESC


/*Most/Least successful brand*/
select sum(t.sale_price) as "Total Revenue",SUM(ss.retail) as "Total Cost of Units sold",
d.DEPT_DESC from transact t 
inner join sku_store ss on t.sku=ss.sku 
inner join sku s on s.sku=t.sku
inner join DEPARTMENT d on d.dept=s.dept
inner join store st on ss.store=st.store
where st.state='TX' and t.ORIG_PRICE>0
group by d.DEPT_DESC

/*Performance of least successful brands over years (in 2014 and 2015)*/

select sum(t.sale_price) as "Total Revenue",SUM(ss.retail) as "Total Cost of Units sold",d.DEPT_DESC,d.DEPTCENT_DESC from transact t 
inner join sku_store ss on t.sku=ss.sku 
inner join sku s on s.sku=t.sku
inner join DEPARTMENT d on d.dept=s.dept
inner join store st on ss.store=st.store
where st.state='TX' and t.ORIG_PRICE>0 AND YEAR(convert(date,t.TRAN_DATE))=2014
group by d.DEPT_DESC,d.DEPTCENT_DESC

select sum(t.sale_price) as "Total Revenue",SUM(ss.retail) as "Total Cost of Units sold",d.DEPT_DESC,d.DEPTCENT_DESC from transact t 
inner join sku_store ss on t.sku=ss.sku 
inner join sku s on s.sku=t.sku
inner join DEPARTMENT d on d.dept=s.dept
inner join store st on ss.store=st.store
where st.state='TX' and t.ORIG_PRICE>0 AND YEAR(convert(date,t.TRAN_DATE))=2015
group by d.DEPT_DESC,d.DEPTCENT_DESC

/*No of SKUs released per brand over the years:*/

select sum(t.sale_price) as "Total Revenue",SUM(ss.retail) as "Total Cost of Units sold",d.DEPT_DESC,d.DEPTCENT_DESC,count(s.sku) from transact t 
inner join sku_store ss on t.sku=ss.sku 
inner join sku s on s.sku=t.sku
inner join DEPARTMENT d on d.dept=s.dept
inner join store st on ss.store=st.store
where st.state='TX' and t.ORIG_PRICE>0 AND YEAR(convert(date,t.TRAN_DATE))=2014
and d.dept_desc in ('GIFTCARD','COSMETIC WORKROOM','MICHAEL KORS WOM FRA','D&G WOMENS FRAGRANCE','GIFTWRAP SUPPLY','D&G MENS FRAGRANCE','DONNA KARAN')
group by d.DEPT_DESC,d.DEPTCENT_DESC

select sum(t.sale_price) as "Total Revenue",SUM(ss.retail) as "Total Cost of Units sold",d.DEPT_DESC,d.DEPTCENT_DESC,count(s.sku) from transact t 
inner join sku_store ss on t.sku=ss.sku 
inner join sku s on s.sku=t.sku
inner join DEPARTMENT d on d.dept=s.dept
inner join store st on ss.store=st.store
where st.state='TX' and t.ORIG_PRICE>0 AND YEAR(convert(date,t.TRAN_DATE))=2015
and d.dept_desc in ('GIFTCARD','COSMETIC WORKROOM','MICHAEL KORS WOM FRA','D&G WOMENS FRAGRANCE','GIFTWRAP SUPPLY','D&G MENS FRAGRANCE','DONNA KARAN')
group by d.DEPT_DESC,d.DEPTCENT_DESC

/* Analysis on Dillard's Departments*/
select count(TRANSACTION_ID) as items_sold,count(cust_ID) as count_customers, Tran_date, TRAN_TYPE, sum(ORIG_PRICE) as orig_MRP,
sum(tran_amt) as sale_price, sum(orig_price)-sum(tRan_amt) as Discount, city , ZIP_CODE , d.DEPT,
DEPT_DESC, DEPTCENT_DESC, DEPTDEC_DESC, CLASSIFICATION
from TRANSACT t inner join STORE s on s.store = t.store
inner join SKU k on k.SKU =t.SKU
inner join DEPARTMENT d on d.DEPT = k.DEPT
where STATE = 'TX' and orig_price>0 and year(TRAN_DATE) in (2014,2015)
group by d.DEPT,DEPT_DESC, DEPTCENT_DESC, DEPTDEC_DESC, CLASSIFICATION , Tran_date, TRAN_TYPE,city , ZIP_CODE
having count(TRANSACTION_ID)>9
order by count(TRANSACTION_ID) desc
