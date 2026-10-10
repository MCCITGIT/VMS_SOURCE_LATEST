Imports System.Data
Imports System.Data.SqlClient
Imports VMS.DataAccess
Imports System.Data.SqlTypes
Imports Newtonsoft.Json
Imports System.Net
Imports System.IO
Imports Newtonsoft.Json.Linq
Imports System.Threading.Tasks

Public Class OPC_VendorClass
#Region "product master"
    Function InsertUpdateBrandMasterDtls(ByRef BrandMasterEntity As ProductMasterEntity) As Integer
        Dim sqlConn As SqlConnection = Nothing
        sqlConn = DBFactory.GetHelper.OpenConnection()
        'sqlTrans = sqlConn.BeginTransaction
        Dim MsgID As Integer

        Dim sqlParams(5) As SqlParameter
        Try
            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@brand_name"
            sqlParams(0).SqlDbType = SqlDbType.VarChar
            sqlParams(0).Direction = Data.ParameterDirection.Input
            sqlParams(0).Value = BrandMasterEntity.PName

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@brand_id"
            sqlParams(1).SqlDbType = SqlDbType.Int
            sqlParams(1).Direction = Data.ParameterDirection.Input
            sqlParams(1).Value = BrandMasterEntity.PID

            sqlParams(2) = New SqlParameter()
            sqlParams(2).ParameterName = "@active"
            sqlParams(2).SqlDbType = SqlDbType.VarChar
            sqlParams(2).Direction = Data.ParameterDirection.Input
            sqlParams(2).Value = BrandMasterEntity.ActiveStatus

            sqlParams(3) = New SqlParameter()
            sqlParams(3).ParameterName = "@user_id"
            sqlParams(3).SqlDbType = SqlDbType.VarChar
            sqlParams(3).Direction = Data.ParameterDirection.Input
            sqlParams(3).Value = BrandMasterEntity.CreatedUser

            sqlParams(4) = New SqlParameter()
            sqlParams(4).ParameterName = "@trantype"
            sqlParams(4).SqlDbType = SqlDbType.Int
            sqlParams(4).Direction = Data.ParameterDirection.Input
            sqlParams(4).Value = BrandMasterEntity.Trantype

            sqlParams(5) = New SqlParameter()
            sqlParams(5).ParameterName = "@outputCode"
            sqlParams(5).DbType = DbType.Int64
            sqlParams(5).Direction = Data.ParameterDirection.Output
            sqlParams(5).Size = 100

            Dim sqlCmd As New SqlCommand()
            sqlCmd.Connection = sqlConn
            'sqlCmd.Transaction = sqlTrans
            sqlCmd.CommandType = CommandType.StoredProcedure
            sqlCmd.CommandText = "[dbo].[opc_product_insertupdate]"
            sqlCmd.Parameters.AddRange(sqlParams)
            sqlCmd.ExecuteNonQuery()
            MsgID = CType(sqlParams(5).Value, Integer)
            'sqlTrans.Commit()
        Catch ex As Exception
            'If (sqlTrans IsNot Nothing) Then
            '    sqlTrans.Rollback()
            'End If
            Throw ex
        Finally
            If (sqlConn IsNot Nothing) Then
                sqlConn.Close()
            End If
        End Try
        Return MsgID
    End Function
    Function GetBrandMasterList() As DataSet
        Dim DS As System.Data.DataSet
        DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[opc_get_brand_master_list]", Data.CommandType.StoredProcedure)
        Return DS
    End Function
    Function BindBrandMasterList() As DataSet
        Dim DS As System.Data.DataSet
        DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[opc_bind_brand_list]", Data.CommandType.StoredProcedure)
        Return DS
    End Function
#End Region

#Region "Raw Material Master"
    Public Function GetRawMatList(ByVal searchText As String) As DataSet
        Dim ds As DataSet
        Dim sqlParams(0) As SqlParameter

        sqlParams(0) = New SqlParameter()
        sqlParams(0).ParameterName = "@search_key"
        sqlParams(0).DbType = DbType.String
        sqlParams(0).Direction = ParameterDirection.Input
        sqlParams(0).Value = If(Not String.IsNullOrWhiteSpace(searchText), CObj(searchText.Trim()), DBNull.Value)

        ds = DBFactory.GetHelper().ExecuteDataSet("[dbo].[GetRawmaterialData]", CommandType.StoredProcedure, sqlParams)
        Return ds
    End Function
    Public Function GetRawMaterial_SearchList(ByVal searchText As String) As DataSet
        Dim ds As DataSet
        Dim sqlParams(0) As SqlParameter

        sqlParams(0) = New SqlParameter()
        sqlParams(0).ParameterName = "@search_key"
        sqlParams(0).DbType = DbType.String
        sqlParams(0).Direction = ParameterDirection.Input
        sqlParams(0).Value = If(Not String.IsNullOrWhiteSpace(searchText), CObj(searchText.Trim()), DBNull.Value)

        ds = DBFactory.GetHelper().ExecuteDataSet("[dbo].[GetRawmaterial]", CommandType.StoredProcedure, sqlParams)
        Return ds
    End Function
    Function InsertUpdateRawMatMasterDtls(ByRef entity As RawMaterialMasterEntity) As Integer
        Dim sqlConn As SqlConnection = Nothing
        sqlConn = DBFactory.GetHelper.OpenConnection()
        Dim MsgID As Integer

        Dim sqlParams(4) As SqlParameter
        Try
            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@rawmat_code"
            sqlParams(0).SqlDbType = SqlDbType.VarChar
            sqlParams(0).Direction = Data.ParameterDirection.Input
            sqlParams(0).Value = entity.RawMatCode

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@active"
            sqlParams(1).SqlDbType = SqlDbType.VarChar
            sqlParams(1).Direction = Data.ParameterDirection.Input
            sqlParams(1).Value = entity.ActiveStatus

            sqlParams(2) = New SqlParameter()
            sqlParams(2).ParameterName = "@user_id"
            sqlParams(2).SqlDbType = SqlDbType.VarChar
            sqlParams(2).Direction = Data.ParameterDirection.Input
            sqlParams(2).Value = entity.CreatedUser

            sqlParams(3) = New SqlParameter()
            sqlParams(3).ParameterName = "@trantype"
            sqlParams(3).SqlDbType = SqlDbType.Int
            sqlParams(3).Direction = Data.ParameterDirection.Input
            sqlParams(3).Value = entity.Trantype

            sqlParams(4) = New SqlParameter()
            sqlParams(4).ParameterName = "@outputCode"
            sqlParams(4).DbType = DbType.Int64
            sqlParams(4).Direction = Data.ParameterDirection.Output
            sqlParams(4).Size = 100

            Dim sqlCmd As New SqlCommand()
            sqlCmd.Connection = sqlConn
            sqlCmd.CommandType = CommandType.StoredProcedure
            sqlCmd.CommandText = "[dbo].[opc_rawmat_insertupdate]"
            sqlCmd.Parameters.AddRange(sqlParams)
            sqlCmd.ExecuteNonQuery()
            MsgID = CType(sqlParams(4).Value, Integer)
        Catch ex As Exception
            Throw ex
        Finally
            If (sqlConn IsNot Nothing) Then
                sqlConn.Close()
            End If
        End Try
        Return MsgID
    End Function
    Function GetRawmaterialMstrList() As DataSet
        Dim DS As System.Data.DataSet
        DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[GetRawmaterialDataList]", Data.CommandType.StoredProcedure)
        Return DS
    End Function

#End Region

