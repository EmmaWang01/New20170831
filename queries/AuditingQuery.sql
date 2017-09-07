

SELECT
APP_NAME() AS ApplicationName,
DATABASE_PRINCIPAL_ID() AS DatabasePrincipalId,
USER_NAME() AS DatabasePrincipalName,
SUSER_ID() AS ServerPrincipalId,
SUSER_SID() AS ServerPrincipalSID,
SUSER_SNAME() AS ServerPrincipalName,
CONNECTIONPROPERTY('net_transport') AS TransportProtocol,
CONNECTIONPROPERTY('client_net_address') AS ClientNetAddress,
CURRENT_TIMESTAMP AS CurrentDateTime,
@@ROWCOUNT AS RowsProcessedByLastCommand;
GO


