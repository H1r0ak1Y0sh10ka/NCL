; This file is Draw Configuration.
; Hiroaki Yoshioka(yoshioka@dpac.kyoto-u.ac.jp)
; History:
; 05/05/2018 - 1st released
; 12/19/2018 - 2nd released
; 08/03/2020 - 3rd released 
; ====================================================================================================

undef ( "Config_wind_curlvector" )
procedure Config_wind_curlvector (  \
  RES[*]           : logical \
  )
local none
begin


RES@vcGlyphStyle              = "CurlyVector"
RES@vcFillArrowsOn            = True
;RES@vcFillArrowEdgeColor     = "black"
RES@vcFillArrowEdgeColor      = "white"
RES@vcLineArrowThicknessF     = 5
RES@vcFillArrowEdgeThicknessF = 8.0
RES@vcMinDistanceF            = 0.017

RES@vcRefLengthF             = 0.02
RES@vcRefMagnitudeF          = 20 
RES@vcRefAnnoString1         = "20"
RES@vcRefAnnoSide            = "Left"
RES@vcRefAnnoString2On       = False
RES@vcRefAnnoPerimOn         = False
RES@vcRefAnnoOrthogonalPosF   =  -0.075
RES@vcRefAnnoBackgroundColor  = "plum1"

end

undef ( "Config_vr_vector" )
procedure Config_vr_vector (  \
  RES[*]           : logical \
  )
local none
begin

RES@vcGlyphStyle              = "FillArrow"
RES@vcFillArrowsOn            = True
;RES@vcFillArrowEdgeColor     = "black"
RES@vcFillArrowEdgeColor      = "white"
RES@vcLineArrowThicknessF     = 5
RES@vcFillArrowEdgeThicknessF = 8.0
RES@vcMinDistanceF            = 0.0001

RES@vcRefLengthF             = 0.06
RES@vcRefMagnitudeF          = 10 
RES@vcRefAnnoString1         = "10"
RES@vcRefAnnoSide            = "Left"
RES@vcRefAnnoString2On       = False
RES@vcRefAnnoPerimOn         = False
RES@vcRefAnnoOrthogonalPosF   =  -0.075
RES@vcRefAnnoBackgroundColor  = "plum1"

end

undef ( "Config_vt_contour" )
procedure Config_vt_contour (  \
  RES[*]           : logical \
  )
local none
begin

RES@cnLineColor                   = "black"                ; Set the line color
RES@cnInfoLabelOn                 = False
RES@cnLineThicknessF              =  12
RES@gsnContourNegLineDashPattern  = 1                      ; sets negative contours to dash pattern 1
RES@cnLineLabelInterval           = 1                      ; default = 2
RES@cnLineLabelFontHeightF        = 0.025

RES@cnLevelSelectionMode          = "ManualLevels"         ; set manual contour levels
RES@cnMinLevelValF                =       5                ; set min contour level
RES@cnMaxLevelValF                =      55                ; set max contour level
RES@cnLevelSpacingF               =       5                ; set contour spacing

end

undef ( "Config_vtvgano_shade" )
procedure Config_vtvgano_shade (  \
  RES[*]           : logical \
  )
local none
begin

RES@cnFillOn             = True                   ; turn on color
RES@lbLabelAutoStride    = True                   ; nice label bar labels
RES@cnLinesOn            = False                  ; no contour lines

RES@lbOrientation        = "vertical"
RES@lbTitlePosition      = "Right"                           ; title location
RES@lbTitleDirection     = "Across"                          ; letter angle
RES@lbTitleAngleF        = 90.                               ; title angle
RES@lbTitleFontHeightF   = 0.025                             ; font height

RES@cnFillPalette        = "cmp_flux"
;RES@cnFillOpacityF       = 0.75 
RES@cnLevelSelectionMode = "ManualLevels"       ; set manual contour levels
RES@cnMinLevelValF       =     -5           ; set min contour level
RES@cnMaxLevelValF       =      5           ; set max contour level
RES@cnLevelSpacingF      =      1          ; set contour spacing

