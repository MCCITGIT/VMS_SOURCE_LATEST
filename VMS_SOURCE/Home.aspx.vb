'Imports VMS.Common
'Imports VMS.BusinessFacade
Imports System.Data.SqlClient
Imports System.Data
Imports System.Text
Imports VMS.Web


Partial Class Home
    Inherits System.Web.UI.Page

    Dim drRow As DataRow
    Dim intSrlno1 As Integer
    Public strFlash As String
    Dim arrayQuick(1000, 1) As String
    Public strA, strToDay, strRegDay, strProj As String
    Dim strscroller As String

    Private Sub checkSession()
        Dim userInfo As VMSUserEntity = New VMSUserEntity()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        Else
            Response.Redirect("~/Login.aspx")
        End If
    End Sub

#Region "Page Load Events"
    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Dim userInfo As VMSUserEntity = New VMSUserEntity()
        If Not IsPostBack Then
            If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
                userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
                PopulateUnit()
                PopulateProcessYr()
                BindLoadDispatchChart()
                PopulateDashBoard()
                Dim srl As Integer = 0
                PopulateActionRequiredList(srl)
                PopulateNews()
                PopulateLastStockUpdateDate()
            Else
                Response.Redirect("~/Login.aspx")
            End If
        End If
    End Sub

    Private Sub PopulateUnit()
        Dim userInfo As VMSUserEntity = New VMSUserEntity()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        Else
            Response.Redirect("~/Login.aspx")
        End If
        Dim UnitDespatch As New PendingDespatchesClass
        Dim UnitSet As New DataSet

        UnitSet = UnitDespatch.GetUnitName(Constant.Common.ActiveStatus, String.Empty)
        If (Not (UnitSet Is Nothing) AndAlso UnitSet.Tables.Count > 0 AndAlso Not (UnitSet.Tables(0) Is Nothing) AndAlso UnitSet.Tables(0).Rows.Count > 0) Then
            ddlvendor.DataSource = UnitSet.Tables(0)
            ddlvendor.DataTextField = "unit_name"
            ddlvendor.DataValueField = "unit_code"
            ddlvendor.DataBind()
            ddlvendor.Items.Insert(0, New ListItem(Constant.Common.All, String.Empty, True))
        End If
        If (userInfo.userGroupCodeEntity = "UNIT") Then
            ddlvendor.SelectedValue = userInfo.userBranchEntity
            ddlvendor.Enabled = False
        End If
    End Sub

    Private Sub PopulateProcessYr()
        Dim userInfo As VMSUserEntity = New VMSUserEntity()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        Else
            Response.Redirect("~/Login.aspx")
        End If

        Dim ProcessYr As New Common
        Dim StandrdParams As New MonthlyUnitDespatch
        Dim YearSet As New DataSet
        Dim StandardYrMnth As New DataSet

        YearSet = ProcessYr.GetFinYrDetails(Constant.Common.Company, Constant.Common.ActiveStatus)
        StandardYrMnth = StandrdParams.GetMnthsYr(Constant.Common.ActiveStatus)
        If (Not (YearSet Is Nothing) AndAlso YearSet.Tables.Count > 0 AndAlso Not (YearSet.Tables(0) Is Nothing) AndAlso YearSet.Tables(0).Rows.Count > 0) Then
            ddlProcessYr.DataSource = YearSet.Tables(0)
            ddlProcessYr.DataTextField = "fin_year"
            ddlProcessYr.DataValueField = "fin_year"
            ddlProcessYr.DataBind()
            'ddlProcessYr.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
            'ddlProcessYr.Items.Insert(0, New ListItem("2011", String.Empty, True))
        End If
        'If Not (userInfo.userGroupCodeEntity = Constant.UserFormAccess.SYSADMIN Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.HOMARKETING Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.HOACCOUNTS Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.DEPOT) Then
        '    ddlProcessYr.SelectedValue = userInfo.currentFinancialYearEntity
        '    ddlProcessYr.Enabled = False
        'End If


        If (Not (StandardYrMnth Is Nothing) AndAlso StandardYrMnth.Tables.Count > 0 AndAlso Not (StandardYrMnth.Tables(0) Is Nothing) AndAlso StandardYrMnth.Tables(0).Rows.Count > 0) Then
            ddlProcessYr.SelectedValue = StandardYrMnth.Tables(0).Rows(0)("param_char_value")
            ddlProcessMnth.SelectedValue = StandardYrMnth.Tables(0).Rows(1)("param_char_value")
        End If

    End Sub

#End Region

#Region "Count Indents for Approval."
    Private Function getUnapprovedIndentsCount() As Integer

        Dim indIndentMaster As New IndentMaster()
        Dim dsIndentList As DataSet
        Dim indent_header As New IndentHeaderEntity()
        Dim row_count As Integer

        row_count = 0

        indent_header.IndentDepot = String.Empty
        indent_header.IndentFinYear = GetStandardParameter(Constant.Common.StandardParameter_ProcessYear)
        indent_header.IndentFinMonth = GetStandardParameter(Constant.Common.StandardParameter_ProcessMonth)
        indent_header.IndentStatus = "E"

        Try
            dsIndentList = indIndentMaster.GetIndentCount(indent_header)
            row_count = CType(dsIndentList.Tables(0).Rows(0)(0).ToString, Integer)
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Server.Transfer(returnUrl)
        End Try

        Return row_count
    End Function
#End Region

#Region "Count Despatch Challans for Approval."
    Private Function getUnapprovedDespatchChallan(ByVal user_unit As String) As Integer

        Dim cmn As New Common()
        Dim ds As DataSet
        Dim unit As String
        Dim fin_year As String
        Dim fin_month As String

        Dim row_count As Integer

        row_count = 0

        unit = user_unit
        fin_year = GetStandardParameter(Constant.Common.StandardParameter_ProcessYear)
        fin_month = GetStandardParameter(Constant.Common.StandardParameter_ProcessMonth)

        Try
            ds = cmn.GetUnapprovedDespatchCount(unit, fin_year, fin_month)
            row_count = CType(ds.Tables(0).Rows(0)(0).ToString, Integer)
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Server.Transfer(returnUrl)
        End Try

        Return row_count
    End Function
#End Region

#Region "Count Despatch Challans for Approval."
    Private Function getNewDocUploadedCount(ByVal depot As String) As Integer

        Dim cmn As New Common()
        Dim ds As DataSet

        Dim row_count As Integer

        row_count = 0

        Try
            ds = cmn.GetNewDocUploadedCount(depot)
            row_count = CType(ds.Tables(0).Rows(0)(0).ToString, Integer)
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Server.Transfer(returnUrl)
        End Try

        Return row_count
    End Function
#End Region

