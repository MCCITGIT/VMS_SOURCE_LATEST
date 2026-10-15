Imports VMS.Web
Imports System.Data
Imports System.Data.SqlTypes
Partial Class Login
    Inherits System.Web.UI.Page


#Region "AddAttributes"
    Private Sub AddAttributes()
        imgbtnLogin.Attributes.Add("onClick", "return ValidateUserID('txtUserId');")
        'imgbtnLogin.Attributes.Add("onClick", "return ValidatePWD('txtPassword');")
    End Sub
#End Region

#Region "Validate user"
    'Checks for the authentication of the user
    Private Function ValidateUser() As Boolean
        'Session(Constant.SessionKeys.GetServerTime) = DatePart(DateInterval.Hour, Now)
        'GetSrtime = Session(Constant.SessionKeys.GetServerTime)
        'Select Case True
        '    Case GetSrtime < Convert.ToInt32(ConfigurationManager.AppSettings(Constant.ConfigKeys.DBWorkingStartTime))
        '        HttpContext.Current.Session(Constant.SessionKeys.ErrorValue) = TransGuard.SIM.Web.Messages.DBConnectionAfterWorkingTime
        '        HttpContext.Current.Server.Transfer("~/SIMErrorPage.aspx")
        '    Case GetSrtime > Convert.ToInt32(ConfigurationManager.AppSettings(Constant.ConfigKeys.DBWorkingEndTime))
        '        HttpContext.Current.Session(Constant.SessionKeys.ErrorValue) = TransGuard.SIM.Web.Messages.DBConnectionAfterWorkingTime
        '        HttpContext.Current.Server.Transfer("~/SIMErrorPage.aspx")
        'End Select

        'Dim roles As Constant.Roles
        Dim userInfo As VMSUserEntity
        'roles = Constant.Roles.None
        FormsAuthentication.Initialize()

        Dim userDetailsObject As New UserLogin()

        userInfo = userDetailsObject.LoginUserDetails(txtUserId.Text.Trim(), txtPassword.Text.Trim())
        If Not (userInfo Is Nothing) Then
            'roles = userInfo.Role
            If userInfo.userStatusEntity = Constant.Common.InActiveStatus Then
                lblErrorMessage.Text = Constant.ErrorMessages.UserNotActiveMessage
                lblErrorMessage.ForeColor = Drawing.Color.Red
                lblErrorMessage.Visible = True
            Else
                ' Drop the previous user's session, including saved list filters, before storing this login.
                Session.Clear()
                Session(Constant.SessionKeys.UserInfo) = userInfo
                'Create a new ticket used for authentication
                'Dim roleSet As System.Data.DataSet = userDetailsObject.GetRolePrivileges(userInfo.PartyID)
                'If Not (roleSet Is Nothing) Then
                '    Session(Constant.SessionKeys.Roles) = roleSet
                'End If
                Dim ticket As New FormsAuthenticationTicket(1, txtUserId.Text, DateTime.Now, DateTime.Now.AddMinutes(720), False, "Roles", FormsAuthentication.FormsCookiePath)

                'Encrypt the cookie using the machine key for secure transport
                Dim hash As String = FormsAuthentication.Encrypt(ticket)
                Dim cookie As New HttpCookie(FormsAuthentication.FormsCookieName, hash)
                cookie.Path = FormsAuthentication.FormsCookiePath
                cookie.HttpOnly = True

                'Set the cookie's expiration time to the tickets expiration time
                If (ticket.IsPersistent) Then
                    cookie.Expires = ticket.Expiration
                End If

                'Add the cookie to the list for outgoing response
                Response.Cookies.Add(cookie)

                'Redirect to requested URL, or homepage if no previous page requested
                'Changes By Sumeet 26-02-2015 (Start)
                Dim returnUrl As String
                If (userInfo.userPWDEntity = Constant.Common.ChangePwd) Then
                    returnUrl = "~/Change_Password.aspx?Status=FirstTimeEntry"
                ElseIf (userInfo.UserPasswordChangeDifferenceEntity >= Constant.Common.PasswordChangeDateDiff) Then
                    returnUrl = "~/Change_Password.aspx?Status=PasswordExpired"
                Else
                    returnUrl = "~/Home.aspx"
                    'returnUrl = "~/Home.aspx"
                End If

                'If ((Roles = Constant.Roles.Administrator)) Then
                '    returnUrl = "~/UserList.aspx"
                'Else
                '    returnUrl = "~/CertificateList.aspx"
                'End If

                'Don't call FormsAuthentication.RedirectFromLoginPage since it could
                'replace the authentication ticket (cookie) we just added
                Response.Redirect(returnUrl) ' returnUrl
            End If
        Else

            lblErrorMessage.Text = Constant.ErrorMessages.InvalidLoginMessage
            lblErrorMessage.ForeColor = Drawing.Color.Red
            lblErrorMessage.Visible = True

        End If
        txtUserId.Text = String.Empty
        txtPassword.Text = String.Empty
    End Function
#End Region

#Region "Only IE User Get Login"
    Public Sub ChkIEUser(ByVal Browser As String)
        Try
            Dim Index As Integer = InStr(Browser, "MSIE")
            If Index = 0 Then
                tralert.Style(HtmlTextWriterStyle.Display) = "block"
                hdnNavgr.Value = Constant.Common.InvalidBrowser
            Else
                Dim IE As String = Mid(Browser, Index, 8)
                Dim IEVer As String = Mid(IE, 6, 3)
                If CDbl(IEVer) < 6 Then
                    tralert.Style(HtmlTextWriterStyle.Display) = "block"
                    hdnNavgr.Value = Constant.Common.InvalidBrowser
                End If
            End If

        Catch ex As Exception
            tralert.Style(HtmlTextWriterStyle.Display) = "block"
            hdnNavgr.Value = Constant.Common.InvalidBrowser
        End Try


    End Sub
#End Region

    Protected Sub imgbtnLogin_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles imgbtnLogin.Click
        'Calls validateUser Function
        If Not hdnNavgr.Value = Constant.Common.InvalidBrowser Then
            ValidateUser()
        Else
            lblErrorMessage.Text = Constant.ErrorMessages.ErrorBrwoser
            lblErrorMessage.ForeColor = Drawing.Color.Red
            lblErrorMessage.Visible = True
        End If
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Response.Redirect("GoLogin.aspx")


        'Calls validateUser Function
        tralert.Style(HtmlTextWriterStyle.Display) = "none"
        txtUserId.Focus()
        Dim brow As String = Request.ServerVariables("HTTP_USER_AGENT")
        lblErrorMessage.Text = String.Empty
        'ChkIEUser(brow)
        If Not IsPostBack Then
            AddAttributes()
            ' divLoginImage.InnerHtml = "<marquee id=mar1 style='height:100%;width:100%' SCROLLDELAY=300 direction=up onmouseover='this.stop();' onmouseout='this.start();'>" + "<img src="images/prt-2.jpg"/>"<img src="images/prt-1.gif"/>"</marquee>"

        End If
    End Sub
End Class
