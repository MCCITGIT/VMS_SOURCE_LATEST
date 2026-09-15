<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Login.aspx.vb" Inherits="Login" %>

<!doctype html>
<html lang="en">
<head runat="server">
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>:: Welcome to Vendor Management System ::</title>
     <link rel="shortcut icon" href="images/favicon.png" type="image/x-icon" />
    <link href="includes/style.css?v=@DateTime.Now.ToString()" rel="stylesheet" type="text/css" />
    <link href="includes/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="includes/upgrad-style.css?v=@DateTime.Now.ToString()" rel="stylesheet" type="text/css" />

    <script type="text/javascript">
        var _gaq = _gaq || [];
        _gaq.push(['_setAccount', 'UA-33450822-1']);
        _gaq.push(['_trackPageview']);

        (function () {
            var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
            ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
            var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
        })();
    </script>
    <script type="text/javascript" src="Scripts/Validate_support.js"></script>
    <script type="text/javascript" src="Scripts/FunctionValidator.js"></script>
    <script type="text/javascript" src="Scripts/ValidationLogin.js"></script>
    <script type="text/javascript" src="Scripts/Messages.js"></script>
    <script type="text/javascript">
        function newwindow(strUrl, strtarget) {
            var docwindow = window.open(strUrl, strtarget, 'width=600, height=400, toolbar=no, location=no, directories=yes , status=no, menubar=no, scrollbars=yes, copyhistory=yes, resizable=yes');
        }

        function fnWindowSpan(strUrl, strtarget) {
            window.open(strUrl, strtarget, "status=no,toolbar=no,menubar=no,location=no,scrollbars=no,modal=no,resizable=no");
        }
    </script>
    <script>
        function togglePasswordVisibility(inputId, iconContainer) {
            var input = document.getElementById(inputId);
            var eyeIcon = iconContainer.querySelector('.fa-eye');
            var eyeSlashIcon = iconContainer.querySelector('.fa-eye-slash');

            if (input.type === 'password') {
                input.type = 'text';
                eyeIcon.classList.add('d-none');
                eyeSlashIcon.classList.remove('d-none');
            } else {
                input.type = 'password';
                eyeIcon.classList.remove('d-none');
                eyeSlashIcon.classList.add('d-none');
            }
        }
    </script>
</head>
<body class="loginBg">
    <form id="form1" runat="server">
        <div class="loginFullBody">
            <div class="loginCBox" id="page_content">
                <div class="row">
                    <div class="col-md-7 mobDisplyNan">
                        <div class="leftSubBg">
                            <div class="compyDtls">
                                <img id="logo" class="bLogo" src="images/logo-new.jpg" alt="Best Wall Paint Colors, House Painting Colors" title="Lewis Berger Paints" />
                                <h3 class="bTitle" id="since">Berger Paints India Limited</h3>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-5">
                        <div class="loginFormArea">
                            <div class="vmsCompanyDtls">
                                <img class="vmsLogo" src="images/globe.jpg" alt="Logo" />
                                <h3 class="vmsTitle">VENDOR MANAGEMENT SYSTEM</h3>
                                <p class="vmsSubTitle">This platform facilitates supply management of Vendor produced FG products</p>
                                <div id="register">
                                    <div class="row">
                                        <div class="col-md-12">
                                            <div class="form-group">
                                                <label class="form-control-label">Username:<span class="mandatory">*</span></label>
                                                <asp:TextBox ID="txtUserId" MaxLength="20" class="form-control" runat="server" placeholder="Enter here..."></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-md-12">
                                            <div class="pRelative">
                                                <label class="form-control-label">Password:<span class="mandatory">*</span></label>
                                                <asp:TextBox ID="txtPassword" MaxLength="20" class="form-control" runat="server" TextMode="Password" placeholder="Enter here..."></asp:TextBox>
                                                <div class="pwShowHideIcon" onclick="togglePasswordVisibility('<%= txtPassword.ClientID %>', this)">
                                                    <i class="fas fa-eye"></i>
                                                    <i class="fas fa-eye-slash d-none"></i>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-12">
                                            <div class="form-group">
                                                <a href="ChangePasswordLink_New.aspx" class="changPw">Change Password ?</a>
                                            </div>
                                        </div>
                                        <div class="col-md-12">
                                            <asp:Button ID="imgbtnLogin" runat="server" Text="Login" CssClass="btn btn-primary loginBtnView" />
                                            <asp:Label ID="lblError" CssClass="errormsg" Visible="true" runat="server"></asp:Label>
                                        </div>
                                        <asp:HiddenField ID="hdnNavgr" runat="server" />
                                        <span id="UsrErrMsg" class="errormsg"></span>
                                        <asp:Label ID="lblErrorMessage" Visible="false" runat="server" CssClass="errormsg"></asp:Label>
                                    </div>
                                </div>
                                <div class="supportLink">
                                    <ul>
                                        <li>
                                            <a href="Contacts.html" target="_blank" title="Contact Us">Contact Us</a>
                                        </li>
                                        <li>
                                            <a href="Faqs_info.html" target="_blank" title="Help">Help</a>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                            <div id="tralert" runat="server" style="display: none;">
                                <img alt="" src="images/warning_logo.jpg" />
                                <img alt="" src="images/ie_logo.jpg" /><br />
                                <span style="background-color: #FFFFFF; color: #CC3300; font-size: 11pt; font-weight: bold;">Use Internet Explorer 6 or Higher Version</span>
                                <img alt="" src="images/mozilla_logo.jpg" />&nbsp;&nbsp;<img alt="" src="images/opera_logo.png" />
                                <img alt="" src="images/google-chrome_logo.jpg" />
                                <img alt="" src="images/netscape_logo.png" /><br />
                                <span>If You Use Other Browsers Application may not work properly</span>
                            </div>
                        </div>
                        <p class="copyRight">© Copyright 2012 Management and Computer Consultant. <a href="https://mccit.co.in/" target="_blank" title="Management and Computer Consultants">www.mccit.co.in</a></p>
                    </div>
                </div>
            </div>
        </div>
        <div class="transBg">
            <div id="notice" class="disclaimerTx">
                <ul id="notice_nav">
                    <li><a id="current" href="#" title="Disclaimer">Disclaimer</a></li>
                </ul>
            </div>
            <p class="dclimCont" id="notice_content">Use of this system is restricted to Authorized Users only. This computer system is a private property of the company and may only be used those individuals authorized by the company management in accordance with Management and Computer Consultants, system policies. Unauthorized, illegal or improper use of this system may result in disciplinary action against the violators and may also lead to criminal prosecution. All the users of this computer system should be aware that any information placed in the system is subject to close monitoring and is not subject to any expectation of privacy. By accessing this system, the User Agrees to The Terms &amp; Conditions of the firm.</p>
        </div>
    </form>
</body>
</html>
