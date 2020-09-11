; This file is Analysis and Draw program.
; Hiroaki Yoshioka(yoshioka@dpac.kyoto-u.ac.jp)
; History:
; 08/25/2020 - 1st released
;
; Please rewrite only the argument of "Part - Enter Constant, Directory, NAME and so on" as necessary.
; Note : Use the data of ibtracs version 4.0 or higher. 
;=====================================================================================

;   Script display location of model domains
;   Only works for ARW domains
;   Reads namelist file directly

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

begin
;

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
; read the following namelist file
  filename = "/Users/yoshioka-hiroaki/model/PALI/wpsdir/namelist.wps"

;************************   Part END   ***************************

;;****************************************************************
;; Read the data
;;****************************************************************
  inFile = addfile( ibtDir+ibtPath, "r" )

  stormYear = inFile->season
  stormName = tostring(inFile->name)

  ii = str_match_ind_ic(stormName,tcName)

  print("Record number:"+ii)
  print("Record TC name:"+stormName(ii))
  print("Record genesis year:"+stormYear(ii))

  stormLat = short2flt( inFile->lat(ii,:) )
  stormLon = short2flt( inFile->lon(ii,:) )
  stormLon = where( stormLon.lt.0, stormLon+360, stormLon )
  stormWind = short2flt( inFile->wmo_wind(ii,:) )
  stormDate = cd_calendar(inFile->time(ii,:),0)
  stormStatus = tostring(inFile->usa_status(ii,:,:))

  stormDay    = tointeger(stormDate(:,2))
  stormHour   = tointeger(stormDate(:,3))

  ;printMinMax(stormLat, True)
  ;printMinMax(stormLon, True)
  
  N = num(.not.ismissing(stormLat))-1

;;****************************************************************
;; Customize base plot
;;****************************************************************

  plotName = "WRF-domain_ibtracs-onecase_track-"+stormYear(ii)+"_"+stormName(ii)
  wks = gsn_open_wks(plotType,plotName)

; Set the colors to be used
  colors = (/"white","black","White","ForestGreen","DeepSkyBlue","Red","Blue"/)
  gsn_define_colormap(wks, colors)  

; Set some map information ; line and text information
  mpres = True
  mpres@mpFillOn = True
  mpres@mpFillColors  = (/"background","lightblue","ForestGreen","lightblue", "transparent"/)
  mpres@mpGeophysicalLineColor      = "darkgreen";"Black"
  mpres@mpGridLineColor             = "Black"
  mpres@mpLimbLineColor             = "Black"
  mpres@mpNationalLineColor         = "Black"
  mpres@mpPerimLineColor            = "Black"
