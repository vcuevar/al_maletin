--Ejemplo del uso del Having Regresa del Select solo los de la condicion
select ITT1.Father as PT, o1.ItemName as Modelo, ITT1.Code as Codigo, o2.ItemName as Descripcion, count(Code) as repetido
from dbo.ITT1
left join OITM o1 on o1.ItemCode = Father
left join OITM o2 on o2.ItemCode = Code
--where Father = 'ZAR0707'
group by Father, Code, o1.ItemName, o2.ItemName
having count(Code) > 1
Se usa en lugar del Where cuando inplican comparacion de Grupo SUM, MAX, COUNT etc

--Funciones para Excel
' Modulo de Herramientas de las Macros.
' Ing. Vicente Cueva Ramirez.
' Actualizado: Sabado 18 de Agosto del 2018

Public Sub CONEXION()
    ' Abrir la Base de Datos usando las credenciales de Windows.
    cnn.ConnectionTimeout = 200
    cnn.CommandTimeout = 0
    cnn.Open "Provider=sqloledb;" & _
    "Data Source=win-u0omr306d55\sqlexpress;" & _
    "Initial Catalog=iteknia;" & _
    "User Id=sa;Password=C4224a"
End Sub
Public Sub TEMPO_CONEXION()
    ' Abrir la Base de Datos usando las credenciales de Windows.
    cnn.ConnectionTimeout = 200
    cnn.CommandTimeout = 0
    cnn.Open "Provider=sqloledb;" & _
    "Data Source=SAPSOPORTE\SQLEXPRESS;" & _
    "Initial Catalog=itekniaLoc;" & _
    "User Id=sa;Password=V1k0"
End Sub

Public Sub CONEXIONCOM()
    ' Abrir la Base de Datos usando las credenciales de Windows.
    cnn.ConnectionTimeout = 200
    cnn.CommandTimeout = 0
    cnn.Open "Provider=sqloledb;" & _
    "Data Source=win-u0omr306d55\sqlexpress;" & _
    "Initial Catalog=comercializadora;" & _
    "User Id=sa;Password=C4224a"
End Sub

Public Sub PIDE_FECHA_IF()
' Solicita las fechas del reporte.
On Error GoTo error
    FechaI = InputBox("Fecha Inicial: " & Chr(13) & Chr(13) & Chr(13) & "Formato: dd/mm/aaaa ", "Producción de A. Costura", CDate(Date))
    FechaF = InputBox("Fecha Final: " & Chr(13) & Chr(13) & Chr(13) & "Formato: dd/mm/aaaa ", "Producción de A. Costura", CDate(Date))
    Exit Sub
error:
     MsgBox "FECHA INCORRECTA...", vbOKOnly, "Robot BEV 1."
     Exit Sub
End Sub


'  FechaI = InputBox("Fecha Inicial", "Fecha Inicial", Date)
'    FechaF = InputBox("Fecha Final", "Fecha Final", Date)

' Poner o Quitar los Filtros. Posicionar en Primer Celda del Encabezado
' debe tener el listado corrido si espacios en primer columna.
Public Sub PONQUITAFILTRO()
    Range(Selection, Selection.End(xlToRight)).Select
    Range(Selection, Selection.End(xlDown)).Select
    Selection.AutoFilter
End Sub
' Borra los datos anteriores de la Hoja
Public Sub LIMPIA_HOJA3()
    Hoja3.Activate
    Range("A7:X2000").Select
    Selection.ClearContents
    PINTABLANCO
    Range("B7").Select
End Sub
' Borra los datos anteriores de la Hoja
Public Sub LIMPIA_HOJA4()
    Hoja4.Activate
    Range("A7:L2000").Select
    Selection.ClearContents
    PINTABLANCO
    Range("B7").Select
End Sub

' Pinta en Color Blanco el Fondo Previo Rango Seleccionado.
Public Sub PINTABLANCO()
  With Selection.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .ThemeColor = xlThemeColorDark1
        .TintAndShade = 0
        .PatternTintAndShade = 0
    End With
End Sub
' Cambia Nombre del Mes en Ingles a Español.
Public Sub CAMB_MES()

Select Case NOM_MES

