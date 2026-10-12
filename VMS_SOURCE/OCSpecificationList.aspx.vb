Imports System
Imports System.Collections.Generic
Imports System.Linq
Imports System.Web
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports VMS.Web
Imports System.Data
Imports System.Data.SqlClient
Imports VMS.DataAccess
Imports System.Data.SqlTypes
Imports CrystalDecisions.CrystalReports
Imports CrystalDecisions.CrystalReports.Engine
Imports CrystalDecisions.ReportSource
Imports CrystalDecisions.Shared
Imports CrystalDecisions
Imports System.Security.Permissions
Imports Microsoft.Win32
Imports System.IO
Imports System.Globalization

Partial Class OCSpecificationList
    Inherits System.Web.UI.Page
    Dim userInfo As VMSUserEntity = New VMSUserEntity()
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        CheckLogin()
        AddAttributes()
        MaintainScrollPositionOnPostBack = True
        If Not IsPostBack Then
            'Modified-by MUKESH BHAGAT on 20-08-2026 : InvariantCulture so "/" is always emitted
            '(on en-IN machines "/" in a format string becomes "-", which broke FormatDate's Split("/"))
            txtFromDate.Text = DateTime.Now.ToString("dd/MM/yyyy", System.Globalization.CultureInfo.InvariantCulture)
            txtTodate.Text = DateTime.Now.ToString("dd/MM/yyyy", System.Globalization.CultureInfo.InvariantCulture)
            PopulateVender()
            PopulateProducts()
            BindGrid(ddlVender.SelectedValue, txtFromDate.Text, txtTodate.Text, ddlproduct.SelectedValue)
        End If
    End Sub
#Region "AddAttributes"
    Private Sub AddAttributes()
        txtFromDate.Attributes.Add("ReadOnly", "ReadOnly")
        txtTodate.Attributes.Add("ReadOnly", "ReadOnly")

    End Sub
#End Region
#Region "Check Login"
    Private Sub CheckLogin()

        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)

        Else
            Response.Redirect("~/Login.aspx")
        End If

    End Sub
#End Region
    Public Sub PopulateVender()
        Dim ds As DataSet
        Try
            Dim StockObj As New UnitDespatchClass
            ds = StockObj.GetUnit(String.Empty, Constant.Common.ActiveStatus)
            If ((Not (ds Is Nothing) And ds.Tables.Count > 0 And Not (ds.Tables(0) Is Nothing) And ds.Tables(0).Rows.Count > 0)) Then
                ddlVender.DataSource = ds.Tables(0)
                ddlVender.DataTextField = "unit_name"
                ddlVender.DataValueField = "unit_code"
                ddlVender.DataBind()
                ddlVender.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
            Else
                ddlVender.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
            End If
            If (userInfo.userGroupCodeEntity = "UNIT") Then
                ddlVender.SelectedValue = userInfo.userBranchEntity
                ddlVender.Enabled = False
            End If
        Catch ex As Exception
            Dim returnUrl = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Response.Redirect(returnUrl)
        End Try
    End Sub
    Public Sub PopulateProducts()
        Dim mstr As New OCSpecification
        Dim dsLovDtls As New DataSet
        Dim LovType As String = "OCS_PRODUCTS"
        dsLovDtls = mstr.GetProdDetails(userInfo.userIDEntity)
        If (Not (dsLovDtls Is Nothing) AndAlso dsLovDtls.Tables.Count > 0 AndAlso Not (dsLovDtls.Tables(0) Is Nothing) AndAlso dsLovDtls.Tables(0).Rows.Count > 0) Then
            ddlproduct.DataSource = dsLovDtls.Tables(0)
            ddlproduct.DataTextField = "lov_value"
            ddlproduct.DataValueField = "lov_code"
            ddlproduct.DataBind()
            ddlproduct.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
        End If

        If Not (userInfo.userGroupCodeEntity = Constant.UserFormAccess.SYSADMIN Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.HOMARKETING Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.HOACCOUNTS Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.UNIT) Then
            ddlproduct.SelectedValue = userInfo.userRegionEntity
            ddlproduct.Enabled = False
        End If
    End Sub
