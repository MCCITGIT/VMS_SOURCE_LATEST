Imports VMS.Web
Imports System.Data
Imports System.Data.SqlTypes
Imports System.Data.SqlClient
Imports VMS.DataAccess
Imports System.Web.UI.DataVisualization.Charting
Imports System.Drawing

Partial Class vrs_vendorrating_mstr
    Inherits System.Web.UI.Page
#Region "Global Variable"
    Dim userInfo As VMSUserEntity = New VMSUserEntity()

    Public Property ProgressValue As Integer = 0
    Public Property StatusText As String = ""

    Public Property CircularProgressBar1 As Object
#End Region

#Region "Page_Load Event"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        CheckLogin()
        AddAttributes()
        If Not IsPostBack Then
            'Populate_Quarter()
            PopulateFinYear()
            Dim vendor As String = ddlVendor.SelectedValue
            ' PopulateVendor()
            Populate_VendorGroup()
            divVendorScoreCategoryLyTyWise.Visible = False
            divTopVendor.Visible = False
            Populate_GroupWise_Vendor(String.Empty)
            PopulateVendorProduct(String.Empty)
            PopulateVendorBrand(String.Empty)
            If (userInfo.userGroupCodeEntity.Equals("HO-MARKETING") Or userInfo.userGroupCodeEntity.Equals("SYSADMIN") Or userInfo.userGroupCodeEntity.Equals("DEPOT")) Then
                'divVendorRating.Visible = True
                'gvVendorHeader.Visible = True
                divSrcVendorGroup.Visible = True
                divSrcProductGroup.Visible = True
                divSrcProduct.Visible = True
                'divVendorDashboard.Visible = False
            End If

            If userInfo.userGroupCodeEntity.Equals("UNIT") Then
                divSrcVendorGroup.Visible = False
                divSrcProductGroup.Visible = False
                divSrcProduct.Visible = False
                ddlVendor.SelectedValue = userInfo.userIDEntity.ToString()
                ddlVendor.Enabled = False
            End If

            divSrcVendor.Visible = False
            divSrcHeadGrp.Visible = False
            'divSrcProductGroup.Visible = False
            'divSrcProduct.Visible = False

        End If
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
#Region "AddAttributes"
    Private Sub AddAttributes()
        btnsearch.Attributes.Add("onclick", "return Validate_VendorRate_Search();")
    End Sub
#End Region

#Region "Populate FinYear"
    Private Sub PopulateFinYear()
        CheckLogin()
        Try
            Dim Obj As New vrs_legalscore_class
            Dim ds As New DataSet
            ddlFinYear.Items.Clear()
            ds = Obj.GetFinYear(userInfo.userIDEntity)
            If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
                ddlFinYear.DataSource = ds.Tables(0)
                ddlFinYear.DataTextField = "fin_year_text"
                ddlFinYear.DataValueField = "fin_year"
                ddlFinYear.DataBind()
                ddlFinYear.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
                'If Not (ds.Tables(0).Rows.Count = 1) Then
                '    ddlvendor.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
                'End If

                If ds.Tables(0).Rows.Count = 1 Then
                    ddlFinYear.SelectedIndex = 1
                    ddlFinYear.Enabled = False
                    Populate_Quarter()
                End If

            End If
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Server.Transfer(returnUrl)
        End Try
    End Sub
#End Region

#Region "Populate Quarter"
    Private Sub Populate_Quarter()
        Try
            Dim obj As New vrs_legalscore_class
            Dim ds As New DataSet
            ddlquartor.Items.Clear()
            ds = obj.Get_QuarterList_vr1(userInfo.userIDEntity, ddlFinYear.SelectedValue)

            If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
                ddlquartor.DataSource = ds.Tables(0)
                ddlquartor.DataTextField = "qm_quarter_short_code"
                ddlquartor.DataValueField = "qm_id"
                ddlquartor.DataBind()

                If Not (ds.Tables(0).Rows.Count = 1) Then
                    ddlquartor.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
                End If
            End If
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Server.Transfer(returnUrl)
        End Try

    End Sub
#End Region


#Region "Populate VendorGroup"
    Private Sub Populate_VendorGroup()
        Try
            Dim obj As New Vendor_RatingClass
            Dim ds As New DataSet
            ddlVendorGrp.Items.Clear()
            ds = obj.Get_VendorGroupList()

            If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
                ddlVendorGrp.DataSource = ds.Tables(0)
                ddlVendorGrp.DataTextField = "vendor_grp"
                ddlVendorGrp.DataValueField = "vendor_grp_code"
                ddlVendorGrp.DataBind()

                If Not (ds.Tables(0).Rows.Count = 1) Then
                    ddlVendorGrp.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
                End If
            End If
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Server.Transfer(returnUrl)
        End Try

    End Sub
#End Region

#Region "Populate Group Wsie Vendor"
    Private Sub Populate_GroupWise_Vendor(ByVal vendorGrp As String)
        Try
            Dim obj As New Vendor_RatingClass
            Dim ds As New DataSet
            ddlVendor.Items.Clear()
            ds = obj.Get_GroupWisevendorList(vendorGrp)

            If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
                ddlVendor.DataSource = ds.Tables(0)
                ddlVendor.DataTextField = "vendor_name"
                ddlVendor.DataValueField = "vendor_code"
                ddlVendor.DataBind()

                If Not (ds.Tables(0).Rows.Count = 1) Then
                    ddlVendor.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
                End If
            End If
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Server.Transfer(returnUrl)
        End Try

    End Sub
#End Region

#Region "Populate Vendor"
    Private Sub PopulateVendor()

        Try
            Dim obj As New DeviationsFGQualityClass
            Dim dsUnitSet As New DataSet
            ddlVendor.Items.Clear()
            dsUnitSet = obj.GetVendor(userInfo.userIDEntity)
            If (Not (dsUnitSet Is Nothing) AndAlso dsUnitSet.Tables.Count > 0 AndAlso Not (dsUnitSet.Tables(0) Is Nothing) AndAlso dsUnitSet.Tables(0).Rows.Count > 0) Then
                ddlVendor.DataSource = dsUnitSet.Tables(0)
                ddlVendor.DataTextField = "vendor_name"
                ddlVendor.DataValueField = "vendor_code"
                ddlVendor.DataBind()
                ddlVendor.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
                If dsUnitSet.Tables(0).Rows.Count = 1 Then
                    ddlVendor.SelectedIndex = 1
                    ddlVendor.Enabled = False
                End If

                ' ddlVendor_SelectedIndexChanged(Nothing, Nothing)
            End If
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Server.Transfer(returnUrl)
        End Try

    End Sub
#End Region

