'**************************************************
'Copyright	    : VMS, MCC, KOLKATA
'Source	        : App_Code/UserLogin.vb
'Created Date	: 06-December-2007
'Created By	    : Saravanan
'Version	    : R02.00.00
'Description	: Code behind file for UserLogin Class

'Modified By       Modified On       Version         Reason

'*************************************************************
Imports System.Data
Imports System.Data.SqlClient
Imports System.Data.SqlTypes
Imports Microsoft.Office.Interop.Excel
Imports Microsoft.VisualBasic
Imports VMS.DataAccess

Namespace VMS.Web

    Public Class UserLogin

        Public Shared col_LR As New Collection

#Region "Login User Details"
        'Get Login user details
        Public Function LoginUserDetails(ByVal userName As String, ByVal password As String) As VMSUserEntity
            Dim userSet As DataSet
            Dim userInfo As VMSUserEntity = Nothing

            Dim sqlParams(1) As SqlParameter

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@usp_user_id"
            sqlParams(0).DbType = DbType.String
            sqlParams(0).Direction = Data.ParameterDirection.Input
            sqlParams(0).Value = userName

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@usp_pswd"
            sqlParams(1).DbType = DbType.String
            sqlParams(1).Direction = Data.ParameterDirection.Input
            sqlParams(1).Value = password

            userSet = DBFactory.GetHelper().ExecuteDataSet("LoginUser_Get", Data.CommandType.StoredProcedure, sqlParams)

            If (Not (userSet Is Nothing) AndAlso userSet.Tables.Count > 0) Then
                If (Not (userSet.Tables(0) Is Nothing) AndAlso userSet.Tables(0).Rows.Count > 0) Then
                    'HttpContext.Current.Session(Constant.SessionKeys.UserLogged) = True
                    userInfo = New VMSUserEntity()
                    userInfo.userIDEntity = IIf(userSet.Tables(0).Rows(0)("usp_user_id") Is DBNull.Value, String.Empty, userSet.Tables(0).Rows(0)("usp_user_id")).ToString
                    userInfo.userPWDEntity = IIf(userSet.Tables(0).Rows(0)("usp_pswd") Is DBNull.Value, String.Empty, userSet.Tables(0).Rows(0)("usp_pswd")).ToString
                    userInfo.userFirstNameEntity = IIf(userSet.Tables(0).Rows(0)("usp_first_name") Is DBNull.Value, String.Empty, userSet.Tables(0).Rows(0)("usp_first_name")).ToString
                    userInfo.userLastNameEntity = IIf(userSet.Tables(0).Rows(0)("usp_last_name") Is DBNull.Value, String.Empty, userSet.Tables(0).Rows(0)("usp_last_name")).ToString
                    userInfo.userGroupCodeEntity = IIf(userSet.Tables(0).Rows(0)("usp_group_code") Is DBNull.Value, String.Empty, userSet.Tables(0).Rows(0)("usp_group_code")).ToString
                    userInfo.userEmailEntity = IIf(userSet.Tables(0).Rows(0)("usp_mailid") Is DBNull.Value, String.Empty, userSet.Tables(0).Rows(0)("usp_mailid")).ToString
                    userInfo.userDepartmentEntity = IIf(userSet.Tables(0).Rows(0)("usp_dept") Is DBNull.Value, String.Empty, userSet.Tables(0).Rows(0)("usp_dept")).ToString
                    userInfo.userBranchEntity = IIf(userSet.Tables(0).Rows(0)("usp_branch") Is DBNull.Value, String.Empty, userSet.Tables(0).Rows(0)("usp_branch")).ToString
                    userInfo.userCompanyEntity = IIf(userSet.Tables(0).Rows(0)("usp_company") Is DBNull.Value, String.Empty, userSet.Tables(0).Rows(0)("usp_company")).ToString
                    userInfo.userRegionEntity = IIf(userSet.Tables(0).Rows(0)("usp_region") Is DBNull.Value, String.Empty, userSet.Tables(0).Rows(0)("usp_region")).ToString
                    userInfo.userRptManagerEntity = IIf(userSet.Tables(0).Rows(0)("usp_reporting_manager") Is DBNull.Value, String.Empty, userSet.Tables(0).Rows(0)("usp_reporting_manager")).ToString
                    userInfo.userStatusEntity = IIf(userSet.Tables(0).Rows(0)("active") Is DBNull.Value, String.Empty, userSet.Tables(0).Rows(0)("active")).ToString
                    userInfo.currentFinancialYearEntity = IIf(userSet.Tables(0).Rows(0)("CurrentFinYear") Is DBNull.Value, String.Empty, userSet.Tables(0).Rows(0)("CurrentFinYear")).ToString

                    'Changes By Sumeet 26-02-2015 (Start)
                    userInfo.UserPasswordChangeDifferenceEntity = IIf(userSet.Tables(0).Rows(0)("DateDifference") Is DBNull.Value, 0, userSet.Tables(0).Rows(0)("DateDifference")).ToString

                    'Code to trac   
                    Dim addr As String = GetIPAddress()

                    'Code to trace IP
                    UserHistoryInsert(userInfo.userCompanyEntity, userInfo.userIDEntity, userInfo.userGroupCodeEntity, addr)


                End If
            End If

            Return userInfo
        End Function
