

/*Get last Thursday*/
Declare @LastThus As Date = dateadd(dd,datediff(dd,0,getdate())/7 * 7 - 4,0)


/*Convert date to yyyymmdd format*/
select convert(char(8),GETDATE(),112)

