<%@ Page Language="VB" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeFile="RM_DetailsUpload.aspx.vb" Inherits="RM_DetailsUpload" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


   <%-- <asp:UpdateProgress ID="updProgress" runat="server" DisplayAfter="0">
        <ProgressTemplate>
            <div class="pageLoader">
                <div class="innerLoader">
                    <img class="loaderImg" alt="progress" src="images/ajax-loader.gif" />
                    <p class="loaderTx">Processing... Please Wait.</p>
                </div>
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>--%>


    <div class="breadcrumbs">
        <div class="leftFung">
            <a href="Home.aspx" title="Home"><i class="fas fa-home"></i></a>
            <div class="diveider">/</div>
            <div class="pageTitleWrap">
                <h3 class="pageTitle">RM Suplier Details Upload</h3>
                <p class="pageSubTitle">Browse and manage user profiles</p>
            </div>
        </div>
        <div class="rightFung"></div>
    </div>

    <div class="card">
        <div class="card-body">
            <div class="row">
                <div class="col-md-3">
                    <div class="form-group">
                        <asp:UpdatePanel runat="server" ID="UpdatePanel1">
                            <ContentTemplate>
                                <label class="form-control-label">Quarter:</label>
                                <asp:DropDownList ID="ddlQuarter" CssClass="form-control select2" runat="server" AutoPostBack="true" />
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="form-group">
                        <asp:UpdatePanel runat="server" ID="UpdatePanel3" UpdateMode="Conditional">
                            <ContentTemplate>
                                <label class="form-control-label">Upload File:</label>
                                <%--<asp:AsyncFileUpload runat="server" ID="AsyncFileUpload1" OnUploadedComplete="AsyncFileUpload1_UploadedComplete" class="form-control form-control-sm" />--%>
                                <asp:FileUpload runat="server" CssClass="form-control" ID="fuExcel" OnUploadedComplete="AsyncFileUpload1_UploadedComplete" accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.ms-excel" />
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                </div>
                <div class="col-md-5 form-btn-mt">
                    <asp:UpdatePanel runat="server" ID="UpdatePanel2">
                        <ContentTemplate>
                            <asp:Button ID="btnUpload" runat="server" ToolTip="Click to Upload File" Text="Upload" CssClass="btn btn-primary btn-sm" OnClientClick="showProgress()" OnClick="btnUpload_Click" />
                            <asp:Button ID="btnDownload" runat="server" ToolTip="Click to Download File" Text="Download" OnClick="btnDownload_Click" CssClass="btn btn-success btn-sm" />
                            <asp:Button ID="btnReset" runat="server" ToolTip="Click to Reset" Text="Reset" CssClass="btn btn-warning btn-sm" />
                        </ContentTemplate>
                        <Triggers>
                            <asp:PostBackTrigger ControlID="btnDownload" />
                            <asp:PostBackTrigger ControlID="btnUpload" />
                        </Triggers>
                    </asp:UpdatePanel>
                </div>
                <%--<div class="col-md-12 form-btn-mt text-center" runat="server">
                            <asp:UpdatePanel runat="server" ID="UpdatePanel7" UpdateMode="Conditional">
                                <ContentTemplate>
                                    <div id="progressBarContainer">
                                        <div id="progressBar" runat="server"></div>
                                    </div>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </div>--%>
                <div class="col-md-12 form-btn-mt text-center" runat="server">
                    <asp:UpdatePanel runat="server" ID="UpdatePanel6">
                        <ContentTemplate>
                            <div runat="server" id="divFileError" visible="false">
                                <asp:HiddenField runat="server" ID="hdnErrorFilePath" Value="" />
                                <span class="text-danger">There are some error found in file. Please download the file and review. </span>
                                <br />
                                <br />
                                <asp:Button ID="btnDownloadErrorFile" runat="server" ToolTip="Click to Download File" Text="Download File" CssClass="btn btn-primary btn-sm" />
                            </div>
                        </ContentTemplate>
                        <Triggers>
                            <asp:PostBackTrigger ControlID="btnDownloadErrorFile" />
                        </Triggers>
                    </asp:UpdatePanel>
                </div>
            </div>
            <%-- </ContentTemplate>
                        <Triggers>
                            <asp:PostBackTrigger ControlID="btnUpload" />
                        </Triggers>
                    </asp:UpdatePanel>--%>
        </div>
    </div>

</asp:Content>