Case "JANUARY"
    NOM_MES = "ENERO"
Case "FEBRUARY"
    NOM_MES = "FEBRERO"
Case "MARCH"
    NOM_MES = "MARZO"
Case "APRIL"
    NOM_MES = "ABRIL"
Case "JUNE"
    NOM_MES = "JUNIO"
Case "JULY"
    NOM_MES = "JULIO"
Case "AUGUST"
    NOM_MES = "AGOSTO"
Case "SEPTEMBER"
    NOM_MES = "SEPTIEMBRE"
Case "OCTOBER"
    NOM_MES = "OCTUBRE"
Case "NOVEMBER"
    NOM_MES = "NOVIEMBRE"
Case "DECEMBER"
    NOM_MES = "DICIEMBRE"
Case Else
    NOM_MES = "FALTA " + NOM_MES
End Select

End Sub



' Para validar.

Sub SubTitulo()

With Selection
    .HorizontalAlignment = xlLeft
    .VerticalAlignment = xlBottom
    .WrapText = False
    .Orientation = 0
    .AddIndent = False
    .IndentLevel = 0
    .ShrinkToFit = False
    .ReadingOrder = xlContext
    .MergeCells = False
End With
With Selection.Font
    .Name = "Arial"
    .Size = 16
    .Strikethrough = False
    .Superscript = False
    .Subscript = False
    .OutlineFont = False
    .Shadow = False
    .Underline = xlUnderlineStyleNone
    .ColorIndex = xlAutomatic
    .TintAndShade = 0
    .ThemeFont = xlThemeFontNone
End With
Selection.Font.Bold = True

End Sub


Sub NombresR()

With Selection.Interior
    .Pattern = xlSolid
    .PatternColorIndex = xlAutomatic
    .Color = 16764159
    .TintAndShade = 0
    .PatternTintAndShade = 0
End With
With Selection.Font
    .Name = "Arial"
    .Size = 12
    .Strikethrough = False
    .Superscript = False
    .Subscript = False
    .OutlineFont = False
    .Shadow = False
    .Underline = xlUnderlineStyleNone
    .Color = -3407872
    .TintAndShade = 0
    .ThemeFont = xlThemeFontNone
End With
With Selection
    .HorizontalAlignment = xlCenter
    .VerticalAlignment = xlBottom
    .WrapText = False
    .Orientation = 0
    .AddIndent = False
    .IndentLevel = 0
    .ShrinkToFit = False
    .ReadingOrder = xlContext
    .MergeCells = False
End With
Selection.Font.Bold = True
End Sub
Sub IniciaLimpio()
'
' Dejar Seleccion con Formato Nuevo.
    With Selection.Font
        .Name = "Arial"
        .Strikethrough = False
        .Superscript = False
        .Subscript = False
        .OutlineFont = False
        .Shadow = False
        .Underline = xlUnderlineStyleNone
        .TintAndShade = 0
        .ThemeFont = xlThemeFontNone
    End With
    With Selection.Font
        .Name = "Arial"
        .Size = 12
        .Strikethrough = False
        .Superscript = False
        .Subscript = False
        .OutlineFont = False
        .Shadow = False
        .Underline = xlUnderlineStyleNone
        .TintAndShade = 0
        .ThemeFont = xlThemeFontNone
    End With
    With Selection
        .HorizontalAlignment = xlLeft
        .WrapText = False
        .Orientation = 0
        .AddIndent = False
        .IndentLevel = 0
        .ShrinkToFit = False
        .ReadingOrder = xlContext
        .MergeCells = False
    End With
    With Selection.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .ThemeColor = xlThemeColorDark1
        .TintAndShade = 0
        .PatternTintAndShade = 0
    End With
    With Selection.Font
        .ColorIndex = xlAutomatic
        .TintAndShade = 0
    End With
    Selection.Font.Bold = False
End Sub




