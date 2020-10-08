
; Example of using panels with WRF data

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
begin
;

  init  = (/"20160101","20160102","20160103","20160104","20160105","20160106","20160107"/)
  ninit = dimsizes(init)

  member = (/ "c00", "p01", "p02", "p03", "p04", "p05", "p06", "p07", "p08", "p09", "p10" /)
  mmm    = dimsizes(member)
  
  para = (/ "spd"/) ;
  npara    = dimsizes(para)

  f_time = "07th18Z"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 timestep = 193

  do ppp = 0,npara-1 ; parameter loop
  data      = new((/ninit,mmm,timestep/),float)

  do nnn = 0,ninit-1 ; number of initial times

  do ii = 0,mmm-1 ;2,5,3;0,mmm-1 ; number of members 

     trackdata = "/Volumes/HDD01/research/ncl/wrf/track/PALI_"+init(nnn)+"_"+member(ii)+"-"+para(ppp)+"_v25.csv"

;---Read in file as array of strings so we can parse each line
  lines  = asciiread(trackdata,-1,"string")
  nlines = dimsizes(lines)   ; First line is not a header
;---This file has quotes around everything, which we don't want.
  dq    = str_get_dq()
  lines = str_sub_str(lines,dq,"")   ; Replace quotes with empty string
;---First line is name of each field
  delim       = ","
  field_names = str_split(lines(0),delim)
  nfields     = dimsizes(field_names)
;---We're going to read the whole file as a 2D array of strings
  fields = new((/nfields,nlines/),string)
;---Remember that fields start at 1, not 0.
  do nf=0,nfields-1
    fields(nf,:) = str_get_field(lines,nf+1,delim)
 
    do nt = 0, timestep-1
    data(nnn,ii,nt) = stringtofloat(fields(2,nt))
    end do

  end do
   delete(lines)
   delete(fields)
  end do ;;; ii loop
 end do ;;; nnn loop

  if(para.eq."spd")then
  gustfactor = 1.23
  data(:,:,:) = data(:,:,:)/gustfactor
  end if

 box     = new((/mmm/),float)
 dimt = dimsizes(box)
 x25  = round(.25*dimt,3)-1     ; -1 to account for NCL indexing starting
 x75  = round(.75*dimt,3)-1     ; at 0    
 iarr=new((/ninit,5/),float) ;  fill with minimum, 25th percentile, median, 75th percentile, maximum of each timeseries

 do nnn = 0,ninit-1 ; number of initial times
  do ii = 0,mmm-1 ;2,5,3;0,mmm-1 ; number of members 
   
        box(ii)=(data(nnn,ii,156-24*nnn))/1.23

  end do ;;; ii loop
  qsort(box) 
  iarr(nnn,:) = (/min(box),box(x25),dim_median(box),box(x75),max(box)/)  
 end do ;;; nnn loop

 x=ispan(0,ninit-1,1)

 ;colors01 = ispan(2,255,round((255-2)/ninit,3))
 colors01 = ispan(232,2,round((232-2)/ninit,3))

;**********************************************
; create plot
;**********************************************
  wks = gsn_open_wks("png",init(0)+"-boxplot_"+para(ppp)+"_ft"+f_time+"-v25")               ; send graphics to PNG file
;**********************************************
; resources for plot background
;**********************************************
  res            = True                         ; plot mods desired
  res@gsnMaximize         = True                   ; maximize plot in frame
  res@vpWidthF             = 0.7
  res@vpHeightF            = 0.25

  res@tmXBLabels = (/"01st","02nd","03rd","04th","05th","06th","07th"/) ; labels for each box
  res@tmXBLabelAngleF = 45. 
  res@tmYMajorGrid      = True
  res@tmXBMajorOutwardLengthF  = 0.02
  res@tmYLMajorOutwardLengthF  = 0.02
  res@tmYLMinorOutwardLengthF  = 0.01

  if(para(ppp).eq."slp")then
  res@trYMinF = 920
  res@trYMaxF = 1000.
  else if (para(ppp).eq."spd")then
  res@tmYLMode = "Manual"
  res@tmYLTickStartF  =  0.
  res@tmYLTickEndF    = 40.
  res@tmYLTickSpacingF= 10.
  res@trYMinF =  0
  res@trYMaxF = 40

  res@tmXBLabelFontHeightF = 0.02
  res@tmYLLabelFontHeightF = 0.02
  res@tiYAxisString   = "Wind speed (ms~S~-1~N~)"
  res@tiYAxisFontHeightF = 0.025
  res@tiXAxisString   = "Initial time"
  res@tiXAxisFontHeightF = 0.025


  end if
  end if

;colors01 = ispan(2,255,round((255-2)/ninit,3))

;**********************************************
; resources for polylines that draws the boxes
;**********************************************  
  llres                   = True			
  llres@gsLineThicknessF  = 11                 ; line thickness 
;**********************************************
; resources that control color and width of boxes
;**********************************************  
  opti          = True			
  opti@boxWidth = .6				; Width of box (x units)
  ;opti@boxColors = colors01(0:6)	; Color of box(es)

;***********************************************
  plot = boxplot(wks,x,iarr,opti,res,llres)	; All 3 options used...
  draw(wks)                                     ; box plot does not call
  frame(wks)                                    ; these for you


  end do ;;; ppp loop


exit



end






