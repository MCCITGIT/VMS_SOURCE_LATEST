Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports VMS.DataAccess

'Namespace VMS.Web
Public Class VendorUnit
    Public Function Vendor_List_Get() As DataSet
        Dim VendorListSet As New DataSet

        'Dim sqlParams(0) As SqlParameter
        'sqlParams(0) = New SqlParameter()
        'sqlParams(0).ParameterName = "@Company"
        'sqlParams(0).DbType = DbType.String
        'sqlParams(0).Direction = Data.ParameterDirection.Input
        'sqlParams(0).Value = Company

        VendorListSet = DBFactory.GetHelper().ExecuteDataSet("VendorUnit_List", Data.CommandType.StoredProcedure)
        Return VendorListSet

    End Function
    Public Function Vendor_Get(ByVal UnitCode As String) As DataSet
        Dim VendorSet As New DataSet

        Dim sqlParams(0) As SqlParameter

        sqlParams(0) = New SqlParameter()
        sqlParams(0).ParameterName = "@UnitCode"
        sqlParams(0).DbType = DbType.String
        sqlParams(0).Direction = Data.ParameterDirection.Input
        sqlParams(0).Value = UnitCode

        VendorSet = DBFactory.GetHelper().ExecuteDataSet("VendorUnit_Get", Data.CommandType.StoredProcedure, sqlParams)

        Return VendorSet
    End Function

    Public Function VendorInsert(ByRef Vendor As VMS.Web.VendorMasterListEntity) As Integer
        Dim numRowsAffected As Integer

        'sqlConn checks the status of Sql connection whether in open or close state
        Dim sqlConn As SqlConnection = Nothing
        'sqlTrans checks the type of operation to be performed for a particular Sql transaction
        Dim sqlTrans As SqlTransaction = Nothing

        Try
            sqlConn = DBFactory.GetHelper.OpenConnection()
            sqlTrans = sqlConn.BeginTransaction()
            Dim sqlParams(17) As SqlParameter

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@Vend_Company"
            sqlParams(0).DbType = DbType.String
            sqlParams(0).Direction = Data.ParameterDirection.Input
            sqlParams(0).Value = Vendor.Vendcompany

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@VendUnit_Code"
            sqlParams(1).DbType = DbType.String
            sqlParams(1).Direction = Data.ParameterDirection.Input
            'sqlParams(1).Value = IIf(Vendor.VendUnit_Code <> String.Empty, Vendor.VendUnit_Code, DBNull.Value)
            sqlParams(1).Value = Vendor.VendUnit_Code


            sqlParams(2) = New SqlParameter()
            sqlParams(2).ParameterName = "@VendUnit_Name"
            sqlParams(2).DbType = DbType.String
            sqlParams(2).Direction = Data.ParameterDirection.Input
            sqlParams(2).Value = IIf(Vendor.VendUnit_Name <> String.Empty, Vendor.VendUnit_Name, DBNull.Value)


            sqlParams(3) = New SqlParameter()
            sqlParams(3).ParameterName = "@VendUnit_Region"
            sqlParams(3).DbType = DbType.String
            sqlParams(3).Direction = Data.ParameterDirection.Input
            sqlParams(3).Value = IIf(Vendor.VendUnit_Region <> String.Empty, Vendor.VendUnit_Region, DBNull.Value)


            sqlParams(4) = New SqlParameter()
            sqlParams(4).ParameterName = "@VendUnit_Add1"
            sqlParams(4).DbType = DbType.String
            sqlParams(4).Direction = Data.ParameterDirection.Input
            sqlParams(4).Value = IIf(Vendor.VendUnit_Add1 <> String.Empty, Vendor.VendUnit_Add1, DBNull.Value)

            sqlParams(5) = New SqlParameter()
            sqlParams(5).ParameterName = "@VendUnit_Add2"
            sqlParams(5).DbType = DbType.String
            sqlParams(5).Direction = Data.ParameterDirection.Input
            sqlParams(5).Value = IIf(Vendor.VendUnit_Add2 <> String.Empty, Vendor.VendUnit_Add2, DBNull.Value)

            sqlParams(6) = New SqlParameter()
            sqlParams(6).ParameterName = "@VendUnit_Add3"
            sqlParams(6).DbType = DbType.String
            sqlParams(6).Direction = Data.ParameterDirection.Input
            sqlParams(6).Value = IIf(Vendor.VendUnit_Add3 <> String.Empty, Vendor.VendUnit_Add3, DBNull.Value)

            sqlParams(7) = New SqlParameter()
            sqlParams(7).ParameterName = "@VendState"
            sqlParams(7).DbType = DbType.String
            sqlParams(7).Direction = Data.ParameterDirection.Input
            sqlParams(7).Value = IIf(Vendor.VendState <> String.Empty, Vendor.VendState, DBNull.Value)

            sqlParams(8) = New SqlParameter()
            sqlParams(8).ParameterName = "@VendCity"
            sqlParams(8).DbType = DbType.String
            sqlParams(8).Direction = Data.ParameterDirection.Input
            sqlParams(8).Value = IIf(Vendor.VendCity <> String.Empty, Vendor.VendCity, DBNull.Value)

            sqlParams(9) = New SqlParameter()
            sqlParams(9).ParameterName = "@VendPin"
            sqlParams(9).DbType = DbType.String
            sqlParams(9).Direction = Data.ParameterDirection.Input
            sqlParams(9).Value = IIf(Vendor.VendPin <> String.Empty, Vendor.VendPin, DBNull.Value)

            sqlParams(10) = New SqlParameter()
            sqlParams(10).ParameterName = "@VendEmail"
            sqlParams(10).DbType = DbType.String
            sqlParams(10).Direction = Data.ParameterDirection.Input
            sqlParams(10).Value = IIf(Vendor.VendEmail <> String.Empty, Vendor.VendEmail, DBNull.Value)

            sqlParams(11) = New SqlParameter()
            sqlParams(11).ParameterName = "@VendStax_regno"
            sqlParams(11).DbType = DbType.String
            sqlParams(11).Direction = Data.ParameterDirection.Input
            sqlParams(11).Value = IIf(Vendor.VendStax_regno <> String.Empty, Vendor.VendStax_regno, DBNull.Value)

            sqlParams(12) = New SqlParameter()
            sqlParams(12).ParameterName = "@VendTinNo"
            sqlParams(12).DbType = DbType.String
            sqlParams(12).Direction = Data.ParameterDirection.Input
            sqlParams(12).Value = IIf(Vendor.VendTinNo <> String.Empty, Vendor.VendTinNo, DBNull.Value)

            sqlParams(13) = New SqlParameter()
            sqlParams(13).ParameterName = "@VendCenVatRegNo"
            sqlParams(13).DbType = DbType.String
            sqlParams(13).Direction = Data.ParameterDirection.Input
            sqlParams(13).Value = IIf(Vendor.VendCenVatRegNo <> String.Empty, Vendor.VendCenVatRegNo, DBNull.Value)

            sqlParams(14) = New SqlParameter()
            sqlParams(14).ParameterName = "@VendCenVatRegDate"
            sqlParams(14).DbType = DbType.String
            sqlParams(14).Direction = Data.ParameterDirection.Input
            sqlParams(14).Value = IIf(Vendor.VendCenVatRegDate <> String.Empty, Vendor.VendCenVatRegDate, DBNull.Value)

            sqlParams(15) = New SqlParameter()
            sqlParams(15).ParameterName = "@created_user"
            sqlParams(15).DbType = DbType.String
            sqlParams(15).Direction = Data.ParameterDirection.Input
            sqlParams(15).Value = IIf(Vendor.CreatedUser <> String.Empty, Vendor.CreatedUser, DBNull.Value)

            sqlParams(16) = New SqlParameter()
            sqlParams(16).ParameterName = "@active"
            sqlParams(16).DbType = DbType.String
            sqlParams(16).Direction = Data.ParameterDirection.Input
            sqlParams(16).Value = Vendor.ActiveStatus

            sqlParams(17) = New SqlParameter()
            sqlParams(17).ParameterName = "@unit_freight_yn"
            sqlParams(17).DbType = DbType.String
            sqlParams(17).Direction = Data.ParameterDirection.Input
            sqlParams(17).Value = If(String.IsNullOrEmpty(Vendor.FreightYn), "N", Vendor.FreightYn)


            'sqlCmd is the object instance of the SqlCommand 
            Dim sqlCmd As New SqlCommand()
            sqlCmd.Connection = sqlConn
            sqlCmd.Transaction = sqlTrans
            sqlCmd.CommandType = CommandType.StoredProcedure
            sqlCmd.CommandText = "VendorUnit_Insert"
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
    Public Function VendorUpdate(ByRef Vendor As VMS.Web.VendorMasterListEntity) As Integer

        Dim numRowsAffected As Integer

        'sqlConn checks the status of Sql connection whether in open or close state
        Dim sqlConn As SqlConnection = Nothing
        'sqlTrans checks the type of operation to be performed for a particular Sql transaction
        Dim sqlTrans As SqlTransaction = Nothing

        Try
            sqlConn = DBFactory.GetHelper.OpenConnection()
            sqlTrans = sqlConn.BeginTransaction()

            Dim sqlParams(17) As SqlParameter

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@Vend_Company"
            sqlParams(0).DbType = DbType.String
            sqlParams(0).Direction = Data.ParameterDirection.Input
            sqlParams(0).Value = Vendor.Vendcompany

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@VendUnit_Code"
            sqlParams(1).DbType = DbType.String
            sqlParams(1).Direction = Data.ParameterDirection.Input
            'sqlParams(1).Value = IIf(Vendor.VendUnit_Code <> String.Empty, Vendor.VendUnit_Code, DBNull.Value)
            sqlParams(1).Value = Vendor.VendUnit_Code


            sqlParams(2) = New SqlParameter()
            sqlParams(2).ParameterName = "@VendUnit_Name"
            sqlParams(2).DbType = DbType.String
            sqlParams(2).Direction = Data.ParameterDirection.Input
            sqlParams(2).Value = IIf(Vendor.VendUnit_Name <> String.Empty, Vendor.VendUnit_Name, DBNull.Value)


            sqlParams(3) = New SqlParameter()
            sqlParams(3).ParameterName = "@VendUnit_Region"
            sqlParams(3).DbType = DbType.String
            sqlParams(3).Direction = Data.ParameterDirection.Input
            sqlParams(3).Value = IIf(Vendor.VendUnit_Region <> String.Empty, Vendor.VendUnit_Region, DBNull.Value)


            sqlParams(4) = New SqlParameter()
            sqlParams(4).ParameterName = "@VendUnit_Add1"
            sqlParams(4).DbType = DbType.String
            sqlParams(4).Direction = Data.ParameterDirection.Input
            sqlParams(4).Value = IIf(Vendor.VendUnit_Add1 <> String.Empty, Vendor.VendUnit_Add1, DBNull.Value)

            sqlParams(5) = New SqlParameter()
            sqlParams(5).ParameterName = "@VendUnit_Add2"
            sqlParams(5).DbType = DbType.String
            sqlParams(5).Direction = Data.ParameterDirection.Input
            sqlParams(5).Value = IIf(Vendor.VendUnit_Add2 <> String.Empty, Vendor.VendUnit_Add2, DBNull.Value)

            sqlParams(6) = New SqlParameter()
            sqlParams(6).ParameterName = "@VendUnit_Add3"
            sqlParams(6).DbType = DbType.String
            sqlParams(6).Direction = Data.ParameterDirection.Input
            sqlParams(6).Value = IIf(Vendor.VendUnit_Add3 <> String.Empty, Vendor.VendUnit_Add3, DBNull.Value)

            sqlParams(7) = New SqlParameter()
            sqlParams(7).ParameterName = "@VendState"
            sqlParams(7).DbType = DbType.String
            sqlParams(7).Direction = Data.ParameterDirection.Input
            sqlParams(7).Value = IIf(Vendor.VendState <> String.Empty, Vendor.VendState, DBNull.Value)

            sqlParams(8) = New SqlParameter()
            sqlParams(8).ParameterName = "@VendCity"
            sqlParams(8).DbType = DbType.String
            sqlParams(8).Direction = Data.ParameterDirection.Input
            sqlParams(8).Value = IIf(Vendor.VendCity <> String.Empty, Vendor.VendCity, DBNull.Value)

            sqlParams(9) = New SqlParameter()
            sqlParams(9).ParameterName = "@VendPin"
            sqlParams(9).DbType = DbType.String
            sqlParams(9).Direction = Data.ParameterDirection.Input
            sqlParams(9).Value = IIf(Vendor.VendPin <> String.Empty, Vendor.VendPin, DBNull.Value)

            sqlParams(10) = New SqlParameter()
            sqlParams(10).ParameterName = "@VendEmail"
            sqlParams(10).DbType = DbType.String
            sqlParams(10).Direction = Data.ParameterDirection.Input
            sqlParams(10).Value = IIf(Vendor.VendEmail <> String.Empty, Vendor.VendEmail, DBNull.Value)

            sqlParams(11) = New SqlParameter()
            sqlParams(11).ParameterName = "@VendStax_regno"
            sqlParams(11).DbType = DbType.String
            sqlParams(11).Direction = Data.ParameterDirection.Input
            sqlParams(11).Value = IIf(Vendor.VendStax_regno <> String.Empty, Vendor.VendStax_regno, DBNull.Value)

            sqlParams(12) = New SqlParameter()
            sqlParams(12).ParameterName = "@VendTinNo"
            sqlParams(12).DbType = DbType.String
            sqlParams(12).Direction = Data.ParameterDirection.Input
            sqlParams(12).Value = IIf(Vendor.VendTinNo <> String.Empty, Vendor.VendTinNo, DBNull.Value)

            sqlParams(13) = New SqlParameter()
            sqlParams(13).ParameterName = "@VendCenVatRegNo"
            sqlParams(13).DbType = DbType.String
            sqlParams(13).Direction = Data.ParameterDirection.Input
            sqlParams(13).Value = IIf(Vendor.VendCenVatRegNo <> String.Empty, Vendor.VendCenVatRegNo, DBNull.Value)

            sqlParams(14) = New SqlParameter()
            sqlParams(14).ParameterName = "@VendCenVatRegDate"
            sqlParams(14).DbType = DbType.String
            sqlParams(14).Direction = Data.ParameterDirection.Input
            sqlParams(14).Value = IIf(Vendor.VendCenVatRegDate <> String.Empty, Vendor.VendCenVatRegDate, DBNull.Value)

            sqlParams(15) = New SqlParameter()
            sqlParams(15).ParameterName = "@created_user"
            sqlParams(15).DbType = DbType.String
            sqlParams(15).Direction = Data.ParameterDirection.Input
            sqlParams(15).Value = IIf(Vendor.CreatedUser <> String.Empty, Vendor.CreatedUser, DBNull.Value)

            sqlParams(16) = New SqlParameter()
            sqlParams(16).ParameterName = "@active"
            sqlParams(16).DbType = DbType.String
            sqlParams(16).Direction = Data.ParameterDirection.Input
            sqlParams(16).Value = Vendor.ActiveStatus

            sqlParams(17) = New SqlParameter()
            sqlParams(17).ParameterName = "@unit_freight_yn"
            sqlParams(17).DbType = DbType.String
            sqlParams(17).Direction = Data.ParameterDirection.Input
            sqlParams(17).Value = If(String.IsNullOrEmpty(Vendor.FreightYn), "N", Vendor.FreightYn)

            'sqlCmd is the object instance of the SqlCommand 
            Dim sqlCmd As New SqlCommand()
            sqlCmd.Connection = sqlConn
            sqlCmd.Transaction = sqlTrans
            sqlCmd.CommandType = CommandType.StoredProcedure
            sqlCmd.CommandText = "VendorUnit_Update"
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

