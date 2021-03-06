
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

if object_id('tempdb..#Trans') is not null
drop table #Trans

select
	rtm_id
	,rtm_idlink_xtrm
	,RTM_Value
	,RTM_IDLink_Reversal
	,RTM_DateC
	,RTM_IDLink_RMR
into #Trans
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
	'{be317f39-30b3-4469-a80f-b7443d107391}' --all payment type
 )
 and RTM_IDLink_Reversal is not null 
 and RTM_IDLink_Reversal!=''
 and RTM_IDLink_Reversal not in (select rtm_id from #ReversalTransIDs)
 union
select 
	rtm_id
	,rtm_idlink_xtrm
	,isnull(isnull(rtm_ValueCR,0)-isnull(RTM_ValueDB,0),0) as [RTM_Value]
	,RTM_IDLink_Reversal
	,RTM_DateC
	,RTM_IDLink_RMR 
from m3_main_rep.dbo.iO_Product_Transaction with(nolock)
where rtm_idlink_xtrm in
	(
		'{244d60d7-2cef-4e24-8a7d-02c9cab998d1}', --	Money3\Loan\Payment\Repayment Dishonour Manual
		'{cde651a4-8f90-4baf-adc5-83e8499eaa3c}' ,--	Money3\Loan\Payment\Repayment Dishonour Manual
		'{e832ac26-3c19-41aa-871c-a08f9b698d69}',--	Money3\Loan\Payment\Repayment Dishonour NEW
		'{1d80d541-cd59-4e75-90d5-6c48e9c326ca}', --	Money3\Loan\Payment\Repayment Dishonour - Cheque
		'{1711bd64-942a-456a-b723-e65d3c877a89}',--	Money3\Loan\Payment\Repayment Dishonour OLD
		'{bfad6a88-cb2f-49ca-9b88-c1f962b81111}', --	Money3\LOC\Payment\Repayment Dishonour Manual Cheque
		'{f63e5521-cbef-414c-89ed-d6aa29644687}', --	Money3\LOC\Payment\Repayment Dishonour
		'{0e71d163-0bf4-4185-8b48-9e7db7b471fe}', --	Money3\Loan\Payment\Repayment Dishonour - New - Reversal
		'{64a336b6-6562-4abe-809d-ddb951f4c24a}',--	Money3\Loan\Payment\Repayment Dishonour - Old - Reversal
		'{09cd3218-dd59-44ae-8fd3-c8f45bc501d5}' --Loan\Reverse\Payment\Dishonor - Payment
	)
and (RTM_IDLink_Reversal is null or RTM_IDLink_Reversal='')
and RTM_TypeGhost = 0

--select  * from #Trans where rtm_idlink_rmr=(select rmr_id from io_product_masterreference where RMR_SeqNumber=110824)

if object_id('tempdb..#AllTrans') is not null
drop table #AllTrans

SELECT 
	RMR_SeqNumber AS 'LoanID'
	,RMR_ID
	--,Year(RTM_DateC) as ReceivedYear
	--,month(RTM_DateC) as ReceivedMonth
	,rcd.RCD_CurrentStart as 'SettledDate'
	,RTM_DateC as 'ReceivedDate'
	,sum(isnull(rtm_Value,0)) as netAmount
	/*,(sum(
			-- 'CreditAmount'
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
			,ISNULL(rtm_value, 0),0)
		)- 
	sum(
			-- 'DebitAmount'
			IIF(
			rtm_idlink_xtrm ='{1fa76f6c-3a20-415d-a8e5-3a71efeef433}' --//Loan\Schedule\Adjustment\Schedule Balance Adjustment (Principal Transfer CR)
			or rtm_idlink_xtrm ='{2b59edef-b7fa-4033-a477-033ae9da122d}' --//Money3\Discharge\Reversal\Discharge Payment - Reversal
			or rtm_idlink_xtrm ='{d96fdc0b-ea82-46c3-9982-0bc4f155935c}' --//Money3\Loan\Payment\Payment Reversal
			or rtm_idlink_xtrm ='{ef859b47-2820-4459-b033-4bd4d321251a}' --//Money3\Loan\Payment\Payment Reversal - Cash
			or rtm_idlink_xtrm ='{8ae7a940-e7de-47ba-a98e-6227241c4698}' --//Money3\LOC\Payment\Payment Reversal
			or rtm_idlink_xtrm ='{914d2104-748b-47fe-b580-3e9939c39d2a}' --//Money3\LOC\Payment\Payment Reversal - Cash
			,ISNULL(rtm_value, 0),0)
		)
		- 
	sum(
			--AS 'DishonourAmount'
			IIF(
			rtm_idlink_xtrm ='{244d60d7-2cef-4e24-8a7d-02c9cab998d1}' --	Money3\Loan\Payment\Repayment Dishonour Manual
			or rtm_idlink_xtrm ='{cde651a4-8f90-4baf-adc5-83e8499eaa3c}' --	Money3\Loan\Payment\Repayment Dishonour Manual
			or rtm_idlink_xtrm ='{e832ac26-3c19-41aa-871c-a08f9b698d69}'--	Money3\Loan\Payment\Repayment Dishonour NEW
			or rtm_idlink_xtrm ='{1d80d541-cd59-4e75-90d5-6c48e9c326ca}' --	Money3\Loan\Payment\Repayment Dishonour - Cheque
			or rtm_idlink_xtrm ='{1711bd64-942a-456a-b723-e65d3c877a89}'--	Money3\Loan\Payment\Repayment Dishonour OLD
			or rtm_idlink_xtrm ='{bfad6a88-cb2f-49ca-9b88-c1f962b81111}' --	Money3\LOC\Payment\Repayment Dishonour Manual Cheque
			or rtm_idlink_xtrm= '{f63e5521-cbef-414c-89ed-d6aa29644687}' --	Money3\LOC\Payment\Repayment Dishonour
			or rtm_idlink_xtrm = '{0e71d163-0bf4-4185-8b48-9e7db7b471fe}' --	Money3\Loan\Payment\Repayment Dishonour - New - Reversal
			or rtm_idlink_xtrm = '{64a336b6-6562-4abe-809d-ddb951f4c24a}'--	Money3\Loan\Payment\Repayment Dishonour - Old - Reversal
			or rtm_idlink_xtrm = '{09cd3218-dd59-44ae-8fd3-c8f45bc501d5}' --Loan\Reverse\Payment\Dishonor - Payment
			,Isnull(rtm_valuedb, 0),0)
		)
		+ 
	sum(
			--AS 'DishonourAmount'
			IIF(
			rtm_idlink_xtrm ='{244d60d7-2cef-4e24-8a7d-02c9cab998d1}' --	Money3\Loan\Payment\Repayment Dishonour Manual
			or rtm_idlink_xtrm ='{cde651a4-8f90-4baf-adc5-83e8499eaa3c}' --	Money3\Loan\Payment\Repayment Dishonour Manual
			or rtm_idlink_xtrm ='{e832ac26-3c19-41aa-871c-a08f9b698d69}'--	Money3\Loan\Payment\Repayment Dishonour NEW
			or rtm_idlink_xtrm ='{1d80d541-cd59-4e75-90d5-6c48e9c326ca}' --	Money3\Loan\Payment\Repayment Dishonour - Cheque
			or rtm_idlink_xtrm ='{1711bd64-942a-456a-b723-e65d3c877a89}'--	Money3\Loan\Payment\Repayment Dishonour OLD
			or rtm_idlink_xtrm ='{bfad6a88-cb2f-49ca-9b88-c1f962b81111}' --	Money3\LOC\Payment\Repayment Dishonour Manual Cheque
			or rtm_idlink_xtrm= '{f63e5521-cbef-414c-89ed-d6aa29644687}' --	Money3\LOC\Payment\Repayment Dishonour
			or rtm_idlink_xtrm = '{0e71d163-0bf4-4185-8b48-9e7db7b471fe}' --	Money3\Loan\Payment\Repayment Dishonour - New - Reversal
			or rtm_idlink_xtrm = '{64a336b6-6562-4abe-809d-ddb951f4c24a}'--	Money3\Loan\Payment\Repayment Dishonour - Old - Reversal
			or rtm_idlink_xtrm = '{09cd3218-dd59-44ae-8fd3-c8f45bc501d5}' --Loan\Reverse\Payment\Dishonor - Payment
			,Isnull(rtm_valueCR, 0),0)
		)
		)as 'netAmount'*/
		
		--,Dishon.Dishonour
into #AllTrans
FROM reporting_Loan.dbo.zz_NetReceivedOutput_M Loans
left join m3_main_rep.dbo.iO_Product_MasterReference rmr with(nolock) on rmr.RMR_SeqNumber=Loans.LoanNo
--left join [M3_MAIN_REP].dbo.io_product_transaction rtm with(nolock) on rmr.RMR_ID=rtm.RTM_IDLink_RMR
left join #Trans rtm on rtm.RTM_IDLink_RMR=rmr.RMR_ID 
left join m3_main_rep.dbo.iO_Product_ControlDate rcd with(nolock) on rcd.RCD_IDLink_RMR=rmr.RMR_ID and rcd.RCD_type=6
--WHERE RTM_TypeGhost = 0 and RTM_DateC<'20170601'
WHERE RTM_DateC<dateadd(d,1,(EOMONTH(dateadd(m,-1,getdate()))))
GROUP BY RMR_SeqNumber,rmr_id,RTM_DateC,RCD_CurrentStart


if object_id('tempdb..#SMTrans') is not null
drop table #SMTrans

select 
	 LoanID
	 ,'M'+cast (case when DATEPART(D,ReceivedDate) >=DATEPART(D,settledDate) 
		THEN ( case when DATEPART(M,ReceivedDate) = DATEPART(M,settledDate) AND DATEPART(YYYY,ReceivedDate) = DATEPART(YYYY,settledDate) 
				THEN 0 ELSE DATEDIFF(M,settledDate,ReceivedDate)END ) 
		ELSE DATEDIFF(M,settledDate,ReceivedDate)-1 END as char) as 'SeqMonth'
	 --,'M'+cast((datediff(month,settledDate,ReceivedDate)) as char) as 'SeqMonth'
	 ,netAmount 
into #SMTrans
from #AllTrans 



if object_id('tempdb..#MTrans') is not null
drop table #MTrans

select 
	LoanID
	, [M0]
	,[M1]
	,[M2]
	,[M3]
	,[M4]
	,[M5]
	,[M6]
	,[M7]
	,[M8]
	,[M9]
	,[M10]
	,[M11]
	,[M12]
	,[M13]
	,[M14]
	,[M15]
	,[M16]
	,[M17]
	,[M18]
	,[M19]
	,[M20]
	,[M21]
	,[M22]
	,[M23]
	,[M24]
	,[M25]
	,[M26]
	,[M27]
	,[M28]
	,[M29]
	,[M30]
	,[M31]
	,[M32]
	,[M33]
	,[M34]
	,[M35]
	,[M36]
	,[M37]
	,[M38]
	,[M39]
	,[M40]
	,[M41]
	,[M42]
	,[M43]
	,[M44]
	,[M45]
	,[M46]
	,[M47]
	,[M48]
	,[M49]
	,[M50]
	,[M51]
	,[M52]
	,[M53]
	,[M54]
	,[M55]
	,[M56]
	,[M57]
	,[M58]
	,[M59]
	,[M60]
	,[M61]
	,[M62]
	,[M63]
	,[M64]
	,[M65]
	,[M66]
	,[M67]
	,[M68]
	,[M69]
	,[M70]
	,[M71]
	,[M72]
into #MTrans
from
(
	select
		LoanID
		,SeqMonth
		,sum(netAmount) as 'MonthAmount'
	from #SMTrans
	group by LoanID, SeqMonth
) as tblSource
PIVOT(MAX(tblSource.MonthAmount) FOR tblSource.SeqMonth IN 
(
	[M0]
	,[M1]
	,[M2]
	,[M3]
	,[M4]
	,[M5]
	,[M6]
	,[M7]
	,[M8]
	,[M9]
	,[M10]
	,[M11]
	,[M12]
	,[M13]
	,[M14]
	,[M15]
	,[M16]
	,[M17]
	,[M18]
	,[M19]
	,[M20]
	,[M21]
	,[M22]
	,[M23]
	,[M24]
	,[M25]
	,[M26]
	,[M27]
	,[M28]
	,[M29]
	,[M30]
	,[M31]
	,[M32]
	,[M33]
	,[M34]
	,[M35]
	,[M36]
	,[M37]
	,[M38]
	,[M39]
	,[M40]
	,[M41]
	,[M42]
	,[M43]
	,[M44]
	,[M45]
	,[M46]
	,[M47]
	,[M48]
	,[M49]
	,[M50]
	,[M51]
	,[M52]
	,[M53]
	,[M54]
	,[M55]
	,[M56]
	,[M57]
	,[M58]
	,[M59]
	,[M60]
	,[M61]
	,[M62]
	,[M63]
	,[M64]
	,[M65]
	,[M66]
	,[M67]
	,[M68]
	,[M69]
	,[M70]
	,[M71]
	,[M72]
 ))
AS PivotTable

--select * from #MTrans
/**update output talbe**/
update Reporting_Loan.[dbo].[zz_NetReceivedOutput_M]
set
	[M0]=t1.[M0],
[M1]=t1.[M1],
[M2]=t1.[M2],
[M3]=t1.[M3],
[M4]=t1.[M4],
[M5]=t1.[M5],
[M6]=t1.[M6],
[M7]=t1.[M7],
[M8]=t1.[M8],
[M9]=t1.[M9],
[M10]=t1.[M10],
[M11]=t1.[M11],
[M12]=t1.[M12],
[M13]=t1.[M13],
[M14]=t1.[M14],
[M15]=t1.[M15],
[M16]=t1.[M16],
[M17]=t1.[M17],
[M18]=t1.[M18],
[M19]=t1.[M19],
[M20]=t1.[M20],
[M21]=t1.[M21],
[M22]=t1.[M22],
[M23]=t1.[M23],
[M24]=t1.[M24],
[M25]=t1.[M25],
[M26]=t1.[M26],
[M27]=t1.[M27],
[M28]=t1.[M28],
[M29]=t1.[M29],
[M30]=t1.[M30],
[M31]=t1.[M31],
[M32]=t1.[M32],
[M33]=t1.[M33],
[M34]=t1.[M34],
[M35]=t1.[M35],
[M36]=t1.[M36],
[M37]=t1.[M37],
[M38]=t1.[M38],
[M39]=t1.[M39],
[M40]=t1.[M40],
[M41]=t1.[M41],
[M42]=t1.[M42],
[M43]=t1.[M43],
[M44]=t1.[M44],
[M45]=t1.[M45],
[M46]=t1.[M46],
[M47]=t1.[M47],
[M48]=t1.[M48],
[M49]=t1.[M49],
[M50]=t1.[M50],
[M51]=t1.[M51],
[M52]=t1.[M52],
[M53]=t1.[M53],
[M54]=t1.[M54],
[M55]=t1.[M55],
[M56]=t1.[M56],
[M57]=t1.[M57],
[M58]=t1.[M58],
[M59]=t1.[M59],
[M60]=t1.[M60],
[M61]=t1.[M61],
[M62]=t1.[M62],
[M63]=t1.[M63],
[M64]=t1.[M64],
[M65]=t1.[M65],
[M66]=t1.[M66],
[M67]=t1.[M67],
[M68]=t1.[M68],
[M69]=t1.[M69],
[M70]=t1.[M70],
[M71]=t1.[M71],
[M72]=t1.[M72]

from 
	#MTrans t1
where
	t1.LoanID = [Reporting_Loan].dbo.[zz_NetReceivedOutput_M].LoanNo


--
--select * from [dbo].[zz_NetReceivedOutput_M]


