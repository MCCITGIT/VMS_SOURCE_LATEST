Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports VMS.DataAccess

''' <summary>
''' Author: MUKESH BHAGAT  Created: 13-11-2026
''' Data access for the missing-invoice resubmission pages (MissingInvoiceUpload.aspx, MissingInvoiceReview.aspx).
''' Every call is a stored procedure created by Scripts\SQL\missing_invoice_resubmit_v1.sql; the table behind it is
''' dbo.challan_invoice_resubmit (staging only - nothing here changes a challan until head office maps an upload).
''' </summary>
Public Class MissingInvoiceClass

    Private Shared Function P(ByVal name As String, ByVal type As DbType, ByVal value As Object) As SqlParameter
        Dim prm As New SqlParameter()
        prm.ParameterName = name
        prm.DbType = type
        prm.Direction = ParameterDirection.Input
        prm.Value = If(value, DBNull.Value)
        Return prm
    End Function

    ''' <summary>Challans of one vendor (or all when unit is empty) that still have no invoice copy.</summary>
    Public Function GetMissingChallans(ByVal unit As String) As DataSet
        Dim prm(0) As SqlParameter
        prm(0) = P("@unit", DbType.String, unit)
        Return DBFactory.GetHelper().ExecuteDataSet("[cir_get_missing_challans]", CommandType.StoredProcedure, prm)
    End Function

    ''' <summary>Stages one vendor upload. Returns one row: ok (bit), msg, cir_id.</summary>
    Public Function Submit(ByVal unit As String, ByVal challanNo As Integer, ByVal invNo As String, ByVal invDate As Date,
                           ByVal fileName As String, ByVal orgFileName As String, ByVal docPath As String, ByVal userId As String) As DataSet
        Dim prm(7) As SqlParameter
        prm(0) = P("@unit", DbType.String, unit)
        prm(1) = P("@challan_no", DbType.Int32, challanNo)
        prm(2) = P("@inv_no", DbType.String, invNo)
        prm(3) = P("@inv_date", DbType.Date, invDate)
        prm(4) = P("@file_name", DbType.String, fileName)
        prm(5) = P("@org_filename", DbType.String, orgFileName)
        prm(6) = P("@doc_path", DbType.String, docPath)
        prm(7) = P("@user", DbType.String, userId)
        Return DBFactory.GetHelper().ExecuteDataSet("[cir_submit]", CommandType.StoredProcedure, prm)
    End Function

    ''' <summary>Head office list. status = PENDING / MAPPED / REJECTED / REPLACED / ALL.</summary>
    Public Function GetReview(ByVal status As String, ByVal unit As String) As DataSet
        Dim prm(1) As SqlParameter
        prm(0) = P("@status", DbType.String, status)
        prm(1) = P("@unit", DbType.String, unit)
        Return DBFactory.GetHelper().ExecuteDataSet("[cir_get_review]", CommandType.StoredProcedure, prm)
    End Function

    ''' <summary>Attaches a pending upload to its challan. Returns one row: ok (bit), msg.</summary>
    Public Function MapUpload(ByVal cirId As Integer, ByVal userId As String) As DataSet
        Dim prm(1) As SqlParameter
        prm(0) = P("@cir_id", DbType.Int32, cirId)
        prm(1) = P("@user", DbType.String, userId)
        Return DBFactory.GetHelper().ExecuteDataSet("[cir_map]", CommandType.StoredProcedure, prm)
    End Function

    ''' <summary>Rejects a pending upload with a reason. Returns one row: ok (bit), msg.</summary>
    Public Function RejectUpload(ByVal cirId As Integer, ByVal userId As String, ByVal remarks As String) As DataSet
        Dim prm(2) As SqlParameter
        prm(0) = P("@cir_id", DbType.Int32, cirId)
        prm(1) = P("@user", DbType.String, userId)
        prm(2) = P("@remarks", DbType.String, remarks)
        Return DBFactory.GetHelper().ExecuteDataSet("[cir_reject]", CommandType.StoredProcedure, prm)
    End Function

    ''' <summary>Reads ok/msg from the single result row of Submit / MapUpload / RejectUpload.</summary>
    Public Shared Function ReadResult(ByVal ds As DataSet, ByRef message As String) As Boolean
        If ds Is Nothing OrElse ds.Tables.Count = 0 OrElse ds.Tables(0).Rows.Count = 0 Then
            message = "No answer from the database."
            Return False
        End If
        message = Convert.ToString(ds.Tables(0).Rows(0)("msg"))
        Return Convert.ToBoolean(ds.Tables(0).Rows(0)("ok"))
    End Function
End Class