#Region "Populate Action Required List"

    'Modified-by MUKESH BHAGAT on 20-08-2026 : restored from old UAT source
    Private Sub PopulateActionRequiredList(ByVal srlint As Integer)

        Dim userInfo As VMSUserEntity = New VMSUserEntity()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        Else
            Response.Redirect("~/Login.aspx")
        End If

        If (userInfo.userGroupCodeEntity = Constant.UserFormAccess.SYSADMIN Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.HOMARKETING) Then
            Dim unapproved_indt_count As Integer = getUnapprovedIndentsCount()

            If unapproved_indt_count > 0 Then
                tdActionReq.InnerHtml = "<a href='IndentsList.aspx' >" + (srlint + 1).ToString + ". Unapproved Indents - ( " + unapproved_indt_count.ToString + " )" + "</a><br/>"
                srlint += 1
            End If

            Dim new_docs_count As Integer = getNewDocUploadedCount(userInfo.userBranchEntity)

            If new_docs_count > 0 Then
                tdActionReq.InnerHtml += "<a href='Doc_Upload.aspx' class='chi'>" + (srlint + 1).ToString + ". New Documents - ( " + new_docs_count.ToString + " )" + "</a><br/>"
                srlint += 1
            End If

        ElseIf (userInfo.userGroupCodeEntity = Constant.UserFormAccess.UNIT) Then
            Dim unapproved_desp_challan_count As Integer = getUnapprovedDespatchChallan(userInfo.userIDEntity)

            If unapproved_desp_challan_count > 0 Then
                tdActionReq.InnerHtml += "<a href='UnitDespatchPlanList.aspx' class='chi'>" + (srlint + 1).ToString + ". Unapproved Despatch Challans - ( " + unapproved_desp_challan_count.ToString + " )" + "</a><br/>"
                srlint += 1
            End If
        ElseIf (userInfo.userGroupCodeEntity = Constant.UserFormAccess.SYSADMIN Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.HOMARKETING Or userInfo.userGroupCodeEntity = Constant.UserFormAccess.DEPOT) Then
            Dim new_docs_count As Integer = getNewDocUploadedCount(userInfo.userBranchEntity)

            If new_docs_count > 0 Then
                tdActionReq.InnerHtml += "<a href='Doc_Upload.aspx' class='chi'>" + (srlint + 1).ToString + ". New Documents (last 15 days) - ( " + new_docs_count.ToString + " )" + "</a><br/>"
                srlint += 1
            End If
        End If

    End Sub

#End Region