#Region "vendor rawmaterial linking"
    Function GetRawMaterialByVendorId(ByVal vendorid As String) As DataSet
        Dim DS As System.Data.DataSet
        Dim sqlParams(0) As SqlParameter

        sqlParams(0) = New SqlParameter()
        sqlParams(0).ParameterName = "@vendorid"
        sqlParams(0).DbType = DbType.String
        sqlParams(0).Direction = Data.ParameterDirection.Input
        sqlParams(0).Value = vendorid

        DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[get_rawmat_list_for_vendor_link]", Data.CommandType.StoredProcedure, sqlParams)
        Return DS
    End Function
    Function InsertVendorRawmaterialLink(ByVal user_id As String, ByVal tbl As DataTable) As Integer
        Dim sqlConn As SqlConnection = Nothing
        Dim sqlTrans As SqlTransaction = Nothing
        Dim numRowsAffected As Integer
        sqlConn = DBFactory.GetHelper.OpenConnection
        sqlTrans = sqlConn.BeginTransaction

        Dim sqlParams(1) As SqlParameter
        Try
            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@tbl"
            sqlParams(0).Direction = Data.ParameterDirection.Input
            sqlParams(0).Value = tbl

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@userid"
            sqlParams(1).SqlDbType = SqlDbType.VarChar
            sqlParams(1).Direction = Data.ParameterDirection.Input
            sqlParams(1).Value = user_id

            Dim sqlCmd As New SqlCommand()
            sqlCmd.Connection = sqlConn
            sqlCmd.Transaction = sqlTrans
            sqlCmd.CommandType = CommandType.StoredProcedure
            sqlCmd.CommandText = "[dbo].[vendor_rawmaterial_link_insert]"

            sqlCmd.Parameters.AddRange(sqlParams)
            numRowsAffected = sqlCmd.ExecuteNonQuery()

            sqlTrans.Commit()
        Catch ex As SqlException
            If (sqlTrans IsNot Nothing) Then
                sqlTrans.Rollback()
            End If
            Throw
        Catch ex As Exception
            If (sqlTrans IsNot Nothing) Then
                sqlTrans.Rollback()
            End If
            Throw
        Finally
            If (sqlConn IsNot Nothing) Then
                sqlConn.Close()
            End If
        End Try
        Return numRowsAffected
    End Function
    Public Function GetVendorRawMatEditList(ByVal vendorid As String) As DataSet
        Dim ds As DataSet
        Dim sqlParams(0) As SqlParameter

        sqlParams(0) = New SqlParameter()
        sqlParams(0).ParameterName = "@vendor_id"
        sqlParams(0).DbType = DbType.String
        sqlParams(0).Direction = ParameterDirection.Input
        sqlParams(0).Value = vendorid

        ds = DBFactory.GetHelper().ExecuteDataSet("[dbo].[getvendor_rawmateriallink_editdata]", CommandType.StoredProcedure, sqlParams)
        Return ds
    End Function
    Function GetRawmaterialList(ByVal vendorid As String) As DataSet
        Dim DS As System.Data.DataSet
        Dim sqlParams(0) As SqlParameter

        sqlParams(0) = New SqlParameter()
        sqlParams(0).ParameterName = "@vendor_code"
        sqlParams(0).DbType = DbType.String
        sqlParams(0).Direction = Data.ParameterDirection.Input
        sqlParams(0).Value = If(Not String.IsNullOrWhiteSpace(vendorid), CObj(vendorid.Trim()), DBNull.Value)

        DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[getvendor_rawmateriallist]", Data.CommandType.StoredProcedure, sqlParams)
        Return DS
    End Function
    Function UpdateVendorRawMaterialLink(ByVal linkId As Integer,
                                     ByVal active As String,
                                     ByVal userId As String) As Integer

        Dim sqlConn As SqlConnection = Nothing
        Dim rowsAffected As Integer = 0

        Try
            sqlConn = DBFactory.GetHelper.OpenConnection()

            Dim sqlCmd As New SqlCommand()
            sqlCmd.Connection = sqlConn
            sqlCmd.CommandType = CommandType.StoredProcedure
            sqlCmd.CommandText = "[dbo].[vendor_rawmaterial_link_update]"

            sqlCmd.Parameters.AddWithValue("@lin_id", linkId)
            sqlCmd.Parameters.AddWithValue("@active", active)
            sqlCmd.Parameters.AddWithValue("@user_id", userId)

            rowsAffected = sqlCmd.ExecuteNonQuery()

        Catch ex As Exception
            Throw ex

        Finally
            If (sqlConn IsNot Nothing) Then
                sqlConn.Close()
            End If
        End Try

        Return rowsAffected

    End Function

    Function GetVendorList(ByVal searchText As String) As DataSet
        Dim ds As DataSet
        Dim sqlParams(0) As SqlParameter

        sqlParams(0) = New SqlParameter()
        sqlParams(0).ParameterName = "@search_key"
        sqlParams(0).DbType = DbType.String
        sqlParams(0).Direction = ParameterDirection.Input
        sqlParams(0).Value = If(Not String.IsNullOrWhiteSpace(searchText), CObj(searchText.Trim()), DBNull.Value)

        ds = DBFactory.GetHelper().ExecuteDataSet("[dbo].[GetVendor_List]", Data.CommandType.StoredProcedure, sqlParams)
        Return ds
    End Function
#End Region

