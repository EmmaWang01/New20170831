

DECLARE @EndYeat INT = Year(getdate())
Declare @EndMonth Int = Month(dateadd(m,-1,getdate()))

Declare @StartYear int = 2011

Declare @CountY int = @StartYear
Declare @SMonNum int = 1 
Declare @MonString char(2)

Declare @SqlString nvarchar(max) =''


WHILE @CountY < @EndYeat
BEGIN
   set @SMonNum =1
   While @SMonNum <= 12
	Begin
		if @SMonNum<10 set @MonString= '0'+convert(char(1),@SMonNum)
		else set  @MonString= convert(char(2),@SMonNum)
		set @SqlString = @SqlString + ' update [dbo].[zz_FeesReceivedOutput]
		set [M'+ convert(char(4),@CountY) + '-' + @MonString+']
			= [NetFeesReceived]
		from 
			[dbo].[zz_FeesReceived] t1
		where
		t1.LoanNo = [dbo].[zz_FeesReceivedOutput].LoanNo
		and t1.ReceivedDate = '''+ convert(char(4),@CountY) + @MonString+'01'';';
		set @SMonNum = @SMonNum+1
	End;
	set @CountY=@CountY+1
END;

set @SMonNum =1
While @SMonNum <= @EndMonth
	Begin
		if @SMonNum<10 set @MonString= '0'+convert(char(1),@SMonNum)
		else set  @MonString= convert(char(2),@SMonNum)
		set @SqlString = @SqlString + ' update [dbo].[zz_FeesReceivedOutput]
		set [M'+ convert(char(4),@CountY) + '-' + @MonString+']
			= [NetFeesReceived]
		from 
			[dbo].[zz_FeesReceived] t1
		where
		t1.LoanNo = [dbo].[zz_FeesReceivedOutput].LoanNo
		and t1.ReceivedDate = '''+ convert(char(4),@CountY) + @MonString+'01'';';
		set @SMonNum = @SMonNum+1
End;
Exec (@SqlString)
GO