#Region "PopulateMenus"

    Public Sub PopulateMenus()

        Dim userInfo As VMSUserEntity = New VMSUserEntity()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)

            Dim userDetailsObject As New UserLogin()
            Dim adminDataSet As DataSet
            adminDataSet = userDetailsObject.LoginUserFormAccess(userInfo.userCompanyEntity, userInfo.userIDEntity, userInfo.userGroupCodeEntity)
            If (Not (adminDataSet Is Nothing) AndAlso adminDataSet.Tables.Count > 0) Then
                If (Not (adminDataSet.Tables(0) Is Nothing) AndAlso adminDataSet.Tables(0).Rows.Count > 0) Then

                    Dim strMenu As String

                    Dim arrayMenuSysAdmin(1000, 1) As String
                    Dim arrayMenuHOMarketing(1000, 1) As String
                    Dim arrayMenuDepot(1000, 1) As String
                    Dim arrayMenuDespatchUnit(1000, 1) As String
                    Dim arrayMenuToken(1000, 1) As String
                    Dim arrayMenuQC(1000, 1) As String
                    Dim arrayMenuVRS(1000, 1) As String

                    Dim intSrlno1 As Integer
                    Dim intSrlno2 As Integer
                    Dim intSrlno3 As Integer
                    Dim intSrlno4 As Integer
                    Dim intSrlno5 As Integer
                    Dim intSrlno6 As Integer
                    Dim intSrlno7 As Integer

                    Dim blnSysAdmin As Integer
                    Dim blnHOMarketing As Integer
                    Dim blnDepot As Integer
                    Dim blnDespatch As Integer
                    Dim blnToken As Integer
                    Dim blnQC As Integer
                    Dim blnVRS As Integer

                    Dim intI As Integer
                    Dim strSplit() As String

                    'imgScoreCard.Visible = False
                    'imgDashBoard.Visible = False

                    For Each dRow In adminDataSet.Tables(0).Rows
                        If Trim(dRow.Item(0).ToString) = Constant.UserFormAccess.SYSADMIN Then


                            'If Trim(drRow.Item(2).ToString) = "Dash Board" Then
                            'imgDashBoard.Visible = True
                            'Else
                            intSrlno1 += 1
                            arrayMenuSysAdmin(intSrlno1, 1) = Trim(dRow.Item(2).ToString) & "|" & Trim(dRow.Item(3).ToString) & "?rand=" & Server.UrlEncode(Now())
                            'End If
                        ElseIf Trim(dRow.Item(0).ToString) = Constant.UserFormAccess.HOMARKETING Then
                            intSrlno2 += 1
                            arrayMenuHOMarketing(intSrlno2, 1) = Trim(dRow.Item(2).ToString) & "|" & Trim(dRow.Item(3).ToString) & "?rand=" & Server.UrlEncode(Now())
                        ElseIf Trim(dRow.Item(0).ToString) = Constant.UserFormAccess.DEPOT Then
                            intSrlno3 += 1
                            arrayMenuDepot(intSrlno3, 1) = Trim(dRow.Item(2).ToString) & "|" & Trim(dRow.Item(3).ToString) & "?rand=" & Server.UrlEncode(Now())
                        ElseIf Trim(dRow.Item(0).ToString) = Constant.UserFormAccess.UNIT Then
                            intSrlno4 += 1
                            arrayMenuDespatchUnit(intSrlno4, 1) = Trim(dRow.Item(2).ToString) & "|" & Trim(dRow.Item(3).ToString) & "?rand=" & Server.UrlEncode(Now())
                        ElseIf Trim(dRow.Item(0).ToString) = Constant.UserFormAccess.TOKEN Then
                            intSrlno5 += 1
                            arrayMenuToken(intSrlno5, 1) = Trim(dRow.Item(2).ToString) & "|" & Trim(dRow.Item(3).ToString) & "?rand=" & Server.UrlEncode(Now())
                        ElseIf Trim(dRow.Item(0).ToString) = Constant.UserFormAccess.QC Then
                            intSrlno6 += 1
                            arrayMenuQC(intSrlno6, 1) = Trim(dRow.Item(2).ToString) & "|" & Trim(dRow.Item(3).ToString) & "?rand=" & Server.UrlEncode(Now())
                        ElseIf Trim(dRow.Item(0).ToString) = Constant.UserFormAccess.VRS Then
                            intSrlno7 += 1
                            arrayMenuVRS(intSrlno7, 1) = Trim(dRow.Item(2).ToString) & "|" & Trim(dRow.Item(3).ToString) & "?rand=" & Server.UrlEncode(Now())
                        End If

                    Next

                    If arrayMenuSysAdmin(1, 1) <> "" Then blnSysAdmin = 1 Else blnSysAdmin = 0
                    If arrayMenuHOMarketing(1, 1) <> "" Then blnHOMarketing = 1 Else blnHOMarketing = 0
                    If arrayMenuDepot(1, 1) <> "" Then blnDepot = 1 Else blnDepot = 0
                    If arrayMenuDespatchUnit(1, 1) <> "" Then blnDespatch = 1 Else blnDespatch = 0
                    If arrayMenuToken(1, 1) <> "" Then blnToken = 1 Else blnToken = 0
                    If arrayMenuQC(1, 1) <> "" Then blnQC = 1 Else blnQC = 0
                    If arrayMenuVRS(1, 1) <> "" Then blnVRS = 1 Else blnVRS = 0

                    '-- Build Javasript code Dyanamically
                    strMenu = "<SCRIPT LANGUAGE=javascript>"
                    strMenu = strMenu & " eDW('<ul class=components id=sidebarNavToggle>');"

                    '-- System Administration Menu
                    If arrayMenuSysAdmin(1, 1) <> "" Then
                        'strMenu = strMenu & "eDW('<TR align=left>');"
                        strMenu = strMenu & "eDW('<li>');"
                        strMenu = strMenu & "eMF('e1d1','','<i class=""fa fa-cogs""></i>System Administration','fnClose(" & blnSysAdmin & "," & blnHOMarketing & "," & blnDepot & "," & blnDespatch & "," & blnToken & ",1)');"
                        For intI = 1 To UBound(arrayMenuSysAdmin)
                            If arrayMenuSysAdmin(intI, 1) <> "" Then
                                strSplit = Split(arrayMenuSysAdmin(intI, 1), "|")
                                strMenu = strMenu & "eLK('e1d1L1','i','" & strSplit(0) & "','" & strSplit(1) & "');"
                            Else
                                Exit For
                            End If
                        Next
                        strMenu = strMenu & "eDE();"
                        strMenu = strMenu & "eDW('</li>');"
                        'strMenu = strMenu & "eDW('</tR>');"
                    End If

                    '*********HOMARKETING Menu
                    If arrayMenuHOMarketing(1, 1) <> "" Then
                        'strMenu = strMenu & "eDW('<TR align=left>');"
                        strMenu = strMenu & "eDW('<li>');"
                        strMenu = strMenu & "eMF('e1d2','','<i class=""fa fa-home""></i>Distribution & Logistics','fnClose(" & blnSysAdmin & "," & blnHOMarketing & "," & blnDepot & "," & blnDespatch & "," & blnToken & ",2)');"
                        For intI = 1 To UBound(arrayMenuHOMarketing)
                            If arrayMenuHOMarketing(intI, 1) <> "" Then
                                strSplit = Split(arrayMenuHOMarketing(intI, 1), "|")
                                strMenu = strMenu & "eLK('e1d2L2','i','" & strSplit(0) & "','" & strSplit(1) & "');"
                            Else
                                Exit For
                            End If
                        Next
                        strMenu = strMenu & "eDE();"
                        strMenu = strMenu & "eDW('</li>');"
                        'strMenu = strMenu & "eDW('</tR>');"
                    End If

                    '*********Depot Menu
                    If arrayMenuDepot(1, 1) <> "" Then
                        'strMenu = strMenu & "eDW('<TR align=left>');"
                        strMenu = strMenu & "eDW('<li>');"
                        strMenu = strMenu & "eMF('e1d3','','<i class=""fa fa-street-view""></i>Depot','fnClose(" & blnSysAdmin & "," & blnHOMarketing & "," & blnDepot & "," & blnDespatch & "," & blnToken & ",3)');"
                        For intI = 1 To UBound(arrayMenuDepot)
                            If arrayMenuDepot(intI, 1) <> "" Then
                                strSplit = Split(arrayMenuDepot(intI, 1), "|")
                                strMenu = strMenu & "eLK('e1d3L3','i','" & strSplit(0) & "','" & strSplit(1) & "');"
                            Else
                                Exit For
                            End If
                        Next
                        strMenu = strMenu & "eDE();"
                        strMenu = strMenu & "eDW('</li>');"
                        'strMenu = strMenu & "eDW('</tR>');"
                    End If

                    '*********Shipper Menu
                    If arrayMenuDespatchUnit(1, 1) <> "" Then
                        'strMenu = strMenu & "eDW('<TR align=left>');"
                        strMenu = strMenu & "eDW('<li>');"
                        strMenu = strMenu & "eMF('e1d4','','<i class=""fa fa-universal-access""></i>Despatch Unit','fnClose(" & blnSysAdmin & "," & blnHOMarketing & "," & blnDepot & "," & blnDespatch & "," & blnToken & ",4)');"
                        For intI = 1 To UBound(arrayMenuDespatchUnit)
                            If arrayMenuDespatchUnit(intI, 1) <> "" Then
                                strSplit = Split(arrayMenuDespatchUnit(intI, 1), "|")
                                strMenu = strMenu & "eLK('e1d4L4','i','" & strSplit(0) & "','" & strSplit(1) & "');"
                            Else
                                Exit For
                            End If
                        Next
                        strMenu = strMenu & "eDE();"
                        strMenu = strMenu & "eDW('</li>');"
                        'strMenu = strMenu & "eDW('</tR>');"
                    End If


                    '*********Token Menu
                    If arrayMenuToken(1, 1) <> "" Then
                        'strMenu = strMenu & "eDW('<TR align=left>');"
                        strMenu = strMenu & "eDW('<li>');"
                        strMenu = strMenu & "eMF('e1d5','','<i class=""fa fa-tag""></i>Token Requisition','fnClose(" & blnSysAdmin & "," & blnHOMarketing & "," & blnDepot & "," & blnDespatch & "," & blnToken & ",5)');"
                        For intI = 1 To UBound(arrayMenuToken)
                            If arrayMenuToken(intI, 1) <> "" Then
                                strSplit = Split(arrayMenuToken(intI, 1), "|")
                                strMenu = strMenu & "eLK('e1d5L5','i','" & strSplit(0) & "','" & strSplit(1) & "');"
                            Else
                                Exit For
                            End If
                        Next
                        strMenu = strMenu & "eDE();"
                        strMenu = strMenu & "eDW('</li>');"
                        'strMenu = strMenu & "eDW('</tR>');"
                    End If

                    '*********Qulity Control Menu
                    If arrayMenuQC(1, 1) <> "" Then
                        'strMenu = strMenu & "eDW('<TR align=left>');"
                        strMenu = strMenu & "eDW('<li>');"
                        strMenu = strMenu & "eMF('e1d6','','<i class=""fa fa-plug""></i>Qulity Control','fnClose(" & blnSysAdmin & "," & blnHOMarketing & "," & blnDepot & "," & blnDespatch & "," & blnToken & "," & blnQC & ",6)');"
                        For intI = 1 To UBound(arrayMenuQC)
                            If arrayMenuQC(intI, 1) <> "" Then
                                strSplit = Split(arrayMenuQC(intI, 1), "|")
                                strMenu = strMenu & "eLK('e1d6L6','i','" & strSplit(0) & "','" & strSplit(1) & "');"
                            Else
                                Exit For
                            End If
                        Next
                        strMenu = strMenu & "eDE();"
                        strMenu = strMenu & "eDW('</li>');"
                        'strMenu = strMenu & "eDW('</tR>');"
                    End If

                    '*********Vendor Reating
                    '-----Mothar statrt
                    If arrayMenuVRS(1, 1) <> "" Then
                        'strMenu = strMenu & "eDW('<TR align=left>');"
                        strMenu = strMenu & "eDW('<li>');"
                        strMenu = strMenu & "eMF('e1d7','','<i class=""fa fa-star""></i>Vendor Reating','fnClose(" & blnSysAdmin & "," & blnHOMarketing & "," & blnDepot & "," & blnDespatch & "," & blnToken & "," & blnQC & "," & blnVRS & ",7)');"
                        For intI = 1 To UBound(arrayMenuVRS)
                            If arrayMenuVRS(intI, 1) <> "" Then
                                strSplit = Split(arrayMenuVRS(intI, 1), "|")
                                strMenu = strMenu & "eLK('e1d6L7','i','" & strSplit(0) & "','" & strSplit(1) & "');"
                            Else
                                Exit For
                            End If
                        Next
                        strMenu = strMenu & "eDE();"
                        strMenu = strMenu & "eDW('</li>');"
                        'strMenu = strMenu & "eDW('</tR>');"
                    End If
                    '-----Mothar end


                    strMenu = strMenu & "eDW('</ul>');"
                    strMenu = strMenu & "document.write(eGSTR);"
                    strMenu = strMenu & "eGSTR='';"
                    strMenu = strMenu & "if(eMW3C){eF0()};"
                    strMenu = strMenu & "if(window.pageXOffset==0){eV0=true}else if(eIE){eV1=true};"
                    strMenu = strMenu & "if(eGB){eF1()}"

                    '-- Modify below function whenever any menu item is added
                    strMenu = strMenu & "function fnClose(SysAdmn,HOMarketing,Depot,DespatchUnit,Token,QC,chk)"
                    strMenu = strMenu & "{"
                    strMenu = strMenu & " if (SysAdmn==1 && 1!=chk)"
                    strMenu = strMenu & " eCS('e1d1');"
                    strMenu = strMenu & " if (HOMarketing==1 && 2!=chk)"
                    strMenu = strMenu & " eCS('e1d2');"
                    strMenu = strMenu & " if (Depot==1 && 3!=chk)"
                    strMenu = strMenu & " eCS('e1d3');"
                    strMenu = strMenu & " if (DespatchUnit==1 && 4!=chk)"
                    strMenu = strMenu & " eCS('e1d4');"
                    strMenu = strMenu & " if (Token==1 && 5!=chk)"
                    strMenu = strMenu & " eCS('e1d5');"
                    strMenu = strMenu & " if (QC==1 && 6!=chk)"
                    strMenu = strMenu & " eCS('e1d6');"
                    strMenu = strMenu & " if (QC==1 && 7!=chk)"
                    strMenu = strMenu & " eCS('e1d7');"
                    strMenu = strMenu & " }"
                    strMenu = strMenu & "</SCRIPT>"

                    '-- Assign the Javascript Built code to the Literal Constant
                    '_clientScript.Text = strMenu

                    'Today_Reg(userInfo.userCompanyEntity)
                    'Active_Proj(userInfo.userCompanyEntity)
                    QuickLinksGetDetails()
                    'Dim srlint As Integer = 0
                    'ActionReqGetDetails(srlint)

                End If
            End If

        Else
            Response.Redirect("~/Login.aspx")
        End If
    End Sub
