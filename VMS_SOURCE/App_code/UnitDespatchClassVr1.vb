Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Data.SqlTypes
Imports VMS.DataAccess

Public Class UnitDespatchClassVr1
#Region "Get Site Name list"
    Function GetSiteNameList(ByVal unitCode As String, ByVal depotCode As String, ByVal UserId As String) As DataSet
        Dim sqlParams(2) As SqlParameter
        Try
            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@unitCode"
            sqlParams(0).DbType = DbType.String
            sqlParams(0).Direction = Data.ParameterDirection.Input
            sqlParams(0).Value = unitCode

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@depot_code"
            sqlParams(1).DbType = DbType.String
            sqlParams(1).Direction = Data.ParameterDirection.Input
            sqlParams(1).Value = depotCode

            sqlParams(2) = New SqlParameter()
            sqlParams(2).ParameterName = "@UserId"
            sqlParams(2).DbType = DbType.String
            sqlParams(2).Direction = Data.ParameterDirection.Input
            sqlParams(2).Value = UserId


            Return DBFactory.GetHelper().ExecuteDataSet("[Unit_Dspatch_site_details_get_vr1]", Data.CommandType.StoredProcedure, sqlParams)
        Catch ex As Exception
            Throw ex
        End Try
    End Function
#End Region

#Region "Check Invoice Number"
    Function CheckInvoiceNumberExsists(ByVal year As String, ByVal invoice_no As String, ByVal vendor As String) As DataSet
        Dim sqlParams(2) As SqlParameter
        Try
            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@year"
            sqlParams(0).DbType = DbType.String
            sqlParams(0).Direction = Data.ParameterDirection.Input
            sqlParams(0).Value = year

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@gp_no"
            sqlParams(1).DbType = DbType.String
            sqlParams(1).Direction = Data.ParameterDirection.Input
            sqlParams(1).Value = invoice_no

            sqlParams(2) = New SqlParameter()
            sqlParams(2).ParameterName = "@vendor"
            sqlParams(2).DbType = DbType.String
            sqlParams(2).Direction = Data.ParameterDirection.Input
            sqlParams(2).Value = vendor

            Return DBFactory.GetHelper().ExecuteDataSet("[Check_Despatch_Challan_Invoice_Number]", Data.CommandType.StoredProcedure, sqlParams)
        Catch ex As Exception
            Throw ex
        End Try
    End Function
#End Region
#Region "Get PO No "
    Public Function GetPONo(ByVal Depot As String, ByVal unit As String, ByVal siteId As Long) As DataSet
        Dim sqlParams(2) As SqlParameter

        sqlParams(0) = New SqlParameter()
        sqlParams(0).ParameterName = "@Depot"
        sqlParams(0).DbType = DbType.String
        sqlParams(0).Direction = Data.ParameterDirection.Input
        sqlParams(0).Value = Depot

        sqlParams(1) = New SqlParameter()
        sqlParams(1).ParameterName = "@unit"
        sqlParams(1).DbType = DbType.String
        sqlParams(1).Direction = Data.ParameterDirection.Input
        sqlParams(1).Value = unit

        sqlParams(2) = New SqlParameter()
        sqlParams(2).ParameterName = "@SiteId"
        sqlParams(2).DbType = DbType.Int64
        sqlParams(2).Direction = Data.ParameterDirection.Input
        sqlParams(2).Value = siteId

        Return DBFactory.GetHelper().ExecuteDataSet("Unit_Dspatch_PO_No_get_vr1", Data.CommandType.StoredProcedure, sqlParams)
    End Function
#End Region
#Region "Get SKU Details"
    Function GetSKUDetails(ByVal productCode As String, ByVal allSKU As String, ByVal active As String, ByVal unit As String, ByVal depot As String, ByVal poNo As String, ByVal vendorSiteId As Long, ByVal LocationCode As String) As DataSet
        Dim sqlParams(7) As SqlParameter
        Try
            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@productCode"
            sqlParams(0).DbType = DbType.String
            sqlParams(0).Direction = Data.ParameterDirection.Input
            sqlParams(0).Value = IIf(productCode <> String.Empty, productCode, DBNull.Value)

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@allSKU"
            sqlParams(1).DbType = DbType.String
            sqlParams(1).Direction = Data.ParameterDirection.Input
            sqlParams(1).Value = allSKU

            sqlParams(2) = New SqlParameter()
            sqlParams(2).ParameterName = "@active"
            sqlParams(2).DbType = DbType.String
            sqlParams(2).Direction = Data.ParameterDirection.Input
            sqlParams(2).Value = active

            sqlParams(3) = New SqlParameter()
            sqlParams(3).ParameterName = "@unit"
            sqlParams(3).DbType = DbType.String
            sqlParams(3).Direction = Data.ParameterDirection.Input
            sqlParams(3).Value = unit

            sqlParams(4) = New SqlParameter()
            sqlParams(4).ParameterName = "@depot"
            sqlParams(4).DbType = DbType.String
            sqlParams(4).Direction = Data.ParameterDirection.Input
            sqlParams(4).Value = depot

            sqlParams(5) = New SqlParameter()
            sqlParams(5).ParameterName = "@pd_po_no"
            sqlParams(5).DbType = DbType.String
            sqlParams(5).Direction = Data.ParameterDirection.Input
            sqlParams(5).Value = poNo

            sqlParams(6) = New SqlParameter()
            sqlParams(6).ParameterName = "@pd_vendor_site_id"
            sqlParams(6).DbType = DbType.Int64
            sqlParams(6).Direction = Data.ParameterDirection.Input
            sqlParams(6).Value = vendorSiteId

            sqlParams(7) = New SqlParameter()
            sqlParams(7).ParameterName = "@LocationCode"
            sqlParams(7).DbType = DbType.String
            sqlParams(7).Direction = Data.ParameterDirection.Input
            sqlParams(7).Value = LocationCode




            Return DBFactory.GetHelper().ExecuteDataSet("[Unit_Dspatch_Get_SKU_Details_vr1]", Data.CommandType.StoredProcedure, sqlParams)
        Catch ex As Exception
            Throw ex
        End Try
    End Function