#Region "Populate Grid"
    Private Sub BindGrid()
        Try
            Dim obj As New Vendor_RatingClass
            Dim ds As New DataSet
            Dim vendor As String = ddlVendor.SelectedValue
            If ddlType.SelectedValue.Equals("HEAD") Then
                ds = obj.Get_VendorRatingList_All(vendor, ddlFinYear.SelectedValue.ToString(), ddlquartor.SelectedValue.ToString(), ddlProduct.SelectedValue.ToString(), ddlVendorGrp.SelectedValue.ToString(), ddlBrand.SelectedValue.ToString(), ddlHead.SelectedValue)
            Else
                ds = obj.Get_VendorRatingList_All(vendor, ddlFinYear.SelectedValue.ToString(), ddlquartor.SelectedValue.ToString(), ddlProduct.SelectedValue.ToString(), ddlVendorGrp.SelectedValue.ToString(), ddlBrand.SelectedValue.ToString(), ddlType.SelectedValue)

            End If

            If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then

                If Not String.IsNullOrEmpty(ddlType.SelectedValue) Then
                    If ddlType.SelectedValue.Equals("GRPS", StringComparison.InvariantCulture) Then
                        divTopVendor.Visible = True
                        divVendorScoreCategoryLyTyWise.Visible = True

                        'gvVendor_Rate.DataSource = ds.Tables(0)
                        'gvVendor_Rate.DataBind()
                        ViewState("GroupScoreDtls") = ds.Tables(0)
                        reptVendorGroup.DataSource = ds.Tables(0)
                        reptVendorGroup.DataBind()

                        BindPerformanceChart(ds.Tables(1))
                        topVendorname.InnerText = ds.Tables(1).Rows(0)("vendor").ToString()
                        topObtainWeightage.InnerText = ds.Tables(1).Rows(0)("current_quarter_value").ToString()

                        lblGoldCount.Text = Convert.ToString(ds.Tables(5).Rows(0)("Gold_count"))
                        lblPlatinumCount.Text = Convert.ToString(ds.Tables(5).Rows(0)("Platinum_count"))
                        lblSilverCount.Text = Convert.ToString(ds.Tables(5).Rows(0)("Silver_count"))
                        lblBronzeCount.Text = Convert.ToString(ds.Tables(5).Rows(0)("Bronze_count"))

                        progPlatinum.Style("width") = Convert.ToString(ds.Tables(5).Rows(0)("Platinum_pct")) + "%"
                        progPlatinum.InnerText = Convert.ToString(ds.Tables(5).Rows(0)("Platinum_pct")) + "%"
                        progGold.Style("width") = Convert.ToString(ds.Tables(5).Rows(0)("Gold_pct")) + "%"
                        progGold.InnerText = Convert.ToString(ds.Tables(5).Rows(0)("Gold_pct")) + "%"
                        progSilver.Style("width") = Convert.ToString(ds.Tables(5).Rows(0)("Silver_pct")) + "%"
                        progSilver.InnerText = Convert.ToString(ds.Tables(5).Rows(0)("Silver_pct")) + "%"
                        progBronze.Style("width") = Convert.ToString(ds.Tables(5).Rows(0)("Bronze_pct")) + "%"
                        progBronze.InnerText = Convert.ToString(ds.Tables(5).Rows(0)("Bronze_pct")) + "%"

                        Dim grade As String = Convert.ToString(ds.Tables(1).Rows(0)("grade_name"))
                        If grade IsNot Nothing And Not String.IsNullOrEmpty(grade) Then
                            If grade.Equals("Platimun") Then
                                imgGrade.Attributes.Add("src", "images/platinum.png")
                                lblTop1Grade.Text = Convert.ToString(ds.Tables(1).Rows(0)("grade_name"))
                                lblTop1Grade.Attributes.Add("class", "badgeTx Platimun")
                            ElseIf grade.Equals("Gold") Then
                                imgGrade.Attributes.Add("src", "images/gold.png")
                                lblTop1Grade.Text = Convert.ToString(ds.Tables(1).Rows(0)("grade_name"))
                                lblTop1Grade.Attributes.Add("class", "badgeTx gold")
                            ElseIf grade.Equals("Silver") Then
                                imgGrade.Attributes.Add("src", "images/silver.png")
                                lblTop1Grade.Text = Convert.ToString(ds.Tables(1).Rows(0)("grade_name"))
                                lblTop1Grade.Attributes.Add("class", "badgeTx silver")
                            ElseIf grade.Equals("Bronze") Then
                                imgGrade.Attributes.Add("src", "images/bronze.png")
                                lblTop1Grade.Text = Convert.ToString(ds.Tables(1).Rows(0)("grade_name"))
                                lblTop1Grade.Attributes.Add("class", "badgeTx bronze")
                            End If
                        End If

                        gvTopvendor.DataSource = ds.Tables(2)
                        gvTopvendor.DataBind()
                        lblError.Text = ""
                        gvTy.DataSource = ds.Tables(3)
                        gvTy.DataBind()
                        gvLy.DataSource = ds.Tables(4)
                        gvLy.DataBind()

                    ElseIf ddlType.SelectedValue.Equals("HEAD", StringComparison.InvariantCulture) Then

                        divTopVendor.Visible = True
                        divVendorScoreCategoryLyTyWise.Visible = True
                        ViewState("HeadScoreDtls") = ds.Tables(0)
                        rptHeadGrp.DataSource = ds.Tables(0)
                        rptHeadGrp.DataBind()

                        BindPerformanceChart(ds.Tables(1))
                        topVendorname.InnerText = ds.Tables(1).Rows(0)("vendor").ToString()
                        topObtainWeightage.InnerText = ds.Tables(1).Rows(0)("current_quarter_value").ToString()

                        lblGoldCount.Text = Convert.ToString(ds.Tables(5).Rows(0)("Gold_count"))
                        lblPlatinumCount.Text = Convert.ToString(ds.Tables(5).Rows(0)("Platinum_count"))
                        lblSilverCount.Text = Convert.ToString(ds.Tables(5).Rows(0)("Silver_count"))
                        lblBronzeCount.Text = Convert.ToString(ds.Tables(5).Rows(0)("Bronze_count"))

                        progPlatinum.Style("width") = Convert.ToString(ds.Tables(5).Rows(0)("Platinum_pct")) + "%"
                        progPlatinum.InnerText = Convert.ToString(ds.Tables(5).Rows(0)("Platinum_pct")) + "%"
                        progGold.Style("width") = Convert.ToString(ds.Tables(5).Rows(0)("Gold_pct")) + "%"
                        progGold.InnerText = Convert.ToString(ds.Tables(5).Rows(0)("Gold_pct")) + "%"
                        progSilver.Style("width") = Convert.ToString(ds.Tables(5).Rows(0)("Silver_pct")) + "%"
                        progSilver.InnerText = Convert.ToString(ds.Tables(5).Rows(0)("Silver_pct")) + "%"
                        progBronze.Style("width") = Convert.ToString(ds.Tables(5).Rows(0)("Bronze_pct")) + "%"
                        progBronze.InnerText = Convert.ToString(ds.Tables(5).Rows(0)("Bronze_pct")) + "%"

                        gvTopvendor.DataSource = ds.Tables(2)
                        gvTopvendor.DataBind()
                        lblError.Text = ""
                        gvTy.DataSource = ds.Tables(3)
                        gvTy.DataBind()
                        gvLy.DataSource = ds.Tables(4)
                        gvLy.DataBind()

                    Else
                        divTopVendor.Visible = True
                        divVendorScoreCategoryLyTyWise.Visible = True
                        'gvVendor_Rate.DataSource = ds.Tables(0)
                        'gvVendor_Rate.DataBind()
                        ViewState("ScoreDtls") = ds.Tables(0)
                        RatingRepeater.DataSource = ds.Tables(0)
                        RatingRepeater.DataBind()
                        BindPerformanceChart(ds.Tables(1))
                        topVendorname.InnerText = ds.Tables(1).Rows(0)("vendor").ToString()
                        topObtainWeightage.InnerText = ds.Tables(1).Rows(0)("current_quarter_value").ToString()

                        lblGoldCount.Text = Convert.ToString(ds.Tables(5).Rows(0)("Gold_count"))
                        lblPlatinumCount.Text = Convert.ToString(ds.Tables(5).Rows(0)("Platinum_count"))
                        lblSilverCount.Text = Convert.ToString(ds.Tables(5).Rows(0)("Silver_count"))
                        lblBronzeCount.Text = Convert.ToString(ds.Tables(5).Rows(0)("Bronze_count"))

                        progPlatinum.Style("width") = Convert.ToString(ds.Tables(5).Rows(0)("Platinum_pct")) + "%"
                        progPlatinum.InnerText = Convert.ToString(ds.Tables(5).Rows(0)("Platinum_pct")) + "%"
                        progGold.Style("width") = Convert.ToString(ds.Tables(5).Rows(0)("Gold_pct")) + "%"
                        progGold.InnerText = Convert.ToString(ds.Tables(5).Rows(0)("Gold_pct")) + "%"
                        progSilver.Style("width") = Convert.ToString(ds.Tables(5).Rows(0)("Silver_pct")) + "%"
                        progSilver.InnerText = Convert.ToString(ds.Tables(5).Rows(0)("Silver_pct")) + "%"
                        progBronze.Style("width") = Convert.ToString(ds.Tables(5).Rows(0)("Bronze_pct")) + "%"
                        progBronze.InnerText = Convert.ToString(ds.Tables(5).Rows(0)("Bronze_pct")) + "%"

                        Dim grade As String = Convert.ToString(ds.Tables(1).Rows(0)("grade_name"))
                        If grade IsNot Nothing And Not String.IsNullOrEmpty(grade) Then
                            If grade.Equals("Platimun") Then
                                imgGrade.Attributes.Add("src", "images/platinum.png")
                                lblTop1Grade.Text = Convert.ToString(ds.Tables(1).Rows(0)("grade_name"))
                                lblTop1Grade.Attributes.Add("class", "badgeTx Platimun")
                            ElseIf grade.Equals("Gold") Then
                                imgGrade.Attributes.Add("src", "images/gold.png")
                                lblTop1Grade.Text = Convert.ToString(ds.Tables(1).Rows(0)("grade_name"))
                                lblTop1Grade.Attributes.Add("class", "badgeTx gold")
                            ElseIf grade.Equals("Silver") Then
                                imgGrade.Attributes.Add("src", "images/silver.png")
                                lblTop1Grade.Text = Convert.ToString(ds.Tables(1).Rows(0)("grade_name"))
                                lblTop1Grade.Attributes.Add("class", "badgeTx silver")
                            ElseIf grade.Equals("Bronze") Then
                                imgGrade.Attributes.Add("src", "images/bronze.png")
                                lblTop1Grade.Text = Convert.ToString(ds.Tables(1).Rows(0)("grade_name"))
                                lblTop1Grade.Attributes.Add("class", "badgeTx bronze")
                            End If
                        End If

                        gvTopvendor.DataSource = ds.Tables(2)
                        gvTopvendor.DataBind()
                        lblError.Text = ""
                        gvTy.DataSource = ds.Tables(3)
                        gvTy.DataBind()
                        gvLy.DataSource = ds.Tables(4)
                        gvLy.DataBind()
                    End If
                Else
                    'gvVendor_Rate.DataSource = Nothing
                    'gvVendor_Rate.DataBind()
                    divTopVendor.Visible = False
                    divVendorScoreCategoryLyTyWise.Visible = False
                End If
            Else
                'gvVendor_Rate.DataSource = Nothing
                'gvVendor_Rate.DataBind()
                divTopVendor.Visible = False
                divVendorScoreCategoryLyTyWise.Visible = False
            End If
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Server.Transfer(returnUrl)
        End Try

    End Sub
    Private Sub BindVendorListByGroupId()
        Try
            Dim obj As New Vendor_RatingClass
            Dim ds As New DataSet
            Dim vendor As String = ddlVendor.SelectedValue
            ds = obj.Get_VendorRatingList_All(vendor, ddlFinYear.SelectedValue.ToString(), ddlquartor.SelectedValue.ToString(), ddlProduct.SelectedValue.ToString(), ddlVendorGrp.SelectedValue.ToString(), ddlBrand.SelectedValue.ToString(), "INDIVIDUAL")

            If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
                RatingRepeater.DataSource = ds.Tables(0)
                RatingRepeater.DataBind()

                BindPerformanceChart(ds.Tables(1))
                topVendorname.InnerText = ds.Tables(1).Rows(0)("vendor").ToString()
                topObtainWeightage.InnerText = ds.Tables(1).Rows(0)("current_quarter_value").ToString()

                lblGoldCount.Text = Convert.ToString(ds.Tables(5).Rows(0)("Gold_count"))
                lblPlatinumCount.Text = Convert.ToString(ds.Tables(5).Rows(0)("Platinum_count"))
                lblSilverCount.Text = Convert.ToString(ds.Tables(5).Rows(0)("Silver_count"))
                lblBronzeCount.Text = Convert.ToString(ds.Tables(5).Rows(0)("Bronze_count"))

                progPlatinum.Style("width") = Convert.ToString(ds.Tables(5).Rows(0)("Platinum_pct")) + "%"
                progPlatinum.InnerText = Convert.ToString(ds.Tables(5).Rows(0)("Platinum_pct")) + "%"
                progGold.Style("width") = Convert.ToString(ds.Tables(5).Rows(0)("Gold_pct")) + "%"
                progGold.InnerText = Convert.ToString(ds.Tables(5).Rows(0)("Gold_pct")) + "%"
                progSilver.Style("width") = Convert.ToString(ds.Tables(5).Rows(0)("Silver_pct")) + "%"
                progSilver.InnerText = Convert.ToString(ds.Tables(5).Rows(0)("Silver_pct")) + "%"
                progBronze.Style("width") = Convert.ToString(ds.Tables(5).Rows(0)("Bronze_pct")) + "%"
                progBronze.InnerText = Convert.ToString(ds.Tables(5).Rows(0)("Bronze_pct")) + "%"

                Dim grade As String = Convert.ToString(ds.Tables(1).Rows(0)("grade_name"))
                If grade IsNot Nothing And Not String.IsNullOrEmpty(grade) Then
                    If grade.Equals("Platimun") Then
                        imgGrade.Attributes.Add("src", "images/platinum.png")
                        lblTop1Grade.Text = Convert.ToString(ds.Tables(1).Rows(0)("grade_name"))
                        lblTop1Grade.Attributes.Add("class", "badgeTx Platimun")
                    ElseIf grade.Equals("Gold") Then
                        imgGrade.Attributes.Add("src", "images/gold.png")
                        lblTop1Grade.Text = Convert.ToString(ds.Tables(1).Rows(0)("grade_name"))
                        lblTop1Grade.Attributes.Add("class", "badgeTx gold")
                    ElseIf grade.Equals("Silver") Then
                        imgGrade.Attributes.Add("src", "images/silver.png")
                        lblTop1Grade.Text = Convert.ToString(ds.Tables(1).Rows(0)("grade_name"))
                        lblTop1Grade.Attributes.Add("class", "badgeTx silver")
                    ElseIf grade.Equals("Bronze") Then
                        imgGrade.Attributes.Add("src", "images/bronze.png")
                        lblTop1Grade.Text = Convert.ToString(ds.Tables(1).Rows(0)("grade_name"))
                        lblTop1Grade.Attributes.Add("class", "badgeTx bronze")
                    End If
                End If

                gvTopvendor.DataSource = ds.Tables(2)
                gvTopvendor.DataBind()
                lblError.Text = ""
                gvTy.DataSource = ds.Tables(3)
                gvTy.DataBind()
                gvLy.DataSource = ds.Tables(4)
                gvLy.DataBind()


            Else
                RatingRepeater.DataSource = Nothing
                RatingRepeater.DataBind()
            End If
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Server.Transfer(returnUrl)
        End Try

    End Sub
