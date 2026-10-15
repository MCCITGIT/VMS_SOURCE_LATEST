Imports System.Data
Imports System.Data.SqlClient
Imports VMS.DataAccess
Imports System.Data.SqlTypes
Imports Newtonsoft.Json
Imports System.Net
Imports System.IO
Imports Newtonsoft.Json.Linq
Imports System.Threading.Tasks

Public Class VendorPoDepotLinkClass
#Region "Po No populate"
    Function GetPoNoList(ByVal unitCode As String) As DataSet
        Dim DS As System.Data.DataSet
        Dim sqlParams(0) As SqlParameter

        sqlParams(0) = New SqlParameter()
        sqlParams(0).ParameterName = "@unit_code"
        sqlParams(0).DbType = DbType.String
        sqlParams(0).Direction = Data.ParameterDirection.Input
        sqlParams(0).Value = If(String.IsNullOrWhiteSpace(unitCode), CObj(DBNull.Value), unitCode.Trim())

        DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[GetPoNo]", Data.CommandType.StoredProcedure, sqlParams)
        Return DS
    End Function
#End Region
#Region "Search data"
    Function GetDepotPoList(ByVal vendorcode As String, ByVal poNo As Int32) As DataSet
        Dim DS As System.Data.DataSet
        Dim sqlParams(1) As SqlParameter

        sqlParams(0) = New SqlParameter()
        sqlParams(0).ParameterName = "@vendorcode"
        sqlParams(0).DbType = DbType.String
        sqlParams(0).Direction = Data.ParameterDirection.Input
        sqlParams(0).Value = vendorcode

        sqlParams(1) = New SqlParameter()
        sqlParams(1).ParameterName = "@pono"
        sqlParams(1).SqlDbType = SqlDbType.Int
        sqlParams(1).Direction = Data.ParameterDirection.Input
        sqlParams(1).Value = poNo

        DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[Vendor_PO_Depot_Linking_List]", Data.CommandType.StoredProcedure, sqlParams)
        Return DS
    End Function

    Function GetDepotPolinkReport(ByVal vendorcode As String, ByVal poNo As Integer?) As DataSet
        Dim DS As System.Data.DataSet
        Dim sqlParams(1) As SqlParameter

        sqlParams(0) = New SqlParameter()
        sqlParams(0).ParameterName = "@unit_code"
        sqlParams(0).DbType = DbType.String
        sqlParams(0).Direction = Data.ParameterDirection.Input
        sqlParams(0).Value = If(String.IsNullOrWhiteSpace(vendorcode), CObj(DBNull.Value), vendorcode.Trim())

        sqlParams(1) = New SqlParameter()
        sqlParams(1).ParameterName = "@pono"
        sqlParams(1).SqlDbType = SqlDbType.BigInt
        sqlParams(1).Direction = Data.ParameterDirection.Input
        sqlParams(1).Value = If(poNo.HasValue, CObj(poNo.Value), DBNull.Value)

        DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[Get_Vendor_PO_Depot_Link_Report]", Data.CommandType.StoredProcedure, sqlParams)
        Return DS
    End Function
#End Region
#Region "Insert / update depot link"
    Function SaveVendorPoDepotLink(ByVal vendorCode As String, ByVal poNo As Integer, ByVal userId As String, ByVal tbl As DataTable) As Integer
        Dim sqlConn As SqlConnection = Nothing
        Dim sqlTrans As SqlTransaction = Nothing
        Try
            sqlConn = DBFactory.GetHelper.OpenConnection()
            sqlTrans = sqlConn.BeginTransaction()

            Dim sqlCmd As New SqlCommand()
            sqlCmd.Connection = sqlConn
            sqlCmd.Transaction = sqlTrans
            sqlCmd.CommandType = CommandType.StoredProcedure
            sqlCmd.CommandText = "[dbo].[vendor_po_depot_link_insert]"

            Dim tblParam As New SqlParameter("@tbl", SqlDbType.Structured)
            tblParam.TypeName = "dbo.type_vendor_po_depot"
            tblParam.Value = tbl
            sqlCmd.Parameters.Add(tblParam)

            sqlCmd.Parameters.Add("@vendor_code", SqlDbType.VarChar, 3).Value = vendorCode
            sqlCmd.Parameters.Add("@pono", SqlDbType.BigInt).Value = poNo
            sqlCmd.Parameters.Add("@userid", SqlDbType.VarChar, 50).Value = If(String.IsNullOrWhiteSpace(userId), CObj(DBNull.Value), userId)

            sqlCmd.ExecuteNonQuery()
            sqlTrans.Commit()
            Return 1
        Catch ex As Exception
            If sqlTrans IsNot Nothing Then
                sqlTrans.Rollback()
            End If
            Throw
        Finally
            If sqlConn IsNot Nothing Then
                sqlConn.Close()
            End If
        End Try
    End Function
#End Region
End Class