#Region "BindGrid"
    Protected Sub BindGrid(ByVal vender As String, ByVal FromDate As String, ByVal Todate As String, ByVal Product As String)
        Dim Fdate As SqlDateTime
        Dim Tdate As SqlDateTime
        Fdate = FormatDate(FromDate)
        Tdate = FormatDate(Todate)
        CheckLogin()
        Try
            Dim ocspecificationds As New DataSet
            Dim objOCSpecification As New OCSpecification
            ocspecificationds = objOCSpecification.OCSpecificationListData(vender, Fdate, Tdate, Product)
            If (Not (ocspecificationds Is Nothing) AndAlso ocspecificationds.Tables.Count > 0 AndAlso Not (ocspecificationds.Tables(0) Is Nothing) AndAlso ocspecificationds.Tables(0).Rows.Count > 0) Then
                gvOcSpecification.DataSource = ocspecificationds.Tables(0)
                gvOcSpecification.DataBind()

            Else
                gvOcSpecification.DataSource = Nothing
                gvOcSpecification.DataBind()
            End If
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.ErrorBindingGrid
            Server.Transfer(returnUrl)
        End Try
    End Sub
#End Region
#Region "Date Format"
    Public Function FormatDate(ByVal stringdate As String) As SqlDateTime

        If (stringdate.Equals(String.Empty)) Then
            Return SqlDateTime.MinValue
        End If

        If Not (stringdate = String.Empty) Then
            Dim ddate As String() = stringdate.Split("/")
            Dim arrlist As New ArrayList
            Dim index As Integer = 0

            While index <= ddate.Length - 1
                arrlist.Add(ddate(index))
                System.Math.Min(System.Threading.Interlocked.Increment(index), index - 1)
            End While
            Dim dd As Integer = System.Convert.ToInt32(arrlist.Item(0))
            Dim mm As Integer = System.Convert.ToInt32(arrlist.Item(1))
            Dim yyyy As Integer = System.Convert.ToInt32(arrlist.Item(2))

            Dim dt As DateTime = New DateTime(yyyy, mm, dd)
            dt = FormatDateTime(dt, DateFormat.LongDate)
            Return dt
        End If

    End Function
