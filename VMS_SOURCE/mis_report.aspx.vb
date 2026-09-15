Imports VMS.Web
Imports System.Data

' Modified-by MUKESH BHAGAT on 15-09-2026 : new page - MIS Report (Vendor Score Report export).
' Only a Fin Year dropdown + Export button; no grid, no on-screen preview. Fin Year list reused
' from vrs_legalscore_class.GetFinYear (same [VMS].[dbo].[VRS_Get_Fin_Year] SP vrs_legal_score.aspx
' already uses), so the year list stays identical to the rest of the VRS module.
Partial Class mis_report
    Inherits System.Web.UI.Page
    Dim userInfo As VMSUserEntity = New VMSUserEntity()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        CheckLogin()
        If Not IsPostBack Then
            PopulateFinYear()
        End If
    End Sub

    Private Sub CheckLogin()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        Else
            Response.Redirect("~/Login.aspx")
        End If
    End Sub

    Private Sub PopulateFinYear()
        Dim obj As New vrs_legalscore_class
        Dim ds As New DataSet
        ddlFinYear.Items.Clear()
        ds = obj.GetFinYear(userInfo.userIDEntity)
        If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
            ddlFinYear.DataSource = ds.Tables(0)
            ddlFinYear.DataTextField = "fin_year_text"
            ddlFinYear.DataValueField = "fin_year"
            ddlFinYear.DataBind()
            ddlFinYear.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
        End If
    End Sub

    Protected Sub btnExport_Click(ByVal sender As Object, ByVal e As EventArgs)
        CheckLogin()
        lblErrorMessage.Text = String.Empty

        If String.IsNullOrEmpty(ddlFinYear.SelectedValue) Then
            lblErrorMessage.Text = "Please select a Fin Year."
            Exit Sub
        End If

        Try
            Dim obj As New MisReportClass
            Dim ds As DataSet = obj.GetVendorScoreReport(ddlFinYear.SelectedValue)

            If ds Is Nothing OrElse ds.Tables.Count = 0 OrElse ds.Tables(0).Rows.Count = 0 Then
                lblErrorMessage.Text = "No data found for the selected Fin Year."
                Exit Sub
            End If

            MisVendorScoreExcelExport.ExportVendorScoreReport(ds, ddlFinYear.SelectedItem.Text, AppDomain.CurrentDomain.BaseDirectory, Response)

        Catch ex As System.Threading.ThreadAbortException
            ' expected - Response.End() inside the export raises this; the file has already been sent
            Throw
        Catch ex As Exception
            lblErrorMessage.Text = "Could not generate the report: " & ex.Message
        End Try
    End Sub

End Class