#End Region


        Public Function GetIPAddress() As String
            Dim context As System.Web.HttpContext = System.Web.HttpContext.Current()
            Dim sIPAddress As String = context.Request.ServerVariables("HTTP_X_FORWARDED_FOR")
            If String.IsNullOrEmpty(sIPAddress) Then
                Return context.Request.ServerVariables("REMOTE_ADDR")
            Else
                Dim ipArray As String() = sIPAddress.Split(New [Char]() {","c})
                Return ipArray(0)
            End If
        End Function
#Region "Login Statistics Insert"

        'Insert User Login History
        Public Function UserHistoryInsert(ByVal Company As String, ByVal userId As String, ByVal groupCode As String, ByVal ip As String) As Integer

            'sqlConn checks the status of Sql connection whether in open or close state
            Dim sqlConn As SqlConnection = Nothing
            'sqlTrans checks the type of operation to be performed for a particular Sql transaction
            Dim sqlTrans As SqlTransaction = Nothing
            Dim numRowsAffected As Integer
            Dim sqlParams(3) As SqlParameter
            Try

                sqlConn = DBFactory.GetHelper.OpenConnection()
                sqlTrans = sqlConn.BeginTransaction()

                sqlParams(0) = New SqlParameter()
                sqlParams(0).ParameterName = "@uh_company"
                sqlParams(0).DbType = DbType.String
                sqlParams(0).Direction = Data.ParameterDirection.Input
                sqlParams(0).Value = Company

                sqlParams(1) = New SqlParameter()
                sqlParams(1).ParameterName = "@uh_userid"
                sqlParams(1).DbType = DbType.String
                sqlParams(1).Direction = Data.ParameterDirection.Input
                sqlParams(1).Value = userId

                sqlParams(2) = New SqlParameter()
                sqlParams(2).ParameterName = "@uh_user_group"
                sqlParams(2).DbType = DbType.String
                sqlParams(2).Direction = Data.ParameterDirection.Input
                sqlParams(2).Value = groupCode

                sqlParams(3) = New SqlParameter()
                sqlParams(3).ParameterName = "@uh_logged_ip"
                sqlParams(3).DbType = DbType.String
                sqlParams(3).Direction = Data.ParameterDirection.Input
                sqlParams(3).Value = ip

                'sqlCmd is the object instance of the SqlCommand 
                Dim sqlCmd As New SqlCommand()
                sqlCmd.Connection = sqlConn
                sqlCmd.Transaction = sqlTrans
                sqlCmd.CommandType = CommandType.StoredProcedure
                sqlCmd.CommandText = "UserHistory_Insert"
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
#End Region