#End Region

#Region "Today Registration"

    Public Sub Today_Reg(ByVal Logincompany As String)

        Dim userDetailsObject As New UserLogin()
        Dim TodayRegSet As DataSet
        TodayRegSet = userDetailsObject.GetTodayReg(Logincompany)
        If (Not (TodayRegSet Is Nothing) AndAlso TodayRegSet.Tables.Count > 0) Then
            If (Not (TodayRegSet.Tables(0) Is Nothing) AndAlso TodayRegSet.Tables(0).Rows.Count > 0) Then
                Dim i As Integer
                strscroller = ""
                For i = 0 To TodayRegSet.Tables(0).Rows.Count - 1
                    strscroller &= (i + 1).ToString & ". Plot " & "<strong><font color='yellow'> " & TodayRegSet.Tables(0).Rows(i)("bk_plot_display").ToString() & "</font></strong>" & "&nbsp;" & "Layout: " & "<strong><font color='yellow'> " & TodayRegSet.Tables(0).Rows(i)("prj_layout_name").ToString() & "</font></strong>" & "&nbsp;" & "Client: " & "<strong><font color='yellow'> " & TodayRegSet.Tables(0).Rows(i)("clientname").ToString() & "</font></strong>" & "&nbsp;" & "ME: " & "<strong><font color='yellow'> " & TodayRegSet.Tables(0).Rows(i)("usp_initials").ToString() & "</font></strong>" & "&nbsp</br></br>"
                Next
                strscroller = "<marquee id=mar1 style='height:60px;' SCROLLDELAY=300 direction=up onmouseover='this.stop();' onmouseout='this.start();'>" & strscroller & "</marquee>"
                'reg_marquee_scroll.InnerHtml = strscroller

            End If
        Else
            Response.Redirect("~/Login.aspx")
        End If

    End Sub

#End Region

#Region "QuickLinks Get Details"

    Private Sub QuickLinksGetDetails()

        Dim userInfo As VMSUserEntity = New VMSUserEntity()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)

        Else
            Response.Redirect("~/Login.aspx")
        End If

        If userInfo.userGroupCodeEntity.Equals("UNIT") Then
            tblComplainRegistrationLink.Visible = True
        Else
            tblComplainRegistrationLink.Visible = False
        End If

        Dim QuickLinkGet As New UserLogin
        Dim QuickLinksList As DataSet

        QuickLinksList = QuickLinkGet.GetQuickLink(userInfo.userCompanyEntity, userInfo.userGroupCodeEntity)
        If (Not (QuickLinksList Is Nothing) AndAlso QuickLinksList.Tables.Count > 0) Then
            If (Not (QuickLinksList.Tables(0) Is Nothing) AndAlso QuickLinksList.Tables(0).Rows.Count > 0) Then

                Dim i As Integer
                strscroller = ""
                Dim html = ""
                For i = 0 To QuickLinksList.Tables(0).Rows.Count - 1
                    html &= "<div class='menu-item' role='menuitem' tabindex='0' onclick=""window.open('" & QuickLinksList.Tables(0).Rows(i)("form_name").ToString() & "', '_blank').focus();"">" &
                                "<div class='icon'><img src='./images/q-links.png' alt='Link'></div>" &
                                "<span>" & QuickLinksList.Tables(0).Rows(i)("form_desc").ToString() & "</span>" &
                            "</div>"
                    strscroller &= "<li><a href='" + QuickLinksList.Tables(0).Rows(i)("form_name") + "'title='" & QuickLinksList.Tables(0).Rows(i)("form_desc").ToString() & "'><i class='fa fa-dot-circle'></i>" + QuickLinksList.Tables(0).Rows(i)("form_desc").ToString() + "</a></li>"
                Next
                tdQuickLink.InnerHtml = strscroller
                tblQuickMenu.InnerHtml = html

                'tdQuickLink.InnerHtml = QuickLinksList.Tables(0).Rows(0)("form_desc")
            End If
        End If

    End Sub