#End Region

    Private Sub BindPerformanceChart(ByVal dt As DataTable)
        ' Sample data (X = Time, Y = Performance values)
        Try
            Dim series = PerformanceChart.Series("Performance")
            series.Points.Clear()
            Dim cols As String()
            Dim index As Integer = 0
            Dim selectedColumnNames As New List(Of String)()
            Dim values As New List(Of String)()

            For Each col As DataColumn In dt.Columns
                If index > 1 AndAlso index < 6 Then
                    Dim colName As String = dt.Columns(index).ColumnName
                    selectedColumnNames.Add(colName)
                End If
                index = index + 1
            Next

            For Each row As DataRow In dt.Rows
                '    Dim rowValues As New List(Of String) From {
                'row("Q1").ToString(),
                'row("Q2").ToString(),
                'row("Q3").ToString(),
                'row("Q4").ToString()
                ' }
                'values.Add(rowValues)
                Dim Q1 As String = row("Q1").ToString
                Dim Q2 As String = row("Q2").ToString
                Dim Q3 As String = row("Q3").ToString
                Dim Q4 As String = row("Q4").ToString
                values.Add(Q1)
                values.Add(Q2)
                values.Add(Q3)
                values.Add(Q4)
            Next

            cols = selectedColumnNames.ToArray()
            For i As Integer = 0 To cols.Length - 1
                series.Points.AddXY(selectedColumnNames(i), values(i))
            Next
            ' series.Points.AddXY(selectedColumnNames, values)

            'Dim timeLabels As String() = {"Jan", "Feb", "Mar", "Apr"}
            'Dim performanceValues As Integer() = {20, 30, 28, 40}

            'Dim series = PerformanceChart.Series("Performance")
            'series.Points.Clear()

            'For i As Integer = 0 To timeLabels.Length - 1
            '    series.Points.AddXY(timeLabels(i), performanceValues(i))
            'Next
            'PerformanceChart.Width = 100
            'PerformanceChart.Height = 200
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Server.Transfer(returnUrl)
        End Try


    End Sub

#Region "Populate Vendor Grid"
    Private Sub BindVendorGrid()
        Try
            Dim obj As New Vendor_RatingClass
            Dim ds As New DataSet
            divTopVendor.Visible = False
            ds = obj.Get_VendorRatingHeaderList(ddlVendor.SelectedValue, ddlquartor.SelectedValue.ToString(), userInfo.userIDEntity.ToString())

            If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
                'gvVendorHeader.DataSource = ds
                'gvVendorHeader.DataBind()

                Dim sum As Decimal = Convert.ToDecimal(ds.Tables(0).Compute("SUM(obtain_weightage)", String.Empty))
                lblObtain.Text = Convert.ToString(sum)
                lblObtain.Text = Convert.ToString(ds.Tables(0).Rows(0)("current_quarter_value"))
                penaltyLabel.Text = Convert.ToString(ds.Tables(0).Rows(0)("penalty_quarter_value"))
                finalLabel.Text = Convert.ToString(ds.Tables(0).Rows(0)("final_quarter_value"))

                'For Each row As DataRow In ds.Tables(0).Rows
                '    StatutoryObtainWeigtage.InnerText = 
                'Next

                For Each row As DataRow In ds.Tables(0).Rows

                    If (row("Head").ToString() = "Statutory") Then
                        StatutoryObtainWeigtage.InnerText = row("obtain_Weightage").ToString()
                        StatutoryMaxWeigtage.InnerText = row("maxWeightage").ToString()
                        hdn_hdrSat.Value = row("hdr_id")
                    End If

                    If (row("Head").ToString() = "Quality") Then
                        QualityObtainWeigtage.InnerText = row("obtain_Weightage").ToString()
                        QualityMaxWeigtage.InnerText = row("maxWeightage").ToString()
                        hdn_Qualtityhdr.Value = row("hdr_id")
                    End If

                    If (row("Head").ToString() = "Audit") Then
                        AuditObtainWeigtage.InnerText = row("obtain_Weightage").ToString()
                        AuditMaxWeigtage.InnerText = row("maxWeightage").ToString()
                        hdn_Audithdr.Value = row("hdr_id")
                    End If

                    If (row("Head").ToString() = "Service") Then
                        ServiceObtainWeigtage.InnerText = row("obtain_Weightage").ToString()
                        ServiceMaxWeigtage.InnerText = row("maxWeightage").ToString()
                        hdn_Servicehdr.Value = row("hdr_id")
                    End If

                    If (row("Head").ToString() = "Complaints") Then
                        ComplaintsObtainWeigtage.InnerText = row("obtain_Weightage").ToString()
                        ComplaintsMaxWeigtage.InnerText = row("maxWeightage").ToString()
                        hdn_Complaintshdr.Value = row("hdr_id")
                    End If


                Next

                lblError.Text = ""
                Dim dt As DataTable = ds.Tables(0)
                Chart1.Series.Clear()

                ' Create two series: Obtained and Remaining
                Dim obtainedSeries As New Series("Obtained")
                obtainedSeries.ChartType = SeriesChartType.StackedColumn

                Dim remainingSeries As New Series("Remaining")
                remainingSeries.ChartType = SeriesChartType.StackedColumn

                ' Define color palettes (customize as needed)
                ' Dim obtainedColors As Color() = {Color.LimeGreen, Color.CornflowerBlue, Color.Orange, Color.MediumPurple, Color.Teal}
                Dim obtainedColors As Color() = {Color.DarkOrange, Color.CornflowerBlue, Color.DarkOliveGreen, Color.MediumPurple, Color.Teal}
                Dim remainingColors As Color() = {Color.LightGray, Color.LightGray, Color.LightGray, Color.LightGray, Color.LightGray}

                Dim index As Integer = 0

                For Each row As DataRow In dt.Rows
                    Dim heads As String = row("Head").ToString()
                    Dim maxValues As Double = Convert.ToDouble(row("maxWeightage"))
                    Dim obtainedValues As Double = Convert.ToDouble(row("obtain_Weightage"))
                    Dim remaining = maxValues - obtainedValues

                    ' Create obtained point and set color
                    Dim obtainedPoint = obtainedSeries.Points.AddXY(heads, obtainedValues)
                    obtainedSeries.Points(index).Color = obtainedColors(index Mod obtainedColors.Length)

                    ' Create remaining point and set color
                    remainingSeries.Points.AddXY(heads, remaining)
                    remainingSeries.Points(index).Color = remainingColors(index Mod remainingColors.Length)

                    index += 1
                Next

                ' Add to chart
                Chart1.Series.Add(obtainedSeries)
                Chart1.Series.Add(remainingSeries)
                Chart1.Width = 800
                Chart1.Height = 335

            Else
                'gvVendorHeader.DataSource = Nothing
                'gvVendorHeader.DataBind()
            End If
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Server.Transfer(returnUrl)
        End Try

    End Sub