#End Region
#Region "Insert Despatch Header"
    Function InsertDespHeader(ByVal sqlConn As SqlConnection, ByVal sqlTrans As SqlTransaction, ByRef DespEntity As DespatchHeaderEntity) As Integer

        Dim numRowsAffected As Integer
        Dim challanNo As Integer
        challanNo = -1

        Try

            Dim sqlParams(20) As SqlParameter

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@desph_desp_unit"
            sqlParams(0).DbType = DbType.String
            sqlParams(0).Direction = Data.ParameterDirection.Input
            sqlParams(0).Value = DespEntity.DespUnit

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@desph_desp_depot"
            sqlParams(1).DbType = DbType.String
            sqlParams(1).Direction = Data.ParameterDirection.Input
            sqlParams(1).Value = DespEntity.DespDepot

            sqlParams(2) = New SqlParameter()
            sqlParams(2).ParameterName = "@desph_challan_fin_year"
            sqlParams(2).DbType = DbType.String
            sqlParams(2).Direction = Data.ParameterDirection.Input
            sqlParams(2).Value = DespEntity.ChallanFinYear

            sqlParams(3) = New SqlParameter()
            sqlParams(3).ParameterName = "@desph_challan_no"
            sqlParams(3).DbType = DbType.Int64
            sqlParams(3).Direction = Data.ParameterDirection.Output

            sqlParams(4) = New SqlParameter()
            sqlParams(4).ParameterName = "@desph_challan_date"
            sqlParams(4).DbType = DbType.DateTime
            sqlParams(4).Direction = Data.ParameterDirection.Input
            sqlParams(4).Value = DespEntity.ChallanDate


            sqlParams(5) = New SqlParameter()
            sqlParams(5).ParameterName = "@desph_total_ltr"
            sqlParams(5).DbType = DbType.Decimal
            sqlParams(5).Direction = Data.ParameterDirection.Input
            sqlParams(5).Value = DespEntity.TotalLtr

            sqlParams(6) = New SqlParameter()
            sqlParams(6).ParameterName = "@desph_total_kg"
            sqlParams(6).DbType = DbType.Decimal
            sqlParams(6).Direction = Data.ParameterDirection.Input
            sqlParams(6).Value = DespEntity.TotalKg

            sqlParams(7) = New SqlParameter()
            sqlParams(7).ParameterName = "@desph_transporter_name"
            sqlParams(7).DbType = DbType.String
            sqlParams(7).Direction = Data.ParameterDirection.Input
            sqlParams(7).Value = DespEntity.TransporterName

            sqlParams(8) = New SqlParameter()
            sqlParams(8).ParameterName = "@desph_truck_no"
            sqlParams(8).DbType = DbType.String
            sqlParams(8).Direction = Data.ParameterDirection.Input
            sqlParams(8).Value = DespEntity.TruckNo

            sqlParams(9) = New SqlParameter()
            sqlParams(9).ParameterName = "@desph_excise_gp_no"
            sqlParams(9).DbType = DbType.String
            sqlParams(9).Direction = Data.ParameterDirection.Input
            sqlParams(9).Value = DespEntity.ExciseGpNo


            sqlParams(10) = New SqlParameter()
            sqlParams(10).ParameterName = "@desph_excise_gp_dt"
            sqlParams(10).DbType = DbType.DateTime
            sqlParams(10).Direction = Data.ParameterDirection.Input
            sqlParams(10).Value = DespEntity.ExciseGpDt

            sqlParams(11) = New SqlParameter()
            sqlParams(11).ParameterName = "@created_user"
            sqlParams(11).DbType = DbType.String
            sqlParams(11).Direction = Data.ParameterDirection.Input
            sqlParams(11).Value = DespEntity.CreatedUser

            sqlParams(12) = New SqlParameter()
            sqlParams(12).ParameterName = "@active"
            sqlParams(12).DbType = DbType.String
            sqlParams(12).Direction = Data.ParameterDirection.Input
            sqlParams(12).Value = DespEntity.ActiveStatus

            sqlParams(13) = New SqlParameter()
            sqlParams(13).ParameterName = "@desph_process_month"
            sqlParams(13).DbType = DbType.String
            sqlParams(13).Direction = Data.ParameterDirection.Input
            sqlParams(13).Value = DespEntity.ProcessMonth

            sqlParams(14) = New SqlParameter()
            sqlParams(14).ParameterName = "@desph_road_permit_no"
            sqlParams(14).DbType = DbType.String
            sqlParams(14).Direction = Data.ParameterDirection.Input
            sqlParams(14).Value = DespEntity.RoadPermitNo

            sqlParams(15) = New SqlParameter()
            sqlParams(15).ParameterName = "@desph_po_no"
            sqlParams(15).DbType = DbType.String
            sqlParams(15).Direction = Data.ParameterDirection.Input
            sqlParams(15).Value = DespEntity.po_no

            sqlParams(16) = New SqlParameter()
            sqlParams(16).ParameterName = "@site_name"
            sqlParams(16).DbType = DbType.String
            sqlParams(16).Direction = Data.ParameterDirection.Input
            sqlParams(16).Value = DespEntity.site_name

            sqlParams(17) = New SqlParameter()
            sqlParams(17).ParameterName = "@delivery_depot"
            sqlParams(17).DbType = DbType.String
            sqlParams(17).Direction = Data.ParameterDirection.Input
            sqlParams(17).Value = DespEntity.delivery_depot

            sqlParams(18) = New SqlParameter()
            sqlParams(18).ParameterName = "@desph_site_id"
            sqlParams(18).DbType = DbType.Int64
            sqlParams(18).Direction = Data.ParameterDirection.Input
            sqlParams(18).Value = DespEntity.SiteId

            sqlParams(19) = New SqlParameter()
            sqlParams(19).ParameterName = "@desph_transport_id"
            sqlParams(19).DbType = DbType.Int32
            sqlParams(19).Direction = Data.ParameterDirection.Input
            sqlParams(19).Value = IIf(DespEntity.TranspoterId <> Integer.MinValue, DespEntity.TranspoterId, DBNull.Value)

            sqlParams(20) = New SqlParameter()
            sqlParams(20).ParameterName = "@desph_invoice_value"
            sqlParams(20).DbType = DbType.Decimal
            sqlParams(20).Direction = Data.ParameterDirection.Input
            sqlParams(20).Value = IIf(DespEntity.InvoiceValue <> Decimal.MinValue, DespEntity.InvoiceValue, DBNull.Value)

            'sqlCmd is the object instance of the SqlCommand 
            Dim sqlCmd As New SqlCommand()
            sqlCmd.Connection = sqlConn
            sqlCmd.Transaction = sqlTrans
            sqlCmd.CommandType = CommandType.StoredProcedure
            sqlCmd.CommandText = "[Unit_Dspatch_Insert_Hdr_vr1]"
            sqlCmd.Parameters.AddRange(sqlParams)
            numRowsAffected = sqlCmd.ExecuteNonQuery()

            challanNo = sqlParams(3).Value

        Catch ex As Exception
            Throw ex
        End Try

        Return challanNo

    End Function
#End Region
#Region "Update Despatch Header"
    Function UpdateDespHeader(ByVal sqlConn As SqlConnection, ByVal sqlTrans As SqlTransaction, ByRef DespEntity As DespatchHeaderEntity) As Integer

        Dim numRowsAffected As Integer
        Try

            Dim sqlParams(20) As SqlParameter

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@desph_desp_unit"
            sqlParams(0).DbType = DbType.String
            sqlParams(0).Direction = Data.ParameterDirection.Input
            sqlParams(0).Value = DespEntity.DespUnit

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@desph_desp_depot"
            sqlParams(1).DbType = DbType.String
            sqlParams(1).Direction = Data.ParameterDirection.Input
            sqlParams(1).Value = DespEntity.DespDepot

            sqlParams(2) = New SqlParameter()
            sqlParams(2).ParameterName = "@desph_challan_fin_year"
            sqlParams(2).DbType = DbType.String
            sqlParams(2).Direction = Data.ParameterDirection.Input
            sqlParams(2).Value = DespEntity.ChallanFinYear

            sqlParams(3) = New SqlParameter()
            sqlParams(3).ParameterName = "@desph_challan_no"
            sqlParams(3).DbType = DbType.Int64
            sqlParams(3).Direction = Data.ParameterDirection.Input
            sqlParams(3).Value = DespEntity.ChallanNo

            sqlParams(4) = New SqlParameter()
            sqlParams(4).ParameterName = "@desph_challan_date"
            sqlParams(4).DbType = DbType.DateTime
            sqlParams(4).Direction = Data.ParameterDirection.Input
            sqlParams(4).Value = DespEntity.ChallanDate


            sqlParams(5) = New SqlParameter()
            sqlParams(5).ParameterName = "@desph_total_ltr"
            sqlParams(5).DbType = DbType.Decimal
            sqlParams(5).Direction = Data.ParameterDirection.Input
            sqlParams(5).Value = DespEntity.TotalLtr

            sqlParams(6) = New SqlParameter()
            sqlParams(6).ParameterName = "@desph_total_kg"
            sqlParams(6).DbType = DbType.Decimal
            sqlParams(6).Direction = Data.ParameterDirection.Input
            sqlParams(6).Value = DespEntity.TotalKg

            sqlParams(7) = New SqlParameter()
            sqlParams(7).ParameterName = "@desph_transporter_name"
            sqlParams(7).DbType = DbType.String
            sqlParams(7).Direction = Data.ParameterDirection.Input
            sqlParams(7).Value = DespEntity.TransporterName

            sqlParams(8) = New SqlParameter()
            sqlParams(8).ParameterName = "@desph_truck_no"
            sqlParams(8).DbType = DbType.String
            sqlParams(8).Direction = Data.ParameterDirection.Input
            sqlParams(8).Value = DespEntity.TruckNo

            sqlParams(9) = New SqlParameter()
            sqlParams(9).ParameterName = "@desph_excise_gp_no"
            sqlParams(9).DbType = DbType.String
            sqlParams(9).Direction = Data.ParameterDirection.Input
            sqlParams(9).Value = DespEntity.ExciseGpNo


            sqlParams(10) = New SqlParameter()
            sqlParams(10).ParameterName = "@desph_excise_gp_dt"
            sqlParams(10).DbType = DbType.DateTime
            sqlParams(10).Direction = Data.ParameterDirection.Input
            sqlParams(10).Value = DespEntity.ExciseGpDt

            sqlParams(11) = New SqlParameter()
            sqlParams(11).ParameterName = "@created_user"
            sqlParams(11).DbType = DbType.String
            sqlParams(11).Direction = Data.ParameterDirection.Input
            sqlParams(11).Value = DespEntity.CreatedUser

            sqlParams(12) = New SqlParameter()
            sqlParams(12).ParameterName = "@active"
            sqlParams(12).DbType = DbType.String
            sqlParams(12).Direction = Data.ParameterDirection.Input
            sqlParams(12).Value = DespEntity.ActiveStatus

            sqlParams(13) = New SqlParameter()
            sqlParams(13).ParameterName = "@desph_process_month"
            sqlParams(13).DbType = DbType.String
            sqlParams(13).Direction = Data.ParameterDirection.Input
            sqlParams(13).Value = DespEntity.ProcessMonth

            sqlParams(14) = New SqlParameter()
            sqlParams(14).ParameterName = "@desph_road_permit_no"
            sqlParams(14).DbType = DbType.String
            sqlParams(14).Direction = Data.ParameterDirection.Input
            sqlParams(14).Value = DespEntity.RoadPermitNo

            sqlParams(15) = New SqlParameter()
            sqlParams(15).ParameterName = "@desph_po_no"
            sqlParams(15).DbType = DbType.String
            sqlParams(15).Direction = Data.ParameterDirection.Input
            sqlParams(15).Value = DespEntity.po_no

            sqlParams(16) = New SqlParameter()
            sqlParams(16).ParameterName = "@site_name"
            sqlParams(16).DbType = DbType.String
            sqlParams(16).Direction = Data.ParameterDirection.Input
            sqlParams(16).Value = DespEntity.site_name

            sqlParams(17) = New SqlParameter()
            sqlParams(17).ParameterName = "@delivery_depot"
            sqlParams(17).DbType = DbType.String
            sqlParams(17).Direction = Data.ParameterDirection.Input
            sqlParams(17).Value = DespEntity.delivery_depot

            sqlParams(18) = New SqlParameter()
            sqlParams(18).ParameterName = "@desph_site_id"
            sqlParams(18).DbType = DbType.Int64
            sqlParams(18).Direction = Data.ParameterDirection.Input
            sqlParams(18).Value = DespEntity.SiteId

            sqlParams(19) = New SqlParameter()
            sqlParams(19).ParameterName = "@desph_transport_id"
            sqlParams(19).DbType = DbType.Int32
            sqlParams(19).Direction = Data.ParameterDirection.Input
            sqlParams(19).Value = IIf(DespEntity.TranspoterId <> Integer.MinValue, DespEntity.TranspoterId, DBNull.Value)

            sqlParams(20) = New SqlParameter()
            sqlParams(20).ParameterName = "@desph_invoice_value"
            sqlParams(20).DbType = DbType.Decimal
            sqlParams(20).Direction = Data.ParameterDirection.Input
            sqlParams(20).Value = IIf(DespEntity.InvoiceValue <> Decimal.MinValue, DespEntity.InvoiceValue, DBNull.Value)

            'sqlCmd is the object instance of the SqlCommand 
            Dim sqlCmd As New SqlCommand()
            sqlCmd.Connection = sqlConn
            sqlCmd.Transaction = sqlTrans
            sqlCmd.CommandType = CommandType.StoredProcedure
            sqlCmd.CommandText = "[Unit_Dspatch_Update_Hdr_vr1]"
            sqlCmd.Parameters.AddRange(sqlParams)
            numRowsAffected = sqlCmd.ExecuteNonQuery()

        Catch ex As Exception
            Throw ex
        End Try

        Return numRowsAffected

    End Function