#Region "formulation master"
    Function GetProduct(ByVal searchText As String) As DataSet
        'Dim DS As System.Data.DataSet
        'DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[GetProduct_List]", Data.CommandType.StoredProcedure)
        'Return DS
        Dim ds As DataSet
        Dim sqlParams(0) As SqlParameter

        sqlParams(0) = New SqlParameter()
        sqlParams(0).ParameterName = "@search_key"
        sqlParams(0).DbType = DbType.String
        sqlParams(0).Direction = ParameterDirection.Input
        sqlParams(0).Value = If(Not String.IsNullOrWhiteSpace(searchText), CObj(searchText.Trim()), DBNull.Value)

        ds = DBFactory.GetHelper().ExecuteDataSet("[dbo].[GetProduct_List]", Data.CommandType.StoredProcedure, sqlParams)
        Return ds
    End Function
    Function GetShadeCodeList(ByVal productcode As String) As DataSet
        Dim DS As System.Data.DataSet
        Dim sqlParams(0) As SqlParameter

        sqlParams(0) = New SqlParameter()
        sqlParams(0).ParameterName = "@product_code"
        sqlParams(0).DbType = DbType.String
        sqlParams(0).Direction = Data.ParameterDirection.Input
        sqlParams(0).Value = productcode

        DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[GetShade_List]", Data.CommandType.StoredProcedure, sqlParams)
        Return DS
    End Function
    Function GetRawMaterial() As DataSet
        Dim DS As System.Data.DataSet
        DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[GetRawMaterialDtls]", Data.CommandType.StoredProcedure)
        Return DS
    End Function
    Public Function InsertFormulation(ByVal headerid As Integer, ByVal brandCode As String,
                                  ByVal rawMatCode As String,
                                  ByVal productCode As String,
                                  ByVal user_id As String,
                                  ByVal tbl As DataTable) As Integer

        Dim sqlConn As SqlConnection = Nothing
        Dim sqlTrans As SqlTransaction = Nothing
        Dim numRowsAffected As Integer

        sqlConn = DBFactory.GetHelper.OpenConnection
        sqlTrans = sqlConn.BeginTransaction

        Dim sqlParams(5) As SqlParameter

        Try

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@headerid"
            sqlParams(0).SqlDbType = SqlDbType.Int
            sqlParams(0).Direction = ParameterDirection.Input
            sqlParams(0).Value = headerid

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@opc_brand_code"
            sqlParams(1).SqlDbType = SqlDbType.VarChar
            sqlParams(1).Direction = ParameterDirection.Input
            sqlParams(1).Value = brandCode

            sqlParams(2) = New SqlParameter()
            sqlParams(2).ParameterName = "@opc_rawmat_code"
            sqlParams(2).SqlDbType = SqlDbType.VarChar
            sqlParams(2).Direction = ParameterDirection.Input
            sqlParams(2).Value = rawMatCode

            sqlParams(3) = New SqlParameter()
            sqlParams(3).ParameterName = "@opc_product_code"
            sqlParams(3).SqlDbType = SqlDbType.VarChar
            sqlParams(3).Direction = ParameterDirection.Input
            sqlParams(3).Value = productCode

            sqlParams(4) = New SqlParameter()
            sqlParams(4).ParameterName = "@created_user"
            sqlParams(4).SqlDbType = SqlDbType.VarChar
            sqlParams(4).Direction = ParameterDirection.Input
            sqlParams(4).Value = user_id

            sqlParams(5) = New SqlParameter()
            sqlParams(5).ParameterName = "@FormulationDetails"
            sqlParams(5).SqlDbType = SqlDbType.Structured
            sqlParams(5).TypeName = "dbo.tbl_opc_formulation_dtls"
            sqlParams(5).Direction = ParameterDirection.Input
            sqlParams(5).Value = tbl

            Dim sqlCmd As New SqlCommand()
            sqlCmd.Connection = sqlConn
            sqlCmd.Transaction = sqlTrans
            sqlCmd.CommandType = CommandType.StoredProcedure
            sqlCmd.CommandText = "[dbo].[opc_formulation_insert]"

            sqlCmd.Parameters.AddRange(sqlParams)
            Using dr As SqlDataReader = sqlCmd.ExecuteReader()
                If dr.Read() AndAlso Not IsDBNull(dr("Status")) Then
                    numRowsAffected = Convert.ToInt32(dr("Status"))
                Else
                    numRowsAffected = 0
                End If
            End Using
            sqlTrans.Commit()

        Catch ex As Exception

            If (sqlTrans IsNot Nothing) Then
                sqlTrans.Rollback()
            End If

            Throw ex

        Finally

            If (sqlConn IsNot Nothing) Then
                sqlConn.Close()
            End If

        End Try

        Return numRowsAffected

    End Function
    Function GetFormulationDataList(ByVal brandcode As String, ByVal rawmatcode As String, ByVal productcode As String, ByVal vendorcode As String) As DataSet
        Dim DS As System.Data.DataSet
        Dim sqlParams(3) As SqlParameter

        sqlParams(0) = New SqlParameter()
        sqlParams(0).ParameterName = "@brand_code"
        sqlParams(0).DbType = DbType.String
        sqlParams(0).Direction = Data.ParameterDirection.Input
        sqlParams(0).Value = If(Not String.IsNullOrWhiteSpace(brandcode), CObj(brandcode.Trim()), DBNull.Value)

        sqlParams(1) = New SqlParameter()
        sqlParams(1).ParameterName = "@rawmat_code"
        sqlParams(1).DbType = DbType.String
        sqlParams(1).Direction = Data.ParameterDirection.Input
        sqlParams(1).Value = If(Not String.IsNullOrWhiteSpace(rawmatcode), CObj(rawmatcode.Trim()), DBNull.Value)

        sqlParams(2) = New SqlParameter()
        sqlParams(2).ParameterName = "@product_code"
        sqlParams(2).DbType = DbType.String
        sqlParams(2).Direction = Data.ParameterDirection.Input
        sqlParams(2).Value = If(Not String.IsNullOrWhiteSpace(productcode), CObj(productcode.Trim()), DBNull.Value)

        sqlParams(3) = New SqlParameter()
        sqlParams(3).ParameterName = "@vendor_code"
        sqlParams(3).DbType = DbType.String
        sqlParams(3).Direction = Data.ParameterDirection.Input
        sqlParams(3).Value = If(Not String.IsNullOrWhiteSpace(vendorcode), CObj(vendorcode.Trim()), DBNull.Value)

        DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[getformulation_datalist]", Data.CommandType.StoredProcedure, sqlParams)
        Return DS
    End Function
    Function GetFormulationEditList(ByVal brandcode As String, ByVal rawmatcode As Integer, ByVal productcode As String) As DataSet
        Dim DS As System.Data.DataSet
        Dim sqlParams(2) As SqlParameter

        sqlParams(0) = New SqlParameter()
        sqlParams(0).ParameterName = "@brandcode"
        sqlParams(0).DbType = DbType.String
        sqlParams(0).Direction = Data.ParameterDirection.Input
        sqlParams(0).Value = If(Not String.IsNullOrWhiteSpace(brandcode), CObj(brandcode.Trim()), DBNull.Value)

        sqlParams(1) = New SqlParameter()
        sqlParams(1).ParameterName = "@rawcode"
        sqlParams(1).DbType = DbType.Int32
        sqlParams(1).Direction = Data.ParameterDirection.Input
        sqlParams(1).Value = rawmatcode

        sqlParams(2) = New SqlParameter()
        sqlParams(2).ParameterName = "@producode"
        sqlParams(2).DbType = DbType.String
        sqlParams(2).Direction = Data.ParameterDirection.Input
        sqlParams(2).Value = If(Not String.IsNullOrWhiteSpace(productcode), CObj(productcode.Trim()), DBNull.Value)

        'DS = DBFactory.GetHelper().ExecuteDataSet("dbo.opc_get_formulation_for_edit", Data.CommandType.StoredProcedure, sqlParams)
        DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[opc_get_formulation_for_view]", Data.CommandType.StoredProcedure, sqlParams)
        Return DS
    End Function

    Public Function Insert_Formulation(ByVal headerid As Integer, ByVal brandCode As String, ByVal UnitCode As String, ByVal productCode As String, ByVal tbl As DataTable, ByVal user_id As String) As Integer
        Dim ignoredHeaderId As Integer = 0
        Return Insert_Formulation(headerid, brandCode, UnitCode, productCode, tbl, user_id, ignoredHeaderId)
    End Function

    ''' <summary>Same as above but also returns the HeaderID emitted by [opc_formulationinsert] (added by MUKESH BHAGAT on 09-Oct-2026 for Product_Formulation).</summary>
    Public Function Insert_Formulation(ByVal headerid As Integer, ByVal brandCode As String, ByVal UnitCode As String, ByVal productCode As String, ByVal tbl As DataTable, ByVal user_id As String, ByRef headerIdOut As Integer) As Integer

        Dim sqlConn As SqlConnection = Nothing
        Dim sqlTrans As SqlTransaction = Nothing
        Dim numRowsAffected As Integer
        headerIdOut = 0

        sqlConn = DBFactory.GetHelper.OpenConnection
        sqlTrans = sqlConn.BeginTransaction
        Dim sqlParams(5) As SqlParameter

        Try
            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@headerid"
            sqlParams(0).SqlDbType = SqlDbType.Int
            sqlParams(0).Direction = ParameterDirection.Input
            sqlParams(0).Value = headerid

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@opc_brand_code"
            sqlParams(1).SqlDbType = SqlDbType.VarChar
            sqlParams(1).Direction = ParameterDirection.Input
            sqlParams(1).Value = brandCode

            sqlParams(2) = New SqlParameter()
            sqlParams(2).ParameterName = "@unit_code"
            sqlParams(2).SqlDbType = SqlDbType.VarChar
            sqlParams(2).Direction = ParameterDirection.Input
            sqlParams(2).Value = UnitCode

            sqlParams(3) = New SqlParameter()
            sqlParams(3).ParameterName = "@opc_product_code"
            sqlParams(3).SqlDbType = SqlDbType.VarChar
            sqlParams(3).Direction = ParameterDirection.Input
            sqlParams(3).Value = productCode

            sqlParams(4) = New SqlParameter()
            sqlParams(4).ParameterName = "@FormulationDetails"
            sqlParams(4).SqlDbType = SqlDbType.Structured
            sqlParams(4).TypeName = "dbo.tbl_opc_formula_dtls"
            sqlParams(4).Direction = ParameterDirection.Input
            sqlParams(4).Value = tbl

            sqlParams(5) = New SqlParameter()
            sqlParams(5).ParameterName = "@created_user"
            sqlParams(5).SqlDbType = SqlDbType.VarChar
            sqlParams(5).Direction = ParameterDirection.Input
            sqlParams(5).Value = user_id

            Dim sqlCmd As New SqlCommand()
            sqlCmd.Connection = sqlConn
            sqlCmd.Transaction = sqlTrans
            sqlCmd.CommandType = CommandType.StoredProcedure
            sqlCmd.CommandText = "[dbo].[opc_formulationinsert]"

            sqlCmd.Parameters.AddRange(sqlParams)
            Using dr As SqlDataReader = sqlCmd.ExecuteReader()
                If dr.Read() AndAlso Not IsDBNull(dr("Status")) Then
                    numRowsAffected = Convert.ToInt32(dr("Status"))
                    ' the SP returns HeaderID only on success (Status = 1)
                    For i As Integer = 0 To dr.FieldCount - 1
                        If String.Equals(dr.GetName(i), "HeaderID", StringComparison.OrdinalIgnoreCase) AndAlso Not dr.IsDBNull(i) Then
                            headerIdOut = Convert.ToInt32(dr.GetValue(i))
                        End If
                    Next
                Else
                    numRowsAffected = 0
                End If
            End Using
            sqlTrans.Commit()

        Catch ex As Exception

            If (sqlTrans IsNot Nothing) Then
                sqlTrans.Rollback()
            End If
            Throw ex
        Finally
            If (sqlConn IsNot Nothing) Then
                sqlConn.Close()
            End If
        End Try
        Return numRowsAffected
    End Function
    Public Shared Async Function PostApiWithHeadersToDataSet(ByVal apiUrl As String, ByVal postBody As Object) As Task(Of DataSet)
        Dim ds As DataSet = New DataSet()

        Try
            Dim jsonBody As String = JsonConvert.SerializeObject(postBody)
            ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12
            Dim httpWReq As HttpWebRequest = CType(WebRequest.Create(apiUrl), HttpWebRequest)
            httpWReq.Accept = "application/json"
            httpWReq.Method = "POST"
            httpWReq.ContentType = "application/json"
            httpWReq.Headers.Add("Authorization", "Basic " & ConfigurationManager.AppSettings("BerGerWebAPIAuthToken").ToString())
            Dim encoding = New UTF8Encoding()
            Dim data = encoding.GetBytes(jsonBody)
            httpWReq.ContentLength = data.Length

            Using stream = httpWReq.GetRequestStream()
                stream.Write(data, 0, data.Length)
            End Using

            Dim httpResponse As HttpWebResponse = CType(httpWReq.GetResponse(), HttpWebResponse)
            Dim responseJson As String = New StreamReader(httpResponse.GetResponseStream()).ReadToEnd()
            Dim jObject As JObject = JObject.Parse(responseJson)
            Dim detailsArray As JArray = CType(jObject("Details"), JArray)
            Dim table As DataTable = detailsArray.ToObject(Of DataTable)()
            ds.Tables.Add(table)
            Return ds
        Catch ex As Exception
            Dim exMsg = ex.Message
        End Try

        Return ds
    End Function
#End Region

#Region "Raw Material Vendor Master"
    Function InsertUpdateRawMaterialVendorMasterDtls(ByRef entity As RawMaterialVendorMasterEntity) As Integer
        Dim sqlConn As SqlConnection = Nothing
        sqlConn = DBFactory.GetHelper.OpenConnection()
        Dim MsgID As Integer

        Dim sqlParams(13) As SqlParameter
        Try
            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@vendor_code"
            sqlParams(0).SqlDbType = SqlDbType.VarChar
            sqlParams(0).Direction = Data.ParameterDirection.Input
            sqlParams(0).Value = entity.VendorCode

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@vendor_name"
            sqlParams(1).SqlDbType = SqlDbType.VarChar
            sqlParams(1).Direction = Data.ParameterDirection.Input
            sqlParams(1).Value = entity.VendorName

            sqlParams(2) = New SqlParameter()
            sqlParams(2).ParameterName = "@gst_registration_number"
            sqlParams(2).SqlDbType = SqlDbType.VarChar
            sqlParams(2).Direction = Data.ParameterDirection.Input
            sqlParams(2).Value = entity.GstRegistrationNumber

            sqlParams(3) = New SqlParameter()
            sqlParams(3).ParameterName = "@address"
            sqlParams(3).SqlDbType = SqlDbType.VarChar
            sqlParams(3).Direction = Data.ParameterDirection.Input
            sqlParams(3).Value = entity.Address

            sqlParams(4) = New SqlParameter()
            sqlParams(4).ParameterName = "@city"
            sqlParams(4).SqlDbType = SqlDbType.VarChar
            sqlParams(4).Direction = Data.ParameterDirection.Input
            sqlParams(4).Value = entity.Vendor_City

            sqlParams(5) = New SqlParameter()
            sqlParams(5).ParameterName = "@state"
            sqlParams(5).SqlDbType = SqlDbType.VarChar
            sqlParams(5).Direction = Data.ParameterDirection.Input
            sqlParams(5).Value = entity.Vendor_State

            sqlParams(6) = New SqlParameter()
            sqlParams(6).ParameterName = "@pincode"
            sqlParams(6).SqlDbType = SqlDbType.VarChar
            sqlParams(6).Direction = Data.ParameterDirection.Input
            sqlParams(6).Value = entity.Vendor_PinCode

            sqlParams(7) = New SqlParameter()
            sqlParams(7).ParameterName = "@contact_person"
            sqlParams(7).SqlDbType = SqlDbType.VarChar
            sqlParams(7).Direction = Data.ParameterDirection.Input
            sqlParams(7).Value = entity.ContactPerson

            sqlParams(8) = New SqlParameter()
            sqlParams(8).ParameterName = "@mobile_number"
            sqlParams(8).SqlDbType = SqlDbType.VarChar
            sqlParams(8).Direction = Data.ParameterDirection.Input
            sqlParams(8).Value = entity.MobileNumber

            sqlParams(9) = New SqlParameter()
            sqlParams(9).ParameterName = "@email_address"
            sqlParams(9).SqlDbType = SqlDbType.VarChar
            sqlParams(9).Direction = Data.ParameterDirection.Input
            sqlParams(9).Value = entity.EmailAddress

            sqlParams(10) = New SqlParameter()
            sqlParams(10).ParameterName = "@active"
            sqlParams(10).SqlDbType = SqlDbType.VarChar
            sqlParams(10).Direction = Data.ParameterDirection.Input
            sqlParams(10).Value = entity.ActiveStatus

            sqlParams(11) = New SqlParameter()
            sqlParams(11).ParameterName = "@user_id"
            sqlParams(11).SqlDbType = SqlDbType.VarChar
            sqlParams(11).Direction = Data.ParameterDirection.Input
            sqlParams(11).Value = entity.CreatedUser

            sqlParams(12) = New SqlParameter()
            sqlParams(12).ParameterName = "@trantype"
            sqlParams(12).SqlDbType = SqlDbType.Int
            sqlParams(12).Direction = Data.ParameterDirection.Input
            sqlParams(12).Value = entity.Trantype

            sqlParams(13) = New SqlParameter()
            sqlParams(13).ParameterName = "@outputCode"
            sqlParams(13).DbType = DbType.Int64
            sqlParams(13).Direction = Data.ParameterDirection.Output
            sqlParams(13).Size = 100

            Dim sqlCmd As New SqlCommand()
            sqlCmd.Connection = sqlConn
            sqlCmd.CommandType = CommandType.StoredProcedure
            sqlCmd.CommandText = "[dbo].[opc_rawmaterial_vendor_insertupdate]"
            sqlCmd.Parameters.AddRange(sqlParams)
            sqlCmd.ExecuteNonQuery()
            MsgID = CType(sqlParams(13).Value, Integer)
        Catch ex As Exception
            Throw ex
        Finally
            If (sqlConn IsNot Nothing) Then
                sqlConn.Close()
            End If
        End Try
        Return MsgID
    End Function
    Function GetRawMaterialVendorMasterList(Optional ByVal vendorName As String = "") As DataSet
        Dim DS As System.Data.DataSet
        Dim sqlParams(0) As SqlParameter

        sqlParams(0) = New SqlParameter()
        sqlParams(0).ParameterName = "@vendor_code"
        sqlParams(0).DbType = DbType.String
        sqlParams(0).Direction = Data.ParameterDirection.Input
        sqlParams(0).Value = If(Not String.IsNullOrWhiteSpace(vendorName), CObj(vendorName.Trim()), DBNull.Value)

        DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[opc_get_rawmaterial_vendor_list]", Data.CommandType.StoredProcedure, sqlParams)
        Return DS
    End Function
    Function GetRawMaterialVendorMasterEdit(ByVal vendorCode As String) As DataSet
        Dim DS As System.Data.DataSet
        Dim sqlParams(0) As SqlParameter

        sqlParams(0) = New SqlParameter()
        sqlParams(0).ParameterName = "@vendor_code"
        sqlParams(0).DbType = DbType.String
        sqlParams(0).Direction = Data.ParameterDirection.Input
        sqlParams(0).Value = vendorCode

        DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[opc_get_rawmaterial_vendor_edit]", Data.CommandType.StoredProcedure, sqlParams)
        Return DS
    End Function
    Function GetNextRawMaterialVendorCode() As DataSet
        Dim DS As System.Data.DataSet

        DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[opc_get_rawmaterial_vendor_next_code]", CommandType.StoredProcedure)

        'If Not (DS Is Nothing) AndAlso DS.Tables.Count > 0 AndAlso Not (DS.Tables(0) Is Nothing) AndAlso DS.Tables(0).Rows.Count > 0 Then
        '    Return Convert.ToString(DS.Tables(0).Rows(0)("vendor_code")).Trim()
        'End If

        'Return String.Empty
        Return DS
    End Function
    Function GetRawMaterialVendorList() As DataSet
        Dim DS As System.Data.DataSet
        DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[getrawmat_vendorlist]", CommandType.StoredProcedure)
        Return DS
    End Function
    Function GetRawMaterialVendorList_vr1() As DataSet
        Dim DS As System.Data.DataSet
        DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[getrawmat_vendorlist_vr1]", CommandType.StoredProcedure)
        Return DS
    End Function
#End Region

#Region "Raw Material Requisition"
    Function InsertUpdateRawMaterialRequisition(ByRef entity As RawMaterialRequisitionHeaderEntity, ByVal dtDetails As DataTable) As Integer

        Dim sqlConn As SqlConnection = Nothing
        sqlConn = DBFactory.GetHelper.OpenConnection()
        Dim MsgID As Integer
        Dim sqlParams(6) As SqlParameter

        Try

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@orh_Id"
            sqlParams(0).SqlDbType = SqlDbType.Int
            sqlParams(0).Direction = Data.ParameterDirection.Input
            sqlParams(0).Value = entity.RequestId

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@vendor_code"
            sqlParams(1).SqlDbType = SqlDbType.VarChar
            sqlParams(1).Size = 50
            sqlParams(1).Direction = Data.ParameterDirection.Input
            sqlParams(1).Value = entity.VendorCode

            sqlParams(2) = New SqlParameter()
            sqlParams(2).ParameterName = "@rawmaterial_vender_code"
            sqlParams(2).SqlDbType = SqlDbType.VarChar
            sqlParams(2).Size = 50
            sqlParams(2).Direction = Data.ParameterDirection.Input
            sqlParams(2).Value = entity.RawMaterialVendorCode

            sqlParams(3) = New SqlParameter()
            sqlParams(3).ParameterName = "@user_id"
            sqlParams(3).SqlDbType = SqlDbType.VarChar
            sqlParams(3).Size = 50
            sqlParams(3).Direction = Data.ParameterDirection.Input
            sqlParams(3).Value = entity.CreatedUser

            sqlParams(4) = New SqlParameter()
            sqlParams(4).ParameterName = "@tran_type"
            sqlParams(4).SqlDbType = SqlDbType.Int
            sqlParams(4).Direction = Data.ParameterDirection.Input
            sqlParams(4).Value = entity.Trantype

            sqlParams(5) = New SqlParameter()
            sqlParams(5).ParameterName = "@tbl_opc_request_dtls"
            sqlParams(5).SqlDbType = SqlDbType.Structured
            sqlParams(5).Direction = Data.ParameterDirection.Input
            sqlParams(5).TypeName = "dbo.tbl_opc_request_dtls"
            sqlParams(5).Value = dtDetails

            sqlParams(6) = New SqlParameter()
            sqlParams(6).ParameterName = "@outputCode"
            sqlParams(6).SqlDbType = SqlDbType.Int
            sqlParams(6).Direction = Data.ParameterDirection.Output

            Dim sqlCmd As New SqlCommand()
            sqlCmd.Connection = sqlConn
            sqlCmd.CommandType = CommandType.StoredProcedure
            sqlCmd.CommandText = "[dbo].[opc_rawmaterial_request_insert_update]"
            sqlCmd.Parameters.AddRange(sqlParams)
            sqlCmd.ExecuteNonQuery()

            If Not IsDBNull(sqlParams(6).Value) Then
                MsgID = Convert.ToInt32(sqlParams(6).Value)
                entity.RequestId = MsgID
            End If
        Catch ex As Exception
            Throw ex
        Finally
            If (sqlConn IsNot Nothing) Then
                sqlConn.Close()
            End If
        End Try
        Return MsgID
    End Function
    Function GetRawMaterialRequestList(ByVal vendorCode As String, ByVal rawmat_vendorCode As String, ByVal approval_status As String) As DataSet
        Dim DS As System.Data.DataSet
        Dim sqlParams(2) As SqlParameter

        sqlParams(0) = New SqlParameter()
        sqlParams(0).ParameterName = "@vendor_code"
        sqlParams(0).DbType = DbType.String
        sqlParams(0).Direction = Data.ParameterDirection.Input
        sqlParams(0).Value = If(Not String.IsNullOrWhiteSpace(vendorCode), CObj(vendorCode.Trim()), DBNull.Value)

        sqlParams(1) = New SqlParameter()
        sqlParams(1).ParameterName = "@rawmat_vendor_code"
        sqlParams(1).DbType = DbType.String
        sqlParams(1).Direction = Data.ParameterDirection.Input
        sqlParams(1).Value = If(Not String.IsNullOrWhiteSpace(rawmat_vendorCode), CObj(rawmat_vendorCode.Trim()), DBNull.Value)

        sqlParams(2) = New SqlParameter()
        sqlParams(2).ParameterName = "@approval_status"
        sqlParams(2).DbType = DbType.String
        sqlParams(2).Direction = Data.ParameterDirection.Input
        sqlParams(2).Value = If(Not String.IsNullOrWhiteSpace(approval_status), CObj(approval_status.Trim()), DBNull.Value)

        DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[getrawmaterial_requisitionlist]", Data.CommandType.StoredProcedure, sqlParams)
        Return DS
    End Function
    Function GetRawMaterialRequesteditt(ByVal requestid As Integer) As DataSet
        Dim DS As System.Data.DataSet
        Dim sqlParams(0) As SqlParameter

        sqlParams(0) = New SqlParameter()
        sqlParams(0).ParameterName = "@requestid"
        sqlParams(0).DbType = DbType.Int32
        sqlParams(0).Direction = Data.ParameterDirection.Input
        sqlParams(0).Value = requestid

        DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[getrawmaterial_requisition_editdata]", Data.CommandType.StoredProcedure, sqlParams)
        Return DS
    End Function
    Function ApproveRawMaterialRequest(ByVal userId As String, ByVal dtApprove As DataTable) As Integer
        Dim sqlConn As SqlConnection = Nothing
        Dim outputCode As Integer = 0
        Dim sqlParams(2) As SqlParameter

        Try
            If dtApprove Is Nothing OrElse dtApprove.Rows.Count = 0 Then
                Return 0
            End If

            sqlConn = DBFactory.GetHelper.OpenConnection()

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@user_id"
            sqlParams(0).SqlDbType = SqlDbType.VarChar
            sqlParams(0).Size = 50
            sqlParams(0).Direction = Data.ParameterDirection.Input
            sqlParams(0).Value = userId

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@tbl_opc_request_approve"
            sqlParams(1).SqlDbType = SqlDbType.Structured
            sqlParams(1).Direction = Data.ParameterDirection.Input
            sqlParams(1).TypeName = "dbo.tbl_opc_request_approve"
            sqlParams(1).Value = dtApprove

            sqlParams(2) = New SqlParameter()
            sqlParams(2).ParameterName = "@outputCode"
            sqlParams(2).SqlDbType = SqlDbType.Int
            sqlParams(2).Direction = Data.ParameterDirection.Output

            Dim sqlCmd As New SqlCommand()
            sqlCmd.Connection = sqlConn
            sqlCmd.CommandType = CommandType.StoredProcedure
            sqlCmd.CommandText = "[dbo].[opc_rawmaterial_request_approve]"
            sqlCmd.Parameters.AddRange(sqlParams)
            sqlCmd.ExecuteNonQuery()

            If Not IsDBNull(sqlParams(2).Value) Then
                outputCode = Convert.ToInt32(sqlParams(2).Value)
            End If
        Catch ex As Exception
            Throw ex
        Finally
            If (sqlConn IsNot Nothing) Then
                sqlConn.Close()
            End If
        End Try

        Return outputCode
    End Function
    Public Function GetUnitName(ByVal active As String) As DataSet
        Dim PrjectList As DataSet

        Dim sqlParams(0) As SqlParameter

        sqlParams(0) = New SqlParameter()
        sqlParams(0).ParameterName = "@active"
        sqlParams(0).DbType = DbType.String
        sqlParams(0).Direction = Data.ParameterDirection.Input
        sqlParams(0).Value = active

        PrjectList = DBFactory.GetHelper().ExecuteDataSet("[dbo].[GetUnitList]", Data.CommandType.StoredProcedure, sqlParams)
        Return PrjectList

    End Function
    Function GetRawMaterial_Requesteditt(ByVal vendor_id As String, ByVal rawmat_vendorcode As String) As DataSet
        Dim DS As System.Data.DataSet
        Dim sqlParams(1) As SqlParameter

        sqlParams(0) = New SqlParameter()
        sqlParams(0).ParameterName = "@vendor_id"
        sqlParams(0).DbType = DbType.String
        sqlParams(0).Direction = Data.ParameterDirection.Input
        sqlParams(0).Value = vendor_id

        sqlParams(1) = New SqlParameter()
        sqlParams(1).ParameterName = "@rawmat_vendorcode"
        sqlParams(1).DbType = DbType.String
        sqlParams(1).Direction = Data.ParameterDirection.Input
        sqlParams(1).Value = rawmat_vendorcode

        DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[getrawmaterial_vendorlink_data]", Data.CommandType.StoredProcedure, sqlParams)
        Return DS
    End Function
#End Region
#Region "Receipt Raw Material"
    Function GetRawMaterialReceiptList(ByVal rmvendorcode As String, ByVal status As String) As DataSet
        Dim DS As System.Data.DataSet
        Dim sqlParams(1) As SqlParameter

        sqlParams(0) = New SqlParameter()
        sqlParams(0).ParameterName = "@rmVendor_code"
        sqlParams(0).DbType = DbType.String
        sqlParams(0).Direction = Data.ParameterDirection.Input
        sqlParams(0).Value = If(Not String.IsNullOrWhiteSpace(rmvendorcode), CObj(rmvendorcode.Trim()), DBNull.Value)

        sqlParams(1) = New SqlParameter()
        sqlParams(1).ParameterName = "@status"
        sqlParams(1).DbType = DbType.String
        sqlParams(1).Direction = Data.ParameterDirection.Input
        sqlParams(1).Value = If(Not String.IsNullOrWhiteSpace(status), CObj(status.Trim()), DBNull.Value)

        'DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[opc_bulkreceiptlist]", Data.CommandType.StoredProcedure, sqlParams)
        DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[opc_bulkreceiptlist_vr1]", Data.CommandType.StoredProcedure, sqlParams)
        Return DS
    End Function
    Function GetRawMaterial_DespatchHdrList(ByVal despatchid As String) As DataSet
        Dim DS As System.Data.DataSet
        Dim sqlParams(0) As SqlParameter

        sqlParams(0) = New SqlParameter()
        sqlParams(0).ParameterName = "@despatchid"
        sqlParams(0).DbType = DbType.Int32
        sqlParams(0).Direction = Data.ParameterDirection.Input
        Dim despatchIdValue As Integer = 0
        Integer.TryParse(despatchid, despatchIdValue)
        sqlParams(0).Value = despatchIdValue

        DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[opc_getdespatch_headerdtls]", Data.CommandType.StoredProcedure, sqlParams)
        Return DS
    End Function

    Function GetRawMaterial_ReceivedHdrList(ByVal receiveid As String) As DataSet
        Dim DS As System.Data.DataSet
        Dim sqlParams(0) As SqlParameter

        sqlParams(0) = New SqlParameter()
        sqlParams(0).ParameterName = "@receiveid"
        sqlParams(0).DbType = DbType.Int32
        sqlParams(0).Direction = Data.ParameterDirection.Input
        Dim receiveIdValue As Integer = 0
        Integer.TryParse(receiveid, receiveIdValue)
        sqlParams(0).Value = receiveIdValue

        DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[opc_getreceived_headerdtls]", Data.CommandType.StoredProcedure, sqlParams)
        Return DS
    End Function

    Function InsertRawMaterialReceipt(ByVal dispatchId As Integer, ByVal userId As String, ByVal dtDetails As DataTable) As Integer
        Dim sqlConn As SqlConnection = Nothing
        Dim receiveId As Integer = 0
        Dim sqlParams(3) As SqlParameter

        Try
            sqlConn = DBFactory.GetHelper.OpenConnection()

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@dispatch_id"
            sqlParams(0).SqlDbType = SqlDbType.Int
            sqlParams(0).Direction = Data.ParameterDirection.Input
            sqlParams(0).Value = dispatchId

            'sqlParams(1) = New SqlParameter()
            'sqlParams(1).ParameterName = "@inv_no"
            'sqlParams(1).SqlDbType = SqlDbType.VarChar
            'sqlParams(1).Size = 100
            'sqlParams(1).Direction = Data.ParameterDirection.Input
            'sqlParams(1).Value = If(String.IsNullOrWhiteSpace(invNo), CObj(DBNull.Value), invNo)

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@user_id"
            sqlParams(1).SqlDbType = SqlDbType.VarChar
            sqlParams(1).Size = 50
            sqlParams(1).Direction = Data.ParameterDirection.Input
            sqlParams(1).Value = If(String.IsNullOrWhiteSpace(userId), CObj(DBNull.Value), userId)

            sqlParams(2) = New SqlParameter()
            sqlParams(2).ParameterName = "@tbl"
            sqlParams(2).SqlDbType = SqlDbType.Structured
            sqlParams(2).Direction = Data.ParameterDirection.Input
            sqlParams(2).TypeName = "dbo.tbl_received_dtls"
            sqlParams(2).Value = dtDetails

            sqlParams(3) = New SqlParameter()
            sqlParams(3).ParameterName = "@outputCode"
            sqlParams(3).SqlDbType = SqlDbType.Int
            sqlParams(3).Direction = Data.ParameterDirection.Output

            Dim sqlCmd As New SqlCommand()
            sqlCmd.Connection = sqlConn
            sqlCmd.CommandType = CommandType.StoredProcedure
            sqlCmd.CommandText = "[dbo].[opc_rawmaterial_receipt_insert]"
            sqlCmd.Parameters.AddRange(sqlParams)
            sqlCmd.ExecuteNonQuery()

            If Not IsDBNull(sqlParams(3).Value) Then
                Integer.TryParse(Convert.ToString(sqlParams(3).Value), receiveId)
            End If
        Catch ex As Exception
            Throw ex
        Finally
            If (sqlConn IsNot Nothing) Then
                sqlConn.Close()
            End If
        End Try

        Return receiveId
    End Function
#End Region

#Region "SKU formulation V2 (Product_Formulation: ratio + price + packaging, versioned) - added by MUKESH BHAGAT on 09-Oct-2026"
    ''' <summary>Result of [opc_sku_formulation_save]: Status 1 saved, 2 no change, 0 error.</summary>
    Public Class SkuFormulationSaveResult
        Public Property Status As Integer
        Public Property Message As String = ""
        Public Property HeaderId As Integer
        Public Property Version As Integer
    End Class

    ''' <summary>Empty TVP tables with the exact column layout of the three table types.</summary>
    Public Shared Function NewSkuFormulationDtlTable() As DataTable
        Dim t As New DataTable()
        t.Columns.Add("srl", GetType(Integer))
        t.Columns.Add("rawmat_code", GetType(String))
        t.Columns.Add("ratio", GetType(Decimal))
        t.Columns.Add("price", GetType(Decimal))
        t.Columns.Add("uom", GetType(String))
        Return t
    End Function

    Public Shared Function NewPackagingPackTable() As DataTable
        Dim t As New DataTable()
        t.Columns.Add("pack_key", GetType(Integer))
        t.Columns.Add("pack_size", GetType(String))
        t.Columns.Add("processing_fee", GetType(Decimal))
        t.Columns.Add("labour_charge", GetType(Decimal))
        t.Columns.Add("margin_pct", GetType(Decimal))
        Return t
    End Function

    Public Shared Function NewPackagingLineTable() As DataTable
        Dim t As New DataTable()
        t.Columns.Add("pack_key", GetType(Integer))
        t.Columns.Add("srl", GetType(Integer))
        t.Columns.Add("cost_name", GetType(String))
        t.Columns.Add("amount", GetType(Decimal))
        Return t
    End Function

    ''' <summary>[opc_sku_formulation_save] - new version of brand+vendor+product with raw materials and packaging in one transaction.</summary>
    Function SaveSkuFormulation(ByVal brandCode As String, ByVal vendorCode As String, ByVal productCode As String, ByVal remarks As String,
                                ByVal dtl As DataTable, ByVal packs As DataTable, ByVal lines As DataTable, ByVal userId As String) As SkuFormulationSaveResult
        Dim result As New SkuFormulationSaveResult()
        Dim sqlConn As SqlConnection = Nothing
        Try
            sqlConn = DBFactory.GetHelper.OpenConnection
            Dim sqlCmd As New SqlCommand("[dbo].[opc_sku_formulation_save]", sqlConn)
            sqlCmd.CommandType = CommandType.StoredProcedure
            sqlCmd.Parameters.Add("@brand_code", SqlDbType.VarChar, 50).Value = brandCode
            sqlCmd.Parameters.Add("@vendor_code", SqlDbType.VarChar, 50).Value = vendorCode
            sqlCmd.Parameters.Add("@product_code", SqlDbType.VarChar, 50).Value = productCode
            sqlCmd.Parameters.Add("@remarks", SqlDbType.VarChar, 500).Value = If(String.IsNullOrWhiteSpace(remarks), CObj(DBNull.Value), remarks.Trim())
            Dim pDtl As SqlParameter = sqlCmd.Parameters.Add("@dtl", SqlDbType.Structured) : pDtl.TypeName = "dbo.tbl_opc_sku_formulation_dtl" : pDtl.Value = dtl
            Dim pPack As SqlParameter = sqlCmd.Parameters.Add("@packs", SqlDbType.Structured) : pPack.TypeName = "dbo.tbl_opc_packaging_pack" : pPack.Value = packs
            Dim pLine As SqlParameter = sqlCmd.Parameters.Add("@lines", SqlDbType.Structured) : pLine.TypeName = "dbo.tbl_opc_packaging_line" : pLine.Value = lines
            sqlCmd.Parameters.Add("@user_id", SqlDbType.VarChar, 50).Value = userId
            Using dr As SqlDataReader = sqlCmd.ExecuteReader()
                If dr.Read() Then
                    result.Status = If(IsDBNull(dr("Status")), 0, Convert.ToInt32(dr("Status")))
                    result.Message = If(IsDBNull(dr("Message")), "", Convert.ToString(dr("Message")))
                    result.HeaderId = If(IsDBNull(dr("HeaderID")), 0, Convert.ToInt32(dr("HeaderID")))
                    result.Version = If(IsDBNull(dr("Version")), 0, Convert.ToInt32(dr("Version")))
                End If
            End Using
        Finally
            If sqlConn IsNot Nothing Then sqlConn.Close()
        End Try
        Return result
    End Function

    ''' <summary>[opc_sku_formulation_get] - table 0 header, 1 raw materials, 2 packs, 3 pack lines. Pass sfId, or 0 with the key for the current version.</summary>
    Function GetSkuFormulation(ByVal sfId As Integer, Optional ByVal brandCode As String = Nothing, Optional ByVal vendorCode As String = Nothing, Optional ByVal productCode As String = Nothing) As DataSet
        Dim sqlParams(3) As SqlParameter
        sqlParams(0) = New SqlParameter("@sf_id", SqlDbType.Int) With {.Value = If(sfId > 0, CObj(sfId), DBNull.Value)}
        sqlParams(1) = New SqlParameter("@brand_code", SqlDbType.VarChar, 50) With {.Value = If(String.IsNullOrWhiteSpace(brandCode), CObj(DBNull.Value), brandCode)}
        sqlParams(2) = New SqlParameter("@vendor_code", SqlDbType.VarChar, 50) With {.Value = If(String.IsNullOrWhiteSpace(vendorCode), CObj(DBNull.Value), vendorCode)}
        sqlParams(3) = New SqlParameter("@product_code", SqlDbType.VarChar, 50) With {.Value = If(String.IsNullOrWhiteSpace(productCode), CObj(DBNull.Value), productCode)}
        Return DBFactory.GetHelper().ExecuteDataSet("[dbo].[opc_sku_formulation_get]", Data.CommandType.StoredProcedure, sqlParams)
    End Function

    ''' <summary>[opc_sku_formulation_list] - current versions (history = "N") or every version (history = "Y").</summary>
    Function ListSkuFormulation(ByVal brandCode As String, ByVal vendorCode As String, ByVal productCode As String, ByVal history As String) As DataSet
        Dim sqlParams(3) As SqlParameter
        sqlParams(0) = New SqlParameter("@brand_code", SqlDbType.VarChar, 50) With {.Value = If(String.IsNullOrWhiteSpace(brandCode), CObj(DBNull.Value), brandCode.Trim())}
        sqlParams(1) = New SqlParameter("@vendor_code", SqlDbType.VarChar, 50) With {.Value = If(String.IsNullOrWhiteSpace(vendorCode), CObj(DBNull.Value), vendorCode.Trim())}
        sqlParams(2) = New SqlParameter("@product_code", SqlDbType.VarChar, 50) With {.Value = If(String.IsNullOrWhiteSpace(productCode), CObj(DBNull.Value), productCode.Trim())}
        sqlParams(3) = New SqlParameter("@history", SqlDbType.Char, 1) With {.Value = If(history = "Y", "Y", "N")}
        Return DBFactory.GetHelper().ExecuteDataSet("[dbo].[opc_sku_formulation_list]", Data.CommandType.StoredProcedure, sqlParams)
    End Function