Private Sub Formato_Linea(LL)
' Dar Formato a la Linea de Datos del Resumen de Tapiceria.
' Celda de la Semana.
    Range("A" & LL).Select
    Selection.Borders(xlDiagonalDown).LineStyle = xlNone
    Selection.Borders(xlDiagonalUp).LineStyle = xlNone
    With Selection.Borders(xlEdgeLeft)
        .LineStyle = xlDot
        .ThemeColor = 4
        .TintAndShade = 0.599963377788629
        .Weight = xlThin
    End With
    With Selection.Borders(xlEdgeTop)
        .LineStyle = xlDot
        .ThemeColor = 4
        .TintAndShade = 0.599963377788629
        .Weight = xlThin
    End With
    With Selection.Borders(xlEdgeBottom)
        .LineStyle = xlDot
        .ThemeColor = 4
        .TintAndShade = 0.599963377788629
        .Weight = xlThin
    End With
    With Selection.Borders(xlEdgeRight)
        .LineStyle = xlDot
        .ThemeColor = 4
        .TintAndShade = 0.599963377788629
        .Weight = xlThin
    End With
    Selection.Borders(xlInsideVertical).LineStyle = xlNone
    Selection.Borders(xlInsideHorizontal).LineStyle = xlNone
    With Selection
        .HorizontalAlignment = xlCenter
        .VerticalAlignment = xlBottom
        .WrapText = False
        .Orientation = 0
        .AddIndent = False
        .IndentLevel = 0
        .ShrinkToFit = False
        .ReadingOrder = xlContext
        .MergeCells = False
    End With
    Selection.Font.Bold = False
    With Selection.Font
        .Name = "Arial"
        .Size = 12
        .Strikethrough = False
        .Superscript = False
        .Subscript = False
        .OutlineFont = False
        .Shadow = False
        .Underline = xlUnderlineStyleNone
        .ThemeColor = xlThemeColorLight1
        .TintAndShade = 0
        .ThemeFont = xlThemeFontNone
    End With
    ' Azul 3
    With Selection.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .ThemeColor = xlThemeColorAccent1
        .TintAndShade = 0.399975585192419
        .PatternTintAndShade = 0
    End With

' Celda del Numero de Dia.
    Range("B" & LL).Select
    Selection.Borders(xlDiagonalDown).LineStyle = xlNone
    Selection.Borders(xlDiagonalUp).LineStyle = xlNone
    With Selection.Borders(xlEdgeLeft)
        .LineStyle = xlDot
        .ThemeColor = 4
        .TintAndShade = 0.599963377788629
        .Weight = xlThin
    End With
    With Selection.Borders(xlEdgeTop)
        .LineStyle = xlDot
        .ThemeColor = 4
        .TintAndShade = 0.599963377788629
        .Weight = xlThin
    End With
    With Selection.Borders(xlEdgeBottom)
        .LineStyle = xlDot
        .ThemeColor = 4
        .TintAndShade = 0.599963377788629
        .Weight = xlThin
    End With
    With Selection.Borders(xlEdgeRight)
        .LineStyle = xlDot
        .ThemeColor = 4
        .TintAndShade = 0.599963377788629
        .Weight = xlThin
    End With
    Selection.Borders(xlInsideVertical).LineStyle = xlNone
    Selection.Borders(xlInsideHorizontal).LineStyle = xlNone
      Selection.Font.Bold = False
    With Selection.Font
        .Name = "Arial"
        .Size = 12
        .Strikethrough = False
        .Superscript = False
        .Subscript = False
        .OutlineFont = False
        .Shadow = False
        .Underline = xlUnderlineStyleNone
        .ThemeColor = xlThemeColorLight1
        .TintAndShade = 0
        .ThemeFont = xlThemeFontNone
    End With
    With Selection
        .HorizontalAlignment = xlCenter
        .VerticalAlignment = xlBottom
        .WrapText = False
        .Orientation = 0
        .AddIndent = False
        .IndentLevel = 0
        .ShrinkToFit = False
        .ReadingOrder = xlContext
        .MergeCells = False
    End With
     ' Azul 2
    With Selection.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .ThemeColor = xlThemeColorAccent1
        .TintAndShade = 0.599993896298105
        .PatternTintAndShade = 0
    End With

