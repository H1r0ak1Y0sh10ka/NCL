; This file is Analysis and Draw program.
; Hiroaki Yoshioka(yoshioka@dpac.kyoto-u.ac.jp)
; History:
; 08/06/2020 - 1st released
;
; This script calcurate relative vorticity for .
; WRF experimental result required.
; Please rewrite only the argument of "Part - Enter Constant, Directory, NAME and so on" as necessary.
;
;=====================================================================================

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "../../config/Tools.ncl"
load "../../config/DrawConfiguration.ncl"
begin

;********** Part - Enter Constant, Directory, NAME and so on **********

  NAME = "test"
  LAT  = "25N"

  LEV  = 850

  OUT_DIRC   =  "~/Dropbox/fig/S_rv"+LEV+"-C_slp/"+NAME+"_"+LAT+"/" 
  OUTNAME_PREFIX = "WRF-ideal-horizontal-S_rv"+LEV+"-C_slp-v1-"+NAME+"_"+LAT

; Open ARW WRF output for the quarter supercell idealized case
   ;f = addfile("~/local/model/WRFv4.2_ideal_"+LAT+"/WRFV4/run/wrfout_d01_2007-09-01_00:00:00.nc","r")
   f = addfile("~/DATA/WRF/ideal/"+NAME+"_"+LAT+"/wrfout_d01_2007-09-01_00:00:00.nc","r")

;*************************************************************************

  makedir(OUT_DIRC)

    times = wrf_user_getvar(f,"times",-1)  ; get all times in the file
    N_times = dimsizes(times)
    N_skiptime = 1
    DX      = f@DX
    DY      = f@DY
    ff      = f->F(0,:,:)
    N_DX    = dimsizes(ff(0,:))
    N_DY    = dimsizes(ff(:,0))
    X_LABEL = fspan( (-1*(DX*0.001)*N_DX*0.5),((DX*0.001)*N_DX*0.5),N_DX/20+1 )
    Y_LABEL = fspan( (-1*(DY*0.001)*N_DY*0.5),((DY*0.001)*N_DY*0.5),N_DY/20+1 )

    do it = 0,N_times-1,N_skiptime

        if(it.lt.10)then
        ft_time = "FT00"+it
        else if (it.ge.10.and.it.lt.100)then
        ft_time   = "FT0"+it
        else if (it.ge.100)then
        ft_time   = "FT"+it
        end if 
        end if
        end if

       pp    = wrf_user_getvar(f, "pressure",it)   ; total pressure
       uu    = wrf_user_getvar(f,"ua",it)         ; u on mass points
       vv    = wrf_user_getvar(f,"va",it)         ; v on mass points
       slp = wrf_user_getvar(f,"slp",it)

       uu_LEV = wrf_user_interp_level(uu,pp,LEV,False)
       vv_LEV = wrf_user_interp_level(vv,pp,LEV,False)

       scale = 1.e06                               
       rv_LEV           = uu_LEV                                  ; retain coordinates
       rv_LEV           = uv2vrF(uu_LEV,vv_LEV) * scale
       rv_LEV@long_name = "Relative Vorticity"
       rv_LEV@units     = "scaled s^-1"

      wks01 = gsn_open_wks("png",OUT_DIRC + "/" + OUTNAME_PREFIX+"-"+ft_time)

      res_title = True
      res_title@gsnLeftString       = ft_time
      res_title@gsnRightString      = "EXP : "+ NAME + "_" + LAT

      res_basis = True 
      res_basis@gsnDraw             = False
      res_basis@gsnFrame            = False
      res_basis@gsnMaximize         = True
      res_basis@vpWidthF            = 0.80
      res_basis@vpHeightF           = 0.80

      res_basis@tiXAxisString       = "DX(km)" 
      res_basis@tiXAxisFontHeightF  = 0.025                             ; default 
      res_basis@tmXBMode            = "Explicit"
      res_basis@tmXBValues          = ispan(0,N_DX,20)
      res_basis@tmXBLabels          = X_LABEL
      res_basis@tmXBLabelFontHeightF= 0.02

      res_basis@tiYAxisString       = "DY(km)"
      res_basis@tiYAxisFontHeightF  = 0.025                             ; default 
      res_basis@tmYLMode            = "Explicit"
      res_basis@tmYLValues          = ispan(0,N_DY,20)
      res_basis@tmYLLabels          = Y_LABEL
      res_basis@tmYLLabelFontHeightF= 0.03

      res = True
      res = res_basis
      res = res_title

      shade01_opts = True
      shade01_opts = res
      Config_rv_shade(shade01_opts)
      
      contour01_opts = True
      contour01_opts = res
      Config_slp_contour(contour01_opts)

      shade01_data   = rv_LEV(:,:)
      contour01_data   = slp(:,:)
      wrf_smooth_2d(shade01_data,50)
      wrf_smooth_2d(contour01_data,50)

      plots_shade   = gsn_csm_contour(wks01, shade01_data   ,shade01_opts)
      plots_contour = gsn_csm_contour(wks01, contour01_data ,contour01_opts)

      overlay(plots_shade,plots_contour)
      draw(plots_shade)
      frame(wks01)

    end do


end

exit