#End Region

    '#Region "Action Required Get Details"
    '    'needs to be comeented out if any Changes to System Required
    '    Private Sub ActionReqGetDetails(ByVal srlint As Integer)

    '        Dim userInfo As VMSUserEntity = New VMSUserEntity()
    '        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
    '            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)

    '        Else
    '            Response.Redirect("~/Login.aspx")
    '        End If

    '        Dim ActionReqGet As New UserLogin
    '        Dim ActionReqList As DataSet

    '        ActionReqList = ActionReqGet.GetActionReq(userInfo.userCompanyEntity, userInfo.userGroupCodeEntity, userInfo.userIDEntity)
    '        If (Not (ActionReqList Is Nothing) AndAlso ActionReqList.Tables.Count > 0) Then
    '            If (Not (ActionReqList.Tables(0) Is Nothing) AndAlso ActionReqList.Tables(0).Rows.Count > 0) Then
    '                If ActionReqList.Tables(0).Rows(0)("issuecount") > 0 Then
    '                    tdActionReq.InnerHtml = "<a href='Issue_Management.aspx' class='chi'>" + (srlint + 1).ToString + ". Issues -  ( " + ActionReqList.Tables(0).Rows(0)("issuecount").ToString + " )" + "</a><br/>"
    '                    srlint += 1
    '                End If

    '            End If
    '        End If

    '        ActionReq_statement(srlint)
    '    End Sub

    '#End Region
    '#Region "Action Required Get statement Details"
    '    'needs to be comeented out if any Changes to System Required
    '    Private Sub ActionReq_statement(ByVal srlint As Integer)

    '        Dim userInfo As VMSUserEntity = New VMSUserEntity()
    '        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
    '            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)

    '        Else
    '            Response.Redirect("~/Login.aspx")
    '        End If

    '        Dim ActionReqGet As New UserLogin
    '        Dim ActionReqList As DataSet

    '        ActionReqList = ActionReqGet.GetActionReq_Statement(userInfo.userCompanyEntity, userInfo.userGroupCodeEntity, userInfo.userIDEntity)
    '        If (Not (ActionReqList Is Nothing) AndAlso ActionReqList.Tables.Count > 0) Then
    '            If (Not (ActionReqList.Tables(0) Is Nothing) AndAlso ActionReqList.Tables(0).Rows.Count > 0) Then
    '                If ActionReqList.Tables(0).Rows(0)("issuecount") > 0 Then
    '                    tdActionReq.InnerHtml = "<a href='Issue_Management.aspx' class='chi'>" + (srlint + 1).ToString + ". Unread Statements -  ( " + ActionReqList.Tables(0).Rows(0)("issuecount").ToString + " )" + "</a><br/>"
    '                    srlint += 1
    '                End If

    '            End If
    '        End If

    '        PoActionRequired(srlint)
    '    End Sub

    '#End Region

    '#Region "Po Approve action Required"
    '    'needs to be comeented out if any Changes to System Required
    '    Private Sub PoActionRequired(ByVal srlint As Integer)
    '        Dim userInfo As VMSUserEntity = New VMSUserEntity()
    '        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
    '            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)

    '        Else
    '            Response.Redirect("~/Login.aspx")
    '        End If

    '        Dim POobj As New VendorPO
    '        Dim ActionReqList As DataSet
    '        ActionReqList = POobj.PoApproveActionGet(userInfo)
    '        If (Not (ActionReqList Is Nothing) AndAlso ActionReqList.Tables.Count > 0) Then
    '            If (Not (ActionReqList.Tables(0) Is Nothing) AndAlso ActionReqList.Tables(0).Rows.Count > 0) Then
    '                If ActionReqList.Tables(0).Rows(0)("PoActionCount") > 0 Then
    '                    tdActionReq.InnerHtml &= "<a href='Vendor_PO_List.aspx' class='chi'>" + (srlint + 1).ToString + ". Pending Po Approval -  ( " + ActionReqList.Tables(0).Rows(0)("PoActionCount").ToString + " )" + "</a>" + "<br/>"
    '                    srlint += 1
    '                End If

    '            End If
    '        End If
    '        Mtl_Rct_ActionRequired(srlint)

    '    End Sub
    '#End Region




    '#Region "Mtl Rct Approve action Required"
    '    'needs to be comeented out if any Changes to System Required
    '    Private Sub Mtl_Rct_ActionRequired(ByVal srlint As Integer)
    '        Dim userInfo As VMSUserEntity = New VMSUserEntity()
    '        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
    '            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)

    '        Else
    '            Response.Redirect("~/Login.aspx")
    '        End If

    '        Dim MtlListobj As New MtlRct_DC
    '        Dim ActionReqList As DataSet
    '        ActionReqList = MtlListobj.MtlRct_approve_actionGet(userInfo)
    '        If (Not (ActionReqList Is Nothing) AndAlso ActionReqList.Tables.Count > 0) Then
    '            If (Not (ActionReqList.Tables(0) Is Nothing) AndAlso ActionReqList.Tables(0).Rows.Count > 0) Then
    '                If ActionReqList.Tables(0).Rows(0)("mtlActionCount") > 0 Then
    '                    tdActionReq.InnerHtml &= "<a href='Mtl_Rct_List.aspx' class='chi'>" + (srlint + 1).ToString + ". Pending Mtl Receipt Approval -  ( " + ActionReqList.Tables(0).Rows(0)("mtlActionCount").ToString + " )" + "</a>" + "<br/>"
    '                    srlint += 1
    '                End If

    '            End If
    '        End If
    '        Depot_adv_ActionRequired(srlint)
    '    End Sub
    '#End Region

    '#Region "Depot advice approve action Required"
    '    'needs to be comeented out if any Changes to System Required
    '    Private Sub Depot_adv_ActionRequired(ByVal srlint As Integer)
    '        Dim userInfo As VMSUserEntity = New VMSUserEntity()
    '        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
    '            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)

    '        Else
    '            Response.Redirect("~/Login.aspx")
    '        End If

    '        Dim depotAdviceobj As New DepotAdvice
    '        Dim ActionReqList As DataSet
    '        ActionReqList = depotAdviceobj.depot_approve_action_Required_get(userInfo)
    '        If (Not (ActionReqList Is Nothing) AndAlso ActionReqList.Tables.Count > 0) Then
    '            If (Not (ActionReqList.Tables(0) Is Nothing) AndAlso ActionReqList.Tables(0).Rows.Count > 0) Then
    '                If ActionReqList.Tables(0).Rows(0)("depotActionCount") > 0 Then
    '                    tdActionReq.InnerHtml &= "<a href='Depot_Advice_List.aspx' class='chi'>" + (srlint + 1).ToString + ". Pending Depot Advice Approval -  ( " + ActionReqList.Tables(0).Rows(0)("depotActionCount").ToString + " )" + "</a>" + "<br/>"
    '                    srlint += 1
    '                End If

    '            End If
    '        End If
    '        IdttoDesp_ActionRequired(srlint)
    '    End Sub
    '#End Region

    '#Region "Depot advice Consignment approve action Required"
    '    'needs to be comeented out if any Changes to System Required
    '    Private Sub Depot_adv_cons_ActionRequired(ByVal srlint As Integer)
    '        Dim userInfo As VMSUserEntity = New VMSUserEntity()
    '        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
    '            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)

    '        Else
    '            Response.Redirect("~/Login.aspx")
    '        End If

    '        Dim depotAdviceobj As New DepotAdvice
    '        Dim ActionReqList As DataSet
    '        Dim sysmonth As String = Month(Date.Now).ToString
    '        If Len(sysmonth) = 1 Then
    '            sysmonth = "0" + sysmonth

    '        End If

    '        ActionReqList = depotAdviceobj.depot_cons_approve_action_Required_get(userInfo, sysmonth)
    '        If (Not (ActionReqList Is Nothing) AndAlso ActionReqList.Tables.Count > 0) Then
    '            If (Not (ActionReqList.Tables(0) Is Nothing) AndAlso ActionReqList.Tables(0).Rows.Count > 0) Then
    '                If ActionReqList.Tables(0).Rows(0)("depotActionCount") > 0 Then
    '                    tdActionReq.InnerHtml &= "<a href='Depot_Advice_List.aspx' class='chi'>" + (srlint + 1).ToString + ". Pending Depot Advice Approval -  ( " + ActionReqList.Tables(0).Rows(0)("depotActionCount").ToString + " )" + "</a>" + "</br>"
    '                    srlint += 1
    '                End If

    '            End If
    '        End If
    '    End Sub
    '#End Region

    '#Region "Depot Idt to Despatch action Required"
    '    'needs to be comeented out if any Changes to System Required
    '    Private Sub IdttoDesp_ActionRequired(ByVal srlint As Integer)
    '        Dim userInfo As VMSUserEntity = New VMSUserEntity()
    '        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
    '            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)

    '        Else
    '            Response.Redirect("~/Login.aspx")
    '        End If

    '        Dim depotAdviceobj As New DepotAdvice
    '        Dim ActionReqList As DataSet
    '        ActionReqList = depotAdviceobj.ActionRequired_Idt_despatch(userInfo)
    '        If (Not (ActionReqList Is Nothing) AndAlso ActionReqList.Tables.Count > 0) Then
    '            If (Not (ActionReqList.Tables(0) Is Nothing) AndAlso ActionReqList.Tables(0).Rows.Count > 0) Then
    '                If ActionReqList.Tables(0).Rows.Count > 0 Then
    '                    tdActionReq.InnerHtml &= "<a href='IDT_to_despatch.aspx' class='chi'>" + (srlint + 1).ToString + ". Advice Pending for IDT-toDespatch -  ( " + ActionReqList.Tables(0).Rows.Count.ToString + " )" + "</a>" + "<br/>"
    '                    srlint += 1
    '                End If

    '            End If
    '        End If
    '        IdttoRecv_ActionRequired(srlint)
    '    End Sub
    '#End Region

    '#Region "Depot Idt to Receive action Required"
    '    'needs to be comeented out if any Changes to System Required
    '    Private Sub IdttoRecv_ActionRequired(ByVal srlint As Integer)
    '        Dim userInfo As VMSUserEntity = New VMSUserEntity()
    '        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
    '            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)

    '        Else
    '            Response.Redirect("~/Login.aspx")
    '        End If

    '        Dim depotAdviceobj As New DepotAdvice
    '        Dim ActionReqList As DataSet
    '        ActionReqList = depotAdviceobj.ActionRequired_Idt_Receive(userInfo)
    '        If (Not (ActionReqList Is Nothing) AndAlso ActionReqList.Tables.Count > 0) Then
    '            If (Not (ActionReqList.Tables(0) Is Nothing) AndAlso ActionReqList.Tables(0).Rows.Count > 0) Then
    '                If ActionReqList.Tables(0).Rows.Count > 0 Then
    '                    tdActionReq.InnerHtml &= "<a href='IDT_to_receive.aspx' class='chi'>" + (srlint + 1).ToString + ". Advice Pending for IDT-toReceive -  ( " + ActionReqList.Tables(0).Rows.Count.ToString + " )" + "</a>" + "<br/>"
    '                    srlint += 1
    '                End If

    '            End If
    '        End If
    '    End Sub
    '#End Region