' Celda de la Fecha.
Range("C" & LL).Select
    Selection.Borders(xlDiagonalDown).LineStyle = xlNone
    Selection.Borders(xlDiagonalUp).LineStyle = xlNone
    With Selection.Borders(xlEdgeLeft)
        .LineStyle = xlDot
        .ThemeColor = 4
        .TintAndShade = 0.599963377788629
        .Weight = xlThin
    End With
    With Selection.Borders(xlEdgeTop)
        .LineStyle = xlDot
        .ThemeColor = 4
        .TintAndShade = 0.599963377788629
        .Weight = xlThin
    End With
    With Selection.Borders(xlEdgeBottom)
        .LineStyle = xlDot
        .ThemeColor = 4
        .TintAndShade = 0.599963377788629
        .Weight = xlThin
    End With
    With Selection.Borders(xlEdgeRight)
        .LineStyle = xlDot
        .ThemeColor = 4
        .TintAndShade = 0.599963377788629
        .Weight = xlThin
    End With
    Selection.Borders(xlInsideVertical).LineStyle = xlNone
    Selection.Borders(xlInsideHorizontal).LineStyle = xlNone
    Selection.Font.Bold = False
    With Selection.Font
        .Name = "Arial"
        .Size = 12
        .Strikethrough = False
        .Superscript = False
        .Subscript = False
        .OutlineFont = False
        .Shadow = False
        .Underline = xlUnderlineStyleNone
        .ThemeColor = xlThemeColorLight1
        .TintAndShade = 0
        .ThemeFont = xlThemeFontNone
    End With
    Selection.NumberFormat = "ddd-dd-mmm"
    With Selection
        .HorizontalAlignment = xlCenter
        .VerticalAlignment = xlBottom
        .WrapText = False
        .Orientation = 0
        .AddIndent = False
        .IndentLevel = 0
        .ShrinkToFit = False
        .ReadingOrder = xlContext
        .MergeCells = False
    End With
    
'Celdas de Numeros
Range("D" & LL).Select
    Selection.Borders(xlDiagonalDown).LineStyle = xlNone
    Selection.Borders(xlDiagonalUp).LineStyle = xlNone
    With Selection.Borders(xlEdgeLeft)
        .LineStyle = xlDot
        .ThemeColor = 4
        .TintAndShade = 0.599963377788629
        .Weight = xlThin
    End With
    With Selection.Borders(xlEdgeTop)
        .LineStyle = xlDot
        .ThemeColor = 4
        .TintAndShade = 0.599963377788629
        .Weight = xlThin
    End With
    With Selection.Borders(xlEdgeBottom)
        .LineStyle = xlDot
        .ThemeColor = 4
        .TintAndShade = 0.599963377788629
        .Weight = xlThin
    End With
    With Selection.Borders(xlEdgeRight)
        .LineStyle = xlDot
        .ThemeColor = 4
        .TintAndShade = 0.599963377788629
        .Weight = xlThin
    End With
    Selection.Borders(xlInsideVertical).LineStyle = xlNone
    Selection.Borders(xlInsideHorizontal).LineStyle = xlNone
    Selection.Font.Bold = False
    With Selection.Font
        .Name = "Arial"
        .Size = 12
        .Strikethrough = False
        .Superscript = False
        .Subscript = False
        .OutlineFont = False
        .Shadow = False
        .Underline = xlUnderlineStyleNone
        .ThemeColor = xlThemeColorLight1
        .TintAndShade = 0
        .ThemeFont = xlThemeFontNone
    End With
    With Selection
        .HorizontalAlignment = xlCenter
        .VerticalAlignment = xlBottom
        .WrapText = False
        .Orientation = 0
        .AddIndent = False
        .IndentLevel = 0
        .ShrinkToFit = False
        .ReadingOrder = xlContext
        .MergeCells = False
    End With
    Selection.NumberFormat = "#,##0.00_ ;[Red]-#,##0.00 "
    
    'Llenar mismo formato de Numero.
    Range("D" & LL).Select
    Selection.Copy
    Range("E" & LL & ":" & "Q" & LL).Select
    'Range(Selection, Selection.End(xlToRight)).Select
    Selection.PasteSpecial Paste:=xlPasteFormats, Operation:=xlNone, _
        SkipBlanks:=False, Transpose:=False
    Application.CutCopyMode = False
    
    ' Alto de Celda ponerlo en 30
    Rows(LL).Select
    Selection.RowHeight = 30
    ' Centrar en forma vertical todo el renglon selecciondo
    With Selection
        .VerticalAlignment = xlCenter
        .WrapText = False
        .Orientation = 0
        .AddIndent = False
        .IndentLevel = 0
        .ShrinkToFit = False
        .ReadingOrder = xlContext
        .MergeCells = False
    End With
