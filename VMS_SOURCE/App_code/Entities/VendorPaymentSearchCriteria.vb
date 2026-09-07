Imports Microsoft.VisualBasic

Public Class VendorPaymentSearchCriteria
    Private vendor_name As String
    Private from_date As String
    Private to_date As String
    Private page_no As Integer

    Public Sub New()
        vendor_name = String.Empty
        from_date = String.Empty
        to_date = String.Empty
        page_no = 0
    End Sub

    Public Property VendorName() As String
        Get
            Return vendor_name
        End Get
        Set(ByVal value As String)
            vendor_name = value
        End Set
    End Property

    Public Property FromDate() As String
        Get
            Return from_date
        End Get
        Set(ByVal value As String)
            from_date = value
        End Set
    End Property

    Public Property ToDate() As String
        Get
            Return to_date
        End Get
        Set(ByVal value As String)
            to_date = value
        End Set
    End Property

    Public Property PageNo() As Integer
        Get
            Return page_no
        End Get
        Set(ByVal value As Integer)
            page_no = value
        End Set
    End Property
End Class
