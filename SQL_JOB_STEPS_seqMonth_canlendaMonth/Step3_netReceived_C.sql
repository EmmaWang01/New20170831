
if OBJECT_ID('tempdb..#Loans') is not null
drop table #Loans

Select 
	[LoanNo]
	,[SettleDate]
into #Loans
From [zz_NetReceivedOutput]

---- get all dishonor & reversal transactions ids -----------
if OBJECT_ID('tempdb..#ReversalTransIDs') is not null
drop table #ReversalTransIDs

select distinct rtm_id  
into #ReversalTransIDs 
from m3_main_rep.dbo.io_product_transaction rtm with(nolock)
left join m3_main_rep.dbo.iO_Control_TransactionMaster xtrm with(nolock) on rtm.rtm_idlink_xtrm=xtrm.XTRM_ID
where rtm_idlink_xtrm in
 (
	'{1fa76f6c-3a20-415d-a8e5-3a71efeef433}', --//Loan\Schedule\Adjustment\Schedule Balance Adjustment (Principal Transfer CR)
	'{2b59edef-b7fa-4033-a477-033ae9da122d}', --//Money3\Discharge\Reversal\Discharge Payment - Reversal
	'{d96fdc0b-ea82-46c3-9982-0bc4f155935c}', --//Money3\Loan\Payment\Payment Reversal
	'{ef859b47-2820-4459-b033-4bd4d321251a}',--//Money3\Loan\Payment\Payment Reversal - Cash
	'{8ae7a940-e7de-47ba-a98e-6227241c4698}',--//Money3\LOC\Payment\Payment Reversal
	'{914d2104-748b-47fe-b580-3e9939c39d2a}' --//Money3\LOC\Payment\Payment Reversal - Cash
 )
OR xtrm_detail LIKE 'Money3\%\Payment\Repayment Dishonour%'
OR xtrm_detail = 'Loan\Reverse\Payment\Dishonor - Payment'


/*--- get all transactions need to be calculated-------------------------------------------------------
----- 2 union parts -----------------------------------------------------------------------------------
----- 1. all non-ghost payment transactions with no reversals happend----------------------------------
----- 2. all payment transactions which have reversal id but the reversal is not exist in database----*/

if object_id('tempdb..#AllTrans') is not null
drop table #AllTrans

select
	rtm_id
	,rtm_idlink_xtrm
	,rtm_Value
	,RTM_IDLink_Reversal
	,RTM_DateC
	,RTM_IDLink_RMR
into #AllTrans
from m3_main_rep.dbo.iO_Product_Transaction
where rtm_idlink_xtrm in
(
	'{0d09ef16-c8c6-4fd7-aa07-4d40ce7a3d60}',
	'{2f97e453-ddcd-49b7-958d-e85460e5c3cf}',
	'{369d0352-6702-44dc-86a5-aa1e63d43a28}',
	'{3b78e2bc-412d-4e78-927a-e255975efbfd}',
	'{468824e4-f92e-428c-8000-de9d68619d23}',
	'{5d21b3ef-7739-4427-85a6-70a1677786f1}',
	'{77d7215b-a0ad-495a-86f5-e791f035f335}',
	'{857a90f4-efa8-4c9f-abbf-19b7057a7b79}',
	'{88d368ae-d2e3-4db4-9880-3de434f3b542}',
	'{8b80a451-3d1a-4097-81ea-959dd2f0d8f6}',
	'{9251d213-46b3-4ffe-a59e-675bc7ed8258}',
	'{95df5a7c-ba97-45cd-a732-cf9eb4cf4fd0}',
	'{9a77a79c-c8f7-494f-8e9f-48e304dfd652}',
	'{9d57bb56-d2b6-4aef-9165-dcbdfa354997}',
	'{a8136ec2-6d41-4df2-97e2-a92baa39f139}',
	'{b426962b-3748-4bbf-9232-92ba164dc785}',
	'{c1b0f505-72bd-4f1d-ac11-f45d77e4bf7d}',
	'{d685de8f-4009-4968-9fe6-bd63de507376}',
	'{d90943f6-a537-4e04-adc0-7a880260a940}',
	'{da9c356c-51b7-46e7-b637-22f2c2897a44}',
	'{dc2c3e2a-1594-4058-b10f-73627855f28a}',
	'{e1365ab7-7216-4d36-9127-8a46e6d7cb02}',
	'{f03763e2-eb24-4ca9-bef2-e525ade90ce8}',
	'{be317f39-30b3-4469-a80f-b7443d107391}'  --all payment type
 )