End Sub
Private Sub Formato_Blanco(LL)
    Rows(LL).Select
    Selection.RowHeight = 8
End Sub
Private Sub Formato_Total(LL)
    'Celda del Titulo Total en Azul fuerte.
    Range("A" & LL).Select
    With Selection.Font
        .Name = "Arial"
        .Size = 12
        .Strikethrough = False
        .Superscript = False
        .Subscript = False
        .OutlineFont = False
        .Shadow = False
        .Underline = xlUnderlineStyleNone
        .ThemeColor = xlThemeColorLight1
        .TintAndShade = 0
        .ThemeFont = xlThemeFontNone
    End With
    Selection.Font.Bold = True
    With Selection.Font
        .ThemeColor = xlThemeColorDark1
        .TintAndShade = 0
    End With
    With Selection.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .ThemeColor = xlThemeColorAccent1
        .TintAndShade = -0.249977111117893
        .PatternTintAndShade = 0
    End With
    Selection.Borders(xlDiagonalDown).LineStyle = xlNone
    Selection.Borders(xlDiagonalUp).LineStyle = xlNone
    With Selection.Borders(xlEdgeLeft)
        .LineStyle = xlContinuous
        .ThemeColor = 5
        .TintAndShade = -0.249946592608417
        .Weight = xlMedium
    End With
    With Selection.Borders(xlEdgeTop)
        .LineStyle = xlContinuous
        .ThemeColor = 5
        .TintAndShade = -0.249946592608417
        .Weight = xlMedium
    End With
    With Selection.Borders(xlEdgeBottom)
        .LineStyle = xlContinuous
        .ThemeColor = 5
        .TintAndShade = -0.249946592608417
        .Weight = xlMedium
    End With
    With Selection.Borders(xlEdgeRight)
        .LineStyle = xlContinuous
        .ThemeColor = 5
        .TintAndShade = -0.249946592608417
        .Weight = xlMedium
    End With
    Selection.Borders(xlInsideVertical).LineStyle = xlNone
    Selection.Borders(xlInsideHorizontal).LineStyle = xlNone
    
    Range("B" & LL).Select
    With Selection.Font
        .Name = "Arial"
        .Size = 12
        .Strikethrough = False
        .Superscript = False
        .Subscript = False
        .OutlineFont = False
        .Shadow = False
        .Underline = xlUnderlineStyleNone
        .ThemeColor = xlThemeColorLight1
        .TintAndShade = 0
        .ThemeFont = xlThemeFontNone
    End With
    Selection.Font.Bold = True
    With Selection.Font
        .ThemeColor = xlThemeColorDark1
        .TintAndShade = 0
    End With
    With Selection.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .ThemeColor = xlThemeColorAccent1
        .TintAndShade = -0.249977111117893
        .PatternTintAndShade = 0
    End With
    Selection.Borders(xlDiagonalDown).LineStyle = xlNone
    Selection.Borders(xlDiagonalUp).LineStyle = xlNone
    With Selection.Borders(xlEdgeLeft)
        .LineStyle = xlContinuous
        .ThemeColor = 5
        .TintAndShade = -0.249946592608417
        .Weight = xlMedium
    End With
    With Selection.Borders(xlEdgeTop)
        .LineStyle = xlContinuous
        .ThemeColor = 5
        .TintAndShade = -0.249946592608417
        .Weight = xlMedium
    End With
    With Selection.Borders(xlEdgeBottom)
        .LineStyle = xlContinuous
        .ThemeColor = 5
        .TintAndShade = -0.249946592608417
        .Weight = xlMedium
    End With
    With Selection.Borders(xlEdgeRight)
        .LineStyle = xlContinuous
        .ThemeColor = 5
        .TintAndShade = -0.249946592608417
        .Weight = xlMedium
    End With
    Selection.Borders(xlInsideVertical).LineStyle = xlNone
    Selection.Borders(xlInsideHorizontal).LineStyle = xlNone
    
    Range("C" & LL).Select
    With Selection.Font
        .Name = "Arial"
        .Size = 12
        .Strikethrough = False
        .Superscript = False
        .Subscript = False
        .OutlineFont = False
        .Shadow = False
        .Underline = xlUnderlineStyleNone
        .ThemeColor = xlThemeColorLight1
        .TintAndShade = 0
        .ThemeFont = xlThemeFontNone
    End With
    Selection.Font.Bold = True
    With Selection.Font
        .ThemeColor = xlThemeColorDark1
        .TintAndShade = 0
    End With
    With Selection.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .ThemeColor = xlThemeColorAccent1
        .TintAndShade = -0.249977111117893
        .PatternTintAndShade = 0
    End With
    Selection.Borders(xlDiagonalDown).LineStyle = xlNone
    Selection.Borders(xlDiagonalUp).LineStyle = xlNone
    With Selection.Borders(xlEdgeLeft)
        .LineStyle = xlContinuous
        .ThemeColor = 5
        .TintAndShade = -0.249946592608417
        .Weight = xlMedium
    End With
    With Selection.Borders(xlEdgeTop)
        .LineStyle = xlContinuous
        .ThemeColor = 5
        .TintAndShade = -0.249946592608417
        .Weight = xlMedium
    End With
    With Selection.Borders(xlEdgeBottom)
        .LineStyle = xlContinuous
        .ThemeColor = 5
        .TintAndShade = -0.249946592608417
        .Weight = xlMedium
    End With
    With Selection.Borders(xlEdgeRight)
        .LineStyle = xlContinuous
        .ThemeColor = 5
        .TintAndShade = -0.249946592608417
        .Weight = xlMedium
    End With
    Selection.Borders(xlInsideVertical).LineStyle = xlNone
    Selection.Borders(xlInsideHorizontal).LineStyle = xlNone
    
    ' Formato de los Totales
    Range("D" & LL).Select
    Range(Selection, Selection.End(xlToRight)).Select
    With Selection.Font
        .Name = "Arial"
        .Size = 12
        .Strikethrough = False
        .Superscript = False
        .Subscript = False
        .OutlineFont = False
        .Shadow = False
        .Underline = xlUnderlineStyleNone
        .ThemeColor = xlThemeColorLight1
        .TintAndShade = 0
        .ThemeFont = xlThemeFontNone
    End With
    Selection.Font.Bold = True
    Selection.NumberFormat = "#,##0.00_ ;[Red]-#,##0.00 "
    
    ' Poner Marcos en Azul
    Selection.Borders(xlDiagonalDown).LineStyle = xlNone
    Selection.Borders(xlDiagonalUp).LineStyle = xlNone
    With Selection.Borders(xlEdgeLeft)
        .LineStyle = xlDot
        .ThemeColor = 5
        .TintAndShade = -0.249946592608417
        .Weight = xlThin
    End With
    With Selection.Borders(xlEdgeTop)
        .LineStyle = xlDouble
        .ThemeColor = 5
        .TintAndShade = -0.249946592608417
        .Weight = xlThick
    End With
    With Selection.Borders(xlEdgeBottom)
        .LineStyle = xlContinuous
        .ThemeColor = 5
        .TintAndShade = -0.249946592608417
        .Weight = xlThin
    End With
    With Selection.Borders(xlEdgeRight)
        .LineStyle = xlDot
        .ThemeColor = 5
        .TintAndShade = -0.249946592608417
        .Weight = xlThin
    End With
    With Selection.Borders(xlInsideVertical)
        .LineStyle = xlDot
        .ThemeColor = 5
        .TintAndShade = -0.249946592608417
        .Weight = xlThin
    End With
    Selection.Borders(xlInsideHorizontal).LineStyle = xlNone
    Selection.RowHeight = 30
End Sub

Public Function SINULO(VALOR)
    If IsNull(VALOR) Then
        SINULO = 0
    Else
        SINULO = VALOR
    End If
End Function

Public Function SINULS(VALOR)
    If IsNull(VALOR) Then
        SINULS = "S/P"
    Else
        SINULS = VALOR
    End If
End Function