#End Region

#Region "formulation matrix"
    Function GetFormulation_MatrixBindList(ByVal productcode As String) As DataSet
        Dim DS As System.Data.DataSet
        Dim sqlParams(0) As SqlParameter

        sqlParams(0) = New SqlParameter()
        sqlParams(0).ParameterName = "@product_code"
        sqlParams(0).DbType = DbType.String
        sqlParams(0).Direction = Data.ParameterDirection.Input
        sqlParams(0).Value = If(Not String.IsNullOrWhiteSpace(productcode), CObj(productcode.Trim()), DBNull.Value)

        DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[getformulation_matrix_datalist]", Data.CommandType.StoredProcedure, sqlParams)
        Return DS
    End Function

    Function GetFormulationMatrixList(ByVal productcode As String, ByVal brandcode As String, ByVal vendorcode As String) As DataSet
        Dim DS As System.Data.DataSet
        Dim sqlParams(2) As SqlParameter

        sqlParams(0) = New SqlParameter()
        sqlParams(0).ParameterName = "@product_code"
        sqlParams(0).DbType = DbType.String
        sqlParams(0).Direction = Data.ParameterDirection.Input
        sqlParams(0).Value = If(Not String.IsNullOrWhiteSpace(productcode), CObj(productcode.Trim()), DBNull.Value)

        sqlParams(1) = New SqlParameter()
        sqlParams(1).ParameterName = "@vendor_code"
        sqlParams(1).DbType = DbType.String
        sqlParams(1).Direction = Data.ParameterDirection.Input
        sqlParams(1).Value = If(Not String.IsNullOrWhiteSpace(vendorcode), CObj(vendorcode.Trim()), DBNull.Value)

        sqlParams(2) = New SqlParameter()
        sqlParams(2).ParameterName = "@brand_code"
        sqlParams(2).DbType = DbType.String
        sqlParams(2).Direction = Data.ParameterDirection.Input
        sqlParams(2).Value = If(Not String.IsNullOrWhiteSpace(brandcode), CObj(brandcode.Trim()), DBNull.Value)

        DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[getformulation_matrix_list]", Data.CommandType.StoredProcedure, sqlParams)
        Return DS
    End Function

    Function InsertFormulationMatrix(ByVal userId As String, ByVal tbl As DataTable) As Integer
        Dim sqlConn As SqlConnection = Nothing
        Dim outputCode As Integer = 0
        Dim sqlParams(2) As SqlParameter

        Try
            If tbl Is Nothing OrElse tbl.Rows.Count = 0 Then
                Return 0
            End If

            sqlConn = DBFactory.GetHelper.OpenConnection()

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@tbl"
            sqlParams(0).SqlDbType = SqlDbType.Structured
            sqlParams(0).TypeName = "dbo.tbl_opc_formulation_matrix"
            sqlParams(0).Direction = ParameterDirection.Input
            sqlParams(0).Value = tbl

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@userid"
            sqlParams(1).SqlDbType = SqlDbType.VarChar
            sqlParams(1).Size = 50
            sqlParams(1).Direction = ParameterDirection.Input
            sqlParams(1).Value = userId

            sqlParams(2) = New SqlParameter()
            sqlParams(2).ParameterName = "@outputCode"
            sqlParams(2).SqlDbType = SqlDbType.BigInt
            sqlParams(2).Direction = ParameterDirection.Output

            Dim sqlCmd As New SqlCommand()
            sqlCmd.Connection = sqlConn
            sqlCmd.CommandType = CommandType.StoredProcedure
            sqlCmd.CommandText = "[dbo].[opc_formulationmatrix_insert]"
            sqlCmd.Parameters.AddRange(sqlParams)
            sqlCmd.ExecuteNonQuery()

            If sqlParams(2).Value IsNot Nothing AndAlso Not IsDBNull(sqlParams(2).Value) Then
                outputCode = Convert.ToInt32(sqlParams(2).Value)
            End If
        Catch ex As Exception
            Throw
        Finally
            If sqlConn IsNot Nothing Then
                sqlConn.Close()
            End If
        End Try

        Return outputCode
    End Function

    Function UpdateFormulationMatrix(ByVal matrixId As Integer, ByVal rate As String, ByVal userId As String) As Integer
        Dim sqlConn As SqlConnection = Nothing
        Dim rowsAffected As Integer = 0

        Try
            sqlConn = DBFactory.GetHelper.OpenConnection()

            Dim sqlCmd As New SqlCommand()
            sqlCmd.Connection = sqlConn
            sqlCmd.CommandType = CommandType.StoredProcedure
            sqlCmd.CommandText = "[dbo].[opc_formulationmatrix_update]"
            sqlCmd.Parameters.AddWithValue("@id", matrixId)
            sqlCmd.Parameters.AddWithValue("@rate", If(String.IsNullOrWhiteSpace(rate), CObj(DBNull.Value), rate.Trim()))
            sqlCmd.Parameters.AddWithValue("@user_id", userId)

            Using dr As SqlDataReader = sqlCmd.ExecuteReader()
                If dr.Read() AndAlso Not IsDBNull(dr("Status")) Then
                    rowsAffected = Convert.ToInt32(dr("Status"))
                End If
            End Using
        Catch ex As Exception
            Throw
        Finally
            If sqlConn IsNot Nothing Then
                sqlConn.Close()
            End If
        End Try

        Return rowsAffected
    End Function
    'Function GetFormulation_MatrixList(ByVal productcode As String) As DataSet
    '    Dim DS As System.Data.DataSet
    '    Dim sqlParams(0) As SqlParameter

    '    sqlParams(0) = New SqlParameter()
    '    sqlParams(0).ParameterName = "@product_code"
    '    sqlParams(0).DbType = DbType.String
    '    sqlParams(0).Direction = Data.ParameterDirection.Input
    '    sqlParams(0).Value = If(Not String.IsNullOrWhiteSpace(productcode), CObj(productcode.Trim()), DBNull.Value)

    '    DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[getformulation_matrix_datalist]", Data.CommandType.StoredProcedure, sqlParams)
    '    Return DS
    'End Function