end

undef ( "Config_vtvganoDiff_shade" )
procedure Config_vtvganoDiff_shade (  \
  RES[*]           : logical \
  )
local none
begin

RES@cnFillOn             = True                   ; turn on color
RES@lbLabelAutoStride    = True                   ; nice label bar labels
RES@cnLinesOn            = False                  ; no contour lines

RES@lbOrientation        = "vertical"
RES@lbTitlePosition      = "Right"                           ; title location
RES@lbTitleDirection     = "Across"                          ; letter angle
RES@lbTitleAngleF        = 90.                               ; title angle
RES@lbTitleFontHeightF   = 0.025                             ; font height

RES@cnFillPalette        = "cmp_flux"
;RES@cnFillOpacityF       = 0.75 
RES@cnLevelSelectionMode = "ManualLevels"       ; set manual contour levels
RES@cnMinLevelValF       =     -5           ; set min contour level
RES@cnMaxLevelValF       =      5           ; set max contour level
RES@cnLevelSpacingF      =      1          ; set contour spacing

end

undef ( "Config_vtvganoSprd_shade" )
procedure Config_vtvganoSprd_shade (  \
  RES[*]           : logical \
  )
local none
begin

RES@cnFillOn             = True                   ; turn on color
RES@lbLabelAutoStride    = True                   ; nice label bar labels
RES@cnLinesOn            = False                  ; no contour lines

RES@lbOrientation        = "vertical"
RES@lbTitlePosition      = "Right"                           ; title location
RES@lbTitleDirection     = "Across"                          ; letter angle
RES@lbTitleAngleF        = 90.                               ; title angle
RES@lbTitleFontHeightF   = 0.025                            ; font height

RES@cnFillPalette        = "precip2_17lev"
RES@cnLevelSelectionMode = "ManualLevels"       ; set manual contour levels
RES@cnMinLevelValF       =      0.5              ; set min contour level
RES@cnMaxLevelValF       =       5              ; set max contour level
RES@cnLevelSpacingF      =      0.5              ; set contour spacing

end

undef ( "Config_rv_shade" )
procedure Config_rv_shade (  \
  RES[*]           : logical \
  )
local none
begin

RES@cnFillOn             = True                   ; turn on color
RES@lbLabelAutoStride    = True                   ; nice label bar labels
RES@cnLinesOn            = False                  ; no contour lines

RES@lbOrientation        = "vertical"
RES@lbTitlePosition      = "Right"                           ; title location
RES@lbTitleDirection     = "Across"                          ; letter angle
RES@lbTitleAngleF        = 90.                               ; title angle
RES@lbTitleFontHeightF   = 0.025                             ; font height

RES@cnFillPalette        = "hotcold_18lev"
RES@cnLevelSelectionMode = "ManualLevels"       ; set manual contour levels
RES@cnMinLevelValF       =     -30           ; set min contour level
RES@cnMaxLevelValF       =      30           ; set max contour level
RES@cnLevelSpacingF      =       5          ; set contour spacing

end

undef ( "Config_slp_contour" )
procedure Config_slp_contour (  \
  RES[*]           : logical \
  )
local none
begin

RES@cnLineColor                   = "green"                ; Set the line color
RES@cnInfoLabelOn                 = False
RES@cnLineThicknessF              = 8
RES@gsnContourNegLineDashPattern  = 1                      ; sets negative contours to dash pattern 1
RES@cnLineLabelInterval           = 1                      ; default = 2
RES@cnLineLabelFontHeightF        = 0.025

RES@cnLevelSelectionMode          = "ManualLevels"         ; set manual contour levels
RES@cnMinLevelValF                =     1040               ; set min contour level
RES@cnMaxLevelValF                =      940               ; set max contour level
RES@cnLevelSpacingF               =       4                ; set contour spacing

end

undef ( "Config_olr_shade" )
procedure Config_olr_shade (  \
  RES[*]           : logical \
  )
local none
begin