#Region "Flash News"
    'Get Flash News from flash news table
    Public Sub PopulateNews()

        Dim userInfo As VMSUserEntity = New VMSUserEntity()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)

            Dim userDetailsObject As New UserLogin()
            Dim newsDataSet As DataSet
            Dim i As Integer
            newsDataSet = userDetailsObject.GetFalshNews(userInfo.userCompanyEntity, userInfo.userIDEntity)
            If (Not (newsDataSet Is Nothing) AndAlso newsDataSet.Tables.Count > 0) Then
                If (Not (newsDataSet.Tables(0) Is Nothing) AndAlso newsDataSet.Tables(0).Rows.Count > 0) Then
                    strscroller = ""
                    For i = 0 To newsDataSet.Tables(0).Rows.Count - 1
                        strscroller &= newsDataSet.Tables(0).Rows(i)("flash_msg").ToString() & "&nbsp;<br/>"
                    Next
                    strscroller = "<marquee id=mar1 SCROLLDELAY=50 direction=left onmouseover='this.stop();' onmouseout='this.start();' style='color:red;'>" & strscroller & "</marquee>"
                    news_marquee_scroll.InnerHtml = strscroller
                End If
            End If
        Else
            Response.Redirect("~/Login.aspx")
        End If
    End Sub
#End Region

#Region "PopulateMenus"

    Public Sub PopulateLastStockUpdateDate()

        Dim userInfo As VMSUserEntity = New VMSUserEntity()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)

            Dim userDetailsObject As New UserLogin()
            Dim adminDataSet As DataSet
            Try
                adminDataSet = userDetailsObject.GetLastStockUpdateDate()
                If (adminDataSet.Tables(0).Rows.Count > 0) Then
                    'Modified-by MUKESH BHAGAT on 20-08-2026 : restored from old UAT source
                    lblLastStockUpdateDate.Text = adminDataSet.Tables(0).Rows(0)(0).ToString()

                    ' Dim lastUpdate As DateTime = Convert.ToDateTime(adminDataSet.Tables(0).Rows(0)(0))
                    ' Set individual parts
                    'lblDayNumber.Text = lastUpdate.ToString("dd")    ' 28
                    'lblMonthName.Text = lastUpdate.ToString("MMMM")  ' July
                    'lblYear.Text = lastUpdate.ToString("yyyy")       ' 2025
                    'lblDayName.Text = lastUpdate.ToString("dddd")    ' Monday

                End If
            Catch ex As Exception
                Dim returnUrl As String = "~/ExceptionPage.aspx"
                Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
                Server.Transfer(returnUrl)
            End Try

        End If
    End Sub
#End Region


#Region "Get values for a particular Standard Parameter."

    Private Function GetStandardParameter(ByVal param_name As String) As String

        Dim userInfo As VMSUserEntity = New VMSUserEntity()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        Else
            Response.Redirect("~/Login.aspx")
        End If

        Dim cmnStandardParameter As New Common()
        Dim dsStandardParameter As DataSet

        Dim result As String = String.Empty

        Try

            dsStandardParameter = cmnStandardParameter.GetStandardParameterValues(param_name)

            If Not (dsStandardParameter Is Nothing) Then

                If Not (dsStandardParameter.Tables(0).Rows.Count = 0) Then
                    result = dsStandardParameter.Tables(0).Rows(0)("param_char_value")
                Else
                    Dim returnUrl As String = "~/ExceptionPage.aspx"
                    Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
                    Server.Transfer(returnUrl)
                End If

            End If

        Catch ex As Exception

            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Server.Transfer(returnUrl)

        End Try

        Return result

    End Function

#End Region





