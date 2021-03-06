

if object_id('tempdb..#AllTrans') is not null
drop table #AllTrans

SELECT 
	RMR_SeqNumber AS 'LoanID'
	,RMR_ID
	--,Year(RTM_DateC) as ReceivedYear
	--,month(RTM_DateC) as ReceivedMonth
	,rcd.RCD_CurrentStart as 'SettledDate'
	,RTM_DateC as 'ReceivedDate'
	--,sum(isnull(rtm_Value,0)) as netAmount
	,Isnull(Sum(Isnull(rtm_valuedb, 0)), 0) - Isnull(Sum(Isnull(rtm_valuecr, 0)), 0) as 'netAmount'
	
into #AllTrans
FROM reporting_Loan.dbo.zz_FeesReceivedOutput_M Loans
left join m3_main_rep.dbo.iO_Product_MasterReference rmr with(nolock) on rmr.RMR_SeqNumber=Loans.LoanNo
left join [M3_MAIN_REP].dbo.io_product_transaction rtm with(nolock) on rmr.RMR_ID=rtm.RTM_IDLink_RMR
--left join m3_main_rep.dbo.iO_Product_Transaction rtm on rtm.RTM_IDLink_RMR=rmr.RMR_ID 
left join m3_main_rep.dbo.iO_Product_ControlDate rcd with(nolock) on rcd.RCD_IDLink_RMR=rmr.RMR_ID and rcd.RCD_type=6
--WHERE RTM_TypeGhost = 0 and RTM_DateC<'20170601'
WHERE RTM_TypeGhost = 0 and RTM_DateC<dateadd(d,1,(EOMONTH(dateadd(m,-1,getdate()))))
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
update Reporting_Loan.[dbo].zz_InterestReceivedOutput_M
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
	t1.LoanID = [Reporting_Loan].dbo.zz_InterestReceivedOutput_M.LoanNo


--
--select * from [dbo].[zz_FeesReceivedOutput_M]


