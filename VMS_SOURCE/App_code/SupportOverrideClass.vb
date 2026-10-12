Imports System.Data
Imports System.Data.SqlClient
Imports System.Web
Imports System.Collections.Generic
Imports VMS.DataAccess

''' <summary>
''' Support Overrides - runtime switches kept in dbo.support_override_mstr and edited from
''' SupportOverrides.aspx, replacing hard-coded temporary exceptions (e.g. the V02 despatch
''' invoice-limit bypass) and the OCR flags that used to live in page script.
''' Added by MUKESH BHAGAT on 12-Oct-2026.
'''
''' Reading: the effective rows (active + inside their date range) are cached for CacheSeconds,
''' so a change on the support page is live within a minute without a redeploy.
''' A row scoped to a unit / vendor code wins over the '*' row of the same key.
''' </summary>
Public Class SupportOverrideClass

#Region "keys"
    Public Const DESPATCH_INVOICE_LIMIT_BYPASS As String = "DESPATCH_INVOICE_LIMIT_BYPASS"
    Public Const OCR_VALIDATION_ENABLED As String = "OCR_VALIDATION_ENABLED"
    Public Const OCR_FAIL_OPEN As String = "OCR_FAIL_OPEN"
    Public Const OCR_API_TIMEOUT_MS As String = "OCR_API_TIMEOUT_MS"

    ''' <summary>Catalogue shown on the support page: key, label, needs a unit scope, needs a value, value hint.</summary>
    Public Class OverrideType
        Public Property Key As String
        Public Property Label As String
        Public Property NeedsScope As Boolean
        Public Property NeedsValue As Boolean
        Public Property ValueHint As String
        Public Property Description As String
    End Class

    Public Shared ReadOnly Types As OverrideType() =
    {
        New OverrideType With {.Key = DESPATCH_INVOICE_LIMIT_BYPASS, .Label = "Despatch: allow invoice above PO-rate total (unit, date range)", .NeedsScope = True, .NeedsValue = False, .ValueHint = "",
                               .Description = "UnitDespatchPlanAddUpdateVr1: for the selected unit, in the date range, a Final Invoice Value higher than the Total Rate (Incl. GST) no longer blocks the challan. This replaces the hard-coded V02 exception."},
        New OverrideType With {.Key = OCR_VALIDATION_ENABLED, .Label = "OCR: validate the uploaded bill on Submit (Y/N)", .NeedsScope = False, .NeedsValue = True, .ValueHint = "Y or N",
                               .Description = "N = the bill is not checked by COLOURANT_INV_AI at all; the challan saves without OCR."},
        New OverrideType With {.Key = OCR_FAIL_OPEN, .Label = "OCR: continue saving when the OCR service fails (Y/N)", .NeedsScope = False, .NeedsValue = True, .ValueHint = "Y or N",
                               .Description = "Y = if the OCR service errors or times out the save proceeds; N = the save is blocked until OCR answers."},
        New OverrideType With {.Key = OCR_API_TIMEOUT_MS, .Label = "OCR: service timeout in milliseconds", .NeedsScope = False, .NeedsValue = True, .ValueHint = "e.g. 30000",
                               .Description = "How long Submit waits for the OCR service before treating it as failed."}
    }

    Public Shared Function FindType(ByVal key As String) As OverrideType
        For Each t As OverrideType In Types
            If String.Equals(t.Key, key, StringComparison.OrdinalIgnoreCase) Then Return t
        Next
        Return Nothing
    End Function
#End Region

#Region "effective values (cached)"
    Private Const CacheKey As String = "SupportOverride.Effective"
    Private Const CacheSeconds As Integer = 60

    Private Class Row
        Public Key As String
        Public Scope As String
        Public Value As String
    End Class

    Private Shared Function LoadEffective() As List(Of Row)
        Dim rows As List(Of Row) = TryCast(HttpRuntime.Cache(CacheKey), List(Of Row))
        If rows IsNot Nothing Then Return rows
        rows = New List(Of Row)()
        Try
            Dim ds As DataSet = DBFactory.GetHelper().ExecuteDataSet("[dbo].[support_override_get_effective]", CommandType.StoredProcedure)
            If ds IsNot Nothing AndAlso ds.Tables.Count > 0 Then
                For Each dr As DataRow In ds.Tables(0).Rows
                    rows.Add(New Row With {.Key = Convert.ToString(dr("so_key")).Trim(), .Scope = Convert.ToString(dr("so_scope")).Trim(), .Value = Convert.ToString(dr("so_value")).Trim()})
                Next
            End If
        Catch
            ' table / SP not deployed yet, or DB hiccup: behave as "no overrides" (callers use their defaults)
        End Try
        HttpRuntime.Cache.Insert(CacheKey, rows, Nothing, DateTime.UtcNow.AddSeconds(CacheSeconds), Caching.Cache.NoSlidingExpiration)
        Return rows
    End Function

    ''' <summary>Forget the cached rows (called by the support page after every save).</summary>
    Public Shared Sub ClearCache()
        HttpRuntime.Cache.Remove(CacheKey)
    End Sub

    ''' <summary>The effective row for key: the one scoped to scope if present, else the '*' row, else Nothing.</summary>
    Private Shared Function Find(ByVal key As String, ByVal scope As String) As Row
        Dim star As Row = Nothing
        For Each r As Row In LoadEffective()
            If Not String.Equals(r.Key, key, StringComparison.OrdinalIgnoreCase) Then Continue For
            If scope <> "" AndAlso String.Equals(r.Scope, scope, StringComparison.OrdinalIgnoreCase) Then Return r
            If r.Scope = "*" Then star = r
        Next
        Return star
    End Function

    ''' <summary>True when an active, in-date override of key exists for scope (unit / vendor code) or for everyone ('*').</summary>
    Public Shared Function IsActive(ByVal key As String, Optional ByVal scope As String = "") As Boolean
        Return Find(key, If(scope, "").Trim()) IsNot Nothing
    End Function

    ''' <summary>Value of the effective override, or defaultValue when none.</summary>
    Public Shared Function GetValue(ByVal key As String, ByVal defaultValue As String, Optional ByVal scope As String = "") As String
        Dim r As Row = Find(key, If(scope, "").Trim())
        Return If(r Is Nothing OrElse r.Value = "", defaultValue, r.Value)
    End Function

    Public Shared Function GetBool(ByVal key As String, ByVal defaultValue As Boolean, Optional ByVal scope As String = "") As Boolean
        Dim v As String = GetValue(key, "", scope).ToUpperInvariant()
        If v = "Y" OrElse v = "YES" OrElse v = "TRUE" OrElse v = "1" Then Return True
        If v = "N" OrElse v = "NO" OrElse v = "FALSE" OrElse v = "0" Then Return False
        Return defaultValue
    End Function

    Public Shared Function GetInt(ByVal key As String, ByVal defaultValue As Integer, Optional ByVal scope As String = "") As Integer
        Dim n As Integer
        Return If(Integer.TryParse(GetValue(key, "", scope), n) AndAlso n > 0, n, defaultValue)
    End Function
#End Region

#Region "support page data access"
    Public Function ListOverrides() As DataSet
        Return DBFactory.GetHelper().ExecuteDataSet("[dbo].[support_override_list]", CommandType.StoredProcedure)
    End Function

    Public Function SaveOverride(ByVal soId As Integer, ByVal key As String, ByVal scope As String, ByVal value As String, ByVal validFrom As Date?, ByVal validTo As Date?, ByVal remarks As String, ByVal userId As String) As Integer
        Dim sqlConn As SqlConnection = Nothing
        Try
            sqlConn = DBFactory.GetHelper.OpenConnection
            Dim cmd As New SqlCommand("[dbo].[support_override_save]", sqlConn)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@so_id", SqlDbType.Int).Value = soId
            cmd.Parameters.Add("@so_key", SqlDbType.VarChar, 50).Value = key
            cmd.Parameters.Add("@so_scope", SqlDbType.VarChar, 50).Value = If(String.IsNullOrWhiteSpace(scope), "*", scope.Trim())
            cmd.Parameters.Add("@so_value", SqlDbType.VarChar, 100).Value = If(String.IsNullOrWhiteSpace(value), CObj(DBNull.Value), value.Trim())
            cmd.Parameters.Add("@so_valid_from", SqlDbType.Date).Value = If(validFrom.HasValue, CObj(validFrom.Value), DBNull.Value)
            cmd.Parameters.Add("@so_valid_to", SqlDbType.Date).Value = If(validTo.HasValue, CObj(validTo.Value), DBNull.Value)
            cmd.Parameters.Add("@so_remarks", SqlDbType.VarChar, 500).Value = If(String.IsNullOrWhiteSpace(remarks), CObj(DBNull.Value), remarks.Trim())
            cmd.Parameters.Add("@user_id", SqlDbType.VarChar, 50).Value = userId
            Dim pOut As SqlParameter = cmd.Parameters.Add("@out_id", SqlDbType.Int)
            pOut.Direction = ParameterDirection.Output
            cmd.ExecuteNonQuery()
            ClearCache()
            Return If(pOut.Value Is Nothing OrElse IsDBNull(pOut.Value), 0, Convert.ToInt32(pOut.Value))
        Finally
            If sqlConn IsNot Nothing Then sqlConn.Close()
        End Try
    End Function

    Public Function SetActive(ByVal soId As Integer, ByVal activeYn As String, ByVal userId As String) As Integer
        Dim sqlParams(2) As SqlParameter
        sqlParams(0) = New SqlParameter("@so_id", SqlDbType.Int) With {.Value = soId}
        sqlParams(1) = New SqlParameter("@active_yn", SqlDbType.Char, 1) With {.Value = If(activeYn = "Y", "Y", "N")}
        sqlParams(2) = New SqlParameter("@user_id", SqlDbType.VarChar, 50) With {.Value = userId}
        Dim ds As DataSet = DBFactory.GetHelper().ExecuteDataSet("[dbo].[support_override_set_active]", CommandType.StoredProcedure, sqlParams)
        ClearCache()
        If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then Return Convert.ToInt32(ds.Tables(0).Rows(0)("Status"))
        Return 0
    End Function
#End Region
End Class
