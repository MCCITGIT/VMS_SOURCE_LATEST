Imports System.IO
Imports System.Text.RegularExpressions

''' <summary>
''' Author: MUKESH BHAGAT  Created: 16-10-2026
''' Makes an uploaded file name safe BEFORE it is stored, so a download can never break on it again.
''' Background: a challan invoice named "1050, SURAT.pdf" could not be downloaded - the comma (and spaces,
''' quotes, ; # % &amp; etc.) break the Content-Disposition header and some names are not valid on disk at all.
''' Rule: keep letters, digits, dot, dash and underscore; everything else (spaces included) becomes "_";
''' runs of "_" are collapsed; the base is capped at 80 characters; the extension is kept in lower case.
'''   "1050, SURAT.pdf"                 -> "1050_SURAT.pdf"
'''   "BGP ORIGINAL BILL.NO.KTH-25.jpg" -> "BGP_ORIGINAL_BILL.NO.KTH-25.jpg"
''' With unique:=True an 8-character suffix is added ("1050_SURAT_3f9a1c7e.pdf") so two vendors uploading
''' the same name on the same day never overwrite each other.
''' </summary>
Public Module UploadFileName

    Private ReadOnly Unsafe As New Regex("[^A-Za-z0-9._-]+", RegexOptions.Compiled)
    Private ReadOnly MultiUnderscore As New Regex("_{2,}", RegexOptions.Compiled)

    Public Function SafeFileName(ByVal originalName As String, Optional ByVal unique As Boolean = False) As String
        Dim name As String = Path.GetFileName(If(originalName, "")).Trim()
        Dim ext As String = Path.GetExtension(name).ToLowerInvariant()
        Dim base As String = If(ext = "", name, name.Substring(0, name.Length - ext.Length))

        base = Unsafe.Replace(base, "_")
        base = MultiUnderscore.Replace(base, "_").Trim("_"c, "."c, "-"c)
        ext = Unsafe.Replace(ext, "")                      ' ".pdf" stays ".pdf"; odd characters in the extension are dropped
        If base = "" Then base = "file"
        If base.Length > 80 Then base = base.Substring(0, 80).TrimEnd("_"c, "."c, "-"c)
        If unique Then base &= "_" & Guid.NewGuid().ToString("N").Substring(0, 8)
        Return base & ext
    End Function

    ''' <summary>True when the name would be changed by SafeFileName - for a warning before upload.</summary>
    Public Function NeedsCleaning(ByVal originalName As String) As Boolean
        Return Not String.Equals(Path.GetFileName(If(originalName, "")).Trim(), SafeFileName(originalName), StringComparison.Ordinal)
    End Function
End Module