#End Region
#Region "Reports"
    Function GetRawMeterial_ProcurementReport(ByVal vendorcode As String, ByVal rawmat_vendorcode As String, ByVal FromDate As SqlDateTime, ByVal ToDate As SqlDateTime) As DataSet
        Dim DS As System.Data.DataSet
        Dim sqlParams(3) As SqlParameter

        sqlParams(0) = New SqlParameter()
        sqlParams(0).ParameterName = "@vendor_code"
        sqlParams(0).DbType = DbType.String
        sqlParams(0).Direction = Data.ParameterDirection.Input
        sqlParams(0).Value = If(Not String.IsNullOrWhiteSpace(vendorcode), CObj(vendorcode.Trim()), DBNull.Value)

        sqlParams(1) = New SqlParameter()
        sqlParams(1).ParameterName = "@rmVendor_code"
        sqlParams(1).DbType = DbType.String
        sqlParams(1).Direction = Data.ParameterDirection.Input
        sqlParams(1).Value = If(Not String.IsNullOrWhiteSpace(rawmat_vendorcode), CObj(rawmat_vendorcode.Trim()), DBNull.Value)

        sqlParams(2) = New SqlParameter()
        sqlParams(2).ParameterName = "@fromDate"
        sqlParams(2).DbType = DbType.Date
        sqlParams(2).Direction = Data.ParameterDirection.Input
        sqlParams(2).Value = (If(FromDate <> SqlDateTime.MinValue, FromDate, CObj(DBNull.Value)))

        sqlParams(3) = New SqlParameter()
        sqlParams(3).ParameterName = "@toDate"
        sqlParams(3).DbType = DbType.Date
        sqlParams(3).Direction = Data.ParameterDirection.Input
        sqlParams(3).Value = (If(ToDate <> SqlDateTime.MinValue, ToDate, CObj(DBNull.Value)))

        DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[GetRawMetirialProcurementList]", Data.CommandType.StoredProcedure, sqlParams)

        'Dim detailParams(3) As SqlParameter
        'For i As Integer = 0 To sqlParams.Length - 1
        '    Dim src As SqlParameter = sqlParams(i)
        '    Dim dest As New SqlParameter()
        '    dest.ParameterName = src.ParameterName
        '    dest.DbType = src.DbType
        '    dest.Direction = src.Direction
        '    dest.Value = src.Value
        '    detailParams(i) = dest
        'Next

        'Dim dsDetails As DataSet = DBFactory.GetHelper().ExecuteDataSet("[dbo].[GetRawMetirialProcurementDetailsList]", Data.CommandType.StoredProcedure, detailParams)
        'If Not (DS Is Nothing) AndAlso Not (dsDetails Is Nothing) AndAlso dsDetails.Tables.Count > 0 Then
        '    Dim dtDetails As DataTable = dsDetails.Tables(0).Copy()
        '    dtDetails.TableName = "Details"
        '    If DS.Tables.Count > 1 Then
        '        DS.Tables.RemoveAt(1)
        '    End If
        '    DS.Tables.Add(dtDetails)
        'End If

        Return DS
    End Function
#End Region
End Class
