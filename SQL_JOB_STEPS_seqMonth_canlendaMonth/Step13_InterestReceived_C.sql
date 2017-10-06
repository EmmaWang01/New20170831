if OBJECT_ID('tempdb..#Loans') is not null
drop table #Loans

Select 
	[LoanNo]
	,[SettleDate]
into #Loans
From zz_InterestReceivedOutput

truncate table [dbo].[zz_InterestReceived]

insert into [dbo].[zz_InterestReceived](
[LoanNo]
      ,[SettleYear]
      ,[SettleMonth]  
      ,[ReceivedYear]
      ,[ReceivedMonth]
      ,[NetInterestsReceived]
	  ,ReceivedDate
)
select 
	distinct LoanNo
	,year(LoanBook.[SettleDate]) as [SettleYear]
	,month(LoanBook.SettleDate) as [SettleMonth]
	,Credit.ReceivedYear
	,Credit.ReceivedMonth
	,[Interest Paid] as [NetInterestsReceived]
	,cast(cast(Credit.[ReceivedYear] as varchar(10)) + '-' + cast(Credit.[ReceivedMonth] as varchar(50)) + '-1' as date)
from #Loans as LoanBook
left join [M3_MAIN_REP].dbo.IO_Product_Masterreference as LoanMaster with(nolock)
on LoanBook.LoanNo=LoanMaster.RMR_SeqNumber
inner join
(SELECT 
			rtm_idlink_rmr AS 'LoanPK'
			,Year(RTM_DateC) as ReceivedYear
			,month(RTM_DateC) as ReceivedMonth
			,Isnull(Sum(Isnull(rtm_valuedb, 0)), 0) - Isnull(Sum(Isnull(rtm_valuecr, 0)), 0) [Interest Paid]
	
		FROM [M3_MAIN_REP].dbo.io_product_transaction with(nolock)
		WHERE RTM_TypeGhost = 0
		and rtm_idlink_xtrm in
			(
				'{060c5979-653a-4cfd-89ce-d56e4e202aa8}'
				,'{0ca10d4f-b3ad-4841-96ca-73db5a8fe6c8}'
				,'{3a1c25bc-f512-42b0-83e5-44a309c3447b}'
				,'{5f4bc663-fa5b-4281-8b1f-4b34a82c2a8c}'
				,'{94f92410-c38f-457b-8f8d-c028b474787f}'
				,'{bdedc8c4-996c-4ea7-8cc0-0549cd21bb8f}'
				,'{fb20e33c-ee26-42f9-9609-5935d705cd2f}' -- interest transaction types
			)
		GROUP BY rtm_idlink_rmr,Year(RTM_DateC),month(RTM_DateC)
		) Credit ON Credit.LoanPK = LoanMaster.RMR_ID