#Region "DashBoard Info"
    Public Sub PopulateDashBoard()

        Dim userInfo As VMSUserEntity = New VMSUserEntity()

        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)

            Dim userDetailsObject As New UserLogin()
            Dim ds As DataSet = userDetailsObject.GetDashBoardInfo(userInfo.userIDEntity, userInfo.userBranchEntity)
            If userInfo.userGroupCodeEntity.Equals("HO", StringComparison.InvariantCultureIgnoreCase) Or userInfo.userGroupCodeEntity.Equals("SYSADMIN", StringComparison.InvariantCultureIgnoreCase) Then
                divHo.Visible = True
                divNewsCard.Visible = True
                divAction.Visible = True
                divUnit.Visible = False
                divDepot.Visible = False
                'divData.Visible = False
                divDespatch.Visible = False
                divSkuChart.Visible = False
                divSearch.Visible = False

                If (ds IsNot Nothing AndAlso ds.Tables.Count > 0) Then
                    If (ds.Tables(0).Rows.Count > 0) Then
                        lblTotalDespatch.Text = ds.Tables(0).Rows(0)("TotalDespatch").ToString()
                        lblPendingLoad.Text = ds.Tables(0).Rows(0)("PendingLoad").ToString()
                        lblVendorComplaints.Text = ds.Tables(0).Rows(0)("VendorComplaint").ToString()
                        lblNewDoc.Text = ds.Tables(0).Rows(0)("NewDoc").ToString()
                        lblExpDoc.Text = ds.Tables(0).Rows(0)("ExpDoc").ToString()
                        lblUnapprovedIndent.Text = ds.Tables(0).Rows(0)("UnapprovedInd").ToString()
                        lblUnapprovedDespatch.Text = ds.Tables(0).Rows(0)("UnapprovedDespatchChallan").ToString()
                        lblUnapprovedLegal.Text = ds.Tables(0).Rows(0)("UnapprovedLegal").ToString()
                        lblAuditedVendorCount.Text = ds.Tables(0).Rows(0)("auditedVendorCount").ToString()
                        lblSampleTestedVendorCount.Text = ds.Tables(0).Rows(0)("SampleTestedVendorCount").ToString()

                    End If
                    If (ds.Tables(1).Rows.Count > 0) Then
                        Dim pending As New StringBuilder()
                        Dim despatch As New StringBuilder()

                        For Each rdr In ds.Tables(1).Rows
                            pending.Append(rdr("PendingLoads").ToString() & ",")
                            despatch.Append(rdr("TotalDespatch").ToString() & ",")
                        Next
                        litPending.Text = pending.ToString()
                        litDespatch.Text = despatch.ToString()

                    End If
                    If (ds.Tables(2).Rows.Count > 0) Then
                        gvTopvendor.DataSource = ds.Tables(2)
                        gvTopvendor.DataBind()
                    End If
                    If (ds.Tables(3).Rows.Count > 0) Then
                        gvTop3Vend.DataSource = ds.Tables(3)
                        gvTop3Vend.DataBind()
                    End If
                    'If (ds.Tables(4).Rows.Count > 0) Then
                    '    gvVendorDespatch.DataSource = ds.Tables(4)
                    '    gvVendorDespatch.DataBind()
                    'End If
                End If
            ElseIf userInfo.userGroupCodeEntity.Equals("UNIT", StringComparison.InvariantCultureIgnoreCase) Then
                divHo.Visible = False
                divUnit.Visible = False
                divDepot.Visible = False
                divNewsCard.Visible = False
                divAction.Visible = False
                'divData.Visible = True
                divDespatch.Visible = True
                divSkuChart.Visible = True
                divSearch.Visible = True

                Dim unitCode = ddlvendor.SelectedValue
                Dim year = ddlProcessYr.SelectedValue
                Dim month = ddlProcessMnth.SelectedValue
                Dim active = "Y"
                Dim SkuDs As DataSet = userDetailsObject.GetPendingDespatchData(unitCode, year, month, active)
                If (SkuDs IsNot Nothing AndAlso SkuDs.Tables(0).Rows.Count > 0) Then
                    gvVendorDispatch.DataSource = SkuDs.Tables(0)
                    gvVendorDispatch.DataBind()
                Else
                    gvVendorDispatch.DataSource = Nothing
                    gvVendorDispatch.DataBind()
                End If

                'If (SkuDs IsNot Nothing AndAlso SkuDs.Tables(1).Rows.Count > 0) Then
                '    gvVendorDispatch.DataSource = SkuDs.Tables(1)
                '    gvVendorDispatch.DataBind()
                'Else
                '    gvVendorDispatch.DataSource = Nothing
                '    gvVendorDispatch.DataBind()
                'End If

            End If
        Else
            Response.Redirect("~/Login.aspx")
        End If

    End Sub

    Private Sub BindLoadDispatchChart()
        Dim userInfo As VMSUserEntity = New VMSUserEntity()
        If (Not (Session(Constant.SessionKeys.UserInfo) Is Nothing)) Then
            userInfo = CType(Session(Constant.SessionKeys.UserInfo), VMSUserEntity)
        Else
            Response.Redirect("~/Login.aspx")
        End If

        Dim userDetailsObject As New UserLogin()
        Dim ds As New DataSet()
        Dim unitCode = ddlvendor.SelectedValue
        Dim year = ddlProcessYr.SelectedValue
        Dim month = ddlProcessMnth.SelectedValue

        ds = userDetailsObject.GetLoadDespatchSummary(unitCode, year, month)
        If ds Is Nothing OrElse ds.Tables.Count = 0 OrElse ds.Tables(0).Rows.Count = 0 Then
            litSkuRows.Text = "<div class='mst-empty-state'>No data found for this selection.</div>"
            Return
        End If

        Dim dt As DataTable = ds.Tables(0)
        ' Find the max Total_Load_NOP across all rows so bar widths are relative,
        ' exactly like the reference image (the biggest load = 100% width).
        Dim maxLoad As Decimal = 0
        For Each row As DataRow In dt.Rows
            Dim loadVal As Decimal = Convert.ToDecimal(row("Total_Load_NOP"))
            If loadVal > maxLoad Then maxLoad = loadVal
        Next
        If maxLoad = 0 Then maxLoad = 1 ' avoid divide-by-zero

        Dim sb As New StringBuilder()

        For Each row As DataRow In dt.Rows
            Dim sku As String = row("SKU_Name").ToString()
            Dim totalLoad As Decimal = Convert.ToDecimal(row("Total_Load_NOP"))
            Dim totalDispatch As Decimal = Convert.ToDecimal(row("Total_Despatched_NOP"))
            Dim pct As Decimal = Convert.ToDecimal(row("Dispatch_Percentage"))
            Dim pendingLoad As Decimal = Convert.ToDecimal(row("Pending_Load_NOP"))

            ' Bar widths as % of the row with the largest load
            Dim loadWidthPct As Decimal = Math.Round((totalLoad / maxLoad) * 100, 2)
            Dim dispatchWidthPct As Decimal = Math.Round((totalDispatch / maxLoad) * 100, 2)

            ' Badge color tiers — adjust thresholds to whatever your business considers good/bad
            Dim badgeClass As String
            If pct = 0 Then
                badgeClass = "badge-danger"      ' red
            ElseIf pct < 50 Then
                badgeClass = "badge-warning"     ' orange
            ElseIf pct < 80 Then
                badgeClass = "badge-info"        ' yellow
            Else
                badgeClass = "badge-success"     ' green
            End If

            ' Highlight pending in red-ish text if there's a meaningful backlog
            Dim pendingClass As String = If(pendingLoad > 0, "pending-value pending-active", "pending-value")

            sb.Append("<div class='sku-row'>")
            sb.Append("  <div class='sku-label'>" & Server.HtmlEncode(sku) & "</div>")
            sb.Append("  <div class='sku-bars'>")
            sb.Append("    <div class='bar-track'><div class='bar-fill total-load' style='width:" & loadWidthPct.ToString("0.##") & "%'></div></div>")
            sb.Append("    <div class='bar-track dispatch-track'><div class='bar-fill total-dispatch' style='width:" & dispatchWidthPct.ToString("0.##") & "%'></div></div>")
            sb.Append("  </div>")
            sb.Append("  <div class='sku-stats'>Load: <b>" & totalLoad.ToString("N0") & "</b> | Dispatch: <b>" & totalDispatch.ToString("N0") & "</b> | Pending: <b class='" & pendingClass & "'>" & pendingLoad.ToString("N0") & "</b></div>")
            sb.Append("  <div class='sku-badge " & badgeClass & "'>" & pct.ToString("0.0") & "%</div>")
            sb.Append("</div>")
        Next

        litSkuRows.Text = sb.ToString()
    End Sub