RES@cnFillOn             = True                   ; turn on color
RES@lbLabelAutoStride    = True                   ; nice label bar labels
RES@cnLinesOn            = False                  ; no contour lines
RES@cnFillMode           = "RasterFill"

RES@lbOrientation        = "vertical"
RES@lbTitlePosition      = "Right"                           ; title location
RES@lbTitleDirection     = "Across"                          ; letter angle
RES@lbTitleAngleF        = 90.                               ; title angle
RES@lbTitleFontHeightF   = 0.025                             ; font height

RES@cnFillPalette        = "MPL_Greys"
RES@cnLevelSelectionMode = "ManualLevels"       ; set manual contour levels
RES@cnMinLevelValF       =     100           ; set min contour level
RES@cnMaxLevelValF       =     240           ; set max contour level
RES@cnLevelSpacingF      =      20          ; set contour spacing

end

undef ( "Config_prec_shade" )
procedure Config_prec_shade (  \
  RES[*]           : logical \
  )
local none
begin

RES@cnFillOn             = True                   ; turn on color
RES@lbLabelAutoStride    = True                   ; nice label bar labels
RES@cnLinesOn            = False                  ; no contour lines
RES@cnFillMode           = "RasterFill"

RES@lbOrientation        = "vertical"
RES@lbTitlePosition      = "Right"                           ; title location
RES@lbTitleDirection     = "Across"                          ; letter angle
RES@lbTitleAngleF        = 90.                               ; title angle
RES@lbTitleFontHeightF   = 0.025                             ; font height

cmap                    := read_colormap_file("BlAqGrYeOrReVi200")
cmap(0,:)                = (/0,0,0,0/)      ; make first color fully transparent
RES@cnFillPalette        = cmap
RES@cnFillOpacityF       = 1.               ; .85 
RES@cnLevelSelectionMode = "ManualLevels"   ; set manual contour levels
RES@cnMinLevelValF       =      5           ; set min contour level
RES@cnMaxLevelValF       =     60           ; set max contour level
RES@cnLevelSpacingF      =      5           ; set contour spacing

end

undef ( "Config_cape_shade" )
procedure Config_cape_shade (  \
  RES[*]           : logical \
  )
local none
begin

RES@cnFillOn             = True                   ; turn on color
RES@lbLabelAutoStride    = True                   ; nice label bar labels
RES@cnLinesOn            = False                  ; no contour lines

RES@lbOrientation        = "vertical"
RES@lbTitlePosition      = "Right"                           ; title location
RES@lbTitleDirection     = "Across"                          ; letter angle
RES@lbTitleAngleF        = 90.                               ; title angle
RES@lbTitleFontHeightF   = 0.025                             ; font height

RES@cnFillPalette        = "WhiteYellowOrangeRed"
RES@cnLevelSelectionMode = "ManualLevels"       ; set manual contour levels
RES@cnMinLevelValF       =      500              ; set min contour level
RES@cnMaxLevelValF       =     5000             ; set max contour level
RES@cnLevelSpacingF      =      500              ; set contour spacing

end

undef ( "Config_dcapedt_shade" )
procedure Config_dcapedt_shade (  \
  RES[*]           : logical \
  )
local none
begin

RES@cnFillOn             = True                   ; turn on color
RES@lbLabelAutoStride    = True                   ; nice label bar labels
RES@cnLinesOn            = False                  ; no contour lines

RES@lbOrientation        = "vertical"
RES@lbTitlePosition      = "Right"                           ; title location
RES@lbTitleDirection     = "Across"                          ; letter angle
RES@lbTitleAngleF        = 90.                               ; title angle
RES@lbTitleFontHeightF   = 0.025                             ; font height

RES@cnFillPalette        = "hotcold_18lev"
RES@cnLevelSelectionMode = "ManualLevels"       ; set manual contour levels
RES@cnMinLevelValF       =     -500           ; set min contour level
RES@cnMaxLevelValF       =      500          ; set max contour level
RES@cnLevelSpacingF      =      100          ; set contour spacing

end