;  mpres@tiMainString                = "Domain & Best track for "+stormYear(ii)+" "+stormName(ii)
  mpres@tiMainString                = "(a) Domain & "+stormName(ii)+"'s Track"

  ;; ...map gridlines
  mpres@mpGridAndLimbOn = True
  mpres@mpGridLatSpacingF = 5
  mpres@mpGridLonSpacingF = 5
  mpres@mpGridMaskMode    = "MaskLand"
  mpres@mpGridLineColor   = "blue"
  mpres@tmXBLabelFontHeightF = 0.02                 ; resize tick labels
  mpres@tmYLLabelFontHeightF = 0.02    

  ;; ...set map resources
  mpres@mpGeophysicalLineThicknessF = 1
  mpres@mpOutlineBoundarySets       = "AllBoundaries"
  mpres@mpDataBaseVersion           = "MediumRes"
  mpres@mpDataSetName               = "Earth..4"
  mpres@mpOutlineOn                 = True

  lnres = True 
  lnres@gsLineThicknessF = 2.5
  lnres@domLineColors    = (/ "white", "Red" , "Red" , "Blue" /)

  txres = True
  txres@txFont = "helvetica-bold"
  txres@txJust = "TopLeft"
  txres@txPerimOn = False
  txres@txFontHeightF = 0.025

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Do not change anything between the ";;;;;" lines

  mpres@max_dom   = stringtoint  (systemfunc("grep max_dom    " +filename+ " | cut -f2 -d'=' | cut -f1 -d','" ) )
  mpres@dx        = stringtofloat(systemfunc("grep dx         " +filename+ " | cut -f2 -d'=' | cut -f1 -d','" ) )
  mpres@dy        = stringtofloat(systemfunc("grep dy         " +filename+ " | cut -f2 -d'=' | cut -f1 -d','" ) )
  mpres@ref_lat   = stringtofloat(systemfunc("grep ref_lat    " +filename+ " | cut -f2 -d'=' | cut -f1 -d','" ) )
  mpres@ref_lon   = stringtofloat(systemfunc("grep ref_lon    " +filename+ " | cut -f2 -d'=' | cut -f1 -d','" ) )
  
  
  test = systemfunc("grep truelat1 " +filename )

  if ( .not. ismissing(test) )
    mpres@truelat1  = stringtofloat(systemfunc("grep truelat1   " +filename+ " | cut -f2 -d'=' | cut -f1 -d','" ) )
  else
    mpres@truelat1  = 0.0
  end if
  test = systemfunc("grep truelat2 " +filename ) 
  if ( .not. ismissing(test) )
    mpres@truelat2  = stringtofloat(systemfunc("grep truelat2   " +filename+ " | cut -f2 -d'=' | cut -f1 -d','" ) )
  else
    mpres@truelat2  = 0.0
  end if
  mpres@stand_lon = stringtofloat(systemfunc("grep stand_lon  " +filename+ " | cut -f2 -d'=' | cut -f1 -d','" ) )

  test = systemfunc("grep lambert " +filename ) 
  if ( .not. ismissing(test) )
    mpres@map_proj          = "lambert"
  end if
  test = systemfunc("grep mercator " +filename ) 
  if ( .not. ismissing(test) )
    mpres@map_proj          = "mercator"
  end if
  test = systemfunc("grep polar " +filename ) 
  if ( .not. ismissing(test) )
    mpres@map_proj          = "polar"
  end if
  testa = systemfunc("grep 'lat-lon' " +filename ) 
  if ( .not. ismissing(testa) )
    mpres@map_proj          = "lat-lon"
    mpres@pole_lat = stringtofloat(systemfunc("grep pole_lat  " +filename+ " | cut -f2 -d'=' | cut -f1 -d','" ) )
    mpres@pole_lon = stringtofloat(systemfunc("grep pole_lon  " +filename+ " | cut -f2 -d'=' | cut -f1 -d','" ) )
  end if

  parent_id         = new ( mpres@max_dom , integer )
  parent_grid_ratio = new ( mpres@max_dom , integer )
  i_parent_start    = new ( mpres@max_dom , integer )
  j_parent_start    = new ( mpres@max_dom , integer )
  e_we              = new ( mpres@max_dom , integer )
  e_sn              = new ( mpres@max_dom , integer )

  do n = 1, mpres@max_dom 

    n0 = n - 1
    parent_id(n0)         = stringtoint(systemfunc("grep parent_id         " +filename+ " | cut -f2 -d'=' | cut -f"+n+" -d','" ) )
    parent_grid_ratio(n0) = stringtoint(systemfunc("grep parent_grid_ratio " +filename+ " | cut -f2 -d'=' | cut -f"+n+" -d','" ) )
    i_parent_start(n0)    = stringtoint(systemfunc("grep i_parent_start    " +filename+ " | cut -f2 -d'=' | cut -f"+n+" -d','" ) )
    j_parent_start(n0)    = stringtoint(systemfunc("grep j_parent_start    " +filename+ " | cut -f2 -d'=' | cut -f"+n+" -d','" ) )
    e_we(n0)              = stringtoint(systemfunc("grep e_we              " +filename+ " | cut -f2 -d'=' | cut -f"+n+" -d','" ) )
    e_sn(n0)              = stringtoint(systemfunc("grep e_sn              " +filename+ " | cut -f2 -d'=' | cut -f"+n+" -d','" ) )
 
  end do 

  mpres@parent_id         = parent_id
  mpres@parent_grid_ratio = parent_grid_ratio
  mpres@i_parent_start    = i_parent_start
  mpres@j_parent_start    = j_parent_start
  mpres@e_we              = e_we
  mpres@e_sn              = e_sn

  map = wrf_wps_dom (wks,mpres,lnres,txres)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;; Set up an x-y line graph
  cres = True
  cres@gsLineThicknessF = 10.0

  ;cnLevels = (/34,64,83,96,113,137/)
  cnLevels = (/34,48,64/)
  category = (/"TS","STS","TY"/)

  CTable      = "MPL_Paired"
  cmap  = read_colormap_file(CTable)     ; カラーパレットを配列として取得
  cmap  := cmap(33:106,:)                     ; そのうち一部を切り出す
  NC    = dimsizes(cmap(:,0))               ; cmpがもつ色の総数
  NL    = dimsizes(cnLevels)                   ; レベルの数
  cmap  := cmap(ispan(0,NL,1)*(NC-1)/NL,:)  ; NC色のcmpを適宜間引いてNL+1色にする
  
  dum    = new(N,graphic)
  mark   = True                               ; genesis of traj resources
  flag_genesis = 0

  N0       = num(stormHour.eq.0)
  time_mark = new(N0,graphic)
  flag_time = 0

  Nmax = maxind(stormWind)

  text      = new(N,graphic)
  flag_text = 0
  txres     = True

