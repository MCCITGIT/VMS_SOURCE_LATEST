'**************************************************
'Copyright	    : VMS, MCC, KOLKATA
'Source	        : App_Code/EstimationDataDespatchedStatus_App.vb
'Created Date	: 06-December-2011
'Created By	    : Debayan Biswas
'Version	    : R01.00.00
'Description	: Code behind file for EstimationDataDespatchedStatus_App Class

'Modified By       Modified On       Version         Reason

'*************************************************************

Imports Microsoft.VisualBasic
Imports VMS.DataAccess
Imports System.Data
Imports System.Data.SqlClient
Namespace VMS.Web
    Public Class EstimationDataDespatchedStatus_App
#Region "Get product list"

        Function GetProductList(ByVal unitCode As String, ByVal depoCode As String, ByVal active As String) As DataSet

            Dim DetailsDS As System.Data.DataSet
            Dim sqlParams(2) As SqlParameter

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@unitCode"
            sqlParams(0).DbType = DbType.String
            sqlParams(0).Direction = Data.ParameterDirection.Input
            sqlParams(0).Value = IIf(unitCode <> String.Empty, unitCode, DBNull.Value)

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@depotCode"
            sqlParams(1).DbType = DbType.String
            sqlParams(1).Direction = Data.ParameterDirection.Input
            sqlParams(1).Value = IIf(depoCode <> String.Empty, depoCode, DBNull.Value)

            sqlParams(2) = New SqlParameter()
            sqlParams(2).ParameterName = "@active"
            sqlParams(2).DbType = DbType.String
            sqlParams(2).Direction = Data.ParameterDirection.Input
            sqlParams(2).Value = active



            DetailsDS = DBFactory.GetHelper().ExecuteDataSet("[Get_Product_List]", Data.CommandType.StoredProcedure, sqlParams)

            Return DetailsDS
        End Function
