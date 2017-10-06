
Declare @CurrentYear as int = year(getdate())
Declare @CurrentMonth as int= month(getdate())
Declare @CurrentMonthS as char(2)

Declare @PreviousMonth as int
Declare @YearOfPreciousMonth as int
Declare @PreviousMS as varchar(7)

if @CurrentMonth=1 Begin set @PreviousMonth=12 set @YearOfPreciousMonth=@CurrentYear-1 End
else Begin set @PreviousMonth=@CurrentMonth-1 set @YearOfPreciousMonth=@CurrentYear End
set @PreviousMS = convert(char(4),@YearOfPreciousMonth)+'-'+convert(char(2),@PreviousMonth)
--Declare @TableName1 as Varchar(30) = 
Declare @ArchiveS1 as Varchar(200)
Declare @ArchiveS2 as Varchar(200)
Declare @ArchiveS3 as Varchar(200)
Declare @ArchiveS4 as Varchar(200)
Declare @ArchiveS5 as Varchar(200)
Declare @ArchiveS6 as Varchar(200)
Declare @ArchiveS7 as Varchar(200)
--If OBJECT_ID('LC_MM_Received.dbo.ZZ')

if @CurrentMonth<10 set @CurrentMonthS= '0'+convert(char(1),@CurrentMonth)
else set  @CurrentMonthS= convert(char(2),@CurrentMonth)

Declare @FieldName as varchar(10)

set @FieldName= 'M'+ convert(char(4),@CurrentYear)+'-'+@CurrentMonthS+''

select @FieldName

Declare @QueryS as varchar(200)
set @QueryS='Alter table zz_NetReceivedOutput add [' + @FieldName + '] money NULL'
set @QueryS=@QueryS+ ' Alter table zz_FeesReceivedOutput add [' + @FieldName + '] money NULL'
set @QueryS=@QueryS+ ' Alter table zz_InterestReceivedOutput add [' + @FieldName + '] money NULL'


select @QueryS

/*If  COL_LENGTH('zz_NetReceivedOutput',@FieldName) IS NULL 
	exec (@QueryS)*/