#End Region
    Protected Sub gvOcSpecification_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvOcSpecification.RowCommand
        If e.CommandName = "edit" Then
            Dim gv_row As GridViewRow = Nothing
            Dim index As Integer = 0
            gv_row = CType(((CType(e.CommandSource, ImageButton)).NamingContainer), GridViewRow)
            index = gv_row.RowIndex
            Dim hdhdrID As HiddenField = CType(gvOcSpecification.Rows(index).FindControl("hdhdrID"), HiddenField)
            Dim ID As Integer = Convert.ToInt32(hdhdrID.Value)
            Response.Redirect("OC_Specification_Dtls.aspx?OCS_ID=" & ID.ToString())
        End If
        If e.CommandName = "confirm" Then
            Dim gv_row As GridViewRow = Nothing
            Dim index As Integer = 0
            gv_row = CType(((CType(e.CommandSource, ImageButton)).NamingContainer), GridViewRow)
            index = gv_row.RowIndex
            Dim hdhdrID As HiddenField = CType(gvOcSpecification.Rows(index).FindControl("hdhdrID"), HiddenField)

            Dim sqlConn As SqlConnection = Nothing
            Dim sqlTrans As SqlTransaction = Nothing
            sqlConn = DBFactory.GetHelper.OpenConnection()
            sqlTrans = sqlConn.BeginTransaction()
            Dim numberroweffect As Integer = 0

            Try
                Dim OEntity As New OCSpecificationEntity
                Dim OCS As New OCSpecification
                OEntity.Auto_Id = Convert.ToInt32(hdhdrID.Value)
                OEntity.confirmed_by = userInfo.userIDEntity
                numberroweffect = OCS.ConfirmSpecification(OEntity, sqlConn, sqlTrans)
                If numberroweffect > 0 Then
                    sqlTrans.Commit()
                    lblPopMessage.Text = "Submited Successfully."
                Else
                    sqlTrans.Rollback()
                    lblPopMessage.Text = "Some Error Occured."
                End If
            Catch ex As Exception
                lblPopMessage.Text = "Some Error Occured."
            Finally
                sqlConn.Close()
                gvOcSpecification.EditIndex = -1
                BindGrid(ddlVender.SelectedValue, txtFromDate.Text, txtTodate.Text, ddlproduct.SelectedValue)
            End Try
        End If
        If e.CommandName = "download" Then
            Dim gv_row As GridViewRow = Nothing
            Dim index As Integer = 0
            gv_row = CType(((CType(e.CommandSource, ImageButton)).NamingContainer), GridViewRow)
            index = gv_row.RowIndex
            Dim hdhdrID As HiddenField = CType(gvOcSpecification.Rows(index).FindControl("hdhdrID"), HiddenField)

            Dim returnDS As DataSet = New DataSet()
            Dim dt As DataTable = New DataTable()
            Dim OCS As New OCSpecification
            Dim absPath As String = ConfigurationManager.AppSettings.[Get]("UPLOAD_DOCS_FOLDER_ABS_PATH")
            Dim genReportPath As String = String.Concat(Server.MapPath(Request.ApplicationPath), "PDF_Reports/")

            Try
                Dim appReceiptFileName As String = ""
                returnDS = OCS.GetOCSReport(Convert.ToInt32(hdhdrID.Value))
                If ((returnDS IsNot Nothing) AndAlso returnDS.Tables.Count > 0 AndAlso (returnDS.Tables IsNot Nothing) AndAlso returnDS.Tables(0).Rows.Count > 0) Then
                    appReceiptFileName = ExportOCSReport(genReportPath, returnDS.Tables(0))
                    Dim appReceiptFileAbsolutePath As String = String.Concat(genReportPath, appReceiptFileName)
                    If appReceiptFileName.Equals("") Then
                    Else
                        Response.Clear()
                        Response.Charset = String.Empty
                        Response.ContentType = GetMIMEType(appReceiptFileAbsolutePath)
                        Response.AppendHeader("Content-Disposition", "attachment; filename=OCSReport.pdf")
                        Response.TransmitFile(appReceiptFileAbsolutePath)
                        Response.Cache.SetCacheability(HttpCacheability.NoCache)
                        Response.Flush()
                    End If
                End If
            Catch ex As Exception
                Dim a As String = ex.Message
            End Try
        End If
    End Sub
    Protected Sub gvOcSpecification_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvOcSpecification.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim hdnconfirmstatus As HiddenField = e.Row.FindControl("hdnconfirmstatus")
            Dim btnconfirm As ImageButton = e.Row.FindControl("btnconfirm")
            Dim btndownload As ImageButton = e.Row.FindControl("btndownload")
            If hdnconfirmstatus.Value = "Y" Then
                btnconfirm.Visible = False
                btndownload.Visible = True
            End If

        End If
    End Sub
    'Protected Sub imgbtnSearch_Click(sender As Object, e As ImageClickEventArgs) Handles imgbtnSearch.Click
    '    BindGrid(ddlVender.SelectedValue, txtFromDate.Text, txtTodate.Text, ddlproduct.SelectedValue)
    'End Sub

    Protected Sub imgbtnSearch_Click(sender As Object, e As EventArgs) Handles imgbtnSearch.Click
        BindGrid(ddlVender.SelectedValue, txtFromDate.Text, txtTodate.Text, ddlproduct.SelectedValue)
    End Sub
    Public Function ExportOCSReport(ByVal genReportPath As String, ByVal dthdr As DataTable) As String
        Dim ds As DataSet = New DataSet()
        Dim dt1 As DataTable = New DataTable()
        dt1 = dthdr.Copy()
        dt1.TableName = "OCS_Product_Report"
        ds.Tables.Add(dt1)

        If Not (Directory.Exists(genReportPath)) Then
            Directory.CreateDirectory(genReportPath)
        End If

        Dim appReceiptFileName As String = String.Concat("OCSReport_", DateTime.Now.ToString("dd-MM-yyyy"), ".pdf")
        Dim appReceiptFileAbsolutePath As String = String.Concat(genReportPath, appReceiptFileName)
        Dim report As ReportDocument = New ReportDocument()

        report.FileName = AppDomain.CurrentDomain.BaseDirectory + Constant.ReportView.ReportName.OcsReport
        report.SetDataSource(ds)
        report.ExportToDisk(CrystalDecisions.[Shared].ExportFormatType.PortableDocFormat, appReceiptFileAbsolutePath)
        report.Close()
        report.Dispose()
        Return appReceiptFileName
    End Function
    Public Shared Function GetMIMEType(ByVal filepath As String) As String
        Dim regPerm As RegistryPermission = New RegistryPermission(RegistryPermissionAccess.Read, "\HKEY_CLASSES_ROOT")
        Dim classesRoot As RegistryKey = Registry.ClassesRoot
        Dim fileInfo = New FileInfo(filepath)
        Dim dotExt As String = (fileInfo.Extension).ToLower()
        Dim typeKey As RegistryKey = classesRoot.OpenSubKey("MIME\Database\Content Type")
        For Each keyname As String In typeKey.GetSubKeyNames()
            Dim curKey As RegistryKey = classesRoot.OpenSubKey("MIME\Database\Content Type\" & keyname)
            If curKey.GetValue("Extension") Is Nothing Then
                Continue For
            End If
            If String.Compare(curKey.GetValue("Extension").ToString(), dotExt, StringComparison.CurrentCultureIgnoreCase) = 0 Then
                Return keyname
            End If
        Next
        Return String.Empty
    End Function
End Class
