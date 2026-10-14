Imports Microsoft.VisualBasic

Public Class RawMaterialRequisitionHeaderEntity
    Private request_id As Integer
    Private vendor_code As String
    Private rawmaterial_vendor_code As String
    Private created_user As String
    Private created_date As DateTime
    Private modified_user As String
    Private modified_date As DateTime
    Private deleted_user As String
    Private deleted_date As DateTime
    Private active_status As String
    Private tran_type As Integer
    Private po_no As String

    Public Sub New()
        request_id = Integer.MinValue
        vendor_code = String.Empty
        rawmaterial_vendor_code = String.Empty
        created_user = String.Empty
        created_date = DateTime.MinValue
        modified_user = String.Empty
        modified_date = DateTime.MinValue
        deleted_user = String.Empty
        deleted_date = DateTime.MinValue
        active_status = String.Empty
        tran_type = Integer.MinValue
        po_no = String.Empty
    End Sub

    Public Property RequestId() As Integer
        Get
            Return request_id
        End Get
        Set(ByVal value As Integer)
            request_id = value
        End Set
    End Property

    Public Property VendorCode() As String
        Get
            Return vendor_code
        End Get
        Set(ByVal value As String)
            vendor_code = value
        End Set
    End Property

    Public Property RawMaterialVendorCode() As String
        Get
            Return rawmaterial_vendor_code
        End Get
        Set(ByVal value As String)
            rawmaterial_vendor_code = value
        End Set
    End Property
    Public Property CreatedUser() As String
        Get
            Return created_user
        End Get
        Set(ByVal value As String)
            created_user = value
        End Set
    End Property

    Public Property CreatedDate() As DateTime
        Get
            Return created_date
        End Get
        Set(ByVal value As DateTime)
            created_date = value
        End Set
    End Property

    Public Property ModifiedUser() As String
        Get
            Return modified_user
        End Get
        Set(ByVal value As String)
            modified_user = value
        End Set
    End Property

    Public Property ModifiedDate() As DateTime
        Get
            Return modified_date
        End Get
        Set(ByVal value As DateTime)
            modified_date = value
        End Set
    End Property

    Public Property DeletedUser() As String
        Get
            Return deleted_user
        End Get
        Set(ByVal value As String)
            deleted_user = value
        End Set
    End Property

    Public Property DeletedDate() As DateTime
        Get
            Return deleted_date
        End Get
        Set(ByVal value As DateTime)
            deleted_date = value
        End Set
    End Property

    Public Property ActiveStatus() As String
        Get
            Return active_status
        End Get
        Set(ByVal value As String)
            active_status = value
        End Set
    End Property

    Public Property Trantype() As Integer
        Get
            Return tran_type
        End Get
        Set(ByVal value As Integer)
            tran_type = value
        End Set
    End Property
    Public Property PONO() As String
        Get
            Return po_no
        End Get
        Set(ByVal value As String)
            po_no = value
        End Set
    End Property
End Class

Public Class RawMaterialRequisitionDetailEntity
    Private detail_id As Integer
    Private request_id As Integer
    Private link_id As Integer
    Private vendor_code As String
    Private rawmaterial_code As String
    Private ord_qty As Decimal
    Private req_delivery_date As DateTime
    Private ord_remark As String
    Private ord_rate As Decimal
    Private created_user As String
    Private created_date As DateTime
    Private modified_user As String
    Private modified_date As DateTime
    Private deleted_user As String
    Private deleted_date As DateTime
    Private active_status As String

    Public Sub New()
        detail_id = Integer.MinValue
        request_id = Integer.MinValue
        link_id = Integer.MinValue
        vendor_code = String.Empty
        rawmaterial_code = String.Empty
        ord_qty = Decimal.MinValue
        req_delivery_date = DateTime.MinValue
        ord_remark = String.Empty
        ord_rate = Decimal.MinValue
        created_user = String.Empty
        created_date = DateTime.MinValue
        modified_user = String.Empty
        modified_date = DateTime.MinValue
        deleted_user = String.Empty
        deleted_date = DateTime.MinValue
        active_status = String.Empty
    End Sub

    Public Property DetailId() As Integer
        Get
            Return detail_id
        End Get
        Set(ByVal value As Integer)
            detail_id = value
        End Set
    End Property

    Public Property RequestId() As Integer
        Get
            Return request_id
        End Get
        Set(ByVal value As Integer)
            request_id = value
        End Set
    End Property

    Public Property LinkId() As Integer
        Get
            Return link_id
        End Get
        Set(ByVal value As Integer)
            link_id = value
        End Set
    End Property

    Public Property VendorCode() As String
        Get
            Return vendor_code
        End Get
        Set(ByVal value As String)
            vendor_code = value
        End Set
    End Property
    Public Property RawMaterialCode() As String
        Get
            Return rawmaterial_code
        End Get
        Set(ByVal value As String)
            rawmaterial_code = value
        End Set
    End Property

    Public Property Quantity() As Decimal
        Get
            Return ord_qty
        End Get
        Set(ByVal value As Decimal)
            ord_qty = value
        End Set
    End Property

    Public Property ReqDeliveryDate() As DateTime
        Get
            Return req_delivery_date
        End Get
        Set(ByVal value As DateTime)
            req_delivery_date = value
        End Set
    End Property

    Public Property Remark() As String
        Get
            Return ord_remark
        End Get
        Set(ByVal value As String)
            ord_remark = value
        End Set
    End Property

    Public Property Rate() As Decimal
        Get
            Return ord_rate
        End Get
        Set(ByVal value As Decimal)
            ord_rate = value
        End Set
    End Property

    Public Property CreatedUser() As String
        Get
            Return created_user
        End Get
        Set(ByVal value As String)
            created_user = value
        End Set
    End Property

    Public Property CreatedDate() As DateTime
        Get
            Return created_date
        End Get
        Set(ByVal value As DateTime)
            created_date = value
        End Set
    End Property

    Public Property ModifiedUser() As String
        Get
            Return modified_user
        End Get
        Set(ByVal value As String)
            modified_user = value
        End Set
    End Property

    Public Property ModifiedDate() As DateTime
        Get
            Return modified_date
        End Get
        Set(ByVal value As DateTime)
            modified_date = value
        End Set
    End Property

    Public Property DeletedUser() As String
        Get
            Return deleted_user
        End Get
        Set(ByVal value As String)
            deleted_user = value
        End Set
    End Property

    Public Property DeletedDate() As DateTime
        Get
            Return deleted_date
        End Get
        Set(ByVal value As DateTime)
            deleted_date = value
        End Set
    End Property

    Public Property ActiveStatus() As String
        Get
            Return active_status
        End Get
        Set(ByVal value As String)
            active_status = value
        End Set
    End Property

End Class