;********************************
   do i = 0,N-2,2                  ; loop through chosen traj
  
      if(stormDay(i).lt.10)then
      Day = "0" +tostring(stormDay(i))
      else if (stormDay(i).ge.10)then
      Day = tostring(stormDay(i))
      end if
      end if

      if(stormHour(i).lt.10)then
      Hour = "0" +tostring(stormHour(i))
      else if (stormHour(i).ge.10)then
      Hour = tostring(stormHour(i))
      end if
      end if

      c = max(ind((stormWind(i)-cnLevels).ge.0))    
      if (ismissing(c)) then
          cres@gsLineColor = cmap(0,:)
      else
          cres@gsLineColor = cmap(c+1,:)
      end if

      dum(i) = gsn_add_polyline(wks,map,(/stormLon(i),stormLon(i+2)/),(/stormLat(i),stormLat(i+2)/),cres) 

      if(stormWind(i).ge.34.0.and.flag_genesis.eq.0)then
      
      ; create a unique marker to indicate the start of the trajectory
       mark@gsMarkerSizeF  = 20.0       ; marker size
       mark@gsMarkerColor  = "blue"     ; marker color
       mark@gsMarkerIndex  = 16

       genesis_mark = gsn_add_polymarker(wks,map,stormLon(i),stormLat(i),mark) ; draw start of traj
       delete(mark@gsMarkerColor)
       delete(mark@gsMarkerSizeF)
       flag_genesis = flag_genesis + 1

       ; Add text of timestamp 
       ;txres@txFontHeightF = 0.015        
       ;txres@txFontColor   = "blue"
       ;text(flag_text) = gsn_add_text(wks,map,Day+"/"+Hour,stormLon(i)+0.5,stormLat(i)+0.5,txres)
       ;flag_text = flag_text + 1
       
       else if(i.eq.Nmax)then

      ; create a unique marker to indicate the start of the trajectory
       mark@gsMarkerSizeF  = 20.0       ; marker size
       mark@gsMarkerColor  = "red"    ; marker color
       mark@gsMarkerIndex  = 16

       max_mark = gsn_add_polymarker(wks,map,stormLon(i),stormLat(i),mark) ; draw start of traj
       delete(mark@gsMarkerColor)
       delete(mark@gsMarkerSizeF)

       ; Add text of timestamp 
       ;txres@txFontHeightF = 0.015        
       ;txres@txFontColor   = "red"
       ;text(flag_text) = gsn_add_text(wks,map,Day+"/"+Hour,stormLon(i)+0.5,stormLat(i)+0.5,txres)
       ;flag_text = flag_text + 1

       else if(stormHour(i).eq.0)then

       ; create a unique marker to indicate the start of the trajectory
       mark@gsMarkerSizeF  = 20.0       ; marker size
       mark@gsMarkerColor  = "black"    ; marker color
       mark@gsMarkerIndex  = 16

       time_mark(flag_time) = gsn_add_polymarker(wks,map,stormLon(i),stormLat(i),mark) ; draw start of traj
       delete(mark@gsMarkerColor)
       delete(mark@gsMarkerSizeF)
       flag_time = flag_time + 1

       ; Add text of timestamp 
       txres@txFontHeightF = 0.015        
       txres@txFontColor   = "black"
       text(flag_text) = gsn_add_text(wks,map,Day+"/"+Hour,stormLon(i)+0.5,stormLat(i)+1.0,txres)
       flag_text = flag_text + 1

       end if
       end if
       end if
   end do 

  lbres                    = True             
  lbres@vpWidthF           = 0.7               ; 
  lbres@vpHeightF          = 0.1               ; 
  lbres@lbFillColors       = cmap              ; 
  lbres@lbMonoFillPattern  = True              ;
  lbres@lbOrientation      = "Horizontal"      ;
  lbres@lbLabelFontHeightF = 0.02              ;
  lbres@lbLabelAutoStride  = True              ; 
  lbres@lbBoxEndCapStyle   = "TriangleBothEnds"  ;
  lbres@lbLabelAlignment   = "InteriorEdges"   ; 
  lbres@pmLabelBarOrthogonalPosF = 1.          ; 
  lbres@lbTitleOn          = True              ; 
  lbres@lbTitleString      = "knot, class"             ; 
  lbres@lbTitleFontHeightF = lbres@lbLabelFontHeightF  ; 
  lbres@lbTitlePosition    = "Right"           ; 
  lbres@lbTitleDirection   = "Across"          ; 
  lb   = gsn_create_labelbar(wks,NL+1,sprinti("%1.0i",cnLevels)+","+category,lbres)  ; 

  annores = True                               ; 
  annores@amParallelPosF   = -0.060            ; 
  annores@amOrthogonalPosF =  0.425            ;
  anno = gsn_add_annotation(map,lb,annores)  

  draw( map )
  frame(wks)           ; lets frame the plot - do not delete

end

