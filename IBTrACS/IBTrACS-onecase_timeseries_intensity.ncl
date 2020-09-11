; This file is Analysis and Draw program.
; Hiroaki Yoshioka(yoshioka@dpac.kyoto-u.ac.jp)
; History:
; 09/11/2020 - 1st released
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
  plotType = "eps"                 ; send graphics to PNG file
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

  print("DATA NUMBER:"+ii)
  print("STORM NAME:"+stormName(ii))
  print("GENESIS YEAR:"+stormYear(ii))

  stormPres = short2flt( inFile->wmo_pres(ii,:) )
  stormWind = short2flt( inFile->wmo_wind(ii,:) ) * 0.514444
  stormDate = cd_calendar(inFile->time(ii,:),0)

  stormDay    = tointeger(stormDate(:,2))
  stormHour   = tointeger(stormDate(:,3))

  printMinMax(stormWind, True)
  printMinMax(stormPres, True)

  N = num(.not.ismissing(stormDay))

;;****************************************************************
;; Customize base plot
;;****************************************************************
  plotName = "Ibtracs-onecase_timeseries_intensity-"+stormYear(ii)+"_"+stormName(ii)
  wks = gsn_open_wks(plotType,plotName)

; resources for "left" variable
  resL                  = True 

  resL@gsnMaximize      = True
  resL@vpWidthF         = 0.8            ; Change the aspect ratio, but 
  resL@vpHeightF        = 0.4            ; make plot as large as possible.
;  resL@trXMinF          = min(stormTime)           ; Set min/max of right Y axis
;  resL@trXMaxF          = max(stormTime)

  resL@xyLineColor        = "Dodgerblue"
  resL@xyLineThicknessF   = 5.0
  resL@tiYAxisFontColor   = resL@xyLineColor
  resL@tiYAxisString      = "Maximum wind speed (ms~S~-1~N~)"     ; Y-axis title
  resL@tiYAxisFontHeightF = 0.020                 ; Y-axis title font height


; resources for "right" variable
  resR                  = True                      

;  resR@trXMinF          = resL@trXMinF          ; Set min/max of right Y axis
;  resR@trXMaxF          = resL@trXMaxF

  resR@xyLineColor      = "deeppink1" ;"orchid1"
  resR@xyDashPattern    = 2              ; Dashed line for 2nd curve
  resR@xyLineThicknessF = 5.0
  resR@tiYAxisFontColor = resR@xyLineColor
  resR@tiYAxisString      = "Minimum sea level pressure (hPa)"    ;(m s~S~-1~N~F)"   ; Y-axis title
  resR@tiYAxisFontHeightF = 0.020                 ; Y-axis title font height

  resR@tmYRFormat       = "f"            ; Remove trailing zeros from labels

  x = ispan(0,N-1,1)
  label_time = new(N,string)

  do i = 0 , N-1,1

   if(stormDay(i).lt.10)then

        if(stormHour(i).lt.10)then
        label_time(i) = "0" +stormDay(i)+"/0"+stormHour(i)
        else if(stormHour(i).ge.10.and.stormHour(i).lt.100)then
        label_time(i) = "0" +stormDay(i)+"/"+stormHour(i)
        end if 
        end if
 
   else if (stormDay(i).ge.10.and.stormDay(i).lt.100)then

        if(stormHour(i).lt.10)then
        label_time(i) = stormDay(i)+"/0"+stormHour(i)
        else if(stormHour(i).ge.10.and.stormHour(i).lt.100)then
        label_time(i) = stormDay(i)+"/"+stormHour(i)
        end if 
        end if

   end if
   end if 

  end do 
  
  resL@tmXBMode          = "Explicit"
  resL@tmXBLabels        = label_time(::8)
  resL@tmXBValues        = ispan(0,N-1,8)
  resL@tmXBMinorValues    = ispan(0,N-1,1)

  resL@tiXAxisString      = "DATE (DD/HH)" ; X-axis title
  resL@tiXAxisFontHeightF = 0.020         

  resL@gsnLeftString   = "(b)"               ; add the gsn titles
  resL@gsnCenterString = stormName(ii)+"'s Intensity"

  wind = linmsg(stormWind(0:N-1),0)
  pres = linmsg(stormPres(0:N-1),0)
  plot = gsn_csm_xy2(wks,x,wind,pres,resL,resR)

exit
end
