

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
				
				'{00a8c8cd-da00-4365-b7c3-ec70b151b821}',
				'{04415e80-1f17-4925-9074-b478dbd17bc6}',
				'{15df6716-e868-445c-b242-a9045263a625}',
				'{20ea1c5a-3f11-42ab-94bc-2d008413ffce}',
				'{335c9ed6-5f11-4ca3-929c-46ecae08d729}',
				'{355d522c-02fb-4392-92fe-d5a32a8df435}',
				'{419a00a3-cb6b-4c80-bfc1-7eb408b98945}',
				'{438a59aa-1d0a-48cf-a55a-6abd2807eed1}',
				'{5015f0a3-8759-462c-ae67-16796e541ab2}',
				'{524db6fd-1c71-47ab-9c8f-1d1841f05a29}',
				'{5d85970a-fcd2-4e44-8367-8e7c85f90f30}',
				'{64bfbad8-5744-4b8c-85ae-3c021394b882}',
				'{66fccdf2-8609-4402-b55c-3c5026eacaa6}',
				'{67440f09-f0ef-4371-9613-f58645bef916}',
				'{6a745a95-fe3e-4a69-8fb3-204be5a0c7a4}',
				'{6c0aa92f-83a8-4bad-b163-827e7dd3e54f}',
				'{798f3a7c-3d4c-4aeb-8b3c-1e295b5b9b55}',
				'{7e7ca54a-fc0b-4c33-a150-bcfc35da672d}',
				'{82848342-e578-4103-be20-d0d6d31bac6d}',
				'{844b24ea-96c6-4a34-8e29-02f05406db15}',
				'{8da9b6a5-78f6-4036-904e-508a11b6df37}',
				'{8e18b754-8b9d-4142-a018-cfca7b4082cf}',
				'{9d597cf4-21cb-40f7-ac3e-6a10abe524d0}',
				'{a3a31f33-534a-4755-8abe-2dd8d3a73e35}',
				'{a951a02c-9b8b-4564-995b-5225c5085f6b}',
				'{bf8c8181-dc96-4e7e-8f2d-c1034c07822c}',
				'{c151b776-f6c8-4f36-aa5a-bab1cdb7e7c7}',
				'{c6bb3791-3d10-407c-a8ff-f58cb4a445be}',
				'{c8cf8d6f-acf9-4a92-b048-e1177e217bae}',
				'{ce88d442-c040-4d3b-8929-7a34b7c65b29}',
				'{de0c9b34-03a9-4248-9c1c-82032a90984a}',
				'{E0D583A7-2FD0-4FF5-9CBF-414844BDADEE}',
				'{ee9ffc6e-0bbb-4c7d-bce5-228e0f3f9c9c}',
				'{f37874ea-230b-4795-b6bb-fff27bda2b2f}' -- list of fees see excel in same folder for more details

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
update Reporting_Loan.[dbo].[zz_FeesReceivedOutput_M]
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
	t1.LoanID = [Reporting_Loan].dbo.[zz_FeesReceivedOutput_M].LoanNo


--
--select * from [dbo].[zz_FeesReceivedOutput_M]


