

if OBJECT_ID('zz_PrincipalReceived') is not null
drop table zz_PrincipalReceived

Declare @SqlString nvarchar(max) = 'select 
										t1.[LoanNo],
										t1.[Client],
										t1.[SettleDate],
										t1.[Prod_Status],
										t1.[Prod Type],
										t1.[Term],
										t1.[Initial Freq],
										t1.[Initial Repayment Amnt],
										t1.[OStd Balance],
										t1.[Total Cashout],
										t1.[Cash Out],
										t1.[Insurance],
										t1.[Brokerage],
										t1.[Establish Fee],
										t1.[Draw Down],
										t1.[Application Fee],
										t1.[Fees Charged],
										t1.[DrawDown Fee],
										t1.[Interest Charged],
										t1.[Total Received],
										t1.[Total Net Received],
										t1.[Dishonoured],
										t1.[DishonCnt],
										t1.[Last Success Payment Date],
										t1.[Loss Date],'

DECLARE @EndYeat INT = Year(getdate())
Declare @EndMonth Int = Month(dateadd(m,-1,getdate()))

Declare @StartYear int = 2011

Declare @CountY int = @StartYear
Declare @SMonNum int = 1 
Declare @MonString char(2)



WHILE @CountY < @EndYeat
BEGIN
   set @SMonNum =1
   While @SMonNum <= 12
	Begin
		if @SMonNum<10 set @MonString= '0'+convert(char(1),@SMonNum)
		else set  @MonString= convert(char(2),@SMonNum)


		set @SqlString = @SqlString + 'IIF((isnull(t1.[M'+ convert(char(4),@CountY) + '-' + @MonString+'],0)-isnull(t2.[M'+ convert(char(4),@CountY) + '-' + @MonString+'],0)-isnull(t3.[M'+ convert(char(4),@CountY) + '-' + @MonString+'],0))>0, (isnull(t1.[M'+ convert(char(4),@CountY) + '-' + @MonString+'],0)-isnull(t2.[M'+ convert(char(4),@CountY) + '-' + @MonString+'],0)-isnull(t3.[M'+ convert(char(4),@CountY) + '-' + @MonString+'],0)),0) As [M'+ convert(char(4),@CountY) + '-' + @MonString+'],'



		set @SMonNum = @SMonNum+1
	End;
	set @CountY=@CountY+1
END;

set @SMonNum =1
While @SMonNum <= @EndMonth
	Begin
		if @SMonNum<10 set @MonString= '0'+convert(char(1),@SMonNum)
		else set  @MonString= convert(char(2),@SMonNum)

		set @SqlString = @SqlString + 'IIF((isnull(t1.[M'+ convert(char(4),@CountY) + '-' + @MonString+'],0)-isnull(t2.[M'+ convert(char(4),@CountY) + '-' + @MonString+'],0)-isnull(t3.[M'+ convert(char(4),@CountY) + '-' + @MonString+'],0))>0, (isnull(t1.[M'+ convert(char(4),@CountY) + '-' + @MonString+'],0)-isnull(t2.[M'+ convert(char(4),@CountY) + '-' + @MonString+'],0)-isnull(t3.[M'+ convert(char(4),@CountY) + '-' + @MonString+'],0)),0) As [M'+ convert(char(4),@CountY) + '-' + @MonString+'],'

		set @SMonNum = @SMonNum+1
End;

set @SqlString = Left(@SqlString, LEN(@SqlString)-1) + ' into zz_PrincipalReceived
								from zz_NetReceivedOutput as t1
								left join zz_FeesReceivedOutput as t2 on t1.LoanNo = t2.Loanno
								left join zz_InterestReceivedOutput as t3 on t1.Loanno=t3.LoanNo'

--select @SqlString
Exec (@SqlString)

GO


