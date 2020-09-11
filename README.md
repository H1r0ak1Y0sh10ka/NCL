# NCL

## ここにあるディレクトリとスクリプト一覧

<pre>
NCL
├── IBTrACS
│      └── IBTrACS-onecase_track.ncl ; IBTrACSから1つの台風のトラックを描くスクリプト
├── README.md  
├── WRF  
│      ├── ideal
│      │      └── WRF-ideal-horizontal-S_rv-C_slp.ncl　; WRFの理想実験を読んで相対渦度と界面気圧を描くスクリプト
│      └── real
│              ├── WRF-real-horizontal-domain-IBTrACS-onecase_track.ncl ; WRFの現実実験の計算領域とIBTrACSから対象の1つの台風のトラックを描くスクリプト
│              └── WRF-real-horizontal-domain.ncl　; WRFの現実実験の計算領域を描くスクリプト
└── config  
        ├── DrawConfiguration.ncl ; 描画に関する設定ファイル  
        └── Tools.ncl             ; ツール系のスクリプト  
</pre>