#Region "Login User Access Forms"
        'Get Login user Access forms
        Public Function LoginUserFormAccess(ByVal Company As String, ByVal userId As String, ByVal groupCode As String) As DataSet
            Dim LoginUserSet As DataSet
            Dim sqlParams(2) As SqlParameter

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@logincompany"
            sqlParams(0).DbType = DbType.String
            sqlParams(0).Direction = Data.ParameterDirection.Input
            sqlParams(0).Value = Company

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@logingrpid"
            sqlParams(1).DbType = DbType.String
            sqlParams(1).Direction = Data.ParameterDirection.Input
            sqlParams(1).Value = groupCode

            sqlParams(2) = New SqlParameter()
            sqlParams(2).ParameterName = "@loginuserid"
            sqlParams(2).DbType = DbType.String
            sqlParams(2).Direction = Data.ParameterDirection.Input
            sqlParams(2).Value = userId

            'LoginUserSet = DBFactory.GetHelper().ExecuteDataSet("LoginUserAccessForms_Get", Data.CommandType.StoredProcedure, sqlParams)
            LoginUserSet = DBFactory.GetHelper().ExecuteDataSet("[dbo].[LoginUserAccessForms_Get_vr1]", Data.CommandType.StoredProcedure, sqlParams)

            Return LoginUserSet

        End Function

#End Region

#Region "Home Page Today Closed"
        'Get Today Closed
        Public Function GetTodayClosed(ByVal Company As String) As DataSet
            Dim TodayClosedSet As DataSet
            Dim sqlParams(0) As SqlParameter

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@logincompany"
            sqlParams(0).DbType = DbType.String
            sqlParams(0).Direction = Data.ParameterDirection.Input
            sqlParams(0).Value = Company

            TodayClosedSet = DBFactory.GetHelper().ExecuteDataSet("TodayClosed_Get", Data.CommandType.StoredProcedure, sqlParams)

            Return TodayClosedSet

        End Function

#End Region

#Region "Home Page Today's Registration"
        'Get Today Registration
        Public Function GetTodayReg(ByVal Company As String) As DataSet
            Dim TodayRegSet As DataSet
            Dim sqlParams(0) As SqlParameter

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@logincompany"
            sqlParams(0).DbType = DbType.String
            sqlParams(0).Direction = Data.ParameterDirection.Input
            sqlParams(0).Value = Company

            TodayRegSet = DBFactory.GetHelper().ExecuteDataSet("TodayReg_Get", Data.CommandType.StoredProcedure, sqlParams)

            Return TodayRegSet

        End Function

#End Region

#Region "Home Page Active Projects"
        'Get Active Projects
        Public Function GetTodayActiveProjects(ByVal Company As String, ByVal Status As String) As DataSet

            Dim ActiveProjSet As DataSet
            Dim sqlParams(1) As SqlParameter

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@logincompany"
            sqlParams(0).DbType = DbType.String
            sqlParams(0).Direction = Data.ParameterDirection.Input
            sqlParams(0).Value = Company

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@status"
            sqlParams(1).DbType = DbType.String
            sqlParams(1).Direction = Data.ParameterDirection.Input
            sqlParams(1).Value = Status

            ActiveProjSet = DBFactory.GetHelper().ExecuteDataSet("ActiveProjects_Get", Data.CommandType.StoredProcedure, sqlParams)

            Return ActiveProjSet

        End Function

#End Region

#Region "Home Page QuickLink"
        'Get QuickLinks
        Public Function GetQuickLink(ByVal Company As String, ByVal UserGroup As String) As DataSet
            Dim TodayRegSet As DataSet
            Dim sqlParams(1) As SqlParameter

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@company"
            sqlParams(0).DbType = DbType.String
            sqlParams(0).Direction = Data.ParameterDirection.Input
            sqlParams(0).Value = Company

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@usr_group_code"
            sqlParams(1).DbType = DbType.String
            sqlParams(1).Direction = Data.ParameterDirection.Input
            sqlParams(1).Value = UserGroup

            TodayRegSet = DBFactory.GetHelper().ExecuteDataSet("Quick_Link_Get", Data.CommandType.StoredProcedure, sqlParams)

            Return TodayRegSet

        End Function

#End Region