#Region "Check Unit Code"
    'Public Function ChkUnitCode(ByRef Vendor As VMS.Web.VendorMasterListEntity) As Integer
    Public Function ChkUnitCode(ByVal UnitCode As String) As Integer
        Dim VendorRowAffected As System.Data.DataSet
        Dim count1 As Integer

        Dim sqlParams(1) As SqlParameter


        sqlParams(0) = New SqlParameter()
        sqlParams(0).ParameterName = "@UnitCode"
        sqlParams(0).DbType = DbType.String
        sqlParams(0).Direction = Data.ParameterDirection.Input
        sqlParams(0).Value = UnitCode

        'sqlParams(2) = New SqlParameter()
        'sqlParams(2).ParameterName = "@active"
        'sqlParams(2).DbType = DbType.String
        'sqlParams(2).Direction = Data.ParameterDirection.Input
        'sqlParams(2).Value = Vendor.ActiveStatus

        sqlParams(1) = New SqlParameter()
        sqlParams(1).ParameterName = "@count"
        sqlParams(1).DbType = DbType.Int64
        sqlParams(1).Direction = Data.ParameterDirection.Output

        VendorRowAffected = DBFactory.GetHelper().ExecuteDataSet("VendorUnit_ChkUnitCode", Data.CommandType.StoredProcedure, sqlParams)

        count1 = sqlParams(1).Value
        'count1 = CType(sqlParams(4).Value, Integer)

        Return count1
    End Function

#End Region
End Class


'End Namespace
