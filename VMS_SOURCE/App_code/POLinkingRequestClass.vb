Imports System.Data
Imports System.Data.SqlClient
Imports Microsoft.VisualBasic
Imports NPOI.SS.Formula.Functions
Imports VMS.DataAccess

Public Class POLinkingRequestClass
    Public Function GetPOLinkingReqList(ByVal depotCode As String, ByVal vendorCode As String, ByVal status As String) As DataSet
        Dim DS As System.Data.DataSet
        Dim sqlParams As SqlParameter() = New SqlParameter(2) {}
        sqlParams(0) = New SqlParameter()
        sqlParams(0).ParameterName = "@depotCode"
        sqlParams(0).DbType = DbType.String
        sqlParams(0).Direction = System.Data.ParameterDirection.Input
        sqlParams(0).Value = If(depotCode = "", DBNull.Value, CObj(depotCode))

        sqlParams(1) = New SqlParameter()
        sqlParams(1).ParameterName = "@vendorCode"
        sqlParams(1).DbType = DbType.String
        sqlParams(1).Direction = System.Data.ParameterDirection.Input
        sqlParams(1).Value = If(vendorCode = "", DBNull.Value, CObj(vendorCode))

        sqlParams(2) = New SqlParameter()
        sqlParams(2).ParameterName = "@status"
        sqlParams(2).DbType = DbType.String
        sqlParams(2).Direction = System.Data.ParameterDirection.Input
        sqlParams(2).Value = If(status = "", DBNull.Value, CObj(status))
        DS = DBFactory.GetHelper().ExecuteDataSet("Get_POLinkingRequest_List", System.Data.CommandType.StoredProcedure, sqlParams)
        Return DS
    End Function
    Public Function GetToMailAddress() As DataSet
        Dim DS As System.Data.DataSet

        DS = DBFactory.GetHelper().ExecuteDataSet("[VMS].[dbo].[Get_To_Mail_Address]", System.Data.CommandType.StoredProcedure)
        Return DS
    End Function
    Public Function RejectPOLinking(ByVal hdrID As Long, ByVal userId As String) As Integer

        'sqlConn checks the status of Sql connection whether in open or close state
        Dim sqlConn As SqlConnection = Nothing
        'sqlTrans checks the type of operation to be performed for a particular Sql transaction
        Dim sqlTrans As SqlTransaction = Nothing
        Dim numRowsAffected As Integer
        Dim sqlParams(1) As SqlParameter
        Try

            sqlConn = DBFactory.GetHelper.OpenConnection()
            sqlTrans = sqlConn.BeginTransaction()

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@hdrID"
            sqlParams(0).DbType = DbType.Int64
            sqlParams(0).Direction = Data.ParameterDirection.Input
            sqlParams(0).Value = hdrID

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@user"
            sqlParams(1).DbType = DbType.String
            sqlParams(1).Direction = Data.ParameterDirection.Input
            sqlParams(1).Value = userId

            'sqlCmd is the object instance of the SqlCommand 
            Dim sqlCmd As New SqlCommand()
            sqlCmd.Connection = sqlConn
            sqlCmd.Transaction = sqlTrans
            sqlCmd.CommandType = CommandType.StoredProcedure
            sqlCmd.CommandText = "Reject_POLinking"
            sqlCmd.Parameters.AddRange(sqlParams)
            numRowsAffected = sqlCmd.ExecuteNonQuery()

            'SqlTrans is set to commit to save the transaction
            sqlTrans.Commit()

        Catch ex As Exception
            If Not (sqlTrans Is Nothing) Then
                'SqlTrans is set to Rollback to go back to the beginning of the transaction
                sqlTrans.Rollback()
            End If
            Throw ex
        Finally
            If Not (sqlConn Is Nothing) Then
                'sqlConn is set to close state after completing the transaction
                sqlConn.Close()
            End If
        End Try

        Return numRowsAffected

    End Function