#End Region
#Region "Get SKU Details"

    Function GetSKUDetailsForUpdateMode(ByVal challanNo As Integer, ByVal year As String, ByVal active As String, ByVal unit As String, ByVal depot As String, ByVal poNo As String, ByVal vendorSiteId As Long) As DataSet

        Dim DetailsDS As System.Data.DataSet
        Dim sqlParams(6) As SqlParameter

        sqlParams(0) = New SqlParameter()
        sqlParams(0).ParameterName = "@challanNo"
        sqlParams(0).DbType = DbType.Int64
        sqlParams(0).Direction = Data.ParameterDirection.Input
        sqlParams(0).Value = challanNo

        sqlParams(1) = New SqlParameter()
        sqlParams(1).ParameterName = "@processYear"
        sqlParams(1).DbType = DbType.String
        sqlParams(1).Direction = Data.ParameterDirection.Input
        sqlParams(1).Value = year

        sqlParams(2) = New SqlParameter()
        sqlParams(2).ParameterName = "@active"
        sqlParams(2).DbType = DbType.String
        sqlParams(2).Direction = Data.ParameterDirection.Input
        sqlParams(2).Value = active

        sqlParams(3) = New SqlParameter()
        sqlParams(3).ParameterName = "@unit"
        sqlParams(3).DbType = DbType.String
        sqlParams(3).Direction = Data.ParameterDirection.Input
        sqlParams(3).Value = unit

        sqlParams(4) = New SqlParameter()
        sqlParams(4).ParameterName = "@depot"
        sqlParams(4).DbType = DbType.String
        sqlParams(4).Direction = Data.ParameterDirection.Input
        sqlParams(4).Value = depot

        sqlParams(5) = New SqlParameter()
        sqlParams(5).ParameterName = "@pd_po_no"
        sqlParams(5).DbType = DbType.String
        sqlParams(5).Direction = Data.ParameterDirection.Input
        sqlParams(5).Value = poNo

        sqlParams(6) = New SqlParameter()
        sqlParams(6).ParameterName = "@pd_vendor_site_id"
        sqlParams(6).DbType = DbType.Int64
        sqlParams(6).Direction = Data.ParameterDirection.Input
        sqlParams(6).Value = vendorSiteId

        DetailsDS = DBFactory.GetHelper().ExecuteDataSet("[Unit_Dspatch_Get_SKU_Details_For_Update_Mode_vr1]", Data.CommandType.StoredProcedure, sqlParams)

        Return DetailsDS
    End Function