#Region "Home Page ActionReq"
        'Get ActionReq
        Public Function GetActionReq(ByVal Company As String, ByVal UserGroup As String, ByVal UserID As String) As DataSet
            Dim TodayRegSet As DataSet
            Dim sqlParams(2) As SqlParameter

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@company"
            sqlParams(0).DbType = DbType.String
            sqlParams(0).Direction = Data.ParameterDirection.Input
            sqlParams(0).Value = Company

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@usr_group_code"
            sqlParams(1).DbType = DbType.String
            sqlParams(1).Direction = Data.ParameterDirection.Input
            sqlParams(1).Value = UserGroup

            sqlParams(2) = New SqlParameter()
            sqlParams(2).ParameterName = "@usrid"
            sqlParams(2).DbType = DbType.String
            sqlParams(2).Direction = Data.ParameterDirection.Input
            sqlParams(2).Value = UserID

            TodayRegSet = DBFactory.GetHelper().ExecuteDataSet("Action_Req_Get", Data.CommandType.StoredProcedure, sqlParams)

            Return TodayRegSet

        End Function

#End Region

#Region "Home Page ActionReq Statement "
        'Get ActionReq
        Public Function GetActionReq_Statement(ByVal Company As String, ByVal UserGroup As String, ByVal UserID As String) As DataSet
            Dim TodayRegSet As DataSet
            Dim sqlParams(2) As SqlParameter

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@company"
            sqlParams(0).DbType = DbType.String
            sqlParams(0).Direction = Data.ParameterDirection.Input
            sqlParams(0).Value = Company

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@usr_group_code"
            sqlParams(1).DbType = DbType.String
            sqlParams(1).Direction = Data.ParameterDirection.Input
            sqlParams(1).Value = UserGroup

            sqlParams(2) = New SqlParameter()
            sqlParams(2).ParameterName = "@usrid"
            sqlParams(2).DbType = DbType.String
            sqlParams(2).Direction = Data.ParameterDirection.Input
            sqlParams(2).Value = UserID

            TodayRegSet = DBFactory.GetHelper().ExecuteDataSet("Action_Req_Get_statement", Data.CommandType.StoredProcedure, sqlParams)

            Return TodayRegSet

        End Function

#End Region

#Region "Flash News"

        'Get Today Closed
        Public Function GetFalshNews(ByVal Company As String, ByVal LoginUserId As String) As DataSet
            Dim FlashNewsSet As DataSet
            Dim sqlParams(1) As SqlParameter

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@logincompany"
            sqlParams(0).DbType = DbType.String
            sqlParams(0).Direction = Data.ParameterDirection.Input
            sqlParams(0).Value = Company

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@loginuserid"
            sqlParams(1).DbType = DbType.String
            sqlParams(1).Direction = Data.ParameterDirection.Input
            sqlParams(1).Value = LoginUserId


            FlashNewsSet = DBFactory.GetHelper().ExecuteDataSet("FlashNewsDisplay_Get", Data.CommandType.StoredProcedure, sqlParams)

            Return FlashNewsSet

        End Function
#End Region

#Region "Get last stock update date"
        'Get last stock update date
        Public Function GetLastStockUpdateDate() As DataSet

            Dim LoginUserSet As DataSet

            LoginUserSet = DBFactory.GetHelper().ExecuteDataSet("GetLastStockUpdateDate", Data.CommandType.StoredProcedure)

            Return LoginUserSet
        End Function
#End Region

#Region "DashBoard INfo"

        'Get Today Closed
        Public Function GetDashBoardInfo(ByVal LoginUserId As String, ByVal depot As String) As DataSet
            Dim DashBoardSet As DataSet
            Dim sqlParams(1) As SqlParameter

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@userId"
            sqlParams(0).DbType = DbType.String
            sqlParams(0).Direction = Data.ParameterDirection.Input
            sqlParams(0).Value = LoginUserId

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@depot"
            sqlParams(1).DbType = DbType.String
            sqlParams(1).Direction = Data.ParameterDirection.Input
            sqlParams(1).Value = depot



            DashBoardSet = DBFactory.GetHelper().ExecuteDataSet("[dbo].[vrs_get_DashBoardInfo]", Data.CommandType.StoredProcedure, sqlParams)

            Return DashBoardSet

        End Function
