if OBJECT_ID('tempdb..#Loans') is not null
drop table #Loans

Select 
	[LoanNo]
	,[SettleDate]
into #Loans
From zz_FeesReceivedOutput

truncate table [dbo].[zz_FeesReceived]

insert into [dbo].[zz_FeesReceived](
[LoanNo]
      ,[SettleYear]
      ,[SettleMonth]  
      ,[ReceivedYear]
      ,[ReceivedMonth]
      ,[NetFeesReceived]
	  ,ReceivedDate
)
select 
	distinct LoanNo
	,year(LoanBook.[SettleDate]) as [SettleYear]
	,month(LoanBook.SettleDate) as [SettleMonth]
	,Credit.ReceivedYear
	,Credit.ReceivedMonth
	,[FeeCharged] as [NetFeesReceived]
	,cast(cast(Credit.[ReceivedYear] as varchar(10)) + '-' + cast(Credit.[ReceivedMonth] as varchar(50)) + '-1' as date)
from #Loans as LoanBook
left join [M3_MAIN_REP].dbo.IO_Product_Masterreference as LoanMaster with(nolock)
on LoanBook.LoanNo=LoanMaster.RMR_SeqNumber
inner join
(SELECT 
			rtm_idlink_rmr AS 'LoanPK'
			,Year(RTM_DateC) as ReceivedYear
			,month(RTM_DateC) as ReceivedMonth
			,Isnull(Sum(Isnull(rtm_valuedb, 0)), 0) - Isnull(Sum(Isnull(rtm_valuecr, 0)), 0) [FeeCharged]
	
		FROM [M3_MAIN_REP].dbo.io_product_transaction with(nolock)
		WHERE RTM_TypeGhost = 0
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
				'{f37874ea-230b-4795-b6bb-fff27bda2b2f}' -- list of fees 

			)
		GROUP BY rtm_idlink_rmr,Year(RTM_DateC),month(RTM_DateC)
		) Credit ON Credit.LoanPK = LoanMaster.RMR_ID