#Region "Kazi"
    Public Function GetDispatchList(ByVal rmVendorCode As String, ByVal dispatch_status As String) As DataSet
        Try
            'rmVendorCode = "RM001"
            Dim DS As DataSet
            Dim sqlParams(1) As SqlParameter

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@rm_vendor_code"
            sqlParams(0).DbType = DbType.String
            sqlParams(0).Direction = System.Data.ParameterDirection.Input
            sqlParams(0).Value = If(rmVendorCode = "", DBNull.Value, CObj(rmVendorCode))

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@dispatch_status"
            sqlParams(1).DbType = DbType.String
            sqlParams(1).Direction = System.Data.ParameterDirection.Input
            sqlParams(1).Value = If(dispatch_status = "", DBNull.Value, CObj(dispatch_status))

            DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[opc_get_request_list]", System.Data.CommandType.StoredProcedure, sqlParams)
            Return DS
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetRequestDetails(ByVal orhId As Integer, ByVal vendorCode As String) As DataSet
        Try
            Dim DS As DataSet
            Dim sqlParams(1) As SqlParameter

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@orh_id"
            sqlParams(0).DbType = DbType.Int32
            sqlParams(0).Direction = System.Data.ParameterDirection.Input
            sqlParams(0).Value = If(orhId > 0, CObj(orhId), DBNull.Value)

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@vendor_code"
            sqlParams(1).DbType = DbType.String
            sqlParams(1).Direction = System.Data.ParameterDirection.Input
            sqlParams(1).Value = If(vendorCode = "", DBNull.Value, CObj(vendorCode))

            DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[opc_get_request_dtls]", System.Data.CommandType.StoredProcedure, sqlParams)
            Return DS
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    'Public Function InsertDispatchDetails(ByRef dispatchEntity As DistpacthDetailsEntity, ByVal dtDetails As DataTable) As Integer

    '    Dim sqlConn As SqlConnection = Nothing
    '    Dim sqlTrans As SqlTransaction = Nothing

    '    sqlConn = DBFactory.GetHelper.OpenConnection()

    '    Dim MsgID As Integer
    '    Dim sqlParams(17) As SqlParameter

    '    Try
    '        sqlTrans = sqlConn.BeginTransaction()

    '        sqlParams(0) = New SqlParameter()
    '        sqlParams(0).ParameterName = "@RequestID"
    '        sqlParams(0).SqlDbType = SqlDbType.Int
    '        sqlParams(0).Direction = Data.ParameterDirection.Input
    '        sqlParams(0).Value = dispatchEntity.ReqID

    '        sqlParams(1) = New SqlParameter()
    '        sqlParams(1).ParameterName = "@CourierID"
    '        sqlParams(1).SqlDbType = SqlDbType.Int
    '        sqlParams(1).Direction = Data.ParameterDirection.Input
    '        sqlParams(1).Value = dispatchEntity.CourierId

    '        sqlParams(2) = New SqlParameter()
    '        sqlParams(2).ParameterName = "@InvNo"
    '        sqlParams(2).SqlDbType = SqlDbType.VarChar
    '        sqlParams(2).Direction = Data.ParameterDirection.Input
    '        sqlParams(2).Value = dispatchEntity.InvoiceNo

    '        sqlParams(3) = New SqlParameter()
    '        sqlParams(3).ParameterName = "@InvDate"
    '        sqlParams(3).SqlDbType = SqlDbType.Date
    '        sqlParams(3).Direction = Data.ParameterDirection.Input
    '        If dispatchEntity.InvoiceDate = DateTime.MinValue Then
    '            sqlParams(3).Value = DBNull.Value
    '        Else
    '            sqlParams(3).Value = dispatchEntity.InvoiceDate
    '        End If

    '        sqlParams(4) = New SqlParameter()
    '        sqlParams(4).ParameterName = "@TransName"
    '        sqlParams(4).SqlDbType = SqlDbType.VarChar
    '        sqlParams(4).Direction = Data.ParameterDirection.Input
    '        sqlParams(4).Value = dispatchEntity.TransporterName

    '        sqlParams(5) = New SqlParameter()
    '        sqlParams(5).ParameterName = "@LRNo"
    '        sqlParams(5).SqlDbType = SqlDbType.VarChar
    '        sqlParams(5).Direction = Data.ParameterDirection.Input
    '        sqlParams(5).Value = dispatchEntity.LRNumber

    '        sqlParams(6) = New SqlParameter()
    '        sqlParams(6).ParameterName = "@LRDate"
    '        sqlParams(6).SqlDbType = SqlDbType.DateTime
    '        sqlParams(6).Direction = Data.ParameterDirection.Input
    '        If dispatchEntity.LRDt = DateTime.MinValue Then
    '            sqlParams(6).Value = DBNull.Value
    '        Else
    '            sqlParams(6).Value = dispatchEntity.LRDt
    '        End If

    '        sqlParams(7) = New SqlParameter()
    '        sqlParams(7).ParameterName = "@VehicleNo"
    '        sqlParams(7).SqlDbType = SqlDbType.VarChar
    '        sqlParams(7).Direction = Data.ParameterDirection.Input
    '        sqlParams(7).Value = dispatchEntity.VehicleNumber

    '        sqlParams(8) = New SqlParameter()
    '        sqlParams(8).ParameterName = "@LRDoc"
    '        sqlParams(8).SqlDbType = SqlDbType.VarChar
    '        sqlParams(8).Direction = Data.ParameterDirection.Input
    '        sqlParams(8).Value = dispatchEntity.LRDocument

    '        sqlParams(9) = New SqlParameter()
    '        sqlParams(9).ParameterName = "@DelType"
    '        sqlParams(9).SqlDbType = SqlDbType.VarChar
    '        sqlParams(9).Direction = Data.ParameterDirection.Input
    '        sqlParams(9).Value = dispatchEntity.DeliveryType

    '        sqlParams(10) = New SqlParameter()
    '        sqlParams(10).ParameterName = "@CreatedUser"
    '        sqlParams(10).SqlDbType = SqlDbType.VarChar
    '        sqlParams(10).Direction = Data.ParameterDirection.Input
    '        sqlParams(10).Value = dispatchEntity.CreatedUser

    '        sqlParams(11) = New SqlParameter()
    '        sqlParams(11).ParameterName = "@DispatchDate"
    '        sqlParams(11).SqlDbType = SqlDbType.Date
    '        sqlParams(11).Direction = Data.ParameterDirection.Input
    '        sqlParams(11).Value = DateTime.Today

    '        sqlParams(12) = New SqlParameter()
    '        sqlParams(12).ParameterName = "@Details"
    '        sqlParams(12).SqlDbType = SqlDbType.Structured
    '        sqlParams(12).TypeName = "dbo.udt_DispatchDetails"
    '        sqlParams(12).Direction = Data.ParameterDirection.Input
    '        sqlParams(12).Value = dtDetails

    '        sqlParams(13) = New SqlParameter()
    '        sqlParams(13).ParameterName = "@DocFileName"
    '        sqlParams(13).SqlDbType = SqlDbType.VarChar
    '        sqlParams(13).Direction = Data.ParameterDirection.Input
    '        sqlParams(13).Value = If(String.IsNullOrEmpty(dispatchEntity.DocFileName), CType(DBNull.Value, Object), dispatchEntity.DocFileName)

    '        sqlParams(14) = New SqlParameter()
    '        sqlParams(14).ParameterName = "@DocPath"
    '        sqlParams(14).SqlDbType = SqlDbType.VarChar
    '        sqlParams(14).Direction = Data.ParameterDirection.Input
    '        sqlParams(14).Value = If(String.IsNullOrEmpty(dispatchEntity.DocPath), CType(DBNull.Value, Object), dispatchEntity.DocPath)

    '        sqlParams(15) = New SqlParameter()
    '        sqlParams(15).ParameterName = "@NewHdrID"
    '        sqlParams(15).SqlDbType = SqlDbType.Int
    '        sqlParams(15).Direction = Data.ParameterDirection.Output

    '        sqlParams(16) = New SqlParameter()
    '        sqlParams(16).ParameterName = "@Status"
    '        sqlParams(16).SqlDbType = SqlDbType.Int
    '        sqlParams(16).Direction = Data.ParameterDirection.Output

    '        sqlParams(17) = New SqlParameter()
    '        sqlParams(17).ParameterName = "@ErrorMsg"
    '        sqlParams(17).SqlDbType = SqlDbType.NVarChar
    '        sqlParams(17).Size = 4000
    '        sqlParams(17).Direction = Data.ParameterDirection.Output

    '        Dim sqlCmd As New SqlCommand()
    '        sqlCmd.Connection = sqlConn
    '        sqlCmd.Transaction = sqlTrans
    '        sqlCmd.CommandType = CommandType.StoredProcedure
    '        sqlCmd.CommandText = "[dbo].[opc_insert_dispatch_dtls]"
    '        sqlCmd.Parameters.AddRange(sqlParams)
    '        sqlCmd.ExecuteNonQuery()

    '        MsgID = CType(sqlParams(16).Value, Integer) ' @Status

    '        ' -------- Commit or Rollback based on @Status --------
    '        If MsgID = 1 Then
    '            sqlTrans.Commit()

    '            If sqlParams(15).Value IsNot DBNull.Value Then          ' @NewHdrID — shifted from 13 to 15
    '                dispatchEntity.HdrID = CType(sqlParams(15).Value, Integer)
    '            End If
    '        Else
    '            sqlTrans.Rollback()

    '            If sqlParams(17).Value IsNot DBNull.Value Then
    '                dispatchEntity.Message = CType(sqlParams(17).Value, String)
    '            Else
    '                dispatchEntity.Message = "Dispatch not saved."
    '            End If
    '        End If

    '    Catch ex As Exception
    '        If (sqlTrans IsNot Nothing) Then
    '            sqlTrans.Rollback()
    '        End If
    '        MsgID = 0
    '        dispatchEntity.Message = ex.Message
    '        Throw ex
    '    Finally
    '        If (sqlConn IsNot Nothing) Then
    '            sqlConn.Close()
    '        End If
    '    End Try

    '    Return MsgID

    'End Function

    Public Function InsertDispatchDetails(ByRef dispatchEntity As DistpacthDetailsEntity, ByVal dtDetails As DataTable) As Integer

        Dim sqlConn As SqlConnection = Nothing
        Dim sqlTrans As SqlTransaction = Nothing

        sqlConn = DBFactory.GetHelper.OpenConnection()

        Dim MsgID As Integer
        Dim sqlParams(20) As SqlParameter

        Try
            sqlTrans = sqlConn.BeginTransaction()

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@RequestID"
            sqlParams(0).SqlDbType = SqlDbType.Int
            sqlParams(0).Direction = Data.ParameterDirection.Input
            sqlParams(0).Value = dispatchEntity.ReqID

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@CourierID"
            sqlParams(1).SqlDbType = SqlDbType.VarChar
            sqlParams(1).Direction = Data.ParameterDirection.Input
            sqlParams(1).Value = dispatchEntity.CourierId

            sqlParams(2) = New SqlParameter()
            sqlParams(2).ParameterName = "@InvNo"
            sqlParams(2).SqlDbType = SqlDbType.VarChar
            sqlParams(2).Direction = Data.ParameterDirection.Input
            sqlParams(2).Value = dispatchEntity.InvoiceNo

            sqlParams(3) = New SqlParameter()
            sqlParams(3).ParameterName = "@InvDate"
            sqlParams(3).SqlDbType = SqlDbType.Date
            sqlParams(3).Direction = Data.ParameterDirection.Input
            If dispatchEntity.InvoiceDate = DateTime.MinValue Then
                sqlParams(3).Value = DBNull.Value
            Else
                sqlParams(3).Value = dispatchEntity.InvoiceDate
            End If

            sqlParams(4) = New SqlParameter()
            sqlParams(4).ParameterName = "@TransName"
            sqlParams(4).SqlDbType = SqlDbType.VarChar
            sqlParams(4).Direction = Data.ParameterDirection.Input
            sqlParams(4).Value = dispatchEntity.TransporterName

            sqlParams(5) = New SqlParameter()
            sqlParams(5).ParameterName = "@LRNo"
            sqlParams(5).SqlDbType = SqlDbType.VarChar
            sqlParams(5).Direction = Data.ParameterDirection.Input
            sqlParams(5).Value = dispatchEntity.LRNumber

            sqlParams(6) = New SqlParameter()
            sqlParams(6).ParameterName = "@LRDate"
            sqlParams(6).SqlDbType = SqlDbType.DateTime
            sqlParams(6).Direction = Data.ParameterDirection.Input
            If dispatchEntity.LRDt = DateTime.MinValue Then
                sqlParams(6).Value = DBNull.Value
            Else
                sqlParams(6).Value = dispatchEntity.LRDt
            End If

            sqlParams(7) = New SqlParameter()
            sqlParams(7).ParameterName = "@VehicleNo"
            sqlParams(7).SqlDbType = SqlDbType.VarChar
            sqlParams(7).Direction = Data.ParameterDirection.Input
            sqlParams(7).Value = dispatchEntity.VehicleNumber

            sqlParams(8) = New SqlParameter()
            sqlParams(8).ParameterName = "@DelType"
            sqlParams(8).SqlDbType = SqlDbType.VarChar
            sqlParams(8).Direction = Data.ParameterDirection.Input
            sqlParams(8).Value = dispatchEntity.DeliveryType

            sqlParams(9) = New SqlParameter()
            sqlParams(9).ParameterName = "@DispatchUser"
            sqlParams(9).SqlDbType = SqlDbType.VarChar
            sqlParams(9).Direction = Data.ParameterDirection.Input
            sqlParams(9).Value = If(String.IsNullOrEmpty(dispatchEntity.rmVendorCode), CType(DBNull.Value, Object), dispatchEntity.rmVendorCode)

            sqlParams(10) = New SqlParameter()
            sqlParams(10).ParameterName = "@CreatedUser"
            sqlParams(10).SqlDbType = SqlDbType.VarChar
            sqlParams(10).Direction = Data.ParameterDirection.Input
            sqlParams(10).Value = dispatchEntity.CreatedUser

            sqlParams(11) = New SqlParameter()
            sqlParams(11).ParameterName = "@DispatchDate"
            sqlParams(11).SqlDbType = SqlDbType.Date
            sqlParams(11).Direction = Data.ParameterDirection.Input
            sqlParams(11).Value = DateTime.Today

            sqlParams(12) = New SqlParameter()
            sqlParams(12).ParameterName = "@Details"
            sqlParams(12).SqlDbType = SqlDbType.Structured
            sqlParams(12).TypeName = "dbo.udt_DispatchDetails"
            sqlParams(12).Direction = Data.ParameterDirection.Input
            sqlParams(12).Value = dtDetails

            sqlParams(13) = New SqlParameter()
            sqlParams(13).ParameterName = "@LRDocFileName"
            sqlParams(13).SqlDbType = SqlDbType.VarChar
            sqlParams(13).Direction = Data.ParameterDirection.Input
            sqlParams(13).Value = If(String.IsNullOrEmpty(dispatchEntity.LRDocFileName), CType(DBNull.Value, Object), dispatchEntity.LRDocFileName)

            sqlParams(14) = New SqlParameter()
            sqlParams(14).ParameterName = "@LRDocPath"
            sqlParams(14).SqlDbType = SqlDbType.VarChar
            sqlParams(14).Direction = Data.ParameterDirection.Input
            sqlParams(14).Value = If(String.IsNullOrEmpty(dispatchEntity.LRDocPath), CType(DBNull.Value, Object), dispatchEntity.LRDocPath)

            sqlParams(15) = New SqlParameter()
            sqlParams(15).ParameterName = "@InvDocFileName"
            sqlParams(15).SqlDbType = SqlDbType.VarChar
            sqlParams(15).Direction = Data.ParameterDirection.Input
            sqlParams(15).Value = If(String.IsNullOrEmpty(dispatchEntity.InvDocFileName), CType(DBNull.Value, Object), dispatchEntity.InvDocFileName)

            sqlParams(16) = New SqlParameter()
            sqlParams(16).ParameterName = "@InvDocPath"
            sqlParams(16).SqlDbType = SqlDbType.VarChar
            sqlParams(16).Direction = Data.ParameterDirection.Input
            sqlParams(16).Value = If(String.IsNullOrEmpty(dispatchEntity.InvDocPath), CType(DBNull.Value, Object), dispatchEntity.InvDocPath)

            sqlParams(17) = New SqlParameter()
            sqlParams(17).ParameterName = "@NewHdrID"
            sqlParams(17).SqlDbType = SqlDbType.Int
            sqlParams(17).Direction = Data.ParameterDirection.Output

            sqlParams(18) = New SqlParameter()
            sqlParams(18).ParameterName = "@Status"
            sqlParams(18).SqlDbType = SqlDbType.Int
            sqlParams(18).Direction = Data.ParameterDirection.Output

            sqlParams(19) = New SqlParameter()
            sqlParams(19).ParameterName = "@ErrorMsg"
            sqlParams(19).SqlDbType = SqlDbType.NVarChar
            sqlParams(19).Size = 4000
            sqlParams(19).Direction = Data.ParameterDirection.Output

            sqlParams(20) = New SqlParameter()
            sqlParams(20).ParameterName = "@CourierDate"
            sqlParams(20).SqlDbType = SqlDbType.DateTime
            sqlParams(20).Direction = Data.ParameterDirection.Input

            If dispatchEntity.CourDt = DateTime.MinValue Then
                sqlParams(20).Value = DBNull.Value
            Else
                sqlParams(20).Value = dispatchEntity.CourDt
            End If

            Dim sqlCmd As New SqlCommand()
            sqlCmd.Connection = sqlConn
            sqlCmd.Transaction = sqlTrans
            sqlCmd.CommandType = CommandType.StoredProcedure
            sqlCmd.CommandText = "[dbo].[opc_insert_dispatch_dtls]"
            sqlCmd.Parameters.AddRange(sqlParams)
            sqlCmd.ExecuteNonQuery()

            MsgID = CType(sqlParams(18).Value, Integer) ' @Status

            ' -------- Commit or Rollback based on @Status --------
            If MsgID = 1 Then
                sqlTrans.Commit()

                If sqlParams(17).Value IsNot DBNull.Value Then          ' @NewHdrID
                    dispatchEntity.HdrID = CType(sqlParams(17).Value, Integer)
                End If
            Else
                sqlTrans.Rollback()

                If sqlParams(19).Value IsNot DBNull.Value Then
                    dispatchEntity.Message = CType(sqlParams(19).Value, String)
                Else
                    dispatchEntity.Message = "Dispatch not saved."
                End If
            End If

        Catch ex As Exception
            If (sqlTrans IsNot Nothing) Then
                sqlTrans.Rollback()
            End If
            MsgID = 0
            dispatchEntity.Message = ex.Message
            Throw ex
        Finally
            If (sqlConn IsNot Nothing) Then
                sqlConn.Close()
            End If
        End Try

        Return MsgID

    End Function

    Public Function GetLovDetails(ByVal lov_type As String, ByVal lov_status As String) As DataSet
        Dim DS As System.Data.DataSet
        Dim sqlParams As SqlParameter() = New SqlParameter(1) {}
        sqlParams(0) = New SqlParameter()
        sqlParams(0).ParameterName = "@lov_type"
        sqlParams(0).DbType = DbType.String
        sqlParams(0).Direction = System.Data.ParameterDirection.Input
        sqlParams(0).Value = If(lov_type = "", DBNull.Value, CObj(lov_type))

        sqlParams(1) = New SqlParameter()
        sqlParams(1).ParameterName = "@lov_status"
        sqlParams(1).DbType = DbType.String
        sqlParams(1).Direction = System.Data.ParameterDirection.Input
        sqlParams(1).Value = If(lov_status = "", DBNull.Value, CObj(lov_status))

        DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[opc_get_lov_details]", System.Data.CommandType.StoredProcedure, sqlParams)
        Return DS
    End Function

    Public Function GetDispatchDetails(ByVal orhId As Integer, ByVal vendorCode As String) As DataSet
        Try
            Dim DS As DataSet
            Dim sqlParams(1) As SqlParameter

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@odh_id"
            sqlParams(0).DbType = DbType.Int32
            sqlParams(0).Direction = System.Data.ParameterDirection.Input
            sqlParams(0).Value = If(orhId > 0, CObj(orhId), DBNull.Value)

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@vendor_code"
            sqlParams(1).DbType = DbType.String
            sqlParams(1).Direction = System.Data.ParameterDirection.Input
            sqlParams(1).Value = If(vendorCode = "", DBNull.Value, CObj(vendorCode))

            DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[opc_get_dispatch_dtls]", System.Data.CommandType.StoredProcedure, sqlParams)
            Return DS
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetRmConsumedDetails(ByVal userId As String, ByVal Year As String, ByVal Month As String) As DataSet
        Try
            Dim DS As DataSet
            Dim sqlParams(2) As SqlParameter

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@user_id"
            sqlParams(0).DbType = DbType.String
            sqlParams(0).Direction = ParameterDirection.Input
            sqlParams(0).Value = If(String.IsNullOrEmpty(userId), DBNull.Value, CObj(userId))

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@year"
            sqlParams(1).DbType = DbType.String
            sqlParams(1).Direction = ParameterDirection.Input
            sqlParams(1).Value = If(String.IsNullOrEmpty(Year), DBNull.Value, CObj(Year))

            sqlParams(2) = New SqlParameter()
            sqlParams(2).ParameterName = "@month"
            sqlParams(2).DbType = DbType.String
            sqlParams(2).Direction = ParameterDirection.Input
            sqlParams(2).Value = If(String.IsNullOrEmpty(Month), DBNull.Value, CObj(Month))

            DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[opc_rm_consumed_dtls]", CommandType.StoredProcedure, sqlParams)

            Return DS

        Catch ex As Exception
            Throw
        End Try
    End Function

    Public Function GetPendingDispatchData(ByVal userId As String, ByVal Year As String, ByVal Month As String) As DataSet
        Try
            Dim DS As DataSet
            Dim sqlParams(2) As SqlParameter

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@user_id"
            sqlParams(0).DbType = DbType.String
            sqlParams(0).Direction = ParameterDirection.Input
            sqlParams(0).Value = If(String.IsNullOrEmpty(userId), DBNull.Value, CObj(userId))

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@year"
            sqlParams(1).DbType = DbType.String
            sqlParams(1).Direction = ParameterDirection.Input
            sqlParams(1).Value = If(String.IsNullOrEmpty(Year), DBNull.Value, CObj(Year))

            sqlParams(2) = New SqlParameter()
            sqlParams(2).ParameterName = "@month"
            sqlParams(2).DbType = DbType.String
            sqlParams(2).Direction = ParameterDirection.Input
            sqlParams(2).Value = If(String.IsNullOrEmpty(Month), DBNull.Value, CObj(Month))

            DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[opc_get_rm_pending_transit_list]", CommandType.StoredProcedure, sqlParams)

            Return DS

        Catch ex As Exception
            Throw
        End Try
    End Function

    Public Function GetVerifiedVendorList(ByVal userId As String, ByVal Year As String, ByVal Month As String) As DataSet
        Try
            Dim DS As DataSet
            Dim sqlParams(2) As SqlParameter

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@user_id"
            sqlParams(0).DbType = DbType.String
            sqlParams(0).Direction = ParameterDirection.Input
            sqlParams(0).Value = If(String.IsNullOrEmpty(userId), DBNull.Value, CObj(userId))

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@year"
            sqlParams(1).DbType = DbType.String
            sqlParams(1).Direction = ParameterDirection.Input
            sqlParams(1).Value = If(String.IsNullOrEmpty(Year), DBNull.Value, CObj(Year))

            sqlParams(2) = New SqlParameter()
            sqlParams(2).ParameterName = "@month"
            sqlParams(2).DbType = DbType.String
            sqlParams(2).Direction = ParameterDirection.Input
            sqlParams(2).Value = If(String.IsNullOrEmpty(Month), DBNull.Value, CObj(Month))

            DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[opc_get_verified_unverified_rm_vendor_list]", CommandType.StoredProcedure, sqlParams)

            Return DS

        Catch ex As Exception
            Throw
        End Try
    End Function

    Public Function Get_Rm_List(ByVal req_id As String, ByVal user_id As String, ByVal rm_code As String) As DataSet
        Try
            Dim DS As DataSet
            Dim sqlParams(2) As SqlParameter

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@req_id"
            sqlParams(0).DbType = DbType.Int32
            sqlParams(0).Direction = ParameterDirection.Input
            sqlParams(0).Value = req_id

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@user_id"
            sqlParams(1).DbType = DbType.String
            sqlParams(1).Direction = ParameterDirection.Input
            sqlParams(1).Value = If(String.IsNullOrEmpty(user_id), DBNull.Value, CObj(user_id))

            sqlParams(2) = New SqlParameter()
            sqlParams(2).ParameterName = "@rm_code"
            sqlParams(2).DbType = DbType.String
            sqlParams(2).Direction = ParameterDirection.Input
            sqlParams(2).Value = If(String.IsNullOrEmpty(rm_code), DBNull.Value, CObj(rm_code))

            DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[opc_get_rm_list_details]", CommandType.StoredProcedure, sqlParams)

            Return DS

        Catch ex As Exception
            Throw
        End Try
    End Function

    Public Function GetVendorPaymentDashboardDetails(ByVal vendorName As String, ByVal fromDate As String, ByVal toDate As String, ByVal userId As String) As DataSet

        Try
            Dim DS As DataSet
            Dim sqlParams(3) As SqlParameter

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@from_date"
            sqlParams(0).DbType = DbType.DateTime
            sqlParams(0).Direction = ParameterDirection.Input
            sqlParams(0).Value = fromDate

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@to_date"
            sqlParams(1).DbType = DbType.DateTime
            sqlParams(1).Direction = ParameterDirection.Input
            sqlParams(1).Value = toDate

            sqlParams(2) = New SqlParameter()
            sqlParams(2).ParameterName = "@user_id"
            sqlParams(2).DbType = DbType.String
            sqlParams(2).Direction = ParameterDirection.Input
            sqlParams(2).Value = If(String.IsNullOrEmpty(userId), DBNull.Value, CObj(userId))

            sqlParams(3) = New SqlParameter()
            sqlParams(3).ParameterName = "@vendor_name"
            sqlParams(3).DbType = DbType.String
            sqlParams(3).Direction = ParameterDirection.Input
            sqlParams(3).Value = If(String.IsNullOrEmpty(vendorName), DBNull.Value, CObj(vendorName))

            'sqlParams(4) = New SqlParameter()
            'sqlParams(4).ParameterName = "@page_number"
            'sqlParams(4).DbType = DbType.Int32
            'sqlParams(4).Direction = ParameterDirection.Input
            'sqlParams(4).Value = pageNo

            'sqlParams(5) = New SqlParameter()
            'sqlParams(5).ParameterName = "@page_size"
            'sqlParams(5).DbType = DbType.Int32
            'sqlParams(5).Direction = ParameterDirection.Input
            'sqlParams(5).Value = pageSize

            DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[payment_reconciliation_dashboard_dtls]", CommandType.StoredProcedure, sqlParams)
            Return DS

        Catch ex As Exception
            Throw
        End Try
    End Function

    Public Function GetGrnNotDoneList(ByVal unitCode As String, ByVal fromDate As String, ByVal toDate As String, ByVal pageNo As Integer, ByVal pageSize As Integer) As DataSet
        Try
            Dim DS As DataSet
            Dim sqlParams(2) As SqlParameter

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@unit_code"
            sqlParams(0).DbType = DbType.String
            sqlParams(0).Direction = ParameterDirection.Input
            sqlParams(0).Value = unitCode

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@from_date"
            sqlParams(1).DbType = DbType.DateTime
            sqlParams(1).Direction = ParameterDirection.Input
            sqlParams(1).Value = fromDate

            sqlParams(2) = New SqlParameter()
            sqlParams(2).ParameterName = "@to_date"
            sqlParams(2).DbType = DbType.DateTime
            sqlParams(2).Direction = ParameterDirection.Input
            sqlParams(2).Value = toDate

            'sqlParams(3) = New SqlParameter()
            'sqlParams(3).ParameterName = "@page_number"
            'sqlParams(3).DbType = DbType.Int32
            'sqlParams(3).Direction = ParameterDirection.Input
            'sqlParams(3).Value = pageNo

            'sqlParams(4) = New SqlParameter()
            'sqlParams(4).ParameterName = "@page_size"
            'sqlParams(4).DbType = DbType.Int32
            'sqlParams(4).Direction = ParameterDirection.Input
            'sqlParams(4).Value = pageSize

            DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[get_grn_not_done_details]", CommandType.StoredProcedure, sqlParams)
            Return DS

        Catch ex As Exception
            Throw
        End Try
    End Function

    Public Function GetManualGrnList(ByVal unitCode As String, ByVal fromDate As String, ByVal toDate As String, ByVal pageNo As Integer, ByVal pageSize As Integer) As DataSet
        Try
            Dim DS As DataSet
            Dim sqlParams(2) As SqlParameter

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@unit_code"
            sqlParams(0).DbType = DbType.String
            sqlParams(0).Direction = ParameterDirection.Input
            sqlParams(0).Value = unitCode

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@from_date"
            sqlParams(1).DbType = DbType.DateTime
            sqlParams(1).Direction = ParameterDirection.Input
            sqlParams(1).Value = fromDate

            sqlParams(2) = New SqlParameter()
            sqlParams(2).ParameterName = "@to_date"
            sqlParams(2).DbType = DbType.DateTime
            sqlParams(2).Direction = ParameterDirection.Input
            sqlParams(2).Value = toDate

            'sqlParams(3) = New SqlParameter()
            'sqlParams(3).ParameterName = "@page_number"
            'sqlParams(3).DbType = DbType.Int32
            'sqlParams(3).Direction = ParameterDirection.Input
            'sqlParams(3).Value = pageNo

            'sqlParams(4) = New SqlParameter()
            'sqlParams(4).ParameterName = "@page_size"
            'sqlParams(4).DbType = DbType.Int32
            'sqlParams(4).Direction = ParameterDirection.Input
            'sqlParams(4).Value = pageSize

            DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[get_manual_grn_details]", CommandType.StoredProcedure, sqlParams)
            Return DS

        Catch ex As Exception
            Throw
        End Try
    End Function

    Public Function GetInvPaymentList(ByVal unitCode As String, ByVal fromDate As String, ByVal toDate As String, ByVal pageNo As Integer, ByVal pageSize As Integer) As DataSet
        Try
            Dim DS As DataSet
            Dim sqlParams(2) As SqlParameter

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@unit_code"
            sqlParams(0).DbType = DbType.String
            sqlParams(0).Direction = ParameterDirection.Input
            sqlParams(0).Value = unitCode

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@from_date"
            sqlParams(1).DbType = DbType.DateTime
            sqlParams(1).Direction = ParameterDirection.Input
            sqlParams(1).Value = fromDate

            sqlParams(2) = New SqlParameter()
            sqlParams(2).ParameterName = "@to_date"
            sqlParams(2).DbType = DbType.DateTime
            sqlParams(2).Direction = ParameterDirection.Input
            sqlParams(2).Value = toDate

            'sqlParams(3) = New SqlParameter()
            'sqlParams(3).ParameterName = "@page_number"
            'sqlParams(3).DbType = DbType.Int32
            'sqlParams(3).Direction = ParameterDirection.Input
            'sqlParams(3).Value = pageNo

            'sqlParams(4) = New SqlParameter()
            'sqlParams(4).ParameterName = "@page_size"
            'sqlParams(4).DbType = DbType.Int32
            'sqlParams(4).Direction = ParameterDirection.Input
            'sqlParams(4).Value = pageSize

            DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[get_inv_payment_details]", CommandType.StoredProcedure, sqlParams)
            Return DS

        Catch ex As Exception
            Throw
        End Try
    End Function

    Public Function GetDispatchList(ByVal unitCode As String, ByVal fromDate As String, ByVal toDate As String, ByVal pageNo As Integer, ByVal pageSize As Integer) As DataSet
        Try
            Dim DS As DataSet
            Dim sqlParams(2) As SqlParameter

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@unit_code"
            sqlParams(0).DbType = DbType.String
            sqlParams(0).Direction = ParameterDirection.Input
            sqlParams(0).Value = unitCode

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@from_date"
            sqlParams(1).DbType = DbType.DateTime
            sqlParams(1).Direction = ParameterDirection.Input
            sqlParams(1).Value = fromDate

            sqlParams(2) = New SqlParameter()
            sqlParams(2).ParameterName = "@to_date"
            sqlParams(2).DbType = DbType.DateTime
            sqlParams(2).Direction = ParameterDirection.Input
            sqlParams(2).Value = toDate

            'sqlParams(3) = New SqlParameter()
            'sqlParams(3).ParameterName = "@page_number"
            'sqlParams(3).DbType = DbType.Int32
            'sqlParams(3).Direction = ParameterDirection.Input
            'sqlParams(3).Value = pageNo

            'sqlParams(4) = New SqlParameter()
            'sqlParams(4).ParameterName = "@page_size"
            'sqlParams(4).DbType = DbType.Int32
            'sqlParams(4).Direction = ParameterDirection.Input
            'sqlParams(4).Value = pageSize

            DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[get_dispatched_details]", CommandType.StoredProcedure, sqlParams)
            Return DS

        Catch ex As Exception
            Throw
        End Try
    End Function

    Public Function GetDeliveredList(ByVal unitCode As String, ByVal fromDate As String, ByVal toDate As String, ByVal pageNo As Integer, ByVal pageSize As Integer) As DataSet
        Try
            Dim DS As DataSet
            Dim sqlParams(2) As SqlParameter

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@unit_code"
            sqlParams(0).DbType = DbType.String
            sqlParams(0).Direction = ParameterDirection.Input
            sqlParams(0).Value = unitCode

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@from_date"
            sqlParams(1).DbType = DbType.DateTime
            sqlParams(1).Direction = ParameterDirection.Input
            sqlParams(1).Value = fromDate

            sqlParams(2) = New SqlParameter()
            sqlParams(2).ParameterName = "@to_date"
            sqlParams(2).DbType = DbType.DateTime
            sqlParams(2).Direction = ParameterDirection.Input
            sqlParams(2).Value = toDate

            'sqlParams(3) = New SqlParameter()
            'sqlParams(3).ParameterName = "@page_number"
            'sqlParams(3).DbType = DbType.Int32
            'sqlParams(3).Direction = ParameterDirection.Input
            'sqlParams(3).Value = pageNo

            'sqlParams(4) = New SqlParameter()
            'sqlParams(4).ParameterName = "@page_size"
            'sqlParams(4).DbType = DbType.Int32
            'sqlParams(4).Direction = ParameterDirection.Input
            'sqlParams(4).Value = pageSize

            DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[get_delivered_details]", CommandType.StoredProcedure, sqlParams)
            Return DS

        Catch ex As Exception
            Throw
        End Try
    End Function

#End Region
End Class