#End Region
        Public Function GetDepot(ByVal Region As String, ByVal Active As String) As DataSet
            Dim DepotDS As New DataSet
            Dim sqlParams(1) As SqlParameter

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@Region"
            sqlParams(0).DbType = DbType.String
            sqlParams(0).Direction = Data.ParameterDirection.Input
            sqlParams(0).Value = IIf(Region <> String.Empty, Region, DBNull.Value)


            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@Active"
            sqlParams(1).DbType = DbType.String
            sqlParams(1).Direction = Data.ParameterDirection.Input
            sqlParams(1).Value = Active

            'Modified-by MUKESH BHAGAT on 21-09-2026 : _vr1 SP - same list without the depot_rdc_yn='No'
            'condition, so RDCs (e.g. 116 RDC - Devla) can be selected; the report itself already carries
            'RDC rows. The shared [Estimation_Data_Get_Depot] is untouched (used by four other screens).
            'Roll-back = use "[Estimation_Data_Get_Depot]" again.
            DepotDS = DBFactory.GetHelper().ExecuteDataSet("[Estimation_Data_Get_Depot_vr1]", Data.CommandType.StoredProcedure, sqlParams)
            Return DepotDS
        End Function

        Public Function GetUnit(ByVal Active As String) As DataSet
            Dim UnitDS As New DataSet
            Dim sqlParams(0) As SqlParameter

            'sqlParams(0) = New SqlParameter()
            'sqlParams(0).ParameterName = "@Region"
            'sqlParams(0).DbType = DbType.String
            'sqlParams(0).Direction = Data.ParameterDirection.Input
            'sqlParams(0).Value = IIf(Region <> String.Empty, Region, DBNull.Value)


            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@Active"
            sqlParams(0).DbType = DbType.String
            sqlParams(0).Direction = Data.ParameterDirection.Input
            sqlParams(0).Value = Active

            UnitDS = DBFactory.GetHelper().ExecuteDataSet("Get_Unit_Details", Data.CommandType.StoredProcedure, sqlParams)
            Return UnitDS
        End Function

        Public Function GetDetailsGvDsptchdStat(ByVal Region As String, ByVal Depot As String, ByVal Unit As String, ByVal SkuCode As String, ByVal FinYear As String, ByVal Month As String, ByVal Active As String) As DataSet
            Dim DsptchdStatDetailsDS As New DataSet
            Dim sqlParams(6) As SqlParameter

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@Region"
            sqlParams(0).DbType = DbType.String
            sqlParams(0).Direction = Data.ParameterDirection.Input
            sqlParams(0).Value = IIf(Region <> String.Empty, Region, DBNull.Value)

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@Depot"
            sqlParams(1).DbType = DbType.String
            sqlParams(1).Direction = Data.ParameterDirection.Input
            sqlParams(1).Value = IIf(Depot <> String.Empty, Depot, DBNull.Value)

            sqlParams(2) = New SqlParameter()
            sqlParams(2).ParameterName = "@Unit"
            sqlParams(2).DbType = DbType.String
            sqlParams(2).Direction = Data.ParameterDirection.Input
            sqlParams(2).Value = IIf(Unit <> String.Empty, Unit, DBNull.Value)

            sqlParams(3) = New SqlParameter()
            sqlParams(3).ParameterName = "@SkuCode"
            sqlParams(3).DbType = DbType.String
            sqlParams(3).Direction = Data.ParameterDirection.Input
            sqlParams(3).Value = IIf(SkuCode <> String.Empty, SkuCode, DBNull.Value)

            sqlParams(4) = New SqlParameter()
            sqlParams(4).ParameterName = "@FinYear"
            sqlParams(4).DbType = DbType.String
            sqlParams(4).Direction = Data.ParameterDirection.Input
            sqlParams(4).Value = FinYear

            sqlParams(5) = New SqlParameter()
            sqlParams(5).ParameterName = "@Month"
            sqlParams(5).DbType = DbType.String
            sqlParams(5).Direction = Data.ParameterDirection.Input
            sqlParams(5).Value = Month

            sqlParams(6) = New SqlParameter()
            sqlParams(6).ParameterName = "@Active"
            sqlParams(6).DbType = DbType.String
            sqlParams(6).Direction = Data.ParameterDirection.Input
            sqlParams(6).Value = Active

            'Modified-by MUKESH BHAGAT on 21-09-2026 : _vr1 SP - INTRANSIT / RECEIVED now test the GRN on the
            'unique release id (release number + PO number as fallback); the release number alone matched
            'other POs' releases. Roll-back = use "[Estimation_Data_Get_Details]" again.
            DsptchdStatDetailsDS = DBFactory.GetHelper().ExecuteDataSet("[Estimation_Data_Get_Details_vr1]", Data.CommandType.StoredProcedure, sqlParams)
            Return DsptchdStatDetailsDS
        End Function

        Public Function GetExcelDsptchdStatRpt(ByVal Region As String, ByVal Depot As String, ByVal Unit As String, ByVal SkuCode As String, ByVal FinYear As String, ByVal Month As String, ByVal Active As String) As DataSet
            Dim ExcelDsptchdStatDS As New DataSet
            Dim sqlParams(6) As SqlParameter

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@Region"
            sqlParams(0).DbType = DbType.String
            sqlParams(0).Direction = Data.ParameterDirection.Input
            sqlParams(0).Value = IIf(Region <> String.Empty, Region, DBNull.Value)

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@Depot"
            sqlParams(1).DbType = DbType.String
            sqlParams(1).Direction = Data.ParameterDirection.Input
            sqlParams(1).Value = IIf(Depot <> String.Empty, Depot, DBNull.Value)

            sqlParams(2) = New SqlParameter()
            sqlParams(2).ParameterName = "@Unit"
            sqlParams(2).DbType = DbType.String
            sqlParams(2).Direction = Data.ParameterDirection.Input
            sqlParams(2).Value = IIf(Unit <> String.Empty, Unit, DBNull.Value)

            sqlParams(3) = New SqlParameter()
            sqlParams(3).ParameterName = "@SkuCode"
            sqlParams(3).DbType = DbType.String
            sqlParams(3).Direction = Data.ParameterDirection.Input
            sqlParams(3).Value = IIf(SkuCode <> String.Empty, SkuCode, DBNull.Value)

            sqlParams(4) = New SqlParameter()
            sqlParams(4).ParameterName = "@FinYear"
            sqlParams(4).DbType = DbType.String
            sqlParams(4).Direction = Data.ParameterDirection.Input
            sqlParams(4).Value = FinYear

            sqlParams(5) = New SqlParameter()
            sqlParams(5).ParameterName = "@Month"
            sqlParams(5).DbType = DbType.String
            sqlParams(5).Direction = Data.ParameterDirection.Input
            sqlParams(5).Value = Month

            sqlParams(6) = New SqlParameter()
            sqlParams(6).ParameterName = "@Active"
            sqlParams(6).DbType = DbType.String
            sqlParams(6).Direction = Data.ParameterDirection.Input
            sqlParams(6).Value = Active

            'Modified-by MUKESH BHAGAT on 21-09-2026 : _vr1 SP (same INTRANSIT / RECEIVED fix as the grid).
            'Roll-back = use "[Estimation_Data_Get_Details_Report_ForExcel]" again.
            ExcelDsptchdStatDS = DBFactory.GetHelper().ExecuteDataSet("[Estimation_Data_Get_Details_Report_ForExcel_vr1]", Data.CommandType.StoredProcedure, sqlParams)
            Return ExcelDsptchdStatDS
        End Function

        Public Function GetTopFinYear() As String
            Dim noRowsAffected As New DataSet
            Dim sqlParams(0) As SqlParameter

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@Active"
            sqlParams(0).DbType = DbType.String
            sqlParams(0).Direction = Data.ParameterDirection.Input
            sqlParams(0).Value = Constant.Common.ActiveStatus

            noRowsAffected = DBFactory.GetHelper().ExecuteDataSet("Stock_Upload_Get_TopFinYear", Data.CommandType.StoredProcedure, sqlParams)
            Dim TopFinYr As String
            TopFinYr = noRowsAffected.Tables(0).Rows(0)("fin_year")
            Return TopFinYr
        End Function

        Public Function GetLastFinYear() As String
            Dim noRowsAffected As New DataSet
            Dim sqlParams(0) As SqlParameter

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@Active"
            sqlParams(0).DbType = DbType.String
            sqlParams(0).Direction = Data.ParameterDirection.Input
            sqlParams(0).Value = Constant.Common.ActiveStatus

            noRowsAffected = DBFactory.GetHelper().ExecuteDataSet("Stock_Upload_Get_LastFinYear", Data.CommandType.StoredProcedure, sqlParams)
            Dim LastFinYr As String
            LastFinYr = noRowsAffected.Tables(0).Rows(0)("fin_year")
            Return LastFinYr
        End Function

    End Class
End Namespace

