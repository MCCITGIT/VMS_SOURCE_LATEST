'****************************************************************************************
'Copyright	    : TransGuard, MCC, KOLKATA
'Source	        : Logout.aspx.vb
'Created Date	: 28-February-2007
'Created By	    : Vivek Subbiah
'Version	        : R01.01.00
'Description	    :Code behind file for user logout
'
'Modified By       Modified On       Version         Reason
' Mukesh Bhagat     05-October-2026   R01.02.00       Clear session and auth cookie so the
'                                                     next login is not filtered by the previous user.
'****************************************************************************************
Imports VMS.Web
Partial Class Logout
    Inherits System.Web.UI.Page


#Region "Page load Event Handler"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        SignOut()
    End Sub

#End Region
#Region "SignOut Activities"

    ' Drop the current user's session and auth cookie, then send the browser to login.
    Private Sub SignOut()
        Try
            Session.Clear()
            Session.Abandon()
        Catch ex As Exception
        End Try

        ExpireCookie("ASP.NET_SessionId")
        FormsAuthentication.SignOut()
        ExpireCookie(FormsAuthentication.FormsCookieName)

        Response.Redirect("~/Login.aspx", True)
    End Sub

    Private Sub ExpireCookie(ByVal cookieName As String)
        Dim expired As New HttpCookie(cookieName, String.Empty)
        expired.Expires = DateTime.Now.AddDays(-1)
        expired.HttpOnly = True
        expired.Path = "/"
        Response.Cookies.Add(expired)

        Dim appPath As String = Request.ApplicationPath
        If Not String.IsNullOrEmpty(appPath) AndAlso Not appPath.Equals("/", StringComparison.OrdinalIgnoreCase) Then
            Dim expiredForApp As New HttpCookie(cookieName, String.Empty)
            expiredForApp.Expires = DateTime.Now.AddDays(-1)
            expiredForApp.HttpOnly = True
            expiredForApp.Path = appPath
            Response.Cookies.Add(expiredForApp)
        End If
    End Sub
#End Region

End Class
