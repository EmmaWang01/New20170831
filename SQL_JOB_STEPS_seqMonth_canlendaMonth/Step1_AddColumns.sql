

/*Alter table zz_NetReceivedOutput
add  [M2017-05] money NULL

Alter table zz_FeesReceivedOutput
add  [M2017-05] money NULL

Alter table zz_InterestReceivedOutput
add  [M2017-05] money NULL*/

Declare @CurrentYear as int = year(getdate())
Declare @CurrentMonth as int= month(getdate())
Declare @CurrentMonthS as char(2)
if @CurrentMonth<10 set @CurrentMonthS= '0'+convert(char(1),@CurrentMonth)
else set  @CurrentMonthS= convert(char(2),@CurrentMonth)

Declare @FieldName as varchar(10)

set @FieldName= 'M'+ convert(char(4),@CurrentYear)+'-'+@CurrentMonthS+''

--select @FieldName

Declare @QueryS as varchar(200)
set @QueryS='Alter table zz_NetReceivedOutput add [' + @FieldName + '] money NULL'
set @QueryS=@QueryS+ ' Alter table zz_FeesReceivedOutput add [' + @FieldName + '] money NULL'
set @QueryS=@QueryS+ ' Alter table zz_InterestReceivedOutput add [' + @FieldName + '] money NULL'


--select @QueryS

If  COL_LENGTH('zz_NetReceivedOutput',@FieldName) IS NULL 
	exec (@QueryS)

