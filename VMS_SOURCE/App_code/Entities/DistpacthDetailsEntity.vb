Imports Microsoft.VisualBasic

Public Class DistpacthDetailsEntity

    ' ---------------- Header fields (odh_*) ----------------
    Private m_RequestID As Integer
    Private m_DispatchDate As DateTime
    Private m_CourierID As String
    Private m_InvNo As String
    Private m_InvDate As DateTime
    Private m_TransName As String
    Private m_LRNo As String
    Private m_LRDate As DateTime
    Private m_CourierDate As DateTime
    Private m_VehicleNo As String
    Private m_LRDoc As String
    Private m_DelType As String
    'Private m_DocFileName As String
    'Private m_DocPath As String
    Private m_LRDocFileName As String
    Private m_LRDocPath As String
    Private m_InvDocFileName As String
    Private m_InvDocPath As String

    ' ---------------- Detail line fields (odd_*, one grid row) ----------------
    Private m_OrdID As Integer
    Private m_RawMatCode As String
    Private m_RequestedQty As Decimal
    Private m_AlreadyDispatchedQty As Decimal
    Private m_QtyToDispatch As Decimal

    ' ---------------- Output parameters from usp_SubmitDispatch ----------------
    Private m_NewHdrID As Integer
    Private m_NewReceiptID As Integer
    Private m_Status As Integer
    Private m_ErrorMsg As String

    ' ---------------- Common audit fields ----------------
    Private m_created_user As String
    Private m_created_date As DateTime
    Private m_modified_user As String
    Private m_modified_date As DateTime
    Private m_deleted_user As String
    Private m_deleted_date As DateTime
    Private m_active As String
    Private m_rm_vendor_code As String

    Public Sub New()
        m_RequestID = Integer.MinValue
        m_DispatchDate = DateTime.MinValue
        m_CourierID = String.Empty
        m_InvNo = String.Empty
        m_InvDate = DateTime.MinValue
        m_TransName = String.Empty
        m_LRNo = String.Empty
        m_LRDate = DateTime.MinValue
        m_CourierDate = DateTime.MinValue
        m_VehicleNo = String.Empty
        m_LRDoc = String.Empty
        m_DelType = String.Empty

        m_OrdID = Integer.MinValue
        m_RawMatCode = String.Empty
        m_RequestedQty = Decimal.MinValue
        m_AlreadyDispatchedQty = Decimal.MinValue
        m_QtyToDispatch = Decimal.MinValue

        m_NewHdrID = Integer.MinValue
        m_NewReceiptID = Integer.MinValue
        m_Status = Integer.MinValue
        m_ErrorMsg = String.Empty

        m_created_user = String.Empty
        m_created_date = DateTime.MinValue
        m_modified_user = String.Empty
        m_modified_date = DateTime.MinValue
        m_deleted_user = String.Empty
        m_deleted_date = DateTime.MinValue
        m_active = String.Empty
        m_LRDocFileName = String.Empty
        m_LRDocPath = String.Empty
        m_InvDocFileName = String.Empty
        m_InvDocPath = String.Empty
        m_rm_vendor_code = String.Empty
    End Sub

    ' ---------------- Header properties ----------------

    Public Property ReqID() As Integer
        Get
            Return m_RequestID
        End Get
        Set(ByVal value As Integer)
            m_RequestID = value
        End Set
    End Property

    Public Property DispDate() As DateTime
        Get
            Return m_DispatchDate
        End Get
        Set(ByVal value As DateTime)
            m_DispatchDate = value
        End Set
    End Property

    Public Property CourierId() As String
        Get
            Return m_CourierID
        End Get
        Set(ByVal value As String)
            m_CourierID = value
        End Set
    End Property

    Public Property InvoiceNo() As String
        Get
            Return m_InvNo
        End Get
        Set(ByVal value As String)
            m_InvNo = value
        End Set
    End Property

    Public Property InvoiceDate() As DateTime
        Get
            Return m_InvDate
        End Get
        Set(ByVal value As DateTime)
            m_InvDate = value
        End Set
    End Property

    Public Property TransporterName() As String
        Get
            Return m_TransName
        End Get
        Set(ByVal value As String)
            m_TransName = value
        End Set
    End Property

    Public Property LRNumber() As String
        Get
            Return m_LRNo
        End Get
        Set(ByVal value As String)
            m_LRNo = value
        End Set
    End Property

    Public Property LRDt() As DateTime
        Get
            Return m_LRDate
        End Get
        Set(ByVal value As DateTime)
            m_LRDate = value
        End Set
    End Property

    Public Property CourDt() As DateTime
        Get
            Return m_CourierDate
        End Get
        Set(ByVal value As DateTime)
            m_CourierDate = value
        End Set
    End Property

    Public Property VehicleNumber() As String
        Get
            Return m_VehicleNo
        End Get
        Set(ByVal value As String)
            m_VehicleNo = value
        End Set
    End Property

    Public Property LRDocument() As String
        Get
            Return m_LRDoc
        End Get
        Set(ByVal value As String)
            m_LRDoc = value
        End Set
    End Property

    Public Property DeliveryType() As String
        Get
            Return m_DelType
        End Get
        Set(ByVal value As String)
            m_DelType = value
        End Set
    End Property

    ' ---------------- Detail line properties ----------------

    Public Property OrderID() As Integer
        Get
            Return m_OrdID
        End Get
        Set(ByVal value As Integer)
            m_OrdID = value
        End Set
    End Property

    Public Property RawMaterialCode() As String
        Get
            Return m_RawMatCode
        End Get
        Set(ByVal value As String)
            m_RawMatCode = value
        End Set
    End Property

    Public Property ReqQty() As Decimal
        Get
            Return m_RequestedQty
        End Get
        Set(ByVal value As Decimal)
            m_RequestedQty = value
        End Set
    End Property

    Public Property DispatchedQty() As Decimal
        Get
            Return m_AlreadyDispatchedQty
        End Get
        Set(ByVal value As Decimal)
            m_AlreadyDispatchedQty = value
        End Set
    End Property

    Public Property QtyDispatch() As Decimal
        Get
            Return m_QtyToDispatch
        End Get
        Set(ByVal value As Decimal)
            m_QtyToDispatch = value
        End Set
    End Property

    ' ---------------- Output properties ----------------

    Public Property HdrID() As Integer
        Get
            Return m_NewHdrID
        End Get
        Set(ByVal value As Integer)
            m_NewHdrID = value
        End Set
    End Property

    Public Property ReceiptID() As Integer
        Get
            Return m_NewReceiptID
        End Get
        Set(ByVal value As Integer)
            m_NewReceiptID = value
        End Set
    End Property

    Public Property SubmitStatus() As Integer
        Get
            Return m_Status
        End Get
        Set(ByVal value As Integer)
            m_Status = value
        End Set
    End Property

    Public Property Message() As String
        Get
            Return m_ErrorMsg
        End Get
        Set(ByVal value As String)
            m_ErrorMsg = value
        End Set
    End Property

    ' ---------------- Audit properties ----------------

    Public Property CreatedUser() As String
        Get
            Return m_created_user
        End Get
        Set(ByVal value As String)
            m_created_user = value
        End Set
    End Property

    Public Property CreatedDate() As DateTime
        Get
            Return m_created_date
        End Get
        Set(ByVal value As DateTime)
            m_created_date = value
        End Set
    End Property

    Public Property ModifiedUser() As String
        Get
            Return m_modified_user
        End Get
        Set(ByVal value As String)
            m_modified_user = value
        End Set
    End Property

    Public Property ModifiedDate() As DateTime
        Get
            Return m_modified_date
        End Get
        Set(ByVal value As DateTime)
            m_modified_date = value
        End Set
    End Property

    Public Property DeletedUser() As String
        Get
            Return m_deleted_user
        End Get
        Set(ByVal value As String)
            m_deleted_user = value
        End Set
    End Property

    Public Property DeletedDate() As DateTime
        Get
            Return m_deleted_date
        End Get
        Set(ByVal value As DateTime)
            m_deleted_date = value
        End Set
    End Property

    Public Property ActiveStatus() As String
        Get
            Return m_active
        End Get
        Set(ByVal value As String)
            m_active = value
        End Set
    End Property

    Public Property LRDocFileName() As String
        Get
            Return m_LRDocFileName
        End Get
        Set(ByVal value As String)
            m_LRDocFileName = value
        End Set
    End Property

    Public Property LRDocPath() As String
        Get
            Return m_LRDocPath
        End Get
        Set(ByVal value As String)
            m_LRDocPath = value
        End Set
    End Property

    Public Property InvDocFileName() As String
        Get
            Return m_InvDocFileName
        End Get
        Set(ByVal value As String)
            m_InvDocFileName = value
        End Set
    End Property

    Public Property InvDocPath() As String
        Get
            Return m_InvDocPath
        End Get
        Set(ByVal value As String)
            m_InvDocPath = value
        End Set
    End Property

    Public Property rmVendorCode() As String
        Get
            Return m_rm_vendor_code
        End Get
        Set(ByVal value As String)
            m_rm_vendor_code = value
        End Set
    End Property

End Class