#End Region
    Protected Sub lnkViewDetails_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim obj As New Vendor_RatingClass
        Dim ds As DataSet = obj.Get_Total_Despatch()
        gvDtls.DataSource = ds.Tables(0)
        gvDtls.DataBind()
        mp1.Show()
    End Sub
    Protected Sub lnkPendingLoadDetails_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim obj As New Vendor_RatingClass
        Dim ds As DataSet = obj.Get_Pending_Load()
        gvPendingLoad.DataSource = ds.Tables(0)
        gvPendingLoad.DataBind()
        mpPendingLoad.Show()
    End Sub
    Protected Sub lnkVendorComplaintDetails_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim obj As New Vendor_RatingClass
        Dim ds As DataSet = obj.Get_Pending_Complaint()
        gvComplaints.DataSource = ds.Tables(0)
        gvComplaints.DataBind()
        mpComplaints.Show()

        divComplaintscount.Visible = True
        panel_Comaplaints_details.Visible = False
        btnComplaintBack.Visible = False
        btnCloseComplaints.Visible = True

    End Sub
    Protected Sub lnkExpieredDoc_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim obj As New Vendor_RatingClass
        Dim ds As DataSet = obj.Get_Legal_Doc()
        gvLegalDocs.DataSource = ds.Tables(0)
        gvLegalDocs.DataBind()
        mpLegalDocs.Show()
        divExpireDoc.Visible = True
        divExpiredocdtls.Visible = False
        btnLegalExpireBack.Visible = False
        btnCloseLegalDocs.Visible = True
    End Sub
    Protected Sub lnkUnApprovedDoc_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim obj As New Vendor_RatingClass
        Dim ds As DataSet = obj.Get_UnApproved_Doc()
        gvUnApprovedDoc.DataSource = ds.Tables(0)
        gvUnApprovedDoc.DataBind()
        mpUnApprovedDoc.Show()
        btnLegalApproveBack.Visible = False
        divLegalApprove.Visible = True
        divLegalApproveDtl.Visible = False
        btnUnApprovedDoc.Visible = True
    End Sub
    Protected Sub lnkAuditCount_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim obj As New Vendor_RatingClass
        Dim ds As DataSet = obj.Get_Audit_Count()
        gvAuditCount.DataSource = ds.Tables(0)
        gvAuditCount.DataBind()
        mpAuditCount.Show()
    End Sub
    Protected Sub lnkSampleTestedCount_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim obj As New Vendor_RatingClass
        Dim ds As DataSet = obj.Get_SampleTested_Count()
        gvSampleCount.DataSource = ds.Tables(0)
        gvSampleCount.DataBind()
        mpSampleTestedCount.Show()
    End Sub



    Protected Sub btnCloseLegalDocs_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCloseLegalDocs.Click
        mpLegalDocs.Hide()
    End Sub


    Protected Sub btnmp1ClosePopup_Click(sender As Object, e As EventArgs)
        mp1.Hide()
    End Sub
    Protected Sub btnClosePendingLoad_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnClosePendingLoad.Click
        mpPendingLoad.Hide()
    End Sub
    Protected Sub btnCloseComplaints_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCloseComplaints.Click
        mpComplaints.Hide()
        'panel_Comaplaints_details.Visible = False
    End Sub
    Protected Sub btnUnApprovedDoc_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnUnApprovedDoc.Click
        mpUnApprovedDoc.Hide()
    End Sub
    Protected Sub btnAuditCount_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnAuditCount.Click
        mpAuditCount.Hide()
    End Sub
    Protected Sub btnSampleTestedClose_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnSampleTestedClose.Click
        mpSampleTestedCount.Hide()
    End Sub

    Protected Sub gvComplaints_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        Dim obj As New Vendor_RatingClass
        Dim ds As DataSet
        If e.CommandName = "ViewComplaints" Then
            Dim vendorcode As String = e.CommandArgument.ToString()
            ds = obj.Get_DashBoardInfo_Comaplaints_lvl2(vendorcode)
            gvCoplaintsDtl.DataSource = ds.Tables(0)
            gvCoplaintsDtl.DataBind()

            mpComplaints.Show()
            divComplaintscount.Visible = False
            panel_Comaplaints_details.Visible = True
            btnComplaintBack.Visible = True
            btnCloseComplaints.Visible = False

        End If
    End Sub
    Protected Sub btnComplaintBack_Click(sender As Object, e As EventArgs)
        mpComplaints.Show()
        divComplaintscount.Visible = True
        panel_Comaplaints_details.Visible = False
        btnComplaintBack.Visible = False
        btnCloseComplaints.Visible = True
    End Sub
    Protected Sub gvLegalDocs_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        Dim obj As New Vendor_RatingClass
        Dim ds As DataSet
        If e.CommandName = "ViewExpireDoc" Then
            Dim vendorcode As String = e.CommandArgument.ToString()
            ds = obj.Get_DashBoardInfo_LegalExpireDoc_lvl2(vendorcode)
            gvExpiredocDtl.DataSource = ds.Tables(0)
            gvExpiredocDtl.DataBind()
            mpLegalDocs.Show()
            divExpireDoc.Visible = False
            divExpiredocdtls.Visible = True
            btnLegalExpireBack.Visible = True
            btnCloseLegalDocs.Visible = False
        End If

    End Sub
    Protected Sub btnLegalExpireBack_Click(sender As Object, e As EventArgs)
        mpLegalDocs.Show()
        divExpireDoc.Visible = True
        divExpiredocdtls.Visible = False
        btnLegalExpireBack.Visible = False
        btnCloseLegalDocs.Visible = True

    End Sub
    Protected Sub gvUnApprovedDoc_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        Dim obj As New Vendor_RatingClass
        Dim ds As DataSet
        btnLegalApproveBack.Visible = True
        btnUnApprovedDoc.Visible = False
        If e.CommandName = "ViewLegalApprove" Then
            Dim vendorcode As String = e.CommandArgument.ToString()
            ds = obj.Get_DashBoardInfo_UnapproveLegalDoc_lvl2(vendorcode)
            gvLegalApproveDtl.DataSource = ds.Tables(0)
            gvLegalApproveDtl.DataBind()
            mpUnApprovedDoc.Show()
            divLegalApprove.Visible = False
            divLegalApproveDtl.Visible = True
            btnLegalApproveBack.Visible = True
        End If
    End Sub
    Protected Sub btnLegalApproveBack_Click(sender As Object, e As EventArgs)
        mpUnApprovedDoc.Show()
        divLegalApprove.Visible = True
        btnUnApprovedDoc.Visible = True
        divLegalApproveDtl.Visible = False
        btnLegalApproveBack.Visible = False
    End Sub
    Protected Sub lnkUnapproveIndent_Click(sender As Object, e As EventArgs)
        Response.Redirect("~/IndentsList.aspx")

    End Sub
    Protected Sub lnkUnapprovedDespatch_Click(sender As Object, e As EventArgs)
        Response.Redirect("~/UnitDespatchPlanListVr1.aspx")
    End Sub



    Protected Sub btnSearch_Click(sender As Object, e As EventArgs)
        BindLoadDispatchChart()
        PopulateDashBoard()
    End Sub

    Protected Sub gvVendorDispatch_RowCommand(sender As Object, e As GridViewCommandEventArgs)

    End Sub
End Class
