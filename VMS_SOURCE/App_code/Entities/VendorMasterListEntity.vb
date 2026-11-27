Imports Microsoft.VisualBasic

Namespace VMS.Web
    Public Class VendorMasterListEntity
        Private Vend_company As String
        Private Vend_Unit_Code As String
        Private Vend_Unit_Name As String
        Private Vend_Unit_Region As String
        Private Vend_Unit_Add1 As String
        Private Vend_Unit_Add2 As String
        Private Vend_Unit_Add3 As String
        Private Vend_State As String
        Private Vend_City As String
        Private Vend_Pin As String
        Private Vend_Email As String
        Private Vend_Stax_regno As String
        Private Vend_TinNo As String
        Private Vend_CenVatRegNo As String
        Private Vend_CenVatRegDate As String
        Private Created_User As String
        Private Created_date As Date
        Private Modified_User As String
        Private Modified_date As Date
        Private Deleted_user As String
        Private Deleted_date As String
        Private Active As String
        Private Freight_Yn As String

        Public Sub New()
            Vend_company = String.Empty
            Vend_Unit_Code = String.Empty
            Vend_Unit_Name = String.Empty
            Vend_Unit_Region = String.Empty
            Vend_Unit_Add1 = String.Empty
            Vend_Unit_Add2 = String.Empty
            Vend_Unit_Add3 = String.Empty
            Vend_State = String.Empty
            Vend_City = String.Empty
            Vend_Pin = String.Empty
            Vend_Email = String.Empty
            Vend_Stax_regno = String.Empty
            Vend_TinNo = String.Empty
            Vend_CenVatRegNo = String.Empty
            Vend_CenVatRegDate = String.Empty
            Created_User = String.Empty
            Created_date = Date.MinValue
            Modified_User = String.Empty
            Modified_date = Date.MinValue
            Deleted_user = String.Empty
            Deleted_date = String.Empty
            Active = String.Empty
            Freight_Yn = "N"
        End Sub
        Public Property Vendcompany() As String
            'Gets and Sets Company
            Get
                Return Vend_company
            End Get
            Set(ByVal value As String)
                Vend_company = value
            End Set
        End Property
        Public Property VendUnit_Code() As String
            'Gets and Sets Company
            Get
                Return Vend_Unit_Code
            End Get
            Set(ByVal value As String)
                Vend_Unit_Code = value
            End Set
        End Property
        Public Property VendUnit_Name() As String
            'Gets and Sets Company
            Get
                Return Vend_Unit_Name
            End Get
            Set(ByVal value As String)
                Vend_Unit_Name = value
            End Set
        End Property
        Public Property VendUnit_Region() As String
            'Gets and Sets Company
            Get
                Return Vend_Unit_Region
            End Get
            Set(ByVal value As String)
                Vend_Unit_Region = value
            End Set
        End Property
        Public Property VendUnit_Add1() As String
            Get
                Return Vend_Unit_Add1
            End Get
            Set(ByVal value As String)
                Vend_Unit_Add1 = value
            End Set
        End Property
        Public Property VendUnit_Add2() As String
            Get
                Return Vend_Unit_Add2
            End Get
            Set(ByVal value As String)
                Vend_Unit_Add2 = value
            End Set
        End Property
        Public Property VendUnit_Add3() As String
            Get
                Return Vend_Unit_Add3
            End Get
            Set(ByVal value As String)
                Vend_Unit_Add3 = value
            End Set
        End Property
        Public Property VendState() As String
            Get
                Return Vend_State
            End Get
            Set(ByVal value As String)
                Vend_State = value
            End Set
        End Property
        Public Property VendCity() As String
            Get
                Return Vend_City
            End Get
            Set(ByVal value As String)
                Vend_City = value
            End Set
        End Property
        Public Property VendPin() As String
            Get
                Return Vend_Pin
            End Get
            Set(ByVal value As String)
                Vend_Pin = value
            End Set
        End Property
        Public Property VendEmail() As String
            Get
                Return Vend_Email
            End Get
            Set(ByVal value As String)

                Vend_Email = value
            End Set
        End Property
        Public Property VendStax_regno() As String
            Get
                Return Vend_Stax_regno
            End Get
            Set(ByVal value As String)

                Vend_Stax_regno = value
            End Set
        End Property
        Public Property VendTinNo() As String
            Get
                Return Vend_TinNo
            End Get
            Set(ByVal value As String)

                Vend_TinNo = value
            End Set
        End Property

        Public Property VendCenVatRegNo() As String
            Get
                Return Vend_CenVatRegNo
            End Get
            Set(ByVal value As String)

                Vend_CenVatRegNo = value
            End Set
        End Property
        Public Property VendCenVatRegDate() As String
            Get
                Return Vend_CenVatRegDate
            End Get
            Set(ByVal value As String)

                Vend_CenVatRegDate = value
            End Set
        End Property

        Public Property CreatedUser() As String
            Get
                Return Created_User
            End Get
            Set(ByVal value As String)
                Created_User = value
            End Set
        End Property
        Public Property ModifiedUser() As String
            Get
                Return Modified_User
            End Get
            Set(ByVal value As String)
                Modified_User = value
            End Set
        End Property
        Public Property Deleteduser() As String
            Get
                Return Deleted_user
            End Get
            Set(ByVal value As String)
                Deleted_user = value
            End Set
        End Property
        Public Property Createddate() As Date
            Get
                Return Created_date
            End Get
            Set(ByVal value As Date)
                Created_date = value
            End Set
        End Property
        Public Property Modifieddate() As Date
            Get
                Return Modified_date
            End Get
            Set(ByVal value As Date)
                Modified_date = value
            End Set
        End Property
        Public Property Deleteddate() As Date
            Get
                Return Deleted_date
            End Get
            Set(ByVal value As Date)
                Deleted_date = value
            End Set
        End Property
        Public Property ActiveStatus() As String
            Get
                Return Active
            End Get
            Set(ByVal value As String)
                Active = value
            End Set
        End Property
        Public Property FreightYn() As String
            Get
                Return Freight_Yn
            End Get
            Set(ByVal value As String)
                Freight_Yn = value
            End Set
        End Property

    End Class
End Namespace

















