
Declare @StForLastDate as varchar(8) = convert(varchar(4),getdate(),111)+substring(convert(varchar(7),getdate(),111),6,2)+'01'
Declare @DateForLastDate as Date = convert(datetime,@StForLastDate)
/*select @DateForLastDate
select @StForLastDate


select * from M3_MAIN_REP.dbo.ZZ_Loan_LastPayment
	where LastDate<@StForLastDate
*/
Declare @TableName as varchar(10) = convert(varchar(10),EOMONTH(dateadd(m,-1,getdate())),111)
Declare @TableNameS as varchar(8)
Set @TableNameS= SUBSTRING(@TableName,9,2)+SUBSTRING(@TableName,6,2)+SUBSTRING(@TableName,1,4)
--Select @TableNameS


Declare @QueryString as nvarchar(max)

Set @QueryString = 
'
set dateformat DMY

if OBJECT_ID(''tempdb..#SLoans'') is not null
drop table #SLoans

select * into #SLoans
from
(
	select 
	LoanNo
	,Client
	,SettleDate
	,Prod_Status
	,Prod_Type
	,Term
	,[OStd Balance]
	,[Cash Out]
	,Insurance
	,Brokerage
	,[DrawDown]
	,[Application Fee]
	,[Establish Fee]
	,[Fees Charged]
	,[DrawDownFee]
	,[Interest Charged]
	,[Total Received]
	,[Net Received]
	,Dishonoured
	,DishonCnt
	,ROW_NUMBER() over(partition by loanno order by [OStd Balance] desc, ClientNo desc) as ''RowNumber''
	FROM [dbo].lc_balance'+@TableNameS+' as LoanBook with(nolock)
	where Prod_Status in
	(
		''Active''
		,''Arrears''
		,''Collections - Bankrupt''
		,''Collections - DDR Attempt''
		,''Collections - Dead File''
		,''Collections - Do Not Action''
		,''Collections - Dormant''
		,''Collections - External''
		,''Collections - Judgement''
		,''Collections - Legal''
		,''Collections - Part IX''
		,''Collections - Part X''
		,''Collections - Payment Plan''
		,''Collections - Settled''
		,''Collections - Still to Action''
		,''Collections - Valid Phone''
		,''Collections - Veda Listing''
		,''Current''
		,''Default''
		,''Do Not Action''
		,''Hardship''
		,''Hold''
		,''Negotiated payout''
		,''Paid in Full''
		,''Paid in full early discount''
		,''Payment Plan''
		,''Special Arrangement''
		
	) and [Cash Out] is not null
union
	select 
	LoanNo
	,Client
	,SettleDate
	,Prod_Status
	,Prod_Type
	,Term
	,[OStd Balance]
	,[Cash Out]
	,Insurance
	,Brokerage
	,[DrawDown]
	,[Application Fee]
	,[Establish Fee]
	,[Fees Charged]
	,[DrawDownFee]
	,[Interest Charged]
	,[Total Received]
	,[Net Received]
	,Dishonoured
	,DishonCnt
	,ROW_NUMBER() over(partition by loanno order by [OStd Balance] desc, ClientNo desc) as ''RowNumber''
	FROM [dbo].micromotor_balance'+@TableNameS+' as LoanBook with(nolock)
	where Prod_Status in
	(
		''Active''
		
		,''Arrears''
	
		,''Collections - Bankrupt''
		,''Collections - DDR Attempt''
		,''Collections - Dead File''
		,''Collections - Do Not Action''
		,''Collections - Dormant''
		,''Collections - External''
		,''Collections - Judgement''
		,''Collections - Legal''
		,''Collections - Part IX''
		,''Collections - Part X''
		,''Collections - Payment Plan''
		,''Collections - Settled''
		,''Collections - Still to Action''
		,''Collections - Valid Phone''
		,''Collections - Veda Listing''
		,''Current''
		,''Default''
		,''Do Not Action''
		
		,''Hardship''
		,''Hold''
	
		,''Negotiated payout''
		,''Paid in Full''
		,''Paid in full early discount''
		,''Payment Plan''
	
		,''Special Arrangement''
		
	) and [Cash Out] is not null
)tmptb


truncate table [dbo].[zz_InterestReceivedOutput];
insert into [dbo].[zz_InterestReceivedOutput]
(
[LoanNo]
      ,[Client]
      ,[SettleDate]
      ,[Prod_Status]
	  ,[Prod Type]
      ,[Term]
      ,[Initial Freq]
      ,[Initial Repayment Amnt]
      ,[OStd Balance]
      ,[Total Cashout]
      ,[Cash Out]
      ,[Insurance]
      ,[Brokerage]
      ,[Establish Fee]
      ,[Draw Down]
      ,[Application Fee]
      ,[Fees Charged]
      ,[DrawDown Fee]
      ,[Interest Charged]
      ,[Total Received]
      ,[Total Net Received]
      ,[Dishonoured]
      ,[DishonCnt]
      ,[Last Success Payment Date]
      ,[Loss Date]
)
select 
	 Loanbook.LoanNo
	,Client
	,SettleDate
	,Prod_Status
	,Prod_Type
	,Term
	,IniRepayment.XFR_Detail as [Initial Freq]
	,IniRepayment.rpsd_Totalpaymentamount as [Initial Repayment Amnt]
	,[OStd Balance]
	,(isnull([Establish Fee],0)+isnull(Brokerage,0)+isnull(Insurance,0)+isnull([Cash Out],0)) as [Total Cashout]
	,[Cash Out]
	,Insurance
	,Brokerage
	,[Establish Fee]
	,[DrawDown]
	,[Application Fee]
	,[Fees Charged]
	,[DrawDownFee]
	,[Interest Charged]
	,[Total Received]
	,[Net Received]
	,Dishonoured
	,DishonCnt
	,LSPD.LastDate as [Last Success Payment Date]
	,[Loss Date]=
			(case
				when (prod_Status like ''%Collections%'') and (LSPD.LastDate is not null)
					then dateadd(month,1,LSPD.LastDate)
				when (prod_Status like ''%Collections%'') and (LSPD.LastDate is null)
					then dateadd(month,1,SettleDate)
				  
			end)	
	
	
FROM #SLoans as LoanBook with(nolock)
left join [M3_MAIN_REP].dbo.iO_Product_MasterReference as LoanMaster with(nolock) on LoanMaster.RMR_SeqNumber= LoanBook.LoanNo


left join
(
	select 
	
	 LoanPS.RPSD_IDLink_RMR
	,loanPS.rpsd_Totalpaymentamount
	,freq.XFR_Detail
	from
	[M3_MAIN_REP].dbo.io_product_paymentscheduledetail loanPS with(nolock)
	left join [M3_MAIN_REP].dbo.iO_Control_Frequency freq with(nolock) on loanPS.RPSD_IDLink_Frequency=freq.XFR_ID
	right join 
	(	
	select 
		RPSD_IDLink_RMR
		,min(RPSD_SeqNumber) as seq
	from [M3_MAIN_REP].dbo.io_product_paymentscheduledetail with(nolock)
	group by RPSD_IDLink_RMR
	) as t on t.seq=loanPS.RPSD_SeqNumber
) as IniRepayment on IniRepayment.rpsd_idlink_rmr=LoanMaster.RMR_ID

left join
(
	select * from M3_MAIN_REP.dbo.ZZ_Loan_LastPayment
	where LastDate<'''+ @StForLastDate+'''
) as LSPD on LSPD.LoanNo=LoanBook.LoanNo

where LoanBook.RowNumber=1

order by Loanbook.loanNo

'

--select @QueryString

exec (@QueryString)