#End Region
#Region "Insert despatch Detail"
    Function InsertDespatchDetail(ByVal sqlConn As SqlConnection, ByVal sqlTrans As SqlTransaction, ByRef DespEntity As DespatchDetailEntity) As Integer

        Dim numRowsAffected As Integer

        Try

            Dim sqlParams(22) As SqlParameter

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@despd_desp_unit"
            sqlParams(0).DbType = DbType.String
            sqlParams(0).Direction = Data.ParameterDirection.Input
            sqlParams(0).Value = DespEntity.DespUnit

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@despd_desp_depot"
            sqlParams(1).DbType = DbType.String
            sqlParams(1).Direction = Data.ParameterDirection.Input
            sqlParams(1).Value = DespEntity.DespDepot

            sqlParams(2) = New SqlParameter()
            sqlParams(2).ParameterName = "@despd_challan_fin_year"
            sqlParams(2).DbType = DbType.String
            sqlParams(2).Direction = Data.ParameterDirection.Input
            sqlParams(2).Value = DespEntity.ChallanFinYear

            sqlParams(3) = New SqlParameter()
            sqlParams(3).ParameterName = "@despd_challan_no"
            sqlParams(3).DbType = DbType.Int64
            sqlParams(3).Direction = Data.ParameterDirection.Input
            sqlParams(3).Value = DespEntity.ChallanNo

            sqlParams(4) = New SqlParameter()
            sqlParams(4).ParameterName = "@despd_challan_date"
            sqlParams(4).DbType = DbType.DateTime
            sqlParams(4).Direction = Data.ParameterDirection.Input
            sqlParams(4).Value = DespEntity.ChallanDate


            sqlParams(5) = New SqlParameter()
            sqlParams(5).ParameterName = "@despd_srl"
            sqlParams(5).DbType = DbType.Int64
            sqlParams(5).Direction = Data.ParameterDirection.Input
            sqlParams(5).Value = DespEntity.Srl

            sqlParams(6) = New SqlParameter()
            sqlParams(6).ParameterName = "@despd_sku_code"
            sqlParams(6).DbType = DbType.String
            sqlParams(6).Direction = Data.ParameterDirection.Input
            sqlParams(6).Value = DespEntity.SkuCode

            sqlParams(7) = New SqlParameter()
            sqlParams(7).ParameterName = "@despd_sku_uom"
            sqlParams(7).DbType = DbType.String
            sqlParams(7).Direction = Data.ParameterDirection.Input
            sqlParams(7).Value = DespEntity.SkuUom

            sqlParams(8) = New SqlParameter()
            sqlParams(8).ParameterName = "@despd_desp_nop"
            sqlParams(8).DbType = DbType.Int64
            sqlParams(8).Direction = Data.ParameterDirection.Input
            sqlParams(8).Value = DespEntity.DespNop

            sqlParams(9) = New SqlParameter()
            sqlParams(9).ParameterName = "@despd_sku_vol"
            sqlParams(9).DbType = DbType.Decimal
            sqlParams(9).Direction = Data.ParameterDirection.Input
            sqlParams(9).Value = DespEntity.SkuVol


            sqlParams(10) = New SqlParameter()
            sqlParams(10).ParameterName = "@despd_auto_indent"
            sqlParams(10).DbType = DbType.Int64
            sqlParams(10).Direction = Data.ParameterDirection.Input
            sqlParams(10).Value = DespEntity.AutoIndent

            sqlParams(11) = New SqlParameter()
            sqlParams(11).ParameterName = "@despd_depot_indent"
            sqlParams(11).DbType = DbType.Int64
            sqlParams(11).Direction = Data.ParameterDirection.Input
            sqlParams(11).Value = DespEntity.DepotIndent

            sqlParams(12) = New SqlParameter()
            sqlParams(12).ParameterName = "@despd_indent_total"
            sqlParams(12).DbType = DbType.Int64
            sqlParams(12).Direction = Data.ParameterDirection.Input
            sqlParams(12).Value = DespEntity.IndentTotal

            sqlParams(13) = New SqlParameter()
            sqlParams(13).ParameterName = "@despd_despatch_to_date"
            sqlParams(13).DbType = DbType.Int64
            sqlParams(13).Direction = Data.ParameterDirection.Input
            sqlParams(13).Value = DespEntity.DespatchToDate

            sqlParams(14) = New SqlParameter()
            sqlParams(14).ParameterName = "@despd_pending_load"
            sqlParams(14).DbType = DbType.Int64
            sqlParams(14).Direction = Data.ParameterDirection.Input
            sqlParams(14).Value = DespEntity.PendingLoad

            sqlParams(15) = New SqlParameter()
            sqlParams(15).ParameterName = "@created_user"
            sqlParams(15).DbType = DbType.String
            sqlParams(15).Direction = Data.ParameterDirection.Input
            sqlParams(15).Value = DespEntity.CreatedUser

            sqlParams(16) = New SqlParameter()
            sqlParams(16).ParameterName = "@active"
            sqlParams(16).DbType = DbType.String
            sqlParams(16).Direction = Data.ParameterDirection.Input
            sqlParams(16).Value = DespEntity.ActiveStatus

            sqlParams(17) = New SqlParameter()
            sqlParams(17).ParameterName = "@despd_process_month"
            sqlParams(17).DbType = DbType.String
            sqlParams(17).Direction = Data.ParameterDirection.Input
            sqlParams(17).Value = DespEntity.ProcessMonth

            sqlParams(18) = New SqlParameter()
            sqlParams(18).ParameterName = "@despd_transit_till"
            sqlParams(18).DbType = DbType.DateTime
            sqlParams(18).Direction = Data.ParameterDirection.Input
            sqlParams(18).Value = DespEntity.TransitTill

            sqlParams(19) = New SqlParameter()
            sqlParams(19).ParameterName = "@despd_lot_no"
            sqlParams(19).DbType = DbType.String
            sqlParams(19).Direction = Data.ParameterDirection.Input
            sqlParams(19).Value = DespEntity.lot_no

            sqlParams(20) = New SqlParameter()
            sqlParams(20).ParameterName = "@despd_line_num"
            sqlParams(20).DbType = DbType.Int32
            sqlParams(20).Direction = Data.ParameterDirection.Input
            sqlParams(20).Value = DespEntity.LineNum

            sqlParams(21) = New SqlParameter()
            sqlParams(21).ParameterName = "@despd_po_rate"
            sqlParams(21).DbType = DbType.Decimal
            sqlParams(21).Direction = Data.ParameterDirection.Input
            sqlParams(21).Value = DespEntity.Po_Rate

            sqlParams(22) = New SqlParameter()
            sqlParams(22).ParameterName = "@despd_sku_gst"
            sqlParams(22).DbType = DbType.Decimal
            sqlParams(22).Direction = Data.ParameterDirection.Input
            sqlParams(22).Value = DespEntity.Sku_Gst


            'sqlCmd is the object instance of the SqlCommand 
            Dim sqlCmd As New SqlCommand()
            sqlCmd.Connection = sqlConn
            sqlCmd.Transaction = sqlTrans
            sqlCmd.CommandType = CommandType.StoredProcedure
            sqlCmd.CommandText = "[Unit_Dspatch_Insert_Dtl_vr1]"
            sqlCmd.Parameters.AddRange(sqlParams)
            numRowsAffected = sqlCmd.ExecuteNonQuery()



        Catch ex As Exception
            Throw ex
        End Try

        Return numRowsAffected

    End Function
#End Region
#Region "Get Challan Details For List Screen"
    Public Function GetChallanDetails(ByVal Unit As String, ByVal Depot As String, ByVal Year As String, ByVal Month As String, ByVal ChalanNo As Integer, ByVal status As String, ByVal UserId As String) As DataSet
        Dim UnitDS As New DataSet
        Dim sqlParams(6) As SqlParameter

        sqlParams(0) = New SqlParameter()
        sqlParams(0).ParameterName = "@desph_desp_unit"
        sqlParams(0).DbType = DbType.String
        sqlParams(0).Direction = Data.ParameterDirection.Input
        sqlParams(0).Value = IIf(Unit <> String.Empty, Unit, DBNull.Value)


        sqlParams(1) = New SqlParameter()
        sqlParams(1).ParameterName = "@desph_desp_depot"
        sqlParams(1).DbType = DbType.String
        sqlParams(1).Direction = Data.ParameterDirection.Input
        sqlParams(1).Value = IIf(Depot <> String.Empty, Depot, DBNull.Value)

        sqlParams(2) = New SqlParameter()
        sqlParams(2).ParameterName = "@desph_challan_fin_year"
        sqlParams(2).DbType = DbType.String
        sqlParams(2).Direction = Data.ParameterDirection.Input
        sqlParams(2).Value = Year

        sqlParams(3) = New SqlParameter()
        sqlParams(3).ParameterName = "@desph_process_month"
        sqlParams(3).DbType = DbType.String
        sqlParams(3).Direction = Data.ParameterDirection.Input
        sqlParams(3).Value = Month

        sqlParams(4) = New SqlParameter()
        sqlParams(4).ParameterName = "@desph_challan_no"
        sqlParams(4).DbType = DbType.Int64
        sqlParams(4).Direction = Data.ParameterDirection.Input
        sqlParams(4).Value = IIf(ChalanNo <> Integer.MinValue, ChalanNo, DBNull.Value)

        sqlParams(5) = New SqlParameter()
        sqlParams(5).ParameterName = "@status"
        sqlParams(5).DbType = DbType.String
        sqlParams(5).Direction = Data.ParameterDirection.Input
        sqlParams(5).Value = status

        sqlParams(6) = New SqlParameter()
        sqlParams(6).ParameterName = "@UserId"
        sqlParams(6).DbType = DbType.String
        sqlParams(6).Direction = Data.ParameterDirection.Input
        sqlParams(6).Value = UserId

        UnitDS = DBFactory.GetHelper().ExecuteDataSet("[Unit_Dspatch_Get_Challan_Detail_vr1]", Data.CommandType.StoredProcedure, sqlParams)
        Return UnitDS
    End Function

    Public Function GetChallanDetails_Vr1(ByVal Unit As String, ByVal Depot As String, ByVal Year As String, ByVal Month As String, ByVal ChalanNo As Integer, ByVal status As String, ByVal UserId As String, ByVal DespatchType As String) As DataSet
        Dim UnitDS As New DataSet
        Dim sqlParams(7) As SqlParameter

        sqlParams(0) = New SqlParameter()
        sqlParams(0).ParameterName = "@desph_desp_unit"
        sqlParams(0).DbType = DbType.String
        sqlParams(0).Direction = Data.ParameterDirection.Input
        sqlParams(0).Value = IIf(Unit <> String.Empty, Unit, DBNull.Value)


        sqlParams(1) = New SqlParameter()
        sqlParams(1).ParameterName = "@desph_desp_depot"
        sqlParams(1).DbType = DbType.String
        sqlParams(1).Direction = Data.ParameterDirection.Input
        sqlParams(1).Value = IIf(Depot <> String.Empty, Depot, DBNull.Value)

        sqlParams(2) = New SqlParameter()
        sqlParams(2).ParameterName = "@desph_challan_fin_year"
        sqlParams(2).DbType = DbType.String
        sqlParams(2).Direction = Data.ParameterDirection.Input
        sqlParams(2).Value = Year

        sqlParams(3) = New SqlParameter()
        sqlParams(3).ParameterName = "@desph_process_month"
        sqlParams(3).DbType = DbType.String
        sqlParams(3).Direction = Data.ParameterDirection.Input
        sqlParams(3).Value = Month

        sqlParams(4) = New SqlParameter()
        sqlParams(4).ParameterName = "@desph_challan_no"
        sqlParams(4).DbType = DbType.Int64
        sqlParams(4).Direction = Data.ParameterDirection.Input
        sqlParams(4).Value = IIf(ChalanNo <> Integer.MinValue, ChalanNo, DBNull.Value)

        sqlParams(5) = New SqlParameter()
        sqlParams(5).ParameterName = "@status"
        sqlParams(5).DbType = DbType.String
        sqlParams(5).Direction = Data.ParameterDirection.Input
        sqlParams(5).Value = status

        sqlParams(6) = New SqlParameter()
        sqlParams(6).ParameterName = "@UserId"
        sqlParams(6).DbType = DbType.String
        sqlParams(6).Direction = Data.ParameterDirection.Input
        sqlParams(6).Value = UserId

        sqlParams(7) = New SqlParameter()
        sqlParams(7).ParameterName = "@desph_type"
        sqlParams(7).DbType = DbType.String
        sqlParams(7).Direction = Data.ParameterDirection.Input
        sqlParams(7).Value = DespatchType

        UnitDS = DBFactory.GetHelper().ExecuteDataSet("[Unit_Dspatch_Get_Challan_Detail_vr3]", Data.CommandType.StoredProcedure, sqlParams)
        Return UnitDS
    End Function

    'Modified-by MUKESH BHAGAT on 11-09-2026 : VendorChallanList grid now shows GRN No, GRN Date and
    'SKU NOP. Same parameters as GetChallanDetails_Vr1; calls the new _vr4 SP which returns the
    'extra columns GRN_No, GRN_Date and sku_nop. _Vr1 / _vr3 are left untouched for other callers.
    Public Function GetChallanDetails_Vr2(ByVal Unit As String, ByVal Depot As String, ByVal Year As String, ByVal Month As String, ByVal ChalanNo As Integer, ByVal status As String, ByVal UserId As String, ByVal DespatchType As String) As DataSet
        Dim UnitDS As New DataSet
        Dim sqlParams(7) As SqlParameter

        sqlParams(0) = New SqlParameter()
        sqlParams(0).ParameterName = "@desph_desp_unit"
        sqlParams(0).DbType = DbType.String
        sqlParams(0).Direction = Data.ParameterDirection.Input
        sqlParams(0).Value = IIf(Unit <> String.Empty, Unit, DBNull.Value)

        sqlParams(1) = New SqlParameter()
        sqlParams(1).ParameterName = "@desph_desp_depot"
        sqlParams(1).DbType = DbType.String
        sqlParams(1).Direction = Data.ParameterDirection.Input
        sqlParams(1).Value = IIf(Depot <> String.Empty, Depot, DBNull.Value)

        sqlParams(2) = New SqlParameter()
        sqlParams(2).ParameterName = "@desph_challan_fin_year"
        sqlParams(2).DbType = DbType.String
        sqlParams(2).Direction = Data.ParameterDirection.Input
        sqlParams(2).Value = Year

        sqlParams(3) = New SqlParameter()
        sqlParams(3).ParameterName = "@desph_process_month"
        sqlParams(3).DbType = DbType.String
        sqlParams(3).Direction = Data.ParameterDirection.Input
        sqlParams(3).Value = Month

        sqlParams(4) = New SqlParameter()
        sqlParams(4).ParameterName = "@desph_challan_no"
        sqlParams(4).DbType = DbType.Int64
        sqlParams(4).Direction = Data.ParameterDirection.Input
        sqlParams(4).Value = IIf(ChalanNo <> Integer.MinValue, ChalanNo, DBNull.Value)

        sqlParams(5) = New SqlParameter()
        sqlParams(5).ParameterName = "@status"
        sqlParams(5).DbType = DbType.String
        sqlParams(5).Direction = Data.ParameterDirection.Input
        sqlParams(5).Value = status

        sqlParams(6) = New SqlParameter()
        sqlParams(6).ParameterName = "@UserId"
        sqlParams(6).DbType = DbType.String
        sqlParams(6).Direction = Data.ParameterDirection.Input
        sqlParams(6).Value = UserId

        sqlParams(7) = New SqlParameter()
        sqlParams(7).ParameterName = "@desph_type"
        sqlParams(7).DbType = DbType.String
        sqlParams(7).Direction = Data.ParameterDirection.Input
        sqlParams(7).Value = DespatchType

        UnitDS = DBFactory.GetHelper().ExecuteDataSet("[Unit_Dspatch_Get_Challan_Detail_vr4]", Data.CommandType.StoredProcedure, sqlParams)
        Return UnitDS
    End Function

