Imports System.Data
Imports System.Data.SqlClient
Imports VMS.DataAccess

' Modified-by MUKESH BHAGAT on 15-09-2026 : data access for the new MIS Report page
' (mis_report.aspx) - Vendor Score Report export.
Public Class MisReportClass

    ''' <summary>SP [dbo].[vrs_getvendor_score_report] - author MMH, 18-03-2025.
    ''' Returns one row per vendor with a dynamic-pivot set of columns: unit_code, vendor, then
    ''' 4 quarters worth of columns (Q1_&lt;head&gt; ... Q1_total, Q1_grade_name, then Q2_.. Q3_.. Q4_..).
    ''' The exact head list (Audit/Complaints/Penalty/Quality/Service/Statutory today) is built by
    ''' the SP itself from dbo.vrs_vendor_dashboard for the selected year, so it is read generically
    ''' from the returned DataTable's columns rather than hard-coded here - see
    ''' MisVendorScoreExcelExport.vb.</summary>
    Public Function GetVendorScoreReport(ByVal finYear As String) As DataSet
        Dim ds As New DataSet
        Dim sqlParams(0) As SqlParameter

        sqlParams(0) = New SqlParameter()
        sqlParams(0).ParameterName = "@finyear"
        sqlParams(0).DbType = DbType.String
        sqlParams(0).Direction = ParameterDirection.Input
        sqlParams(0).Value = finYear

        ds = DBFactory.GetHelper().ExecuteDataSet("[dbo].[vrs_getvendor_score_report]", Data.CommandType.StoredProcedure, sqlParams)
        Return ds
    End Function

End Class