#End Region

#Region "Kazi"
        Public Function GetPendingDespatchData(ByVal unitCode As String, ByVal year As String, ByVal month As String, ByVal active As String, ByVal pageIndex As Integer, ByVal pageSize As Integer) As DataSet
            Dim DS As DataSet
            Dim sqlParams(5) As SqlParameter

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@unit_code"
            sqlParams(0).DbType = DbType.String
            sqlParams(0).Direction = Data.ParameterDirection.Input
            sqlParams(0).Value = If(unitCode = "", DBNull.Value, CObj(unitCode))

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@ProcessYr"
            sqlParams(1).DbType = DbType.String
            sqlParams(1).Direction = Data.ParameterDirection.Input
            sqlParams(1).Value = year

            sqlParams(2) = New SqlParameter()
            sqlParams(2).ParameterName = "@ProcessMnth"
            sqlParams(2).DbType = DbType.String
            sqlParams(2).Direction = Data.ParameterDirection.Input
            sqlParams(2).Value = month

            sqlParams(3) = New SqlParameter()
            sqlParams(3).ParameterName = "@active"
            sqlParams(3).DbType = DbType.String
            sqlParams(3).Direction = Data.ParameterDirection.Input
            sqlParams(3).Value = active

            sqlParams(4) = New SqlParameter()
            sqlParams(4).ParameterName = "@PageIndex"
            sqlParams(4).DbType = DbType.Int32
            sqlParams(4).Direction = Data.ParameterDirection.Input
            sqlParams(4).Value = pageIndex

            sqlParams(5) = New SqlParameter()
            sqlParams(5).ParameterName = "@PageSize"
            sqlParams(5).DbType = DbType.Int32
            sqlParams(5).Direction = Data.ParameterDirection.Input
            sqlParams(5).Value = pageSize

            DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[PendingDespatch_Source_Dashboard]", Data.CommandType.StoredProcedure, sqlParams)
            Return DS
        End Function

        Public Function GetLoadDespatchSummary(ByVal unitCode As String, ByVal year As String, ByVal month As String, ByVal searchSku As String) As DataSet
            Dim DS As DataSet
            Dim sqlParams(3) As SqlParameter

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@vendor_unit"
            sqlParams(0).DbType = DbType.String
            sqlParams(0).Direction = Data.ParameterDirection.Input
            sqlParams(0).Value = unitCode

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@ProcessYr"
            sqlParams(1).DbType = DbType.String
            sqlParams(1).Direction = Data.ParameterDirection.Input
            sqlParams(1).Value = year

            sqlParams(2) = New SqlParameter()
            sqlParams(2).ParameterName = "@ProcessMnth"
            sqlParams(2).DbType = DbType.String
            sqlParams(2).Direction = Data.ParameterDirection.Input
            sqlParams(2).Value = month

            sqlParams(3) = New SqlParameter()
            sqlParams(3).ParameterName = "@search_sku"
            sqlParams(3).DbType = DbType.String
            sqlParams(3).Direction = Data.ParameterDirection.Input
            sqlParams(3).Value = searchSku

            DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[Get_Total_Load_Dispatch_Summary]", Data.CommandType.StoredProcedure, sqlParams)
            Return DS
        End Function

        Public Function GetBrandDashboardLoadDespatchSummary(ByVal unitCode As String, ByVal year As String, ByVal month As String, ByVal pageIndex As Integer, ByVal pageSize As Integer) As DataSet
            Dim DS As DataSet
            Dim sqlParams(4) As SqlParameter

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@vendor_unit"
            sqlParams(0).DbType = DbType.String
            sqlParams(0).Direction = Data.ParameterDirection.Input
            sqlParams(0).Value = If(unitCode = "", DBNull.Value, CObj(unitCode))

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@ProcessYr"
            sqlParams(1).DbType = DbType.String
            sqlParams(1).Direction = Data.ParameterDirection.Input
            sqlParams(1).Value = year

            sqlParams(2) = New SqlParameter()
            sqlParams(2).ParameterName = "@ProcessMnth"
            sqlParams(2).DbType = DbType.String
            sqlParams(2).Direction = Data.ParameterDirection.Input
            sqlParams(2).Value = month

            sqlParams(3) = New SqlParameter()
            sqlParams(3).ParameterName = "@PageIndex"
            sqlParams(3).DbType = DbType.Int32
            sqlParams(3).Direction = Data.ParameterDirection.Input
            sqlParams(3).Value = pageIndex

            sqlParams(4) = New SqlParameter()
            sqlParams(4).ParameterName = "@PageSize"
            sqlParams(4).DbType = DbType.Int32
            sqlParams(4).Direction = Data.ParameterDirection.Input
            sqlParams(4).Value = pageSize

            DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[Get_BrandWise_Dashboard_Load_Dispatch_Summary]", Data.CommandType.StoredProcedure, sqlParams)
            Return DS
        End Function

        Public Function GetVendorDashboardLoadDespatchSummary(ByVal unitCode As String, ByVal year As String, ByVal month As String, ByVal pageIndex As Integer, ByVal pageSize As Integer) As DataSet
            Dim DS As DataSet
            Dim sqlParams(4) As SqlParameter

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@vendor_unit"
            sqlParams(0).DbType = DbType.String
            sqlParams(0).Direction = Data.ParameterDirection.Input
            sqlParams(0).Value = If(unitCode = "", DBNull.Value, CObj(unitCode))

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@ProcessYr"
            sqlParams(1).DbType = DbType.String
            sqlParams(1).Direction = Data.ParameterDirection.Input
            sqlParams(1).Value = year

            sqlParams(2) = New SqlParameter()
            sqlParams(2).ParameterName = "@ProcessMnth"
            sqlParams(2).DbType = DbType.String
            sqlParams(2).Direction = Data.ParameterDirection.Input
            sqlParams(2).Value = month

            sqlParams(3) = New SqlParameter()
            sqlParams(3).ParameterName = "@PageIndex"
            sqlParams(3).DbType = DbType.Int32
            sqlParams(3).Direction = Data.ParameterDirection.Input
            sqlParams(3).Value = pageIndex

            sqlParams(4) = New SqlParameter()
            sqlParams(4).ParameterName = "@PageSize"
            sqlParams(4).DbType = DbType.Int32
            sqlParams(4).Direction = Data.ParameterDirection.Input
            sqlParams(4).Value = pageSize

            DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[Get_Vendor_Dashboard_Load_Dispatch_Summary]", Data.CommandType.StoredProcedure, sqlParams)
            Return DS
        End Function

        Public Function GetVendorWiseBrandLoadSummary(ByVal brandName As String, ByVal year As String, ByVal month As String, ByVal searchVendor As String) As DataSet
            Dim DS As DataSet
            Dim sqlParams(3) As SqlParameter

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@brand_name"
            sqlParams(0).DbType = DbType.String
            sqlParams(0).Direction = Data.ParameterDirection.Input
            sqlParams(0).Value = brandName

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@ProcessYr"
            sqlParams(1).DbType = DbType.String
            sqlParams(1).Direction = Data.ParameterDirection.Input
            sqlParams(1).Value = year

            sqlParams(2) = New SqlParameter()
            sqlParams(2).ParameterName = "@ProcessMnth"
            sqlParams(2).DbType = DbType.String
            sqlParams(2).Direction = Data.ParameterDirection.Input
            sqlParams(2).Value = month

            sqlParams(3) = New SqlParameter()
            sqlParams(3).ParameterName = "@vendor_name"
            sqlParams(3).DbType = DbType.String
            sqlParams(3).Direction = Data.ParameterDirection.Input
            sqlParams(3).Value = searchVendor

            DS = DBFactory.GetHelper().ExecuteDataSet("[dbo].[Get_Vendor_Wise_Distribution_For_Brand]", Data.CommandType.StoredProcedure, sqlParams)
            Return DS
        End Function

#End Region

    End Class
End Namespace