#End Region
#Region "Get Document Details"
    Public Function GetDocsDetails(ByVal ChalanNo As Integer) As DataSet
        Dim UnitDS As New DataSet
        Dim sqlParams(0) As SqlParameter

        sqlParams(0) = New SqlParameter()
        sqlParams(0).ParameterName = "@challanid"
        sqlParams(0).DbType = DbType.Int32
        sqlParams(0).Direction = Data.ParameterDirection.Input
        sqlParams(0).Value = ChalanNo

        UnitDS = DBFactory.GetHelper().ExecuteDataSet("[]", Data.CommandType.StoredProcedure, sqlParams)
        Return UnitDS
    End Function

#End Region
    Public Function InsertChallanDocument(ByVal ChallanNo As Int32, ByVal FileName As String, ByVal OrgFileName As String, ByVal Doc_Path As String, ByVal UserId As String, ByVal UnitCode As String, ByVal sqlconn As SqlConnection, ByVal sqltrans As SqlTransaction) As Integer
        Dim NumsRowAffected As New Integer

        Try
            Dim sqlparams(5) As SqlParameter

            sqlparams(0) = New SqlParameter
            sqlparams(0).ParameterName = "@ChallanNo"
            sqlparams(0).DbType = DbType.Int64
            sqlparams(0).Direction = ParameterDirection.Input
            sqlparams(0).Value = ChallanNo

            sqlparams(1) = New SqlParameter
            sqlparams(1).ParameterName = "@FileName"
            sqlparams(1).DbType = DbType.String
            sqlparams(1).Direction = ParameterDirection.Input
            sqlparams(1).Value = FileName

            sqlparams(2) = New SqlParameter
            sqlparams(2).ParameterName = "@OrgFileName"
            sqlparams(2).DbType = DbType.String
            sqlparams(2).Direction = ParameterDirection.Input
            sqlparams(2).Value = OrgFileName

            sqlparams(3) = New SqlParameter
            sqlparams(3).ParameterName = "@Doc_Path"
            sqlparams(3).DbType = DbType.String
            sqlparams(3).Direction = ParameterDirection.Input
            sqlparams(3).Value = Doc_Path

            sqlparams(4) = New SqlParameter
            sqlparams(4).ParameterName = "@UserId"
            sqlparams(4).DbType = DbType.String
            sqlparams(4).Direction = ParameterDirection.Input
            sqlparams(4).Value = UserId

            sqlparams(5) = New SqlParameter
            sqlparams(5).ParameterName = "@UnitCode"
            sqlparams(5).DbType = DbType.String
            sqlparams(5).Direction = ParameterDirection.Input
            sqlparams(5).Value = UnitCode

            Dim sqlcmd As New SqlCommand
            sqlcmd.CommandText = "[challan_entry_insert_doc]"
            sqlcmd.CommandType = CommandType.StoredProcedure
            sqlcmd.Connection = sqlconn
            sqlcmd.Transaction = sqltrans
            sqlcmd.Parameters.AddRange(sqlparams)
            NumsRowAffected = sqlcmd.ExecuteNonQuery
            Return NumsRowAffected
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    'Modified-by MUKESH BHAGAT on 27-08-2026 : depot GSTN for the despatch screen.
    'The GST registration of a depot lives in MSTRDB.dbo.mstr_org (org_code = depot code,
    'column org_gstn_no) - dbo.depot_mstr has no GSTN column. Dedicated SP so the screen
    'does not depend on whichever version of [Get_DepotDetails] a given database carries.
    Public Function GetDepotGstn(ByVal DepotCode As String) As DataSet
        Dim sqlparams(0) As SqlParameter

        sqlparams(0) = New SqlParameter
        sqlparams(0).ParameterName = "@DepotCode"
        sqlparams(0).DbType = DbType.String
        sqlparams(0).Direction = ParameterDirection.Input
        sqlparams(0).Value = DepotCode

        Return DBFactory.GetHelper().ExecuteDataSet("[Get_Depot_Gstn]", Data.CommandType.StoredProcedure, sqlparams)
    End Function

    'Modified-by MUKESH BHAGAT on 26-08-2026 : supplier GSTN for the despatch screen.
    'The GST registration is held against the vendor SITE in RFQDB.MSTR.vendor_site_dtls.
    'Pass the selected site id; when it is 0 the SP falls back to the site mapped to the
    'logged-in user in dbo.user_applicable_site_dtls.
    Public Function GetSupplierGstnBySite(ByVal SiteId As Integer, ByVal UserId As String) As DataSet
        Dim sqlparams(1) As SqlParameter

        sqlparams(0) = New SqlParameter
        sqlparams(0).ParameterName = "@SiteId"
        sqlparams(0).DbType = DbType.Int32
        sqlparams(0).Direction = ParameterDirection.Input
        sqlparams(0).Value = SiteId

        sqlparams(1) = New SqlParameter
        sqlparams(1).ParameterName = "@UserId"
        sqlparams(1).DbType = DbType.String
        sqlparams(1).Direction = ParameterDirection.Input
        sqlparams(1).Value = UserId

        Return DBFactory.GetHelper().ExecuteDataSet("[Get_Supplier_Gstn_By_Site]", Data.CommandType.StoredProcedure, sqlparams)
    End Function

    'Modified-by MUKESH BHAGAT on 26-08-2026 : E-Way bill document support.
    'Writes a typed row (@DocType / @SrlNo) through the same [challan_entry_insert_doc]
    'procedure the invoice copy uses. Deliberately runs on its own connection with NO
    'transaction: the E-Way bill is optional and must never be able to roll back a
    'despatch challan that has already been committed.
    Public Function InsertChallanTypedDocument(ByVal ChallanNo As Int64, ByVal FileName As String, ByVal OrgFileName As String, ByVal Doc_Path As String, ByVal UserId As String, ByVal UnitCode As String, ByVal DocType As String, ByVal SrlNo As Integer) As Integer
        Try
            Dim sqlparams(7) As SqlParameter

            sqlparams(0) = New SqlParameter
            sqlparams(0).ParameterName = "@ChallanNo"
            sqlparams(0).DbType = DbType.Int64
            sqlparams(0).Direction = ParameterDirection.Input
            sqlparams(0).Value = ChallanNo

            sqlparams(1) = New SqlParameter
            sqlparams(1).ParameterName = "@FileName"
            sqlparams(1).DbType = DbType.String
            sqlparams(1).Direction = ParameterDirection.Input
            sqlparams(1).Value = FileName

            sqlparams(2) = New SqlParameter
            sqlparams(2).ParameterName = "@OrgFileName"
            sqlparams(2).DbType = DbType.String
            sqlparams(2).Direction = ParameterDirection.Input
            sqlparams(2).Value = OrgFileName

            sqlparams(3) = New SqlParameter
            sqlparams(3).ParameterName = "@Doc_Path"
            sqlparams(3).DbType = DbType.String
            sqlparams(3).Direction = ParameterDirection.Input
            sqlparams(3).Value = Doc_Path

            sqlparams(4) = New SqlParameter
            sqlparams(4).ParameterName = "@UserId"
            sqlparams(4).DbType = DbType.String
            sqlparams(4).Direction = ParameterDirection.Input
            sqlparams(4).Value = UserId

            sqlparams(5) = New SqlParameter
            sqlparams(5).ParameterName = "@UnitCode"
            sqlparams(5).DbType = DbType.String
            sqlparams(5).Direction = ParameterDirection.Input
            sqlparams(5).Value = UnitCode

            sqlparams(6) = New SqlParameter
            sqlparams(6).ParameterName = "@DocType"
            sqlparams(6).DbType = DbType.String
            sqlparams(6).Direction = ParameterDirection.Input
            sqlparams(6).Value = DocType

            sqlparams(7) = New SqlParameter
            sqlparams(7).ParameterName = "@SrlNo"
            sqlparams(7).DbType = DbType.Int32
            sqlparams(7).Direction = ParameterDirection.Input
            sqlparams(7).Value = SrlNo

            Return DBFactory.GetHelper().ExecuteNonQuery("[challan_entry_insert_doc]", Data.CommandType.StoredProcedure, sqlparams)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    'Modified-by MUKESH BHAGAT on 26-08-2026 : reads back one typed document row so the
    'screen can offer a download link for it.
    Public Function GetChallanTypedDocument(ByVal ChallanNo As Int64, ByVal UnitCode As String, ByVal DocType As String) As DataSet
        Dim sqlparams(2) As SqlParameter

        sqlparams(0) = New SqlParameter
        sqlparams(0).ParameterName = "@ChallanNo"
        sqlparams(0).DbType = DbType.Int64
        sqlparams(0).Direction = ParameterDirection.Input
        sqlparams(0).Value = ChallanNo

        sqlparams(1) = New SqlParameter
        sqlparams(1).ParameterName = "@UnitCode"
        sqlparams(1).DbType = DbType.String
        sqlparams(1).Direction = ParameterDirection.Input
        sqlparams(1).Value = UnitCode

        sqlparams(2) = New SqlParameter
        sqlparams(2).ParameterName = "@DocType"
        sqlparams(2).DbType = DbType.String
        sqlparams(2).Direction = ParameterDirection.Input
        sqlparams(2).Value = DocType

        Return DBFactory.GetHelper().ExecuteDataSet("[challan_entry_get_doc]", Data.CommandType.StoredProcedure, sqlparams)
    End Function

    Public Function GetFinalInvoiceValue() As DataSet
        Dim InvoiceVal As New DataSet
        InvoiceVal = DBFactory.GetHelper().ExecuteDataSet("[Get_Final_Invoice_Value]", Data.CommandType.StoredProcedure)
        Return InvoiceVal
    End Function

    Function InsertDespHeader_Vr1(ByVal sqlConn As SqlConnection, ByVal sqlTrans As SqlTransaction, ByRef DespEntity As DespatchHeaderEntity) As Integer

        Dim numRowsAffected As Integer
        Dim challanNo As Integer
        challanNo = -1

        Try

            'Modified-by MUKESH BHAGAT on 20-08-2026 : restored Indent feature from old UAT source
            Dim sqlParams(25) As SqlParameter

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@desph_desp_unit"
            sqlParams(0).DbType = DbType.String
            sqlParams(0).Direction = Data.ParameterDirection.Input
            sqlParams(0).Value = DespEntity.DespUnit

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@desph_desp_depot"
            sqlParams(1).DbType = DbType.String
            sqlParams(1).Direction = Data.ParameterDirection.Input
            sqlParams(1).Value = DespEntity.DespDepot

            sqlParams(2) = New SqlParameter()
            sqlParams(2).ParameterName = "@desph_challan_fin_year"
            sqlParams(2).DbType = DbType.String
            sqlParams(2).Direction = Data.ParameterDirection.Input
            sqlParams(2).Value = DespEntity.ChallanFinYear

            sqlParams(3) = New SqlParameter()
            sqlParams(3).ParameterName = "@desph_challan_no"
            sqlParams(3).DbType = DbType.Int64
            sqlParams(3).Direction = Data.ParameterDirection.Output

            sqlParams(4) = New SqlParameter()
            sqlParams(4).ParameterName = "@desph_challan_date"
            sqlParams(4).DbType = DbType.DateTime
            sqlParams(4).Direction = Data.ParameterDirection.Input
            sqlParams(4).Value = DespEntity.ChallanDate


            sqlParams(5) = New SqlParameter()
            sqlParams(5).ParameterName = "@desph_total_ltr"
            sqlParams(5).DbType = DbType.Decimal
            sqlParams(5).Direction = Data.ParameterDirection.Input
            sqlParams(5).Value = DespEntity.TotalLtr

            sqlParams(6) = New SqlParameter()
            sqlParams(6).ParameterName = "@desph_total_kg"
            sqlParams(6).DbType = DbType.Decimal
            sqlParams(6).Direction = Data.ParameterDirection.Input
            sqlParams(6).Value = DespEntity.TotalKg

            sqlParams(7) = New SqlParameter()
            sqlParams(7).ParameterName = "@desph_transporter_name"
            sqlParams(7).DbType = DbType.String
            sqlParams(7).Direction = Data.ParameterDirection.Input
            sqlParams(7).Value = DespEntity.TransporterName

            sqlParams(8) = New SqlParameter()
            sqlParams(8).ParameterName = "@desph_truck_no"
            sqlParams(8).DbType = DbType.String
            sqlParams(8).Direction = Data.ParameterDirection.Input
            sqlParams(8).Value = DespEntity.TruckNo

            sqlParams(9) = New SqlParameter()
            sqlParams(9).ParameterName = "@desph_excise_gp_no"
            sqlParams(9).DbType = DbType.String
            sqlParams(9).Direction = Data.ParameterDirection.Input
            sqlParams(9).Value = DespEntity.ExciseGpNo


            sqlParams(10) = New SqlParameter()
            sqlParams(10).ParameterName = "@desph_excise_gp_dt"
            sqlParams(10).DbType = DbType.DateTime
            sqlParams(10).Direction = Data.ParameterDirection.Input
            sqlParams(10).Value = DespEntity.ExciseGpDt

            sqlParams(11) = New SqlParameter()
            sqlParams(11).ParameterName = "@created_user"
            sqlParams(11).DbType = DbType.String
            sqlParams(11).Direction = Data.ParameterDirection.Input
            sqlParams(11).Value = DespEntity.CreatedUser

            sqlParams(12) = New SqlParameter()
            sqlParams(12).ParameterName = "@active"
            sqlParams(12).DbType = DbType.String
            sqlParams(12).Direction = Data.ParameterDirection.Input
            sqlParams(12).Value = DespEntity.ActiveStatus

            sqlParams(13) = New SqlParameter()
            sqlParams(13).ParameterName = "@desph_process_month"
            sqlParams(13).DbType = DbType.String
            sqlParams(13).Direction = Data.ParameterDirection.Input
            sqlParams(13).Value = DespEntity.ProcessMonth

            sqlParams(14) = New SqlParameter()
            sqlParams(14).ParameterName = "@desph_road_permit_no"
            sqlParams(14).DbType = DbType.String
            sqlParams(14).Direction = Data.ParameterDirection.Input
            sqlParams(14).Value = IIf(DespEntity.RoadPermitNo <> String.Empty, DespEntity.RoadPermitNo, DBNull.Value)

            sqlParams(15) = New SqlParameter()
            sqlParams(15).ParameterName = "@desph_po_no"
            sqlParams(15).DbType = DbType.String
            sqlParams(15).Direction = Data.ParameterDirection.Input
            sqlParams(15).Value = DespEntity.po_no

            sqlParams(16) = New SqlParameter()
            sqlParams(16).ParameterName = "@site_name"
            sqlParams(16).DbType = DbType.String
            sqlParams(16).Direction = Data.ParameterDirection.Input
            sqlParams(16).Value = DespEntity.site_name

            sqlParams(17) = New SqlParameter()
            sqlParams(17).ParameterName = "@delivery_depot"
            sqlParams(17).DbType = DbType.String
            sqlParams(17).Direction = Data.ParameterDirection.Input
            sqlParams(17).Value = DespEntity.delivery_depot

            sqlParams(18) = New SqlParameter()
            sqlParams(18).ParameterName = "@desph_site_id"
            sqlParams(18).DbType = DbType.Int64
            sqlParams(18).Direction = Data.ParameterDirection.Input
            sqlParams(18).Value = DespEntity.SiteId

            sqlParams(19) = New SqlParameter()
            sqlParams(19).ParameterName = "@desph_transport_id"
            sqlParams(19).DbType = DbType.Int32
            sqlParams(19).Direction = Data.ParameterDirection.Input
            sqlParams(19).Value = IIf(DespEntity.TranspoterId <> Integer.MinValue, DespEntity.TranspoterId, DBNull.Value)

            sqlParams(20) = New SqlParameter()
            sqlParams(20).ParameterName = "@desph_invoice_value"
            sqlParams(20).DbType = DbType.Decimal
            sqlParams(20).Direction = Data.ParameterDirection.Input
            sqlParams(20).Value = IIf(DespEntity.InvoiceValue <> Decimal.MinValue, DespEntity.InvoiceValue, DBNull.Value)

            sqlParams(21) = New SqlParameter()
            sqlParams(21).ParameterName = "@desph_eway_bill_no"
            sqlParams(21).DbType = DbType.String
            sqlParams(21).Direction = Data.ParameterDirection.Input
            sqlParams(21).Value = IIf(DespEntity.EWayBillNo <> String.Empty, DespEntity.EWayBillNo, DBNull.Value)

            sqlParams(22) = New SqlParameter()
            sqlParams(22).ParameterName = "@desph_eway_bill_dt"
            sqlParams(22).DbType = DbType.DateTime
            sqlParams(22).Direction = Data.ParameterDirection.Input
            sqlParams(22).Value = IIf(DespEntity.EwayBillDt <> SqlDateTime.MinValue, DespEntity.EwayBillDt, DBNull.Value)

            sqlParams(23) = New SqlParameter()
            sqlParams(23).ParameterName = "@desph_valid_upto_dt"
            sqlParams(23).DbType = DbType.DateTime
            sqlParams(23).Direction = Data.ParameterDirection.Input
            sqlParams(23).Value = IIf(DespEntity.ValidUptoDt <> SqlDateTime.MinValue, DespEntity.ValidUptoDt, DBNull.Value)

            'Modified-by MUKESH BHAGAT on 20-08-2026 : restored Indent feature from old UAT source
            sqlParams(24) = New SqlParameter()
            sqlParams(24).ParameterName = "@desph_third_party_indent_yn"
            sqlParams(24).DbType = DbType.String
            sqlParams(24).Direction = Data.ParameterDirection.Input
            sqlParams(24).Value = IIf(DespEntity.ThirdPartyIndentYn <> String.Empty, DespEntity.ThirdPartyIndentYn, DBNull.Value)

            sqlParams(25) = New SqlParameter()
            sqlParams(25).ParameterName = "@desph_third_party_indent"
            sqlParams(25).DbType = DbType.String
            sqlParams(25).Direction = Data.ParameterDirection.Input
            sqlParams(25).Value = IIf(DespEntity.ThirdPartyIndent <> String.Empty, DespEntity.ThirdPartyIndent, DBNull.Value)

            'sqlCmd is the object instance of the SqlCommand
            Dim sqlCmd As New SqlCommand()
            sqlCmd.Connection = sqlConn
            sqlCmd.Transaction = sqlTrans
            sqlCmd.CommandType = CommandType.StoredProcedure
            sqlCmd.CommandText = "[Unit_Dspatch_Insert_Hdr_vr2]"
            sqlCmd.Parameters.AddRange(sqlParams)
            numRowsAffected = sqlCmd.ExecuteNonQuery()

            challanNo = sqlParams(3).Value

        Catch ex As Exception
            Throw ex
        End Try

        Return challanNo

    End Function
    Function UpdateDespHeader_Vr1(ByVal sqlConn As SqlConnection, ByVal sqlTrans As SqlTransaction, ByRef DespEntity As DespatchHeaderEntity) As Integer

        Dim numRowsAffected As Integer
        Try

            Dim sqlParams(23) As SqlParameter

            sqlParams(0) = New SqlParameter()
            sqlParams(0).ParameterName = "@desph_desp_unit"
            sqlParams(0).DbType = DbType.String
            sqlParams(0).Direction = Data.ParameterDirection.Input
            sqlParams(0).Value = DespEntity.DespUnit

            sqlParams(1) = New SqlParameter()
            sqlParams(1).ParameterName = "@desph_desp_depot"
            sqlParams(1).DbType = DbType.String
            sqlParams(1).Direction = Data.ParameterDirection.Input
            sqlParams(1).Value = DespEntity.DespDepot

            sqlParams(2) = New SqlParameter()
            sqlParams(2).ParameterName = "@desph_challan_fin_year"
            sqlParams(2).DbType = DbType.String
            sqlParams(2).Direction = Data.ParameterDirection.Input
            sqlParams(2).Value = DespEntity.ChallanFinYear

            sqlParams(3) = New SqlParameter()
            sqlParams(3).ParameterName = "@desph_challan_no"
            sqlParams(3).DbType = DbType.Int64
            sqlParams(3).Direction = Data.ParameterDirection.Input
            sqlParams(3).Value = DespEntity.ChallanNo

            sqlParams(4) = New SqlParameter()
            sqlParams(4).ParameterName = "@desph_challan_date"
            sqlParams(4).DbType = DbType.DateTime
            sqlParams(4).Direction = Data.ParameterDirection.Input
            sqlParams(4).Value = DespEntity.ChallanDate


            sqlParams(5) = New SqlParameter()
            sqlParams(5).ParameterName = "@desph_total_ltr"
            sqlParams(5).DbType = DbType.Decimal
            sqlParams(5).Direction = Data.ParameterDirection.Input
            sqlParams(5).Value = DespEntity.TotalLtr

            sqlParams(6) = New SqlParameter()
            sqlParams(6).ParameterName = "@desph_total_kg"
            sqlParams(6).DbType = DbType.Decimal
            sqlParams(6).Direction = Data.ParameterDirection.Input
            sqlParams(6).Value = DespEntity.TotalKg

            sqlParams(7) = New SqlParameter()
            sqlParams(7).ParameterName = "@desph_transporter_name"
            sqlParams(7).DbType = DbType.String
            sqlParams(7).Direction = Data.ParameterDirection.Input
            sqlParams(7).Value = DespEntity.TransporterName

            sqlParams(8) = New SqlParameter()
            sqlParams(8).ParameterName = "@desph_truck_no"
            sqlParams(8).DbType = DbType.String
            sqlParams(8).Direction = Data.ParameterDirection.Input
            sqlParams(8).Value = DespEntity.TruckNo

            sqlParams(9) = New SqlParameter()
            sqlParams(9).ParameterName = "@desph_excise_gp_no"
            sqlParams(9).DbType = DbType.String
            sqlParams(9).Direction = Data.ParameterDirection.Input
            sqlParams(9).Value = DespEntity.ExciseGpNo


            sqlParams(10) = New SqlParameter()
            sqlParams(10).ParameterName = "@desph_excise_gp_dt"
            sqlParams(10).DbType = DbType.DateTime
            sqlParams(10).Direction = Data.ParameterDirection.Input
            sqlParams(10).Value = DespEntity.ExciseGpDt

            sqlParams(11) = New SqlParameter()
            sqlParams(11).ParameterName = "@created_user"
            sqlParams(11).DbType = DbType.String
            sqlParams(11).Direction = Data.ParameterDirection.Input
            sqlParams(11).Value = DespEntity.CreatedUser

            sqlParams(12) = New SqlParameter()
            sqlParams(12).ParameterName = "@active"
            sqlParams(12).DbType = DbType.String
            sqlParams(12).Direction = Data.ParameterDirection.Input
            sqlParams(12).Value = DespEntity.ActiveStatus

            sqlParams(13) = New SqlParameter()
            sqlParams(13).ParameterName = "@desph_process_month"
            sqlParams(13).DbType = DbType.String
            sqlParams(13).Direction = Data.ParameterDirection.Input
            sqlParams(13).Value = DespEntity.ProcessMonth

            sqlParams(14) = New SqlParameter()
            sqlParams(14).ParameterName = "@desph_road_permit_no"
            sqlParams(14).DbType = DbType.String
            sqlParams(14).Direction = Data.ParameterDirection.Input
            sqlParams(14).Value = DespEntity.RoadPermitNo

            sqlParams(15) = New SqlParameter()
            sqlParams(15).ParameterName = "@desph_po_no"
            sqlParams(15).DbType = DbType.String
            sqlParams(15).Direction = Data.ParameterDirection.Input
            sqlParams(15).Value = DespEntity.po_no

            sqlParams(16) = New SqlParameter()
            sqlParams(16).ParameterName = "@site_name"
            sqlParams(16).DbType = DbType.String
            sqlParams(16).Direction = Data.ParameterDirection.Input
            sqlParams(16).Value = DespEntity.site_name

            sqlParams(17) = New SqlParameter()
            sqlParams(17).ParameterName = "@delivery_depot"
            sqlParams(17).DbType = DbType.String
            sqlParams(17).Direction = Data.ParameterDirection.Input
            sqlParams(17).Value = DespEntity.delivery_depot

            sqlParams(18) = New SqlParameter()
            sqlParams(18).ParameterName = "@desph_site_id"
            sqlParams(18).DbType = DbType.Int64
            sqlParams(18).Direction = Data.ParameterDirection.Input
            sqlParams(18).Value = DespEntity.SiteId

            sqlParams(19) = New SqlParameter()
            sqlParams(19).ParameterName = "@desph_transport_id"
            sqlParams(19).DbType = DbType.Int32
            sqlParams(19).Direction = Data.ParameterDirection.Input
            sqlParams(19).Value = IIf(DespEntity.TranspoterId <> Integer.MinValue, DespEntity.TranspoterId, DBNull.Value)

            sqlParams(20) = New SqlParameter()
            sqlParams(20).ParameterName = "@desph_invoice_value"
            sqlParams(20).DbType = DbType.Decimal
            sqlParams(20).Direction = Data.ParameterDirection.Input
            sqlParams(20).Value = IIf(DespEntity.InvoiceValue <> Decimal.MinValue, DespEntity.InvoiceValue, DBNull.Value)

            sqlParams(21) = New SqlParameter()
            sqlParams(21).ParameterName = "@desph_eway_bill_no"
            sqlParams(21).DbType = DbType.String
            sqlParams(21).Direction = Data.ParameterDirection.Input
            sqlParams(21).Value = IIf(DespEntity.EWayBillNo <> String.Empty, DespEntity.EWayBillNo, DBNull.Value)

            sqlParams(22) = New SqlParameter()
            sqlParams(22).ParameterName = "@desph_eway_bill_dt"
            sqlParams(22).DbType = DbType.DateTime
            sqlParams(22).Direction = Data.ParameterDirection.Input
            sqlParams(22).Value = IIf(DespEntity.EwayBillDt <> SqlDateTime.MinValue, DespEntity.EwayBillDt, DBNull.Value)

            sqlParams(23) = New SqlParameter()
            sqlParams(23).ParameterName = "@desph_valid_upto_dt"
            sqlParams(23).DbType = DbType.DateTime
            sqlParams(23).Direction = Data.ParameterDirection.Input
            sqlParams(23).Value = IIf(DespEntity.ValidUptoDt <> SqlDateTime.MinValue, DespEntity.ValidUptoDt, DBNull.Value)

            'sqlCmd is the object instance of the SqlCommand 
            Dim sqlCmd As New SqlCommand()
            sqlCmd.Connection = sqlConn
            sqlCmd.Transaction = sqlTrans
            sqlCmd.CommandType = CommandType.StoredProcedure
            sqlCmd.CommandText = "[Unit_Dspatch_Update_Hdr_vr2]"
            sqlCmd.Parameters.AddRange(sqlParams)
            numRowsAffected = sqlCmd.ExecuteNonQuery()

        Catch ex As Exception
            Throw ex
        End Try

        Return numRowsAffected

    End Function
    Public Function InsertInvoiceDocument(ByVal IndentNo As Int32, ByVal FileName As String, ByVal Doc_Path As String, ByVal UserId As String, ByVal DepotCode As String, ByVal FinYear As String, ByVal DocMonth As String, ByVal sqlconn As SqlConnection, ByVal sqltrans As SqlTransaction) As Integer
        Dim NumsRowAffected As New Integer

        Try
            Dim sqlparams(6) As SqlParameter

            sqlparams(0) = New SqlParameter
            sqlparams(0).ParameterName = "@IndentNo"
            sqlparams(0).DbType = DbType.Int64
            sqlparams(0).Direction = ParameterDirection.Input
            sqlparams(0).Value = IndentNo

            sqlparams(1) = New SqlParameter
            sqlparams(1).ParameterName = "@FileName"
            sqlparams(1).DbType = DbType.String
            sqlparams(1).Direction = ParameterDirection.Input
            sqlparams(1).Value = FileName

            sqlparams(2) = New SqlParameter
            sqlparams(2).ParameterName = "@Doc_Path"
            sqlparams(2).DbType = DbType.String
            sqlparams(2).Direction = ParameterDirection.Input
            sqlparams(2).Value = Doc_Path

            sqlparams(3) = New SqlParameter
            sqlparams(3).ParameterName = "@UserId"
            sqlparams(3).DbType = DbType.String
            sqlparams(3).Direction = ParameterDirection.Input
            sqlparams(3).Value = UserId

            sqlparams(4) = New SqlParameter
            sqlparams(4).ParameterName = "@DepotCode"
            sqlparams(4).DbType = DbType.String
            sqlparams(4).Direction = ParameterDirection.Input
            sqlparams(4).Value = DepotCode

            sqlparams(5) = New SqlParameter
            sqlparams(5).ParameterName = "@FinYear"
            sqlparams(5).DbType = DbType.String
            sqlparams(5).Direction = ParameterDirection.Input
            sqlparams(5).Value = FinYear

            sqlparams(6) = New SqlParameter
            sqlparams(6).ParameterName = "@DocMonth"
            sqlparams(6).DbType = DbType.String
            sqlparams(6).Direction = ParameterDirection.Input
            sqlparams(6).Value = DocMonth

            Dim sqlcmd As New SqlCommand
            sqlcmd.CommandText = "[dbo].[Indent_entry_insert_invoice_doc]"
            sqlcmd.CommandType = CommandType.StoredProcedure
            sqlcmd.Connection = sqlconn
            sqlcmd.Transaction = sqltrans
            sqlcmd.Parameters.AddRange(sqlparams)
            NumsRowAffected = sqlcmd.ExecuteNonQuery
            Return NumsRowAffected
        Catch ex As Exception
            Throw ex
        End Try
    End Function
End Class
