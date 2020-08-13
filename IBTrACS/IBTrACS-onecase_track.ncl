; This file is Analysis and Draw program.
; Hiroaki Yoshioka(yoshioka@dpac.kyoto-u.ac.jp)
; History:
; 08/13/2020 - 1st released
;
; Please rewrite only the argument of "Part - Enter Constant, Directory, NAME and so on" as necessary.
; Note : Use the data of ibtracs version 4.0 or higher. 
;=====================================================================================

; These files are loaded by default in NCL V6.2.0 and newer
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
;
; These files still have to be loaded manually
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/time_axis_labels.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/ut_string.ncl"

begin

;********** Part - Enter Constant, Directory, NAME and so on **********

;;****************************************************************
;; These are some parameters that could be useful to have up top
;;****************************************************************
  plotType = "png"                 ; send graphics to PNG file
  plotName = "ibtracs"
  plotDpi  = 150

  tcName   = "PALI"

;;****************************************************************
;;****************************************************************
  ibtDir  = "/Volumes/RAID01/research/DATA/ibtracs/"
  ibtPath = "IBTrACS.ALL.v04r00.nc" 

;************************   Part END   ***************************

;;****************************************************************
;; Read the data
;;****************************************************************
  inFile = addfile( ibtDir+ibtPath, "r" )

  stormYear = inFile->season
  stormName = tostring(inFile->name)

  ii = str_match_ind_ic(stormName,tcName)

  print(ii)
  print(stormName(ii))
  print(stormYear(ii))

  stormLat = short2flt( inFile->lat(ii,:) )
  stormLon = short2flt( inFile->lon(ii,:) )
  stormLon = where( stormLon.lt.0, stormLon+360, stormLon )
  stormWind= short2flt( inFile->wmo_wind(ii,:) )
  stormTime= cd_calendar(inFile->time(ii,:),3)

  printMinMax(stormLat, True)
  printMinMax(stormLon, True)
  
;;****************************************************************
;; Customize base plot
;;****************************************************************

;;****************************************************************
;; region
;;****************************************************************

  minLon =  175
  maxLon =  200
  minLat =  -5
  maxLat =  15

  res = True
  res@gsnDraw  = False
  res@gsnFrame = False
  res@tiMainString = tcName 

  ;; ...set the spacing of the lat/lon labels
  res@gsnMajorLonSpacing = 10
  res@gsnMinorLonSpacing = 5
  res@gsnMajorLatSpacing = 10
  res@gsnMinorLatSpacing = 5

  ;; ...map gridlines
  res@mpGridAndLimbOn = True
  res@mpGridLatSpacingF = 5
  res@mpGridLonSpacingF = 5
  res@mpGridMaskMode    = "MaskLand"
  res@mpGridLineColor   = "blue"

  ;; ...set the bounds of a map plot
  res@mpMinLatF    = minLat
  res@mpMaxLatF    = maxLat
  res@mpMinLonF    = minLon
  res@mpMaxLonF    = maxLon
  ;res@mpCenterLonF = centerLon

  ;; ...set map resources
  ;res@mpFillOn = False
  res@mpGeophysicalLineThicknessF = 1
  res@mpGeophysicalLineColor      = "darkgreen"
  res@mpNationalLineColor         = "darkgreen"
  res@mpOutlineBoundarySets       = "AllBoundaries"
  res@mpDataBaseVersion           = "MediumRes"
  res@mpDataSetName               = "Earth..4"
  res@mpOutlineOn                 = True
  res@mpOceanFillColor            = "lightblue"
  res@mpInlandWaterFillColor      = "lightblue"
  res@mpLandFillColor             = "tan"

  ;; Set up an x-y line graph
  xyRes = True
  xyRes@gsnDraw  = False
  xyRes@gsnFrame = False
  xyRes@xyMarkLineMode     = "Lines"
  xyRes@xyMonoDashPattern  = True
  xyRes@xyLineColor        = "red"
  xyRes@xyLineThicknessF   = 5

  ;; ...open the workstation
  wks = gsn_open_wks( plotType, plotName )
  gsn_define_colormap( wks, "default" )

  map = gsn_csm_map_ce( wks, res )
  plot = gsn_csm_xy( wks, stormLon, stormLat, xyRes )
  overlay( map, plot )

  draw( map )
  frame( wks )

exit
end