and (RTM_IDLink_Reversal is null or RTM_IDLink_Reversal='')
and RTM_TypeGhost = 0
union
select 
	rtm_id
	,rtm_idlink_xtrm
	,rtm_Value
	,RTM_IDLink_Reversal
	,RTM_DateC
	,RTM_IDLink_RMR 
from m3_main_rep.dbo.iO_Product_Transaction with(nolock)
 where RTM_IDLink_Reversal is not null 
 and rtm_typeghost=0 
 and rtm_idlink_xtrm in
 (
	'{0d09ef16-c8c6-4fd7-aa07-4d40ce7a3d60}',
	'{2f97e453-ddcd-49b7-958d-e85460e5c3cf}',
	'{369d0352-6702-44dc-86a5-aa1e63d43a28}',
	'{3b78e2bc-412d-4e78-927a-e255975efbfd}',
	'{468824e4-f92e-428c-8000-de9d68619d23}',
	'{5d21b3ef-7739-4427-85a6-70a1677786f1}',
	'{77d7215b-a0ad-495a-86f5-e791f035f335}',
	'{857a90f4-efa8-4c9f-abbf-19b7057a7b79}',
	'{88d368ae-d2e3-4db4-9880-3de434f3b542}',
	'{8b80a451-3d1a-4097-81ea-959dd2f0d8f6}',
	'{9251d213-46b3-4ffe-a59e-675bc7ed8258}',
	'{95df5a7c-ba97-45cd-a732-cf9eb4cf4fd0}',
	'{9a77a79c-c8f7-494f-8e9f-48e304dfd652}',
	'{9d57bb56-d2b6-4aef-9165-dcbdfa354997}',
	'{a8136ec2-6d41-4df2-97e2-a92baa39f139}',
	'{b426962b-3748-4bbf-9232-92ba164dc785}',
	'{c1b0f505-72bd-4f1d-ac11-f45d77e4bf7d}',
	'{d685de8f-4009-4968-9fe6-bd63de507376}',
	'{d90943f6-a537-4e04-adc0-7a880260a940}',
	'{da9c356c-51b7-46e7-b637-22f2c2897a44}',
	'{dc2c3e2a-1594-4058-b10f-73627855f28a}',
	'{e1365ab7-7216-4d36-9127-8a46e6d7cb02}',
	'{f03763e2-eb24-4ca9-bef2-e525ade90ce8}',
	'{be317f39-30b3-4469-a80f-b7443d107391}'
 )
 and RTM_IDLink_Reversal is not null 
 and RTM_IDLink_Reversal!=''
 and RTM_IDLink_Reversal not in (select rtm_id from #ReversalTransIDs)



truncate table [dbo].[zz_NetReceived]

insert into [dbo].[zz_NetReceived](
		[LoanNo]
      ,[SettleYear]
      ,[SettleMonth]
      --,[CreditAmount]
      --,[DebitAmount]
      ,[ReceivedYear]
      ,[ReceivedMonth]
      ,[NetReceived]
      ,[Dishonoured]
	  ,ReceivedDate
)
select 
	distinct LoanNo
	,year(LoanBook.[SettleDate]) as [SettleYear]
	,month(LoanBook.SettleDate) as [SettleMonth]
	--,isnull(Credit.CreditAmount,0) as CreditAmount
	--,isnull(Credit.DebitAmount,0) as DebitAmount
	,Credit.ReceivedYear
	,Credit.ReceivedMonth
	--,(Credit.CreditAmount-Credit.DebitAmount-isnull(Dishon.Dishonour,0)) as NetReceived
	--,Credit.CreditAmount-Credit.DebitAmount as NetReceived
	,isnull(NetReceived,0) - isnull(Dishon.Dishonour,0) as NetReceived
	,[Dishonoured] = cast(isnull( -Dishon.Dishonour, 0) AS MONEY)
	,cast(cast(Credit.[ReceivedYear] as varchar(10)) + '-' + cast(Credit.[ReceivedMonth] as varchar(50)) + '-1' as date)
from
[dbo].[zz_NetReceivedOutput] as LoanBook with(nolock)
left join [M3_MAIN_REP].dbo.IO_Product_Masterreference as LoanMaster with(nolock)
on LoanBook.LoanNo=LoanMaster.RMR_SeqNumber
inner join
(SELECT 
			rtm_idlink_rmr AS 'LoanPK'
			,Year(RTM_DateC) as ReceivedYear
			,month(RTM_dateC) as ReceivedMonth
			/*,sum(
					IIF(
					rtm_idlink_xtrm ='{0d09ef16-c8c6-4fd7-aa07-4d40ce7a3d60}'--//Money3\Loan\Payment\Proceeds FROM 
					or rtm_idlink_xtrm ='{2f97e453-ddcd-49b7-958d-e85460e5c3cf}'--//Money3\Loan\Payment\Payment Cheque
					or rtm_idlink_xtrm ='{369d0352-6702-44dc-86a5-aa1e63d43a28}' --//Money3\LOC\Payment\Payment(Direct Debit) Capitalise NEXT effective dates
					or rtm_idlink_xtrm ='{3b78e2bc-412d-4e78-927a-e255975efbfd}' --//Money3\Loan\Payment\Payment(Direct Debit) Capitalise Do NOT USE
					or rtm_idlink_xtrm ='{468824e4-f92e-428c-8000-de9d68619d23}' --//Money3\LOC\Payment\Payment(Direct Debit) Capitalise Today
					or rtm_idlink_xtrm ='{5d21b3ef-7739-4427-85a6-70a1677786f1}' --//Money3\Loan\Payment\Payment(Direct Debit) Capitalise Effective DATE NEXT day
					or rtm_idlink_xtrm ='{77d7215b-a0ad-495a-86f5-e791f035f335}' --//Money3\Loan\Payment\Payment(Direct Debit) Capitalise Today
					or rtm_idlink_xtrm ='{857a90f4-efa8-4c9f-abbf-19b7057a7b79}' --//Money3\Discharge\Discharge Payment\BPay
					or rtm_idlink_xtrm ='{88d368ae-d2e3-4db4-9880-3de434f3b542}' --//Money3\Discharge\Discharge Payment\Cash
					or rtm_idlink_xtrm ='{8b80a451-3d1a-4097-81ea-959dd2f0d8f6}' --//Money3\Discharge\Discharge Payment\Cheque
					or rtm_idlink_xtrm ='{9251d213-46b3-4ffe-a59e-675bc7ed8258}' --//Money3\Discharge\Discharge Payment\Direct Debit
					or rtm_idlink_xtrm ='{95df5a7c-ba97-45cd-a732-cf9eb4cf4fd0}' --//Money3\Loan\Payment\Payment Cash
					or rtm_idlink_xtrm ='{9a77a79c-c8f7-494f-8e9f-48e304dfd652}' --//Money3\Loan\Payment\Payment Direct Credit Recieved
					or rtm_idlink_xtrm ='{9d57bb56-d2b6-4aef-9165-dcbdfa354997}' --//Money3\Loan\Payment\Insurance Payout
					or rtm_idlink_xtrm ='{a8136ec2-6d41-4df2-97e2-a92baa39f139}' --//Money3\Loan\Payment\Payment BPay
					or rtm_idlink_xtrm ='{b426962b-3748-4bbf-9232-92ba164dc785}' --//Money3\Loan\Payment\Payment(Direct Debit) Capitalise NEXT effective dates - Old
					or rtm_idlink_xtrm ='{c1b0f505-72bd-4f1d-ac11-f45d77e4bf7d}' --//Money3\LOC\Payment\Payment(Cash)
					or rtm_idlink_xtrm ='{d685de8f-4009-4968-9fe6-bd63de507376}' --//Money3\LOC\Payment\Payment(Salary)
					or rtm_idlink_xtrm ='{d90943f6-a537-4e04-adc0-7a880260a940}' --//Money3\Loan\Payment\Payment Salary
					or rtm_idlink_xtrm ='{da9c356c-51b7-46e7-b637-22f2c2897a44}' --//Money3\Loan\Payment\Payment(Direct Debit) Capitalise Today - Old
					or rtm_idlink_xtrm ='{dc2c3e2a-1594-4058-b10f-73627855f28a}' --//Money3\Discharge\Discharge Payment\Direct Credit
					or rtm_idlink_xtrm ='{e1365ab7-7216-4d36-9127-8a46e6d7cb02}' --//Money3\Loan\Payment\Payment DebitCard
					or rtm_idlink_xtrm ='{f03763e2-eb24-4ca9-bef2-e525ade90ce8}' --//Money3\LOC\Payment\Payment(Cheque)
					or rtm_idlink_xtrm ='{be317f39-30b3-4469-a80f-b7443d107391}' --//Money3\Loan\Payment\Insurance Recall
					,ISNULL(rtm_value, 0),0)
				) AS 'CreditAmount'
			,sum(
					IIF(
					rtm_idlink_xtrm ='{1fa76f6c-3a20-415d-a8e5-3a71efeef433}' --//Loan\Schedule\Adjustment\Schedule Balance Adjustment (Principal Transfer CR)
					or rtm_idlink_xtrm ='{2b59edef-b7fa-4033-a477-033ae9da122d}' --//Money3\Discharge\Reversal\Discharge Payment - Reversal
					or rtm_idlink_xtrm ='{d96fdc0b-ea82-46c3-9982-0bc4f155935c}' --//Money3\Loan\Payment\Payment Reversal
					or rtm_idlink_xtrm ='{ef859b47-2820-4459-b033-4bd4d321251a}' --//Money3\Loan\Payment\Payment Reversal - Cash
					or rtm_idlink_xtrm ='{8ae7a940-e7de-47ba-a98e-6227241c4698}' --//Money3\LOC\Payment\Payment Reversal
					or rtm_idlink_xtrm ='{914d2104-748b-47fe-b580-3e9939c39d2a}' --//Money3\LOC\Payment\Payment Reversal - Cash
					,ISNULL(rtm_value, 0),0)
				) AS 'DebitAmount'*/
				,sum(isnull(rtm_value,0)) as 'NetReceived'
	
		From #AllTrans
		--FROM [M3_MAIN_REP].dbo.io_product_transaction with(nolock)
		--WHERE RTM_TypeGhost = 0 and (RTM_IDLink_Reversal is null or RTM_IDLink_Reversal='' or RTM_IDLink_Reversal not in (select rtm_id from #TransIDs)) 
		GROUP BY rtm_idlink_rmr,Year(RTM_DateC),month(RTM_DateC)
		) Credit ON Credit.LoanPK = LoanMaster.RMR_ID

	LEFT JOIN (
	SELECT 
		rtm_idlink_rmr
		,year(RTM_DateC) as year3
		,month(RTM_DateC) as month3
		,Isnull(sum(Isnull(rtm_valuedb, 0)), 0) - Isnull(sum(Isnull(rtm_valuecr, 0)), 0) AS [Dishonour]
	FROM [M3_MAIN_REP].dbo.io_product_transaction WITH (NOLOCK)
	INNER JOIN [M3_MAIN_REP].dbo.io_control_transactionmaster WITH (NOLOCK) ON rtm_idlink_xtrm = xtrm_id
	INNER JOIN [M3_MAIN_REP].dbo.iO_Control_TransactionGL WITH (NOLOCK) ON XTRMgl_IDLink_XTRM = rtm_idlink_xtrm
	WHERE 
			(xtrm_detail LIKE 'Money3\%\Payment\Repayment Dishonour%'
			OR xtrm_detail = 'Loan\Reverse\Payment\Dishonor - Payment')
			and
			(RTM_IDLink_Reversal is null or RTM_IDLink_Reversal='')
			
	GROUP BY rtm_idlink_rmr, year(rtm_DateC), month(RTM_DateC)
	) AS Dishon ON Dishon.rtm_idlink_rmr = LoanMaster.rmr_id
	and Dishon.year3 = Credit.ReceivedYear and Dishon.month3=Credit.ReceivedMonth