#End Region

    Private Sub BindvendorIndividualGrid(ByVal vendorid As String)
        Try
            Dim obj As New Vendor_RatingClass
            Dim ds As New DataSet
            divTopVendor.Visible = False
            ds = obj.Get_VendorRatingHeaderList(ddlVendor.SelectedValue, ddlquartor.SelectedValue.ToString(), vendorid)

            If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
                'gvVendorHeader.DataSource = ds
                'gvVendorHeader.DataBind()
                Dim TotalObtainScore As Decimal = Convert.ToDecimal(ds.Tables(0).Compute("SUM(obtain_weightage)", String.Empty)) 'ds.Tables(0).AsEnumerable().Sum(Function(x) x.Field(Of Decimal)(2))
                lblObtain.Text = Convert.ToString(ds.Tables(0).Rows(0)("current_quarter_value"))
                penaltyLabel.Text = Convert.ToString(ds.Tables(0).Rows(0)("penalty_quarter_value"))
                finalLabel.Text = Convert.ToString(ds.Tables(0).Rows(0)("final_quarter_value"))
                Dim grade As String = Convert.ToString(ds.Tables(0).Rows(0)("grade_name"))
                If grade IsNot Nothing And Not String.IsNullOrEmpty(grade) Then
                    If grade.Equals("Platimun") Then
                        imgInnerGrade.Attributes.Add("src", "images/platinum.png")
                        lblInnerGrade.Text = Convert.ToString(ds.Tables(0).Rows(0)("grade_name"))
                        lblInnerGrade.Attributes.Add("class", "badgeTx Platimun")
                    ElseIf grade.Equals("Gold") Then
                        imgInnerGrade.Attributes.Add("src", "images/gold.png")
                        lblInnerGrade.Text = Convert.ToString(ds.Tables(0).Rows(0)("grade_name"))
                        lblInnerGrade.Attributes.Add("class", "badgeTx gold")
                    ElseIf grade.Equals("Silver") Then
                        imgInnerGrade.Attributes.Add("src", "images/silver.png")
                        lblInnerGrade.Text = Convert.ToString(ds.Tables(0).Rows(0)("grade_name"))
                        lblInnerGrade.Attributes.Add("class", "badgeTx silver")
                    ElseIf grade.Equals("Bronze") Then
                        imgInnerGrade.Attributes.Add("src", "images/bronze.png")
                        lblInnerGrade.Text = Convert.ToString(ds.Tables(0).Rows(0)("grade_name"))
                        lblInnerGrade.Attributes.Add("class", "badgeTx bronze")
                    End If
                End If


                'If (lblObtain.Text >= 80 AndAlso lblObtain.Text <= 100) Then
                '    lblGrade.Text = "Platimun"
                'ElseIf lblObtain.Text >= 60 AndAlso lblObtain.Text <= 79 Then
                '    lblGrade.Text = "Gold"
                'ElseIf lblObtain.Text >= 51 AndAlso lblObtain.Text <= 59 Then
                '    lblGrade.Text = "Silver"
                'ElseIf lblObtain.Text >= 0 AndAlso lblObtain.Text <= 50 Then
                '    lblGrade.Text = "Bronze"
                'End If

                'StatutoryObtainWeigtage.InnerText = "14.00"
                For Each row As DataRow In ds.Tables(0).Rows

                    If (row("Head").ToString() = "Statutory") Then
                        StatutoryObtainWeigtage.InnerText = row("obtain_Weightage").ToString()
                        StatutoryMaxWeigtage.InnerText = row("maxWeightage").ToString()
                        hdn_hdrSat.Value = row("hdr_id")
                    End If

                    If (row("Head").ToString() = "Quality") Then
                        QualityObtainWeigtage.InnerText = row("obtain_Weightage").ToString()
                        QualityMaxWeigtage.InnerText = row("maxWeightage").ToString()
                        hdn_Qualtityhdr.Value = row("hdr_id")
                    End If

                    If (row("Head").ToString() = "Audit") Then
                        AuditObtainWeigtage.InnerText = row("obtain_Weightage").ToString()
                        AuditMaxWeigtage.InnerText = row("maxWeightage").ToString()
                        hdn_Audithdr.Value = row("hdr_id")
                    End If

                    If (row("Head").ToString() = "Service") Then
                        ServiceObtainWeigtage.InnerText = row("obtain_Weightage").ToString()
                        ServiceMaxWeigtage.InnerText = row("maxWeightage").ToString()
                        hdn_Servicehdr.Value = row("hdr_id")
                    End If

                    If (row("Head").ToString() = "Complaints") Then
                        ComplaintsObtainWeigtage.InnerText = row("obtain_Weightage").ToString()
                        ComplaintsMaxWeigtage.InnerText = row("maxWeightage").ToString()
                        hdn_Complaintshdr.Value = row("hdr_id")
                    End If


                Next

                lblError.Text = ""
                Dim dt As DataTable = ds.Tables(0)
                Chart1.Series.Clear()

                ' Create two series: Obtained and Remaining
                Dim obtainedSeries As New Series("Obtained")
                obtainedSeries.ChartType = SeriesChartType.StackedColumn

                Dim remainingSeries As New Series("Remaining")
                remainingSeries.ChartType = SeriesChartType.StackedColumn

                ' Define color palettes (customize as needed)
                Dim obtainedColors As Color() = {Color.DarkOrange, Color.CornflowerBlue, Color.DarkOliveGreen, Color.MediumPurple, Color.Teal, Color.DarkRed}
                'Dim obtainedColors As Color() = {Color.LimeGreen, Color.CornflowerBlue, Color.Orange, Color.MediumPurple, Color.Teal}
                Dim remainingColors As Color() = {Color.LightGray, Color.LightGray, Color.LightGray, Color.LightGray, Color.LightGray, Color.LightGray}

                Dim index As Integer = 0

                For Each row As DataRow In dt.Rows
                    Dim heads As String = row("Head").ToString()
                    Dim maxValues As Double = Convert.ToDouble(row("maxWeightage"))
                    Dim obtainedValues As Double = Convert.ToDouble(row("obtain_Weightage"))
                    Dim remaining = maxValues - obtainedValues

                    ' Create obtained point and set color
                    Dim obtainedPoint = obtainedSeries.Points.AddXY(heads, obtainedValues)
                    obtainedSeries.Points(index).Color = obtainedColors(index Mod obtainedColors.Length)

                    ' Create remaining point and set color
                    remainingSeries.Points.AddXY(heads, remaining)
                    remainingSeries.Points(index).Color = remainingColors(index Mod remainingColors.Length)

                    index += 1
                Next

                ' Add to chart
                Chart1.Series.Add(obtainedSeries)
                Chart1.Series.Add(remainingSeries)
                'Chart1.Width = 800
                Chart1.Width = 630
                Chart1.Height = 310

            Else
                'gvVendorHeader.DataSource = Nothing
                'gvVendorHeader.DataBind()
            End If
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Server.Transfer(returnUrl)
        End Try

    End Sub
    Protected Sub btnsearch_Click(sender As Object, e As EventArgs) Handles btnsearch.Click
        If String.IsNullOrEmpty(ddlquartor.Text) Then
            lblError.Text = "Please Select Quartor."
            ddlquartor.Focus()
            Exit Sub
        End If
        If (userInfo.userGroupCodeEntity.Equals("HO-MARKETING") Or userInfo.userGroupCodeEntity.Equals("SYSADMIN") Or userInfo.userGroupCodeEntity.Equals("DEPOT")) Then
            Dim type As String = ddlType.SelectedValue
            If Not String.IsNullOrEmpty(type) Then
                If type.Equals("GRPS") Then
                    divVendorGroup.Visible = True
                    divVendorRating.Visible = False
                    divSrcVendorGroup.Visible = True
                    divSrcVendor.Visible = False
                    divHeaderList.Visible = False
                ElseIf type.Equals("HEAD") Then
                    divVendorGroup.Visible = False
                    divVendorRating.Visible = False
                    divSrcVendorGroup.Visible = False
                    divSrcVendor.Visible = False
                    divSrcProductGroup.Visible = False
                    divSrcProduct.Visible = False
                    divHeaderList.Visible = True
                Else
                    divHeaderList.Visible = False
                    divVendorGroup.Visible = False
                    divVendorRating.Visible = True
                    divSrcVendorGroup.Visible = True
                    divSrcVendor.Visible = True
                    divSrcProductGroup.Visible = True
                    divSrcProduct.Visible = True
                End If
            End If

            BindGrid()
            'gvVendorHeader.Visible = True
            divVendorDashboard.Visible = False
        End If

        If userInfo.userGroupCodeEntity.Equals("UNIT") Then
            BindVendorGrid()
            divVendorDashboard.Visible = True
        End If
        ddlquartor.Enabled = False
        'btnsearch.Enabled = False
    End Sub

    Protected Sub btnReset_Click(sender As Object, e As EventArgs) Handles btnReset.Click
        Dim path = "~/vrs_vendorrating_mstr.aspx"

        If Not (Request.QueryString.Count = 0) Then
            path += Request.Url.Query
            Response.Redirect(path)
        Else
            Response.Redirect(path)
        End If
    End Sub

    'Protected Sub gvVendor_Rate_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvVendor_Rate.PageIndexChanging
    '    Try
    '        gvVendor_Rate.PageIndex = e.NewPageIndex
    '        BindGrid()
    '    Catch ex As Exception
    '        Dim returnUrl As String = "~/ExceptionPage.aspx"
    '        Session(Constant.SessionKeys.ErrMessage) = ex.ToString()
    '        Response.Redirect(returnUrl)
    '    End Try
    'End Sub

    Protected Sub gvVendorHeader_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        If e.CommandName = "ViewDetails" Then
            Dim args As String() = e.CommandArgument.ToString().Split("|"c)
            Dim obj As New Vendor_RatingClass
            If args.Length = 2 Then
                Dim vendorId As String = args(0)
                Dim head As String = args(1)

                If head.Equals("Statutory", StringComparison.InvariantCulture) Then
                    Dim ds As DataSet = obj.Get_StatutorydtsByHdr(vendorId)

                    gvStatutoryDetails.DataSource = ds.Tables(0)
                    gvStatutoryDetails.DataBind()
                    If (ds.Tables(1).Rows.Count > 0) Then
                        txttotalTargetScore.Text = ds.Tables(1).Rows(0)("max_score").ToString()
                        txttotalObtainScore.Text = ds.Tables(1).Rows(0)("obtain_score").ToString()
                        txttotalObtainPercentage.Text = ds.Tables(1).Rows(0)("obtain_percentage_legal").ToString()
                        txtWeightage.Text = ds.Tables(1).Rows(0)("obtain_Weightage_legal").ToString()
                    End If
                    mpStatutory.Show()
                End If
                If head.Equals("Quality", StringComparison.InvariantCulture) Then
                    Dim ds As DataSet
                    If (userInfo.userGroupCodeEntity.Equals("HO-MARKETING") Or userInfo.userGroupCodeEntity.Equals("SYSADMIN") Or userInfo.userGroupCodeEntity.Equals("DEPOT")) Then
                        ds = obj.Get_QualitydtsByHdr(ddlquartor.SelectedValue, ddlVendor.SelectedValue)
                        Repeater1.DataSource = ds.Tables(2)
                        Repeater1.DataBind()
                        If (ds.Tables(3).Rows.Count > 0) Then
                            txtQualitytargetScore.Text = ds.Tables(3).Rows(0)("dfq_total_score").ToString()
                            txtQualityTotalObtainScore.Text = ds.Tables(3).Rows(0)("dfq_total_obtain_score").ToString()
                            'txtQualityObtainPercentage.Text = ds.Tables(3).Rows(0)("obtain_percentage_quality").ToString()
                            txtQualityObtainWeightage.Text = ds.Tables(3).Rows(0)("obtain_Weightage_quality").ToString()
                        End If
                    End If
                    If (userInfo.userGroupCodeEntity.Equals("UNIT")) Then
                        ds = obj.Get_QualitydtsByHdr(ddlquartor.SelectedValue, userInfo.userIDEntity.ToString())

                        Repeater1.DataSource = ds.Tables(2)
                        Repeater1.DataBind()
                        If (ds.Tables(3).Rows.Count > 0) Then
                            txtQualitytargetScore.Text = ds.Tables(3).Rows(0)("dfq_total_score").ToString()
                            txtQualityTotalObtainScore.Text = ds.Tables(3).Rows(0)("dfq_total_obtain_score").ToString()
                            'txtQualityObtainPercentage.Text = ds.Tables(3).Rows(0)("obtain_percentage_quality").ToString()
                            txtQualityObtainWeightage.Text = ds.Tables(3).Rows(0)("obtain_Weightage_quality").ToString()
                        End If
                    End If
                    mpQuality.Show()
                End If
                If head.Equals("Audit", StringComparison.InvariantCulture) Then
                    Dim ds As DataSet = obj.Get_AuditdtsByHdr(ddlquartor.SelectedValue, vendorId)

                    gvAuditDetails.DataSource = ds.Tables(0)
                    gvAuditDetails.DataBind()
                    If (ds.Tables(1).Rows.Count > 0) Then
                        txtAuditTargetScore.Text = ds.Tables(1).Rows(0)("total_score_audit").ToString()
                        txtAuditObtainScore.Text = ds.Tables(1).Rows(0)("obtain_score_audit").ToString()
                        txtAuditObtainPercentage.Text = ds.Tables(1).Rows(0)("obtain_percentage_audit").ToString()
                        txtAuditObtainWeightage.Text = ds.Tables(1).Rows(0)("obtain_Weightage_audit").ToString()
                    End If
                    mpAudit.Show()
                End If
                If head.Equals("Service", StringComparison.InvariantCulture) Then
                    Dim ds As DataSet = obj.Get_Servicedts(ddlquartor.SelectedValue, vendorId, "")
                End If
                If head.Equals("Complaints", StringComparison.InvariantCulture) Then
                    Dim ds As DataSet = obj.Get_complaintdtlsByHdr(ddlquartor.SelectedValue, vendorId)
                    gvComplaintsDtls.DataSource = ds.Tables(0)
                    gvComplaintsDtls.DataBind()
                    If (ds.Tables(1).Rows.Count > 0) Then
                        txtCompTargetScore.Text = ds.Tables(1).Rows(0)("vch_total_max_score").ToString()
                        txtCompObtainScore.Text = ds.Tables(1).Rows(0)("vch_total_obtain_score").ToString()
                        'txtCompObtainPercentage.Text = ds.Tables(1).Rows(0)("obtain_percentage_complaints").ToString()
                        txtCompObtainWeightage.Text = ds.Tables(1).Rows(0)("obtain_Weightage_complaints").ToString()
                    End If
                    'mpComplaints.Show()
                End If
            End If
        End If
    End Sub
    Protected Sub btnClosePopup_Click(sender As Object, e As EventArgs)
        mpStatutory.Hide()
    End Sub
    Protected Sub btnQualityPopupclose_Click(sender As Object, e As EventArgs)
        mpQuality.Hide()
    End Sub
    Protected Sub Repeater1_ItemDataBound(sender As Object, e As RepeaterItemEventArgs)
        Dim obj As New Vendor_RatingClass
        Dim item As RepeaterItem = e.Item
        Dim brand As String = TryCast(item.FindControl("hdnBrand"), HiddenField).Value
        Dim brandname As String = brand
        Dim skudesc As String = TryCast(item.FindControl("hdnsku"), HiddenField).Value
        Dim sku As String = skudesc
        Dim gvTestList As GridView = CType(e.Item.FindControl("gvTestList"), GridView)
        Dim gvExteriorTestList As GridView = CType(e.Item.FindControl("gvExteriorTestList"), GridView)
        Dim ds As DataSet
        If (userInfo.userGroupCodeEntity.Equals("HO-MARKETING") Or userInfo.userGroupCodeEntity.Equals("SYSADMIN") Or userInfo.userGroupCodeEntity.Equals("DEPOT")) Then
            ds = obj.Get_QualitydtsByHdr(ddlquartor.SelectedValue, hdnIndvendorid.Value)
        End If
        If (userInfo.userGroupCodeEntity.Equals("UNIT")) Then
            ds = obj.Get_QualitydtsByHdr(ddlquartor.SelectedValue, userInfo.userIDEntity.ToString())
        End If
        Dim dtIntQuality As DataTable = ds.Tables(0)
        Dim dtExtQuality As DataTable = ds.Tables(1)
        'Dim filterExpression As String = "brand_name = '" & brandname.Replace("'", "''") & "'"
        Dim filterExpression As String = "brand_name = '" & brandname.Replace("'", "''") & "' AND sku_code = '" & sku & "'"

        If Not String.IsNullOrEmpty(brandname) AndAlso dtIntQuality.Rows.Count > 0 Then
            Dim dr() As DataRow = dtIntQuality.Select(filterExpression)
            If dr.Length > 0 Then
                Dim FilterDtInt As DataTable = dr.CopyToDataTable()
                gvTestList.DataSource = FilterDtInt
                gvTestList.DataBind()
            End If
        End If
        If Not String.IsNullOrEmpty(brandname) AndAlso dtExtQuality.Rows.Count > 0 Then
            Dim dr() As DataRow = dtExtQuality.Select(filterExpression)
            If dr.Length > 0 Then
                Dim FilterDtExt As DataTable = dr.CopyToDataTable()
                gvExteriorTestList.DataSource = FilterDtExt
                gvExteriorTestList.DataBind()
            End If
        End If


    End Sub
    Protected Sub btnAuditClosePopup_Click(sender As Object, e As EventArgs)
        mpAudit.Hide()
    End Sub
    Protected Sub btnComplaintsClosePopup_Click(sender As Object, e As EventArgs)
        mpComplaints.Hide()
    End Sub
    'Protected Sub gvVendor_Rate_RowDataBound(sender As Object, e As GridViewRowEventArgs)
    '    If (e.Row.RowType = DataControlRowType.DataRow) Then
    '        Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)

    '        Dim lblStatutory As Label = CType(e.Row.FindControl("lbl_StatutoryWeightage"), Label)
    '        Dim lblQuality As Label = CType(e.Row.FindControl("lbl_QualityWeightage"), Label)
    '        Dim lblAudit As Label = CType(e.Row.FindControl("lbl_AuditWeightage"), Label)
    '        Dim lblService As Label = CType(e.Row.FindControl("lbl_ServiceWeightage"), Label)
    '        Dim lblComplaints As Label = CType(e.Row.FindControl("lbl_ComplaintsWeightage"), Label)
    '        Dim btnView As Button = CType(e.Row.FindControl("btnView"), Button)
    '        If (Convert.ToDecimal(lblStatutory.Text) > 0 Or Convert.ToDecimal(lblQuality.Text) > 0 Or Convert.ToDecimal(lblAudit.Text) > 0 Or Convert.ToDecimal(lblService.Text) > 0 Or Convert.ToDecimal(lblComplaints.Text) > 0) Then
    '            btnView.Visible = True
    '        Else
    '            btnView.Visible = False
    '        End If

    '    End If
    'End Sub
    'Protected Sub gvVendor_Rate_RowCommand(sender As Object, e As GridViewCommandEventArgs)
    '    If e.CommandName = "ViewDetails" Then
    '        Dim vendorId As String = e.CommandArgument.ToString()
    '        ddlVendor.SelectedValue = vendorId
    '        ddlVendor.Enabled = False
    '        divVendorRating.Visible = False
    '        divVendorDashboard.Visible = True
    '        BindvendorIndividualGrid(vendorId)
    '    End If
    'End Sub

    Protected Sub LnkStatutoryDtls_Click(sender As Object, e As EventArgs)
        Dim hdrid As String = hdn_hdrSat.Value.ToString()
        Dim obj As New Vendor_RatingClass
        Dim ds As DataSet = obj.Get_StatutorydtsByHdr(hdrid)

        gvStatutoryDetails.DataSource = ds.Tables(0)
        gvStatutoryDetails.DataBind()
        If (ds.Tables(1).Rows.Count > 0) Then
            txttotalTargetScore.Text = ds.Tables(1).Rows(0)("max_score").ToString()
            txttotalObtainScore.Text = ds.Tables(1).Rows(0)("obtain_score").ToString()
            txttotalObtainPercentage.Text = ds.Tables(1).Rows(0)("obtain_percentage_legal").ToString()
            txtWeightage.Text = ds.Tables(1).Rows(0)("obtain_Weightage_legal").ToString()
        End If
        mpStatutory.Show()
    End Sub
    Protected Sub LnkQualityDtls_Click(sender As Object, e As EventArgs)
        Dim obj As New Vendor_RatingClass
        Dim ds As DataSet
        If (userInfo.userGroupCodeEntity.Equals("HO-MARKETING") Or userInfo.userGroupCodeEntity.Equals("SYSADMIN") Or userInfo.userGroupCodeEntity.Equals("DEPOT")) Then
            ds = obj.Get_QualitydtsByHdr(ddlquartor.SelectedValue, hdnIndvendorid.Value)
            Repeater1.DataSource = ds.Tables(2)
            Repeater1.DataBind()
            If (ds.Tables(3).Rows.Count > 0) Then
                txtQualitytargetScore.Text = ds.Tables(3).Rows(0)("dfq_total_score").ToString()
                txtQualityTotalObtainScore.Text = ds.Tables(3).Rows(0)("dfq_total_obtain_score").ToString()
                'txtQualityObtainPercentage.Text = ds.Tables(3).Rows(0)("obtain_percentage_quality").ToString()
                txtQualityObtainWeightage.Text = ds.Tables(3).Rows(0)("obtain_Weightage_quality").ToString()
            End If
        End If
        If (userInfo.userGroupCodeEntity.Equals("UNIT")) Then
            ds = obj.Get_QualitydtsByHdr(ddlquartor.SelectedValue, userInfo.userIDEntity.ToString())

            Repeater1.DataSource = ds.Tables(2)
            Repeater1.DataBind()
            If (ds.Tables(3).Rows.Count > 0) Then
                txtQualitytargetScore.Text = ds.Tables(3).Rows(0)("dfq_total_score").ToString()
                txtQualityTotalObtainScore.Text = ds.Tables(3).Rows(0)("dfq_total_obtain_score").ToString()
                'txtQualityObtainPercentage.Text = ds.Tables(3).Rows(0)("obtain_percentage_quality").ToString()
                txtQualityObtainWeightage.Text = ds.Tables(3).Rows(0)("obtain_Weightage_quality").ToString()
            End If
        End If
        mpQuality.Show()
    End Sub
    Protected Sub LnkAuditDtls_Click(sender As Object, e As EventArgs)
        Dim hdrid As String = hdn_Audithdr.Value.ToString()
        Dim obj As New Vendor_RatingClass
        Dim ds As DataSet = obj.Get_AuditdtsByHdr(ddlquartor.SelectedValue, hdrid)
        gvAuditDetails.DataSource = ds.Tables(0)
        gvAuditDetails.DataBind()
        If (ds.Tables(1).Rows.Count > 0) Then
            txtAuditTargetScore.Text = ds.Tables(1).Rows(0)("total_score_audit").ToString()
            txtAuditObtainScore.Text = ds.Tables(1).Rows(0)("obtain_score_audit").ToString()
            txtAuditObtainPercentage.Text = ds.Tables(1).Rows(0)("obtain_percentage_audit").ToString()
            txtAuditObtainWeightage.Text = ds.Tables(1).Rows(0)("obtain_Weightage_audit").ToString()
        End If
        mpAudit.Show()
    End Sub
    Protected Sub LnkServiceDtls_Click(sender As Object, e As EventArgs)
        Dim obj As New Vendor_RatingClass
        Dim ds As DataSet
        'If (userInfo.userGroupCodeEntity.Equals("HO-MARKETING") Or userInfo.userGroupCodeEntity.Equals("SYSADMIN") Or userInfo.userGroupCodeEntity.Equals("DEPOT")) Then
        '    ds = obj.Get_Servicedts(ddlquartor.SelectedValue, hdnIndvendorid.Value)
        '    gvServiceDtls.DataSource = ds.Tables(0)
        '    gvServiceDtls.DataBind()
        '    If (ds.Tables(1).Rows.Count > 0) Then
        '        txtServiceTargetScore.Text = ds.Tables(1).Rows(0)("max_score").ToString()
        '        txtServiceTotalObtain.Text = ds.Tables(1).Rows(0)("obtain_percentage_service").ToString()
        '        txtServiceObtainPer.Text = ds.Tables(1).Rows(0)("obtain_percentage_service").ToString()
        '        txtServiceObtainWeightage.Text = ds.Tables(1).Rows(0)("obtain_Weightage_service").ToString()
        '    End If
        'End If
        'If (userInfo.userGroupCodeEntity.Equals("UNIT")) Then
        '    ds = obj.Get_Servicedts(ddlquartor.SelectedValue, userInfo.userIDEntity.ToString())

        '    gvServiceDtls.DataSource = ds.Tables(0)
        '    gvServiceDtls.DataBind()
        '    If (ds.Tables(1).Rows.Count > 0) Then
        '        txtServiceTargetScore.Text = ds.Tables(1).Rows(0)("max_score").ToString()
        '        txtServiceTotalObtain.Text = ds.Tables(1).Rows(0)("obtain_percentage_service").ToString()
        '        txtServiceObtainPer.Text = ds.Tables(1).Rows(0)("obtain_percentage_service").ToString()
        '        txtServiceObtainWeightage.Text = ds.Tables(1).Rows(0)("obtain_Weightage_service").ToString()
        '    End If
        'End If
        'mpService.Show()
        If (userInfo.userGroupCodeEntity.Equals("HO-MARKETING") Or userInfo.userGroupCodeEntity.Equals("SYSADMIN") Or userInfo.userGroupCodeEntity.Equals("DEPOT")) Then
            ds = obj.Get_GrpServicedts(ddlquartor.SelectedValue, hdnIndvendorid.Value)
            gvgrpService.DataSource = ds.Tables(0)
            gvgrpService.DataBind()

            If (ds.Tables(1).Rows.Count > 0) Then
                txtgrpServicetargetweightage.Text = Convert.ToString(ds.Tables(1).Rows(0)("maxWeightage_Servicegrp"))
                txtgrpServiceObtainweightage.Text = Convert.ToString(ds.Tables(1).Rows(0)("obtain_Weightage_servicegrp"))
                txtVendorServiceAblity.Text = Convert.ToString(ds.Tables(1).Rows(0)("vendor_serviceablity"))
            End If
        End If
        If (userInfo.userGroupCodeEntity.Equals("UNIT")) Then
            ds = obj.Get_GrpServicedts(ddlquartor.SelectedValue, userInfo.userIDEntity.ToString())

            gvgrpService.DataSource = ds.Tables(0)
            gvgrpService.DataBind()

            If (ds.Tables(1).Rows.Count > 0) Then
                txtgrpServicetargetweightage.Text = Convert.ToString(ds.Tables(1).Rows(0)("maxWeightage_Servicegrp"))
                txtgrpServiceObtainweightage.Text = Convert.ToString(ds.Tables(1).Rows(0)("obtain_Weightage_servicegrp"))
                txtVendorServiceAblity.Text = Convert.ToString(ds.Tables(1).Rows(0)("vendor_serviceablity"))
            End If
        End If
        divProductGroup.Visible = True
        divProduct.Visible = False
        mpgrpService.Show()
    End Sub
    Protected Sub LnkSCpomplaintsDtls_Click(sender As Object, e As EventArgs)
        Dim hdrid As String = hdn_Complaintshdr.Value.ToString()
        Dim obj As New Vendor_RatingClass
        Dim ds As DataSet = obj.Get_complaintdtlsByHdr(ddlquartor.SelectedValue, hdrid)
        gvComplaintsDtls.DataSource = ds.Tables(0)
        gvComplaintsDtls.DataBind()
        If (ds.Tables(1).Rows.Count > 0) Then
            txtCompTargetScore.Text = ds.Tables(1).Rows(0)("vch_total_max_score").ToString()
            txtCompObtainScore.Text = ds.Tables(1).Rows(0)("vch_total_obtain_score").ToString()
            'txtCompObtainPercentage.Text = ds.Tables(1).Rows(0)("obtain_percentage_complaints").ToString()
            txtCompObtainWeightage.Text = ds.Tables(1).Rows(0)("obtain_Weightage_complaints").ToString()
        End If
        mpComplaints.Show()
    End Sub
    Protected Sub RatingRepeater_ItemDataBound(sender As Object, e As RepeaterItemEventArgs)
        Dim obj As New Vendor_RatingClass
        Dim item As RepeaterItem = e.Item
        Dim dt As DataTable

        dt = ViewState("ScoreDtls")
        Dim Score As Object = TryCast(item.FindControl("CircularProgressBar1"), UserControl)
        Dim hdnTotal As HiddenField = TryCast(item.FindControl("hdnTotal"), HiddenField)
        Dim LnkViewDetails As LinkButton = TryCast(item.FindControl("LnkViewDetails"), LinkButton)
        If hdnTotal.Value <= 0 Then
            LnkViewDetails.Visible = False
        End If
        Score.SetRating(hdnTotal.Value)
    End Sub
    Protected Sub LnkViewDetails_Click(sender As Object, e As EventArgs)
        Dim lnk As LinkButton = CType(sender, LinkButton)
        Dim vendorId As String = 0
        ' Get the parent RepeaterItem
        Dim item As RepeaterItem = CType(lnk.NamingContainer, RepeaterItem)

        ' Find the HiddenField inside that item
        Dim hdnVendorID As HiddenField = CType(item.FindControl("hdnvendorID"), HiddenField)

        If hdnVendorID IsNot Nothing Then
            vendorId = hdnVendorID.Value
            hdnIndvendorid.Value = vendorId
        End If
        ddlVendor.SelectedValue = vendorId
        ddlVendor.Enabled = False
        divVendorRating.Visible = False
        'divTopVendor.Visible = False
        divVendorDashboard.Visible = True
        BindvendorIndividualGrid(vendorId)

    End Sub

    Private Sub PopulateVendorProduct(ByVal vendorCode As String)
        CheckLogin()
        Try
            Dim obj As New Vendor_RatingClass
            Dim dsUnitSet As New DataSet

            dsUnitSet = obj.Get_VendorWiseProductList(vendorCode, userInfo.userIDEntity)
            ddlProduct.Items.Clear()
            If (Not (dsUnitSet Is Nothing) AndAlso dsUnitSet.Tables.Count > 0 AndAlso Not (dsUnitSet.Tables(0) Is Nothing) AndAlso dsUnitSet.Tables(0).Rows.Count > 0) Then
                ddlProduct.DataSource = dsUnitSet.Tables(0)
                ddlProduct.DataTextField = "product_name"
                ddlProduct.DataValueField = "product_code"
                ddlProduct.DataBind()
                ddlProduct.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
            Else
                ddlProduct.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
                'ddlProduct_SelectedIndexChanged(Nothing, Nothing)
            End If
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Server.Transfer(returnUrl)
        End Try

    End Sub

    Private Sub PopulateVendorBrand(ByVal vendorCode As String)
        CheckLogin()
        Try
            Dim obj As New DeviationsFGQualityClass
            Dim dsUnitSet As New DataSet

            dsUnitSet = obj.GetVendorBrand(vendorCode, userInfo.userIDEntity)
            ddlBrand.Items.Clear()
            If (Not (dsUnitSet Is Nothing) AndAlso dsUnitSet.Tables.Count > 0 AndAlso Not (dsUnitSet.Tables(0) Is Nothing) AndAlso dsUnitSet.Tables(0).Rows.Count > 0) Then
                ddlBrand.DataSource = dsUnitSet.Tables(0)
                ddlBrand.DataTextField = "brand_name"
                ddlBrand.DataValueField = "brand_id"
                ddlBrand.DataBind()
                ddlBrand.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
            Else
                ddlBrand.Items.Insert(0, New ListItem(Constant.Common.Selec, String.Empty, True))
                'ddlBrand_SelectedIndexChanged(Nothing, Nothing)
            End If
        Catch ex As Exception
            Dim returnUrl As String = "~/ExceptionPage.aspx"
            Session(Constant.SessionKeys.ErrMessage) = Constant.ErrorMessages.GeneralError
            Server.Transfer(returnUrl)
        End Try

    End Sub

    Protected Sub ddlVendor_SelectedIndexChanged(sender As Object, e As EventArgs)
        PopulateVendorBrand(ddlVendor.SelectedValue)
    End Sub
    Protected Sub btnback_Click(sender As Object, e As EventArgs)
        divVendorDashboard.Visible = False
        divVendorRating.Visible = True
        divTopVendor.Visible = True
        ddlVendor.SelectedIndex = -1
        ddlVendor.Enabled = True
        BindGrid()
        btnsearch_Click(sender, New EventArgs)
        ddlVendor.Enabled = True

    End Sub



    Protected Sub RatingRepeater_ItemCommand(source As Object, e As RepeaterCommandEventArgs)
        Dim obj As New Vendor_RatingClass
        Dim item As RepeaterItem = e.Item
        If e.CommandName = "ViewProduct" Then
            Dim selectedvendorcode As String = e.CommandArgument.ToString()
            Dim hdnvendorID As HiddenField = TryCast(item.FindControl("hdnvendorID"), HiddenField)
            If hdnvendorID IsNot Nothing And Not String.IsNullOrEmpty(hdnvendorID.Value) Then
                If hdnvendorID.Value = selectedvendorcode Then
                    Dim ds As DataSet = obj.Get_VendorWiseProdut(hdnvendorID.Value, ddlquartor.SelectedValue)
                    ' Dim gvVendorWiseProduct As GridView = CType(item.FindControl("gvVendorWiseProduct"), GridView)
                    gvVendorWiseProduct.DataSource = ds
                    gvVendorWiseProduct.DataBind()
                    mpVendorWiseProduct.Show()

                End If
            End If
        End If
    End Sub
    Protected Sub btnProductPopup_Click(sender As Object, e As EventArgs)
        mpVendorWiseProduct.Hide()
        BindGrid()
    End Sub
    Protected Sub ddlVendorGrp_SelectedIndexChanged(sender As Object, e As EventArgs)
        Populate_GroupWise_Vendor(ddlVendorGrp.SelectedValue)
    End Sub
    Protected Sub ddlBrand_SelectedIndexChanged(sender As Object, e As EventArgs)

    End Sub
    Protected Sub btnCloseServicePopup_Click(sender As Object, e As EventArgs)

    End Sub
    Protected Sub btnCloseServicegrp_Click(sender As Object, e As EventArgs)

    End Sub
    Protected Sub gvgrpService_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        Dim obj As New Vendor_RatingClass
        Dim ds As DataSet
        If e.CommandName = "ViewProductDetails" Then

            Dim args As String() = e.CommandArgument.ToString().Split("|"c)

            If args.Length = 2 Then
                Dim vendorId As String = args(0)
                Dim brandID As String = args(1)
                If (userInfo.userGroupCodeEntity.Equals("HO-MARKETING") Or userInfo.userGroupCodeEntity.Equals("SYSADMIN") Or userInfo.userGroupCodeEntity.Equals("DEPOT")) Then
                    ds = obj.Get_Servicedts(ddlquartor.SelectedValue, hdnIndvendorid.Value, brandID)
                    gvServiceDtls.DataSource = ds.Tables(0)
                    gvServiceDtls.DataBind()
                    If (ds.Tables(1).Rows.Count > 0) Then
                        txtServiceBrandName.Text = Convert.ToString(ds.Tables(1).Rows(0)("bm_brand_name"))
                        txtServiceTotalVol.Text = Convert.ToString(ds.Tables(1).Rows(0)("vgs_despatch_vol"))
                        txtServiceGrpserviceablity.Text = Convert.ToString(ds.Tables(1).Rows(0)("vgs_group_serviceablity"))
                    End If
                End If
                If (userInfo.userGroupCodeEntity.Equals("UNIT")) Then
                    ds = obj.Get_Servicedts(ddlquartor.SelectedValue, userInfo.userIDEntity.ToString(), brandID)

                    gvServiceDtls.DataSource = ds.Tables(0)
                    gvServiceDtls.DataBind()
                    If (ds.Tables(1).Rows.Count > 0) Then
                        txtServiceBrandName.Text = Convert.ToString(ds.Tables(1).Rows(0)("bm_brand_name"))
                        txtServiceTotalVol.Text = Convert.ToString(ds.Tables(1).Rows(0)("vgs_despatch_vol"))
                        txtServiceGrpserviceablity.Text = Convert.ToString(ds.Tables(1).Rows(0)("vgs_group_serviceablity"))
                    End If
                End If

                divProductGroup.Visible = False
                divProduct.Visible = True

                'mpService.Show()
                'mpgrpService.Hide()
            End If
        End If
    End Sub
    Protected Sub btnServiceBack_Click(sender As Object, e As EventArgs)
        divProductGroup.Visible = True
        divProduct.Visible = False
    End Sub
    Protected Sub ddlType_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim type As String = ddlType.SelectedValue
        If Not String.IsNullOrEmpty(type) Then
            If type.Equals("GRPS") Then
                divSrcHeadGrp.Visible = False
                divTopVendor.Visible = False
                divHeaderList.Visible = False
                divVendorScoreCategoryLyTyWise.Visible = False
                divVendorGroup.Visible = True
                divVendorRating.Visible = False
                divSrcVendorGroup.Visible = True
                divSrcVendor.Visible = False
                divSrcProductGroup.Visible = True
                divSrcProduct.Visible = True
                ddlVendorGrp.SelectedIndex = -1
                ddlVendor.SelectedIndex = -1
            ElseIf type.Equals("HEAD") Then
                divSrcHeadGrp.Visible = True
                divTopVendor.Visible = False
                divVendorScoreCategoryLyTyWise.Visible = False
                divVendorGroup.Visible = False
                divVendorRating.Visible = False
                divSrcVendorGroup.Visible = False
                divSrcVendor.Visible = False
                divSrcProductGroup.Visible = False
                divSrcProduct.Visible = False
                ddlVendorGrp.SelectedIndex = -1
                ddlVendor.SelectedIndex = -1
            Else
                divSrcHeadGrp.Visible = False
                divTopVendor.Visible = False
                divHeaderList.Visible = False
                divVendorScoreCategoryLyTyWise.Visible = False
                divVendorGroup.Visible = False
                divVendorRating.Visible = False
                divSrcVendorGroup.Visible = True
                divSrcVendor.Visible = True
                divSrcProductGroup.Visible = True
                divSrcProduct.Visible = True
                ddlVendorGrp.SelectedIndex = -1
                ddlVendor.SelectedIndex = -1
            End If
        End If
    End Sub
    Protected Sub reptVendorGroup_ItemDataBound(sender As Object, e As RepeaterItemEventArgs)
        Dim obj As New Vendor_RatingClass
        Dim item As RepeaterItem = e.Item
        Dim dt As DataTable

        dt = ViewState("GroupScoreDtls")
        Dim progressBar As HtmlGenericControl = TryCast(item.FindControl("LinerProgressBar"), HtmlGenericControl)
        Dim lblGrpTotalScore As Label = TryCast(item.FindControl("lblGrpTotalScore"), Label)
        Dim hdrGrpGrade As HiddenField = TryCast(item.FindControl("hdrGrpGrade"), HiddenField)
        'Dim imgGrpGrade As Image = TryCast(item.FindControl("imgGrpGrade"), Image)
        Dim imgGrpGrade As System.Web.UI.WebControls.Image =
            TryCast(e.Item.FindControl("imgGrpGrade"), System.Web.UI.WebControls.Image)

        If lblGrpTotalScore IsNot Nothing AndAlso progressBar IsNot Nothing AndAlso hdrGrpGrade IsNot Nothing Then
            Dim score As Decimal = Convert.ToDecimal(lblGrpTotalScore.Text)
            progressBar.Style("width") = Convert.ToString(score) + "%"

            If score > 79 AndAlso score <= 100 Then
                progressBar.Style("background-color") = "#b68900"
            ElseIf score > 59 AndAlso score <= 79 Then
                progressBar.Style("background-color") = "#66b201"
            ElseIf score > 50 AndAlso score <= 59 Then
                progressBar.Style("background-color") = "#b31400"
            ElseIf score >= 0 AndAlso score <= 50 Then
                progressBar.Style("background-color") = "#008db6"
            End If


            Dim grade As String = hdrGrpGrade.Value
            If grade IsNot Nothing And Not String.IsNullOrEmpty(grade) Then
                If grade.Equals("Platimun") Then
                    imgGrpGrade.Attributes.Add("src", "images/platinum.png")
                ElseIf grade.Equals("Gold") Then
                    imgGrpGrade.Attributes.Add("src", "images/gold.png")
                ElseIf grade.Equals("Silver") Then
                    imgGrpGrade.Attributes.Add("src", "images/silver.png")
                ElseIf grade.Equals("Bronze") Then
                    imgGrpGrade.Attributes.Add("src", "images/bronze.png")
                End If
            End If

        End If
    End Sub
    Protected Sub reptVendorGroup_ItemCommand(source As Object, e As RepeaterCommandEventArgs)
        Dim obj As New Vendor_RatingClass
        Dim item As RepeaterItem = e.Item
        If e.CommandName = "ViewProduct" Then
            Dim selectedvendorcode As String = e.CommandArgument.ToString()
            Dim hdnvendorID As HiddenField = TryCast(item.FindControl("hdnvendorID"), HiddenField)
            If hdnvendorID IsNot Nothing And Not String.IsNullOrEmpty(hdnvendorID.Value) Then
                If hdnvendorID.Value = selectedvendorcode Then
                    Dim ds As DataSet = obj.Get_VendorWiseProdut(hdnvendorID.Value, ddlquartor.SelectedValue)
                    ' Dim gvVendorWiseProduct As GridView = CType(item.FindControl("gvVendorWiseProduct"), GridView)
                    gvVendorWiseProduct.DataSource = ds
                    gvVendorWiseProduct.DataBind()
                    mpVendorWiseProduct.Show()

                End If
            End If
        End If
    End Sub
    Protected Sub LnkGroupViewDetails_Click(sender As Object, e As EventArgs)
        Dim lnk As LinkButton = CType(sender, LinkButton)
        Dim item As RepeaterItem = CType(lnk.NamingContainer, RepeaterItem)
        Dim hdnVendorGroupId As HiddenField = CType(item.FindControl("hdnVendorGroupId"), HiddenField)

        If hdnVendorGroupId IsNot Nothing Then
            ddlVendorGrp.SelectedValue = hdnVendorGroupId.Value
            BindVendorListByGroupId()
            divVendorGroup.Visible = False
            divVendorRating.Visible = True
        End If
    End Sub
    Protected Sub btnLyTyPop_Click(sender As Object, e As EventArgs)
        mpLYTyDetails.Hide()
        btnsearch_Click(sender, New EventArgs)
    End Sub
    Protected Sub gvTy_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        If e.CommandName = "ViewDetails" Then

            Dim args As String() = e.CommandArgument.ToString().Split("|"c)
            Dim vendorId As String = args(0)
            Dim finyear As String = args(1)
            Dim obj As New Vendor_RatingClass
            Dim ds As New DataSet
            ds = obj.Get_VendorLYTY_DETAILS(vendorId, ddlquartor.SelectedValue, finyear)
            If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
                lblLtTyPopHdr.Text = "This year vendor details"
                gvLyTyDetails.DataSource = ds.Tables(0)
                gvLyTyDetails.DataBind()
                mpLYTyDetails.Show()
            Else
                gvLyTyDetails.DataSource = Nothing
                gvLyTyDetails.DataBind()
                mpLYTyDetails.Hide()
            End If
        End If
    End Sub
    Protected Sub gvLy_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        If e.CommandName = "ViewDetails" Then
            Dim args As String() = e.CommandArgument.ToString().Split("|"c)
            Dim vendorId As String = args(0)
            Dim finyear As String = args(1)


            Dim obj As New Vendor_RatingClass
            Dim ds As New DataSet
            ds = obj.Get_VendorLYTY_DETAILS(vendorId, ddlquartor.SelectedValue, finyear)
            If (Not (ds Is Nothing) AndAlso ds.Tables.Count > 0 AndAlso Not (ds.Tables(0) Is Nothing) AndAlso ds.Tables(0).Rows.Count > 0) Then
                lblLtTyPopHdr.Text = "last year vendor details"
                gvLyTyDetails.DataSource = ds.Tables(0)
                gvLyTyDetails.DataBind()
                mpLYTyDetails.Show()
            Else
                gvLyTyDetails.DataSource = Nothing
                gvLyTyDetails.DataBind()
                mpLYTyDetails.Hide()
            End If
        End If
    End Sub

    'Protected Sub reptHeadGrp_ItemDataBound(sender As Object, e As RepeaterItemEventArgs)

    'End Sub
    'Protected Sub reptHeadGrp_ItemCommand(source As Object, e As RepeaterCommandEventArgs)

    'End Sub
    Protected Sub rptHeadGrp_ItemDataBound(sender As Object, e As RepeaterItemEventArgs)
        Dim obj As New Vendor_RatingClass
        Dim item As RepeaterItem = e.Item
        Dim dt As DataTable

        dt = ViewState("HeadScoreDtls")

        Dim progressBar As HtmlGenericControl = TryCast(item.FindControl("LineHeadProgressBar"), HtmlGenericControl)
        Dim lblHeadTotalScore As Label = TryCast(item.FindControl("lblHeadTotalScore"), Label)
        Dim hdrheadname As HiddenField = TryCast(item.FindControl("hdrheadname"), HiddenField)
        'Dim imgGrpGrade As Image = TryCast(item.FindControl("imgGrpGrade"), Image)
        Dim imgGrpHead As System.Web.UI.WebControls.Image =
            TryCast(e.Item.FindControl("imgGrpHead"), System.Web.UI.WebControls.Image)

        If lblHeadTotalScore IsNot Nothing AndAlso progressBar IsNot Nothing AndAlso hdrheadname IsNot Nothing Then
            Dim score As Decimal = Convert.ToDecimal(lblHeadTotalScore.Text)
            progressBar.Style("width") = Convert.ToString(score) + "%"

            If score > 79 AndAlso score <= 100 Then
                progressBar.Style("background-color") = "#b68900"
            ElseIf score > 59 AndAlso score <= 79 Then
                progressBar.Style("background-color") = "#66b201"
            ElseIf score > 50 AndAlso score <= 59 Then
                progressBar.Style("background-color") = "#b31400"
            ElseIf score >= 0 AndAlso score <= 50 Then
                progressBar.Style("background-color") = "#008db6"
            End If
            'progressBar.Style("background-color") = "#b68900"

        End If

        Dim head As String = hdrheadname.Value
        If head IsNot Nothing And Not String.IsNullOrEmpty(head) Then
            If head.Equals("Statutory") Then
                imgGrpHead.Attributes.Add("src", "images/well.png")
            End If
            If head.Equals("Quality") Then
                imgGrpHead.Attributes.Add("src", "images/quality.png")
            End If
            If head.Equals("Audit") Then
                imgGrpHead.Attributes.Add("src", "images/audit.png")
            End If
            If head.Equals("Service") Then
                imgGrpHead.Attributes.Add("src", "images/service.png")
            End If
            If head.Equals("Complaints") Then
                imgGrpHead.Attributes.Add("src", "images/complaint.png")
            End If

        End If

    End Sub
    Protected Sub rptHeadGrp_ItemCommand(source As Object, e As RepeaterCommandEventArgs)

    End Sub
    Protected Sub ddlHead_SelectedIndexChanged(sender As Object, e As EventArgs)
        divVendorScoreCategoryLyTyWise.Visible = False
        divTopVendor.Visible = False
        divHeaderList.Visible = False
    End Sub

    Protected Sub ddlFinYear_SelectedIndexChanged(sender As Object, e As EventArgs)
        If String.IsNullOrEmpty(ddlFinYear.SelectedValue) Then
            ddlquartor.Items.Clear()
        Else
            Populate_Quarter()
        End If
    End Sub


End Class
